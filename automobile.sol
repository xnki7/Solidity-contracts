//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Automotive{
    address public owner;
    mapping(address=>bool) public buyers;
    string public vehicleMake;
    string public vehicleModel;
    uint public price;

    event Purchase (address buyer, string make, string model, uint price);
    

    constructor() {
        owner = msg.sender;
    }

    function buyVehicle(string memory _make, string memory _model) public payable{
        require(msg.value >= price);
        require(buyers[msg.sender] == false);
        vehicleMake = _make;
        vehicleModel = _model;
        buyers[msg.sender] = true;
        emit Purchase(msg.sender, _make, _model, price);
    }

    function setPrice (uint _price) public{
        require(msg.sender == owner);
        price = _price;
    }

    function checkOwnership() public view returns (bool){
        return buyers[msg.sender];
    }
}
