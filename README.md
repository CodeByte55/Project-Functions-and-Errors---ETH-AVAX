# Project-Functions-and-Errors---ETH-AVAX

This Solidity program is a simple User registration program that demonstrates the basic function and error handling of the Solidity programming language, specifically using require(), assert() and revert() statements.

## Description

This program is a simple contract that allows the address that deployed the contract to be the admin, which is capable of registering and resetting one username and password mapped to that address. Use of the require(), assert() and revert() statements is applied as the required components of this project. These statements are implemented as error handling structures that will test the user inputs, if the admin address already has a registered username and password or not, when registering or resetting a user. It will stop the function and display error messages if the required conditions are not met.   

## Getting Started

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., UserRegistraion.sol). Copy and paste the following code into the file:

```javascript
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
```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.0" (or another compatible version), and then click on the "Compile UserRegistraion.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "UserRegistraion" contract from the dropdown menu, and then click on the "Deploy" button.

Once the contract is deployed, you can interact with it by clicking the public variables userCount and admin, to know if there is a user saved in your contract deployer address, which is stored in admin. The registerUser function requires a username and password input, which will be saved to a mapping variable linked to the contract deployer (admin) address. Calling the function getUsername will display the username, if there is already a saved user. The resetUser function also requires a username and password input. if the credentials are correct, the user saved at the mapping variable is reset, and a new username and password can be saved again using the registerUser function.

## Authors

Rylan Torres  
[@202111443@fit.edu.ph]


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
