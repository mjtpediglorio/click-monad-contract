// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ClickGame {
    bool[1600] public grid;
    address public immutable owner;
    
    uint256 public totalClicks;
    uint256 public totalTurnedOn;
    uint256 public totalTurnedOff;
    
    event BoxClicked(uint256 indexed position, bool newState, uint256 totalClicks);
    
    error NotOwner();
    error InvalidPosition();
    
    function resetGrid() internal {
        // Reset the grid
        for (uint i = 0; i < 1600; i++) {
            grid[i] = false;
        }
        
        // Original indices for one pattern
        uint256[62] memory pattern = [
            uint256(446), 486, 526, 566, 606, 487, 528, 489, 450, 490, 570, 610,
            453, 454, 492, 495, 532, 535, 572, 575, 613, 614, 457, 497, 537,
            577, 617, 498, 539, 580, 621, 461, 501, 541, 581, 621, 623, 583, 530,
            543, 544, 545, 546, 547, 465, 504, 506, 547, 587, 627, 469, 470,
            471, 509, 549, 589, 629, 630, 631, 512, 552, 592
        ];
        
        // Apply pattern at different positions
        int256[9] memory offsets = [int256(-1120), -840, -560, -280, 0, 280, 560, 840, 1120];
        uint256 totalSet = 0;
        
        for (uint o = 0; o < offsets.length; o++) {
            for (uint i = 0; i < pattern.length; i++) {
                int256 newIndex = int256(pattern[i]) + offsets[o];
                if (newIndex >= 0 && uint256(newIndex) < 1600) {
                    if (!grid[uint256(newIndex)]) { // Ensure we only count newly set boxes
                        grid[uint256(newIndex)] = true;
                        totalSet++;
                    }
                }
            }
        }

        // Update counters
        totalTurnedOn = totalSet;
        totalTurnedOff = 1600 - totalTurnedOn;
    }
    
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    function toggleBox(uint256 position) external onlyOwner {
        if (position >= 1600) revert InvalidPosition();
        
        // Toggle the box state
        bool newState = !grid[position];
        grid[position] = newState;
        
        // Update counters
        totalClicks++;
        if (newState) {
            totalTurnedOn++;
            totalTurnedOff--;
        } else {
            totalTurnedOn--;
            totalTurnedOff++;
        }
        
        emit BoxClicked(position, newState, totalClicks);
    }
    
    function getGrid() external view returns (bool[1600] memory) {
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
        for(uint i = 0; i < 1600; i++) {
            if(grid[i]) count++;
        }
        return count;
    }

    constructor() {
        owner = msg.sender;
        resetGrid();
    }
}