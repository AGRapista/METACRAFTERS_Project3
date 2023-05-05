// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract TokenValidation {

// Contract Variables _________________________________________________________________________________________________

    address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    // state variables here
    string public TknName = "ETHCoin";
    string public TknAbbrv = "ETC";
    uint public TknSupply = 0;
    uint public MinimumGasRequired = 4000000;

    struct transaction {
        address _address;
        string operation;
        int value;
    }

    mapping (address => uint) private ledger;  // mapping variable 
    transaction[] public transactionHistory;  // array to hold all transactions


// Contract Functions ___________________________________________________________________________________________________

    // mint function that owner could only access
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    modifier addressExists(address ledgerAddress){
        if (ledger[ledgerAddress] == 0){
            revert("Address does not exist");
        }
        _;
    }

    function mint(address ledgerAddress, uint amount) external onlyOwner {
        TknSupply += amount;
        ledger[ledgerAddress] += amount;
        transactionHistory.push(
            transaction(ledgerAddress, "mint", int(amount))
        );
    }

    // burn function
    function burn(address ledgerAddress, uint amount) external onlyOwner addressExists(ledgerAddress) {
        uint amountInAddress = ledger[ledgerAddress];

        assert (amountInAddress >= amount);
        ledger[ledgerAddress] -= amount;
        TknSupply -= amount;
        transactionHistory.push(
            transaction(ledgerAddress, "burn", int(amount))
        );
        
    }

}
