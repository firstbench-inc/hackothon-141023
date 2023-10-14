// om allah jesus



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract test {
    mapping(string => uint256) public usernamesToUIDs;
    mapping(uint256 => string) public UIDsToUsername;

    address public owner;
    mapping(address => bool) public administrators;

    constructor() {
        owner = msg.sender;
        administrators[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    modifier onlyAdministrator() {
        require(administrators[msg.sender], "Only administrators can call this function");
        _;
    }

    function addAdministrator(address newAdmin) public onlyOwner {
        administrators[newAdmin] = true;
    }

    function removeAdministrator(address admin) public onlyOwner {
        administrators[admin] = false;
    }

    function registeration(string memory username, uint256 uid) public {
        require(uid != 0, "UID cannot be 0");
        require(bytes(username).length > 0, "Username cannot be empty");
        require(usernamesToUIDs[username] == 0, "Username already exists");

        usernamesToUIDs[username] = uid;
        UIDsToUsername[uid] = username;
    }
}




