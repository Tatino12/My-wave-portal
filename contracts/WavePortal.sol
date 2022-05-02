//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves; 

    //We will be using this below to help generate a random number
    uint256 private seed; //creo una variable seed que esencialmente cambiará cada vez que un usuario envíe una nueva ola.
    
    event NewWave(address indexed from, uint256 timestamp, string message);
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    } 
    //I declare a variable waves that lets me store an array of structs.
     //This is what lets me hold all the waves anyone ever sends to me!
     Wave[] waves;

     // This is an address => uint mapping, meaning I can associate an address with a number!
     //In this case, I'll be storing the address with the last time the user waved at us.
        mapping(address => uint256) public lastWavedAt;


    constructor() payable {
        console.log("We have been constructed!");
    
    //Set the initial seed // tomo dos números que me dio Solidity block.difficultyy block.timestamplos combino para crear un número aleatorio.
    seed = (block.timestamp + block.difficulty) % 100; //(% 100)que me aseguraré de que el número se reduzca a un rango entre 0 y 99
    }
//it requires a string called _message. This is the message our user sends us from the frontend!
    function wave(string memory _message) public {
        //We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
        require(lastWavedAt[msg.sender] + 15 seconds < block.timestamp, 
        "Must wait 30 seconds before waving again.");
        //Update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;
        
        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);
        //This is where I actually store the wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        //Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        //Give a 50% chance that the user wins the prize.
        if ( seed <= 50) { //if simple para ver si la semilla es menor o igual a 50, si lo es, ¡entonces el vacilante gana el premio! Entonces, eso significa que el vacilante tiene un 50% de posibilidades de ganar desde que escribimos seed <= 50. Puedes cambiar esto a lo que quieras :
            console.log("%s won!", msg.sender);

//Con prizeAmount Acabo de iniciar una cantidad de premio. Solidity en realidad nos permite usar
// la palabra clave ether para que podamos representar fácilmente cantidades monetarias
        uint256 prizeAmount = 0.0001 ether;
        require ( //require que básicamente verifica que alguna condición sea verdadera. Si no es cierto, abandonará la función y cancelará la transacción
            prizeAmount <= address(this).balance, //address(this).balance está el saldo del contrato en sí,
            "Trying to withdraw more money than the contract has." //para que podamos enviar ETH a alguien, nuestro contrato debe tener ETH
        );
        (bool success, ) = (msg.sender).call{value: prizeAmount}(""); // (msg.sender).call{value: prizeAmount}("") es la línea mágica donde enviamos dinero 
        require(success, "Failed to withdraw money from contract."); //require(success es donde sabemos que la transacción fue un éxito. Si no fuera así, marcaría la transacción como un error y diría "Failed to withdraw money from contract."
    }
        emit NewWave(msg.sender, block.timestamp, _message);
}
    //This will make it easy to retrieve the waves from our website!    
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}