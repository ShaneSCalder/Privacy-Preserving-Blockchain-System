// deploy-bond-token.js
// Deploy Bond Token contract to local blockchain
//const { ethers } = require("hardhat");
const { ethers } = require("ethers"); 

async function main() {
    const BondToken = await ethers.getContractFactory("BondToken");
    const bondToken = await BondToken.deploy("My Bond Token", "MBT", 1000000, 1735660800); // Example parameters
  
    await bondToken.deployed();
  
    console.log("Bond Token deployed to:", bondToken.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });

// Path: scripts/deployBondMaker.js

