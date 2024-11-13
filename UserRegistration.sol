// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistration {
    struct User {
        string username;
        string password;
        bool isRegistered;
    }

    mapping(address => User) private users;
    uint public userCount = 0;
    address public admin;

    constructor() {
        admin = msg.sender; // Set the contract deployer as the admin
    }

    // Modifier to restrict access to admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Function to register a user with a unique username and password
    function registerUser(string memory _username, string memory _password) public {
        // Use `require()` to check if the username and password is not empty
        require(bytes(_username).length > 0 && bytes(_password).length > 0, "Username and password cannot be empty");

        // Check if the user is already registered
        if (users[msg.sender].isRegistered) {
            revert("User is already registered"); // Use `revert()` to stop execution if already registered
        }

        // Register the user
        users[msg.sender] = User({username: _username, password: _password, isRegistered: true});
        userCount += 1;

        // Use `assert` to check that the user count has increased
        assert(userCount > 0);
    }

    // Function to get the username of the registered user
    function getUsername() public view returns (string memory) {
        return users[msg.sender].username;
          
    }

    // function to compare if input username and password is the same as saved username and password
    function resetUser(string memory _username, string memory _password) public {
        // Use `require()` to check if the username and password is not empty
        require(bytes(_username).length > 0 && bytes(_password).length > 0, "Username and password cannot be empty");
        
        // Retrieve the stored username and password
        string memory storedUsername = users[msg.sender].username;
        string memory storedPassword = users[msg.sender].password;

        // Check if the input username and password match the stored username and password
        require(users[msg.sender].isRegistered, "User is not registered");
        if (keccak256(bytes(storedUsername)) == keccak256(bytes(_username)) &&
            keccak256(bytes(storedPassword)) == keccak256(bytes(_password))) {
            reset(msg.sender);
        } else {
            revert("Username or password is incorrect");
        }
    }

    // Function for admin to reset a user's registration
    function reset(address _userAddress) private onlyAdmin {
        // Use `require()` to check if the user is already registered
        require(users[_userAddress].isRegistered, "User is not registered");

        // Reset the user's registration username and status
        users[_userAddress].username = " ";
        users[_userAddress].password = " ";
        users[_userAddress].isRegistered = false;
        userCount -= 1;

        // Use `assert()` to ensure the user count does not fall below zero
        assert(userCount >= 0);
    }
}
