// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


//https://github.com/Cyfrin/foundry-devops
//forge install Cyfrin/foundry-devops --no-commit


//Interaction scripts are to contact smart contracts in programmaticatically, 
//rather than in  using cast cli way

//fund
//withdraw


import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
import {console} from "forge-std/console.sol";

contract FundFundMe is Script{
    uint256 constant SEND_VALUE = 0.01 ether;
    function fundFundMe(address mostRecentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value:SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe ");
    }

    function run() external{

        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        fundFundMe(mostRecentlyDeployed);
        
    }
}

contract WithdrawFundMe is Script{
    function withdrawFundMe(address mostRecentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrawed.");
    }

    function run() external{
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
        
    }
}