// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Insurence{
    address[] public policyholders;
    mapping(address => uint) public policies;
    mapping(address => uint) public claims;
    address payable owner;
    uint public totalPremium;

    constructor() public{
        owner = payable(msg.sender);
    }

    function purchasePolicy(uint premium) public payable{
        require(msg.value == premium, "Incorrect premium amount.");
        require(premium > 0, "Premium amount must be greater than 0");
        policyholders.push(msg.sender);
        policies[msg.sender] = premium;
        totalPremium += premium;
    }

    function fileClaim(uint amount) public{
        require(policies[msg.sender]>0, "Must have a valid policy to file a claim");
        require(amount > 0, "Claim must be greater than 0.");
        require(amount <= policies[msg.sender], "Claim amount cannot exceed policy");
        claims[msg.sender] += amount;
    }

    function approveClaim(address policyholder) public{
        require(msg.sender == owner, "Only owner can approve claims.");
        require(claims[policyholder]>0, "Policyholder has no outstanding claims.");
        payable(policyholder).transfer(claims[policyholder]);
        claims[policyholder] = 0;
    }


    function getPolicy(address policyholder) public view returns (uint){
        return policies[policyholder];
    }


    function getClaim(address policyholder) public view returns(uint){
        return claims[policyholder];
    }

    function getTotalPremium() public view returns(uint){
        return totalPremium;
    }

    function grantAccess(address payable user) public{
        require(msg.sender == owner, "Only the owner can grant access.");
        owner = user;
    }

    function revokeAccess(address payable user) public{
        require(msg.sender == owner, "Only owner can revoke access.");
        require(user != owner, "Cannot revoke access for current owner.");
        owner = payable(msg.sender);
    }

    function destroy() public{
        require(msg.sender == owner, "Only the owner can destroy the contract.");
        selfdestruct(owner);
    }
}
