const hre = require("hardhat");

async function main() {
  const ChatApp = await hre.ethers.getContractFactory("smart");
  const smart = await ChatApp.deploy();

  await smart.deployed();

  console.log(` Contract Address: ${smart.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});