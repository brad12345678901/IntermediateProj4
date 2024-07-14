// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable {
  
    struct item {
      string itemName;
      uint256 price;
    }

    mapping (uint256 => item) private itemLists;
    mapping (address => string[]) private inventory;
    uint256 private numberofitemlist = 3;
    uint256 private limitinventory = 10;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender){
      initItems();
    }

    //Mint Token
    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);           
    }

    function initItems() public {
        itemLists[0] = item("Sword of the Thor's God",100); 
        itemLists[1] = item("Death's Scythe",200);  
        itemLists[2] = item("Moonletta's Double Twin Slashers",150);
    }

    //Transfer Token
    function transferTokens(address _receiver, uint256 _amount) external  {
      require(balanceOf(msg.sender) >= _amount, "Insufficient balance");
      approve(msg.sender, _amount);         
      transferFrom(msg.sender, _receiver, _amount);         
    }

    //Redeeming Tokens
    function redeem (uint256 itemId) external payable {
        uint256 price = itemLists[itemId].price;
        require(balanceOf(msg.sender) >= price, "Insufficient balance");
        require(inventory[msg.sender].length < 10, "Inventory is Full");
        assert(inventory[msg.sender].length < 10);
        inventory[msg.sender].push(itemLists[itemId].itemName);   
        _burn(msg.sender, price);   
    }
    function removeOneItem() external  {
      require(inventory[msg.sender].length > 0, "You have nothing in your Inventory");
      inventory[msg.sender].pop();
    }
    //Burn Token Function
    function burnTokens(uint256 amount) external  {
        _burn(msg.sender, amount);          
    }

    //Item lists price
    function showItemLists() public view returns (item[] memory) {
        item[] memory allitems = new item[](numberofitemlist);  
        for (uint256 i = 0; i < numberofitemlist; i++){
          allitems[i] = itemLists[i]; 
        }
        return allitems;
    }

    //Check Balance
    function viewBalance() public view returns (uint256){
      return super.balanceOf(msg.sender);
    }
    //Check Inventory
    function checkInventory() public view  returns (string[] memory){
      return inventory[msg.sender];
    }
}
