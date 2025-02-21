// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClickGame {
    bool[256] public grid;
    address public immutable owner;
    
    uint256 public totalClicks;
    uint256 public totalTurnedOn;
    uint256 public totalTurnedOff;
    
    event BoxClicked(uint256 indexed position, bool newState, uint256 totalClicks);
    
    error NotOwner();
    error InvalidPosition();
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    function toggleBox(uint256 position) external onlyOwner {
        if (position >= 256) revert InvalidPosition();
        
        // Toggle the box state
        bool newState = !grid[position];
        grid[position] = newState;
        
        // Update counters
        totalClicks++;
        if (newState) {
            totalTurnedOn++;
        } else {
            totalTurnedOff++;
        }
        
        emit BoxClicked(position, newState, totalClicks);
    }
    
    function getGrid() external view returns (bool[256] memory) {
        return grid;
    }
    
    function getClickStats() external view returns (uint256, uint256, uint256) {
        return (totalClicks, totalTurnedOn, totalTurnedOff);
    }
    

    function getOwner() external view returns (address) {
        return owner;
    }

    function getActiveBoxCount() public view returns (uint256) {
        uint256 count = 0;
        for(uint i = 0; i < 256; i++) {
            if(grid[i]) count++;
        }
        return count;
    }

    function resetGrid() external onlyOwner {
        for(uint i = 0; i < 256; i++) {
            grid[i] = false;
        }
    }
}