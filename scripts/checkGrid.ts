import { ethers } from "hardhat";

async function main() {
    const contract = await ethers.getContractAt("ClickGame", '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0');
    const grid = await contract.getGrid();
    console.log(grid);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});