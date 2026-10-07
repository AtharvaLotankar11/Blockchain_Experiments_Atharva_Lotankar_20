// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BugBountyEscrow {
    enum Status { Created, Submitted, Approved, Paid, Refunded }

    struct Bounty {
        uint256 bountyId;
        address payable company;
        address payable hunter;
        uint256 amount;
        string bugReportHash;
        Status status;
    }

    uint256 public bountyCount;
    mapping(uint256 => Bounty) public bounties;

    event BountyCreated(uint256 indexed bountyId, address indexed company, uint256 amount);
    event BugSubmitted(uint256 indexed bountyId, address indexed hunter, string bugReportHash);
    event BountyApproved(uint256 indexed bountyId);
    event RewardPaid(uint256 indexed bountyId, address indexed hunter, uint256 amount);

    function createBounty() external payable {
        require(msg.value > 0, "Bounty reward must be greater than zero");

        bountyCount++;
        bounties[bountyCount] = Bounty({
            bountyId: bountyCount,
            company: payable(msg.sender),
            hunter: payable(address(0)),
            amount: msg.value,
            bugReportHash: "",
            status: Status.Created
        });

        emit BountyCreated(bountyCount, msg.sender, msg.value);
    }

    function submitBug(uint256 _bountyId, string memory _bugReportHash) external {
        Bounty storage bounty = bounties[_bountyId];
        require(bounty.bountyId != 0, "Bounty does not exist");
        require(bounty.status == Status.Created, "Bounty is not open for submission");

        bounty.hunter = payable(msg.sender);
        bounty.bugReportHash = _bugReportHash;
        bounty.status = Status.Submitted;

        emit BugSubmitted(_bountyId, msg.sender, _bugReportHash);
    }

    function approveBug(uint256 _bountyId) external {
        Bounty storage bounty = bounties[_bountyId];
        require(msg.sender == bounty.company, "Only company can approve");
        require(bounty.status == Status.Submitted, "No submission to approve");

        bounty.status = Status.Approved;
        emit BountyApproved(_bountyId);
    }

    function releasePayment(uint256 _bountyId) external {
        Bounty storage bounty = bounties[_bountyId];
        require(msg.sender == bounty.company, "Only company can release payment");
        require(bounty.status == Status.Approved, "Bounty report not approved yet");

        bounty.status = Status.Paid;
        uint256 paymentAmount = bounty.amount;
        bounty.amount = 0;

        bounty.hunter.transfer(paymentAmount);
        emit RewardPaid(_bountyId, bounty.hunter, paymentAmount);
    }

    function getBounty(uint256 _bountyId) external view returns (
        uint256 bountyId,
        address company,
        address hunter,
        uint256 amount,
        string memory bugReportHash,
        Status status
    ) {
        Bounty memory b = bounties[_bountyId];
        require(b.bountyId != 0, "Bounty does not exist");
        return (b.bountyId, b.company, b.hunter, b.amount, b.bugReportHash, b.status);
    }
}