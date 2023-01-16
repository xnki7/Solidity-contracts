// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Xnkit is IERC20{
    string public name = "Xnki7";
    string public symbol = "XK7";
    uint public decimal = 0;
    uint public override totalSupply; 
    address public founder;
    mapping(address=>uint) public balances;
    mapping(address=>mapping(address=>uint)) public allowed;

    constructor(){
        totalSupply = 100;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address account) external view override returns (uint){
        return balances[account];
    }

    function transfer(address recipient, uint amount) external override returns (bool){
        require(balances[msg.sender]>=amount, "You have insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint){
        return allowed[owner][spender];
    }

    function approve(address spender, uint amount) external override returns (bool){
        require(balances[msg.sender]>=amount, "You have insufficient balance");
        require(amount>0, "Zero tokens cannot be approved");
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool){
        require(allowed[sender][recipient]>=amount, "You did not get approval for this much amount");
        require(balances[sender]>=amount, "You have insufficent balance");
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        require(msg.sender == founder, "You are not the founder of contract");
        balances[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        require(msg.sender == founder, "You are not the founder of contract");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}
