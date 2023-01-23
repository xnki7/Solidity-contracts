// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {
    // string public name ;
    address public owner;
    struct Item{
        uint id;
        string name;
        string category;
        string image;
        uint cost;
        uint rating;
        uint stock;
    }

    struct Order{
        uint time;
        Item item;
    }

    mapping(uint => Item) public items;
    mapping(address => uint) public orderCount; 
    mapping(address=> mapping(uint => Order)) public orders;

    event List(string name, uint cost, uint quantity);
    event Buy(address buyer, uint orderId, uint itemId);

    modifier onlyOwner{
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(){
        // name = "Dappazon";
        owner = msg.sender;
    }

    //list product
    function list(
        uint _id, 
        string memory _name, 
        string memory _category,
        string memory _image,
        uint _cost,
        uint _rating,
        uint _stock
        ) public onlyOwner {
            //create Item struct
            Item memory item = Item(_id, _name, _category, _image, _cost, _rating, _stock);

            //save Item struct to blockchain
            items[_id] = item;

            //emit an event
            emit List(_name, _cost, _stock);

    }

    //Buy product
    function buy(uint _id) public payable{
        //fetch item
        Item memory item = items[_id];

        //requirements
        require(msg.value >= item.cost);
        require(item.stock > 0);

        //create an order
        Order memory order = Order(block.timestamp, item);

        //save order to chain
        orderCount[msg.sender]++ ;
        orders[msg.sender][orderCount[msg.sender]] = order; 

        //substract stock
        items[_id].stock = item.stock -1;

        //emit event
        emit Buy(msg.sender, orderCount[msg.sender], item.id);
    }

    //withdraw funds
    function withdraw() public onlyOwner{
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}
