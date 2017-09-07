pragma solidity ^0.4.15;

import "./Owned.sol";

contract Mortal is Owned {
    
    function kill() { 
        if (msg.sender == owner) 
            suicide(owner); 
    }
}