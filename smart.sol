//om allah jesus
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract UserRegistryAndEncryptedMessaging is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable, PausableUpgradeable, UUPSUpgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using AddressUpgradeable for address payable;

    struct User {
        uint256 uid;
        string username;
    }

    struct Message {
        address sender;
        address recipient;
        bytes32 ipfsHash;
        uint256 replyTo;
        bool readStatus;
        uint256 readTimestamp;
    }

    mapping(address => User) public users;
    mapping(string => uint256) public usernamesToUIDs;
    mapping(uint256 => string) public UIDsToUsernames;

    mapping(uint256 => Message) private _messages;
    mapping(address => EnumerableSetUpgradeable.UintSet) private _userMessages;
    uint256 private _nextMessageId;

    constructor() {
        __Ownable_init();
        __ReentrancyGuard_init();
        __Pausable_init();
        __UUPSUpgradeable_init();
    }

    modifier onlyOwner() {
        require(msg.sender == owner(), "Only the owner can call this function");
        _;
    }

    modifier onlyAdministrator() {
        require(administrators[msg.sender], "Only administrators can call this function");
        _;
    }

    function setOwner(address newOwner) public onlyOwner {
        _setOwner(newOwner);
    }

    function addAdministrator(address newAdmin) public onlyOwner {
        administrators[newAdmin] = true;
    }

    function removeAdministrator(address admin) public onlyOwner {
        administrators[admin] = false;
    }

    function registerUser(string memory username, uint256 uid) public {
        require(uid != 0, "UID cannot be 0");
        require(bytes(username).length > 0, "Username cannot be empty");
        require(usernamesToUIDs[username] == 0, "Username already exists");

        usernamesToUIDs[username] = uid;
        UIDsToUsernames[uid] = username;
        users[msg.sender] = User(uid, username);
    }

    function sendMessage(address recipient, bytes32 ipfsHash, uint256 replyTo) external payable whenNotPaused {
        require(recipient != address(0) && recipient != address(this), "Invalid recipient address");

        uint256 parentThreadId = replyTo != 0 ? _messages[replyTo].replyTo : 0;

        require(replyTo == 0 || _messages[replyTo].sender == msg.sender || _messages[replyTo].recipient == msg.sender, "Invalid replyTo message ID");

        _messages[_nextMessageId] = Message(msg.sender, recipient, ipfsHash, parentThreadId, false, 0);

        _userMessages[msg.sender].add(_nextMessageId);
        _userMessages[recipient].add(_nextMessageId);

        emit MessageSent(_nextMessageId, msg.sender, recipient, ipfsHash, replyTo, block.timestamp);
        emit MessageReceived(_nextMessageId, msg.sender, recipient);

        if (msg.value > 0) {
            payable(recipient).sendValue(msg.value);
        }

        _nextMessageId++;
    }

    function markAsRead(uint256 messageId) external whenNotPaused {
        Message storage message = _messages[messageId];

        require(msg.sender == message.recipient, "Caller must be recipient of the message");

        message.readStatus = true;
        message.readTimestamp = block.timestamp;

        emit MessageRead(messageId, msg.sender, block.timestamp);
    }

    function getMessage(uint256 messageId) external view returns (address, address, bytes32, uint256, bool, uint256) {
        Message storage message = _messages[messageId];

        return (message.sender, message.recipient, message.ipfsHash, message.replyTo, message.readStatus, message.readTimestamp);
    }

    function getMessages(uint256 startIndex, uint256 endIndex) external view returns (Message[] memory) {
        require(startIndex < endIndex && endIndex <= _nextMessageId, "Invalid indices");

        Message[] memory messages = new Message[](endIndex - startIndex);

        for (uint256 i = startIndex; i < endIndex; i++) {
            messages[i - startIndex] = _messages[i];
        }

        return messages;
    }

    function getUserMessageIds(address user) external view returns (uint256[] memory) {
        EnumerableSetUpgradeable.UintSet storage userSet = _userMessages[user];
        uint256[] memory ids = new uint256[](userSet.length());

        for (uint256 i = 0; i < userSet.length(); i++) {
            ids[i] = userSet.at(i);
        }

        return ids;
    }

    function getMessageCount() external view returns (uint256) {
        return _nextMessageId;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
