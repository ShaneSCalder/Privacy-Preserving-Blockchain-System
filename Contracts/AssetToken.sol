// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract AssetToken is IERC20 {
    using SafeMath for uint256;

    // State variables
    string public name = "Asset Token";
    string public symbol = "ASSET";
    uint8 public decimals = 18;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Constructor to initialize the total supply
    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Function to get the balance of an address
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // Function to get the total supply
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Function to transfer tokens to another address
    function transfer(address to, uint256 value) public override returns (bool) {
        require(to != address(0), "Transfer to the zero address");
        require(_balances[msg.sender] >= value, "Insufficient balance");
        
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // Function to approve an address to spend tokens on your behalf
    function approve(address spender, uint256 value) public override returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // Function to allow an approved address to transfer tokens on your behalf
    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        require(to != address(0), "Transfer to the zero address");
        require(_balances[from] >= value, "Insufficient balance");
        require(_allowances[from][msg.sender] >= value, "Allowance exceeded");
        
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }

    // Function to increase the allowance for an address
    function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
        _allowances[msg.sender][spender] = _allowances[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }

    // Function to decrease the allowance for an address
    function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "Allowance below spent amount");
        _allowances[msg.sender][spender] = currentAllowance.sub(subtractedValue);
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }
}


