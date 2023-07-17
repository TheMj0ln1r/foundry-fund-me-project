+ forge init --force
+ forge <compile | build >    --> to compile project
+ forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit     --> installing contract dependencies

Remapping imports to installed dependencies 
    In .toml file
    + remappings=["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/"]


++ deploying contract 
    
   with script
    $ forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0 1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff8 --broadcast
  
  Running one contract in a script
    $ forge script script/Interactions.s.sol:FundFundMe --rpc-url http://127.0.0 1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff8 --broadcast
   
   with create
    $ forge create <constract> --rpc-url <URL> --interactive --broadcast




+ forge test --> to run test script

Fork Testing
    + forge test --match-test testPriceFeedVesion --fork-url $RPC_URL_-vvv

Find how much code is tested 
    + forge coverage --fork-url $SEPOLIA_RPC_URL


gas snapshot
    + forge --snapshot <test name>



> During a fork test, the code execution and transactions occur locally on a simulated blockchain instance, replicating the state of the Mainnet. However, these transactions are not broadcasted or executed on the actual Mainnet network. As a result, no gas fees are incurred because the interactions are confined to the local testing environment.

+ the default gas price is 0 in anvil chain and in any forked chain
+ to make the tests are work with real gas prices on mainnet or other which has gas price 
+ txGasPrice cheatcode is used

> chisel used to run solidity code pieces in shell

+ to view storage layout of a contract
+ forge inspect FundMe storageLayout
+ cast storage <contract address> <slot>
    cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 2


> Interaction scripts are to contact smart contracts in programmaticatically, rather than in  using cast cli way

> command to deploy and verify the conctract on etherscan 
    $ forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv