//SP-license-Identifier: MIT

//smart contractt that lets anyone deposit ETH into the contract
//only the owner of the contrct can withdraw the ETh

pragma solidity >= 0.6.0 <0.9.0;

interface AggregatorV3Interface {

 //Get the latest ETH/USD price from chainlink price feed


//block chain (decentralized) oracle is neccessary to make sure that information can come from the 
//internet without human input - a good example is chain link


import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  
  function getRoundData(uint80 _roundId){
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
  }
  
contract FundMe {
      // safe math library check uint256 for interger overflows
      //and stops normal math calculations from overflowing
      using SafeMathChainlink for uint256;

      //mapping (or links) which stores which address deposited an amount of funds 
      //calling method addressTOamountfunded and making it public allows everyone to see it
      mapping(address => uint256) public addressToAmountFunded;
        
      //an array of addresses specifically for those who deposited
      address[] public funders;
      
      //address of the owner (who deployed the contract)
      address public owner;

      /// the constructor is an on start function, meaning that on the contract being set up these things are automatically deployed
      //the first person to deplot the contract is

      contructor() public {
        owner = msg.sender;
      }

      function getVersion() public view returns (uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return pricefeed.version();
      }

      function getPrice() public view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int answer,,,) = pricefeed.latestRoundData();
        // ETH/USD rate in 18 digit ;
        return uint256(answer * 10000000000);
      }

      function getConversionRate(uint256 ethamount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD converision rate, after adjusting the extra 0s
        return ethAmountInUsd;
      }

      //a public funciton that is type payable
      function fund() public payable {
        
         uint256 minimumUSD = 50 * 10 ** 18;

         require(getConversionRate(msg.value*) >= minimumUSD, "You need to spend more EHT!");
         //require means only allow, so the code reads: if not above minimum warning message else, add to mapping and funders array
         addressToAmountFunded[msg.sender] += msg.value;
         funders.push(msg.sender);
        }

       function fund() public payable {
          addressToAmountFunded[msg.sender] += msg.value; 
        }

        //modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
        modifier onlyOwner {
          //is the message sender owner of the contract?
          require(msg.sender == owner);
          _;
        }



        function withdraw() payable onlyOwner public {
          //only modifier will check if their condition is true function will checker that the condition is true,
          // (person executing request is the owner, owner is the one who initiates contract)

          //if you are using version eight(v8) of chainlink aggregator
          //payable(msg.sender).transfer(address(this).balance);
          msg.sender.transfer(address(this).balance);


          //iterate through all the mappings and make them 0
          //since all the deposited amount has been withdrawn
          for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
          }

          //funders array will be initialized to 0
          funders = new address[](0); 
        }
} 
}