pragma solidity ^0.8.0;

contract MockERC20A {
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    string public name;
    string public symbol;
    uint public decimals;

    function transfer(address recipient, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] = balanceOf[msg.sender]- amount;
        balanceOf[recipient] = balanceOf[recipient]+ amount;
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        balanceOf[sender] = balanceOf[sender] - amount;
        balanceOf[recipient] = balanceOf[recipient] + amount;
        allowance[sender][msg.sender] = allowance[sender][msg.sender] - amount;
        return true;
    }
}