// om allah jesus

pragma solidity ^0.8.19;


contract test{
    mapping(string => uint256) public usernamesToUIDs;
    mapping(uint256 => string) public UIDsToUsername;
    
    address public owner;

    constructor(){
        owner = msg.sender;
    } 

    function registeration(string memory username,uint256 uid) public {
        require(uid != 0, "UID cannot be 0");
        
        if (usernamesToUIDs[username] != 0) {
            revert("Username already exists");
        }
         usernamesToUIDs[username] = uid;
         UIDsToUsername[uid] = username;
    }
}




