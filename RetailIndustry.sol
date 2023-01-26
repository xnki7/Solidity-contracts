// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Retail{
    struct Product{
        bytes32 name;
        uint price;
        uint stock;
    }

    mapping(bytes32 => Product) public products;
    address payable owner;

    constructor(){
        owner = payable(msg.sender);
    }

    function addProduct(bytes32 _name, uint _price, uint _stock) public {
        require(msg.sender == owner, "Only the owner can add products");
        products[_name] = Product(_name, _price, _stock);
    }

    function updateProductPrice(bytes32 name, uint price) public{
        require(msg.sender == owner, "Only owner can update product prices.");
        require(products[name].price>0, "product does not exist");
        products[name].price = price;
    }

    function updateProductStock(bytes32 name, uint stock) public{
        require(msg.sender == owner, "Only the owner can update the product's stock");
        require(products[name].stock > 0, "Product does not exist");
        products[name].stock = stock;
    }

    function purchase(bytes32 name, uint quantity) public payable{
        require(msg.value == products[name].price * quantity,"Incorrect payment amount");
        require(quantity <= products[name].stock, "Not enough stock");
        products[name].stock -= quantity;
    }

    function getproduct(bytes32 name) public view returns(bytes32, uint, uint){
        return (products[name].name, products[name].price, products[name].stock);  
    }

    function grantAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can grant access.");
        owner = user;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can revoke access.");
        require(user != owner, "Cannot revoke access for the current owner.");
        owner = payable(msg.sender);
    }

    function destroy() public{
        require(msg.sender == owner,"Only the owner can destroy the contract.");
        selfdestruct(owner);
    }
}
