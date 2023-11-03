// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20; 

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ShareToken is ERC20 {
    address public owner;
    uint256 public totalShares;

    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        owner = msg.sender;
        totalShares = initialSupply;
        _mint(owner, initialSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to transfer ownership to another address
    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    // Function to mint additional shares (only callable by the owner)
    function mintShares(uint256 amount) public onlyOwner {
        _mint(owner, amount);
        totalShares += amount;
    }

    // Function to burn shares (only callable by the owner)
    function burnShares(uint256 amount) public onlyOwner {
        require(totalShares >= amount, "Insufficient total shares");
        _burn(owner, amount);
        totalShares -= amount;
    }

    // Function to transfer shares (only callable by the owner)
    function transferShares(address recipient, uint256 amount) public onlyOwner {
        require(recipient != address(0), "Cannot transfer shares to the zero address");
        require(totalShares >= amount, "Insufficient total shares");
        _transfer(owner, recipient, amount);
    }

    // Struct to represent a proposal
    struct Proposal {
        string description;
        uint256 votes;
        bool executed;
    }
    // function to create a new proposal
    function createProposal(string memory description) public onlyOwner {
        proposals.push(Proposal(description, 0, false));
    }

    // Array of all proposals
    Proposal[] public proposals;

    // function to vote on a proposal
    function vote(uint256 proposalId) public {
        require(balanceOf(msg.sender) > 0, "Only token holders can vote");
        require(proposalId < proposals.length, "Invalid proposal ID");
        require(!proposals[proposalId].executed, "Proposal has already been executed");
        proposals[proposalId].votes += balanceOf(msg.sender);
    }

    // function to execute a proposal
    function executeProposal(uint256 proposalId) public onlyOwner {
        require(proposalId < proposals.length, "Invalid proposal ID");
        require(!proposals[proposalId].executed, "Proposal has already been executed");
        require(proposals[proposalId].votes > totalShares / 2, "Proposal has insufficient votes");
        proposals[proposalId].executed = true;
    }

    // function to get the number of proposals
    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }

    // function to get the details of a proposal
    function getProposalDetails(uint256 proposalId) public view returns (string memory, uint256, bool) {
        require(proposalId < proposals.length, "Invalid proposal ID");
        return (proposals[proposalId].description, proposals[proposalId].votes, proposals[proposalId].executed);
    }

    // function to get the total number of shares
    function getTotalShares() public view returns (uint256) {
        return totalShares;
    }

    // function to get the number of shares held by an address
    function getBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // function to get the address of the owner
    function getOwner() public view returns (address) {
        return owner;
    }
    // Internal mapping to track whether a voter has voted on a specific proposal
    mapping(address => mapping(uint256 => bool)) private _voted;

    // Internal function to mark a voter as having voted on a proposal
    function _markVoted(address voter, uint256 proposalId) internal {
        _voted[voter][proposalId] = true;
    }

    // Internal function to check whether a voter has voted on a specific proposal
    function _hasVoted(address voter, uint256 proposalId) internal view returns (bool) {
        return _voted[voter][proposalId];
    }

    // Function to revoke shares (only callable by the owner)
    function revokeShares(address shareholder, uint256 amount) public onlyOwner {
    require(balanceOf(shareholder) >= amount, "Insufficient balance to revoke");
    _burn(shareholder, amount);
    totalShares -= amount;
    }

    // Function to reissue shares (only callable by the owner)
    function reissueShares(address shareholder, uint256 amount) public onlyOwner {
    _mint(shareholder, amount);
    totalShares += amount;
    }


}
