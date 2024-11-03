//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol";
contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public maxSupply = 1_000_000 * (10**decimals());

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    struct IssueView {
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    Issue[] issues;
    mapping(address => bool) private hasClaimed;

    constructor() ERC20("WeightedToken", "WT") {
        _mint(msg.sender, maxSupply);
    }

    function claim() external {
        if (hasClaimed[msg.sender]) revert TokensClaimed();
        if (totalSupply() >= maxSupply) revert AllTokensClaimed();

        _mint(msg.sender, 100 * (10**decimals()));
        hasClaimed[msg.sender] = true;
    }

    function createIssue(string memory _issueDesc, uint256 _quorum)
        external
        returns (uint256)
    {
        require(balanceOf(msg.sender) > 0, "NoTokensHeld");
        require(_quorum <= totalSupply(), "QuorumTooHigh");

        issues.push();
        Issue storage newIssue = issues[issues.length - 1];

        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        newIssue.votesFor = 0;
        newIssue.votesAgainst = 0;
        newIssue.votesAbstain = 0;
        newIssue.totalVotes = 0;
        newIssue.passed = false;
        newIssue.closed = false;

        return issues.length - 1;
    }

    function getIssue(uint256 _id) external view returns (IssueView memory) {
        Issue storage issue = issues[_id];
        return
            IssueView({
                issueDesc: issue.issueDesc,
                votesFor: issue.votesFor,
                votesAgainst: issue.votesAgainst,
                votesAbstain: issue.votesAbstain,
                totalVotes: issue.totalVotes,
                quorum: issue.quorum,
                passed: issue.passed,
                closed: issue.closed
            });
    }

    function vote(uint256 _issueId, Vote _vote) external {
        Issue storage issue = issues[_issueId];

        if (issue.closed) revert VotingClosed();
        if (issue.voters.contains(msg.sender)) revert AlreadyVoted();
        uint256 weight = balanceOf(msg.sender);
        require(weight > 0, "No tokens to vote");

        issue.voters.add(msg.sender);

        if (_vote == Vote.FOR) issue.votesFor += weight;
        else if (_vote == Vote.AGAINST) issue.votesAgainst += weight;
        else if (_vote == Vote.ABSTAIN) issue.votesAbstain += weight;

        issue.totalVotes += weight;

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            issue.passed = (issue.votesFor > issue.votesAgainst);
        }
    }
}
