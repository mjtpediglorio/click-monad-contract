import { ethers } from "hardhat";

async function main() {
  // Get the contract factory
  const ClickGame = await ethers.getContractFactory("ClickGame");

  // Deploy the contract
  const clickGame = await ClickGame.deploy();
  await clickGame.waitForDeployment();

  console.log("ClickGame deployed to:", clickGame.target);

  // Optional: Verify contract is working by calling some functions
  const owner = await clickGame.owner();
  console.log("Contract owner:", owner);

  // Get initial stats
  const [totalClicks, totalTurnedOn, totalTurnedOff] = await clickGame.getClickStats();
  console.log("Initial stats:", {
    totalClicks: totalClicks.toString(),
    totalTurnedOn: totalTurnedOn.toString(),
    totalTurnedOff: totalTurnedOff.toString()
  });

  // Get active box count
  const activeBoxes = await clickGame.getActiveBoxCount();
  console.log("Active boxes:", activeBoxes.toString());
}

// Handle errors
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});