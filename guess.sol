pragma solidity >0.4.99;

contract Guess {
   address payable public owner;
   address payable[] public players;
   struct Player {
      uint256 guess;
      int8 prizeType;
    }
// The address of the player and => the user info
   mapping(address => Player) public playerInfo;
   function() external payable {}
   
  constructor() public {
      owner = msg.sender;
    }
function kill() public {
      if(msg.sender == owner) selfdestruct(owner);
    }
    
function checkPlayerExists(address payable player) public view returns(bool){
      for(uint256 i = 0; i < players.length; i++){
         if(players[i] == player) return true;
      }
      return false;
    }
function bet(uint8 outcomeguess) public payable {
      //The first require is used to check if the player already exist
      require(!checkPlayerExists(msg.sender));
//We set the player informations : amount of the bet and selected team
      playerInfo[msg.sender].guess = outcomeguess;
//We initialize the prize to NO PRIZE == -1
      playerInfo[msg.sender].prizeType = -1;
//then we add the address of the player to the players array
      players.push(msg.sender);
    }
    
function distributePrizes(uint8 answer) public {
      address payable[1000] memory winners;
      address winner;
      uint256 random_number;
      uint256 count = 0; // This is the count for the array of winners
      address payable playerAddress;
//We loop through the player array to check who selected the correct answer
      for(uint256 i = 0; i < players.length; i++){
         playerAddress = players[i];
//If the player selected the actual occurance, we add his address to the winners array
         if(playerInfo[playerAddress].guess == answer){
            winners[count] = playerAddress;
            count++;
         }
      }
//We loop through the array of winners, to randomly distribute the type of prizes avaluable to them.
      for(uint256 j = 0; j < count; j++){
          // Check that the address in this fixed array is not empty
         if(winners[j] != address(0))
            random_number = now%5;
            winner = winners[j];
            if(random_number == 0) {
                playerInfo[winner].prizeType=0;
            } else if(random_number ==1) {
                playerInfo[winner].prizeType=1;
            } else if (random_number ==2) {
                playerInfo[winner].prizeType=2;
            } else if (random_number ==3) {
                playerInfo[winner].prizeType=3;
            } else {
                playerInfo[winner].prizeType=4;
            }
      }
    }
    
function returnWinners(address payable player) public view returns(int8){
        for(uint256 i = 0; i < players.length; i++){
         if(players[i] == player) {
             return(playerInfo[player].prizeType);
         } else {
             return(-2);
         }
        }
    }
}

