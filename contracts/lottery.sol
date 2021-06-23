pragma solidity ^0.4.17;

contract Lottery{
    address public manager;
    address[] public players;

    function Lottery() public{
        // Deployer of the contract becomes the manager
        manager = msg.sender;
    }

    function enterGame() public payable{
        // paying 0.01ether to enter the lottery
        require(msg.value > 0.01 ether);

        // add the player to the list
        players.push(msg.sender);
    }

    function getPlayerList() public view returns(address[]){
        // getting the list of players
        return players;
    }

    function random() private view returns(uint){
        // get a pseudorandom number
        return uint(keccak256(block.difficulty, now, players)); 
    }

    function pickWinner() public restricted{
        // pick a random winner
        uint index = random() % players.length;

        // transfer the whole amount to the winner's account 
        players[index].transfer(this.balance);

        // reset the game after getting the winner 
        players = new address[](0);

    }

    modifier restricted(){
        // only manager can call the function
        require(msg.sender == manager);
        _;
    }

}