// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol"; // to use run

contract FundMeTest is Test {
    uint num = 1;
    //creating fake user to test tx
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;
    //runs first
    FundMe fundMe;

    function setUp() external {
        // num = 2;
        // us -> FundMeTest -> FundMe
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306); // if we use this we have to update it everytime we change our deploying of contract
        // we can call run() of deploy script here to update the setUp

        //us -> FundMeTest -> DeployFundMe -> FundMe
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,STARTING_BALANCE);
    }

    function testMinUsd() external {
        assertEq(fundMe.MINIMUM_USD(), 1e18);
    }

    function testOwnerIsMsgSender() external {
        // console.log(fundMe.i_owner());
        // console.log(msg.sender);

        // assertEq(fundMe.i_owner(), address(this)); (when run the test with us -> FundMeTest -> FundMe)
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVesion() external {
        assertEq(fundMe.getVersion(), 4);
    }

    //example of cheatcodes in foundry
    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // next line, should revert
        // assert(this tx fails/reverts)
        fundMe.fund(); //send 0 value --> will revert and test passes
    }

    function testFundUpdatesFundedDataStructure() public{
        vm.prank(USER);// next tx will sent by this user
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public{
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        
        address funder = fundMe.getFunder(0);
        assertEq(funder,USER);
    }

    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
    function testOnlyOwnerCanWithdraw() public /*funded*/{
        vm.prank(USER); // we can remove
        fundMe.fund{value: SEND_VALUE}();// these two if we use funded modifier
        
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded{
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //uint256 gasStart = gasLeft();
        //vm.txGasPrice(GAS_PRICE); // to change the default gas price 0 in forked local net
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //uint256 gasStop = gasLeft();
        //uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance,0);
        assertEq(endingOwnerBalance, startingOwnerBalance+startingFundMeBalance);

    }
    
    function testWithdrawFromMultipleFunders() public funded {

        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for(uint160 i = startingFunderIndex; i<numberOfFunders; i++){
            // hoax will do prank and deal
            hoax(address(i),SEND_VALUE);//creates a new user and assigns ether
            fundMe.fund{value: SEND_VALUE}();
        }


        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //vm.startPrank(), vm.stopPrank can be used
        vm.prank(fundMe.getOwner()); 
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalanace = address(fundMe).balance;

        assertEq(endingFundMeBalanace,0);
        assertEq(endingOwnerBalance,startingOwnerBalance + startingFundMeBalance);
    }
    function testCheaperWithdrawFromMultipleFunders() public funded {

        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for(uint160 i = startingFunderIndex; i<numberOfFunders; i++){
            // hoax will do prank and deal
            hoax(address(i),SEND_VALUE);//creates a new user and assigns ether
            fundMe.fund{value: SEND_VALUE}();
        }


        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //vm.startPrank(), vm.stopPrank can be used
        vm.prank(fundMe.getOwner()); 
        fundMe.cheaperWithdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalanace = address(fundMe).balance;

        assertEq(endingFundMeBalanace,0);
        assertEq(endingOwnerBalance,startingOwnerBalance + startingFundMeBalance);
    }

    // function testDemo() external {
    //     console.log(num);
    //     console.log("Hello");
    //     assertEq(num, 2);
    // }
}

// what can we do to work with addresses outside our system

//1. Unit testing
//2. Integration
//3. forked testing
// testing in a simulated environment
// forge test --match-test testPriceFeedVesion --fork-url $RPC_URL_-vvv
//4. Staging
// testing in a real environment
