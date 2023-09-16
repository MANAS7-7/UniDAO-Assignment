// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCheckedBlock;
    uint256 public blockThreshold = 10; // Number of blocks before the switch activates

    constructor(address _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lastCheckedBlock = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function stillAlive() public onlyOwner {
        lastCheckedBlock = block.number;
    }

    function checkStatus() public view {
        require(block.number - lastCheckedBlock <= blockThreshold, "Deadman's switch activated");
    }

    function withdraw() public onlyOwner {
        require(block.number - lastCheckedBlock > blockThreshold, "Cannot withdraw until the switch activates");
        uint256 contractBalance = address(this).balance;
        payable(beneficiary).transfer(contractBalance);
    }

    receive() external payable {}
}
