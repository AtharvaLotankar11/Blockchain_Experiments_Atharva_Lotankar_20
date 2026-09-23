// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title CampusBudgetAllocator
 * @dev Manages campus club budget allocation using weighted department voting.
 */
contract CampusBudgetAllocator {
    
    struct Representative {
        uint studentWeight; // Number of students represented
        bool hasVoted;      // Has the representative voted?
        address delegate;   // Person delegated to
        uint votedClubIndex; // Index of the chosen club
    }

    struct Club {
        string name;        // Name of the campus club
        uint totalVotes;    // Accumulated votes from departments
        uint allocatedBudget; // Calculated funding amount
    }

    address public dean;
    uint public totalTreasuryPool; // Total budget in Wei or arbitrary units
    uint public totalVotesCast;
    
    mapping(address => Representative) public representatives;
    Club[] public clubs;

    constructor(string[] memory clubNames, uint _totalTreasuryPool) {
        dean = msg.sender;
        totalTreasuryPool = _totalTreasuryPool;

        for (uint i = 0; i < clubNames.length; i++) {
            clubs.push(Club({
                name: clubNames[i],
                totalVotes: 0,
                allocatedBudget: 0
            }));
        }
    }

    // Register a representative with dynamic department weight
    function registerRepresentative(address repAddress, uint departmentSize) external {
        require(msg.sender == dean, "Only the Dean can register reps.");
        require(!representatives[repAddress].hasVoted, "Rep already voted.");
        require(representatives[repAddress].studentWeight == 0, "Rep already registered.");
        require(departmentSize > 0, "Department size must be greater than zero.");

        representatives[repAddress].studentWeight = departmentSize;
    }

    // Delegate voting weight to another representative
    function delegateVote(address to) external {
        Representative storage sender = representatives[msg.sender];
        require(sender.studentWeight > 0, "You have no voting rights.");
        require(!sender.hasVoted, "You already voted.");
        require(to != msg.sender, "Self-delegation not allowed.");

        while (representatives[to].delegate != address(0)) {
            to = representatives[to].delegate;
            require(to != msg.sender, "Loop detected in delegation.");
        }

        Representative storage targetDelegate = representatives[to];
        require(targetDelegate.studentWeight >= 1, "Target cannot receive votes.");

        sender.hasVoted = true;
        sender.delegate = to;

        if (targetDelegate.hasVoted) {
            clubs[targetDelegate.votedClubIndex].totalVotes += sender.studentWeight;
            totalVotesCast += sender.studentWeight;
        } else {
            targetDelegate.studentWeight += sender.studentWeight;
        }
    }

    // Cast vote for a club
    function voteForClub(uint clubIndex) external {
        Representative storage sender = representatives[msg.sender];
        require(sender.studentWeight > 0, "Not authorized to vote.");
        require(!sender.hasVoted, "Already voted.");
        require(clubIndex < clubs.length, "Invalid club choice.");

        sender.hasVoted = true;
        sender.votedClubIndex = clubIndex;

        clubs[clubIndex].totalVotes += sender.studentWeight;
        totalVotesCast += sender.studentWeight;
    }

    // Calculate budget split based on percentage share of total votes
    function calculateBudgetDistribution() external {
        require(msg.sender == dean, "Only the Dean can execute payout calculations.");
        require(totalVotesCast > 0, "No votes were cast.");

        for (uint i = 0; i < clubs.length; i++) {
            // Proportional formula: (Club Votes * Total Treasury) / Total Cast Votes
            clubs[i].allocatedBudget = (clubs[i].totalVotes * totalTreasuryPool) / totalVotesCast;
        }
    }

    // Fetch allocated budget for a specific club index
    function getClubDetails(uint clubIndex) external view returns (string memory name, uint totalVotes, uint allocatedBudget) {
        require(clubIndex < clubs.length, "Invalid club index.");
        Club memory c = clubs[clubIndex];
        return (c.name, c.totalVotes, c.allocatedBudget);
    }
}