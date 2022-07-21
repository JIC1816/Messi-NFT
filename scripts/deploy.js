const { ethers } = require("hardhat");

async function main() {
  const initialBalance = ethers.utils.parseEther("0.3");
  const messiNFTContract = await ethers.getContractFactory("MessiCollection");
  const deployedContract = await messiNFTContract.deploy(
    "https://ipfs.io/ipfs/QmaEBPjTjEXfLZu5xEnjTtTd8g5yEJRUewCUtAKBMhnWyA/",
    {
      from: this.signer,
      value: initialBalance,
    }
  );
  await deployedContract.deployed();

  console.log("MessiCollection contract address is:", deployedContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
