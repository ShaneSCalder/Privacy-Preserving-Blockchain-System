// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BondToken is ERC20 {
    address public issuer;
    uint256 public maturityDate;

    /**
     * @param _name The name of the bond token.
     * @param _symbol The symbol or ticker of the bond token.
     * @param _totalSupply The total supply of bond tokens.
     * @param _maturityDate The maturity date of the bond (as a timestamp).
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint256 _maturityDate
    ) ERC20(_name, _symbol) {
        require(_maturityDate > block.timestamp, "Maturity date must be in the future");
        issuer = msg.sender;
        maturityDate = _maturityDate;

        // Mint the initial supply to the issuer
        _mint(msg.sender, _totalSupply);
    }

    /**
     * @notice Allows the issuer to redeem the bond tokens for the underlying asset.
     */

    function redeem() external {
        require(msg.sender == issuer, "Only the issuer can redeem the bond");
        require(block.timestamp >= maturityDate, "The bond cannot be redeemed before maturity");

        // Burn the bond tokens from the issuer
        _burn(issuer, balanceOf(issuer));

        // Transfer the underlying asset to the issuer
        // (in a real-world scenario, this would be a transfer to msg.sender)
        // (and the issuer would be a bank or other financial institution)
        _transfer(address(this), issuer, ERC20(address(this)).balanceOf(address(this)));   
        
}
