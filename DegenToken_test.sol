// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "test.sol";
import "remix_tests.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenTokenTest {
    DegenToken token;

    function beforeAll() public {
        token = new DegenToken();
        token.mintTokens(address(this), 1000);  
    }
    function testMintTokens() public {
        Assert.equal(token.balanceOf(address(this)), 1000, "Initial balance should be 1000 tokens");            
    }

    function testSender() public {
        Assert.equal(token.owner(), address(this), "Contract Owner should be the one who deployed");        
    }

    function testTransferTokens() public {
        token.transferTokens(msg.sender, 100);  
        Assert.equal(token.balanceOf(address(this)), 900, "Balance after transfer should be 1000 tokens");
    }

    function testRedeem() public {
        token.redeem(0); // Assuming item 0 is "Sword of the Thor's God"        
        Assert.equal(token.balanceOf(address(this)), 900  - 100 , "Balance after redeeming should decrease");       
        Assert.equal(token.checkInventory().length, 1, "Inventory should have 1 item after redeeming"); 
    }

    function testBurnTokens() public {
        token.burnTokens(100);              
        Assert.equal(token.balanceOf(address(this)), 700 , "Balance after burning should decrease by 700 tokens");       
    }

    function testRemoveOneItem() public {    
        token.removeOneItem();  
        Assert.equal(token.checkInventory().length, 0, "Inventory should be empty after removing one item");
    }

    function testShowItemLists() public {
        DegenToken.item[] memory items = token.showItemLists();
        Assert.equal(items.length, 3, "There should be 3 items in the item list");  
        Assert.equal(stringCompare(items[0].itemName, "Sword of the Thor's God"), true, "First item name should match");      
    }

    // Helper function to compare strings
    function stringCompare(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}