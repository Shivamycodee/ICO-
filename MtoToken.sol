// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;



contract Ownable{

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address internal _owner;

    constructor() {
        _owner = msg.sender;
        emit  OwnershipTransferred(address(0),_owner);
    }

    modifier onlyOwner(){
        require(msg.sender == _owner,"Can only be called by owner");
        _;
    }

    function owner() public  view returns(address _ownerAddress){
         _ownerAddress = _owner;
    }

    function renounceOwnership() public onlyOwner{
        _owner = address(0);
        emit OwnershipTransferred(_owner,address(0));
    }

    function transferOwnership(address _newOwner) internal onlyOwner {
        require(_newOwner != address(0),"Zero Address used");
        _owner = _newOwner;
        emit OwnershipTransferred(_owner,_newOwner);
    }


}


interface ERC20{

    function transfer(address recipient,uint amount) external returns(bool);
    function transferFrom(address sender,address recipient,uint amount) external returns(bool);
    function balanceOf(address account) external returns(uint);
    function totalSupply() external returns(uint);
    function getOwner() external returns(address);
    
    event Transfer(address indexed from,address indexed To,uint amount);
    event Approval(address indexed owner,address indexed spender,uint amount);


}


contract Token is ERC20,Ownable{


    string public name;
    uint TotalSupply;
    string public symbol;
    uint public immutable decimals = 18;

    constructor(string memory _name,string memory _symbol,uint _amount){
        name = _name;
        symbol = _symbol;
        TotalSupply = _amount*10**decimals;
        balance[msg.sender] = TotalSupply;
        emit Transfer(address(0), msg.sender, TotalSupply);
    }



    mapping (address => uint) balance;
    mapping (address => mapping(address => uint)) allowances;


   
    function transfer(address _recipient,uint _amount) public override returns(bool){
       require(balance[msg.sender] > _amount && _amount > 0,"Not enough token at transfer");
       require(_recipient != address(0),"zero address in transfer");
       _transfer(msg.sender,_recipient,_amount);
        emit Transfer(msg.sender,_recipient,_amount);
       return true;
    }


    function transferFrom(address _sender,address _recipient,uint _amount) public override returns(bool){
        require(balance[_sender] > _amount && allowances[_owner][msg.sender] > _amount,"Not enough token at transferFrom");
        require(_sender != address(0) && _recipient != address(0),"zero address at transferFrom");
        allowances[_owner][msg.sender] -= _amount;
         _transfer(_sender,_recipient,_amount);
         emit Transfer(_sender,_recipient,_amount);
        return true;
    }

      function _transfer(address _sender,address _recipient,uint _amount) private returns(bool){
        require(balance[msg.sender] > _amount && _amount > 0,"Not enough token at _transfer");
        balance[_sender] -= _amount;
        balance[_recipient] += _amount;
        emit Transfer(_sender,_recipient,_amount);
        return true;

    }

    function inDecimalTransfer(address _recipient,uint _amount) public returns(bool){
    require(balance[msg.sender] > _amount && allowances[_owner][msg.sender] > _amount,"Not enough token");
    require( _recipient != address(0),"zero address recipient");
    balance[msg.sender] -= _amount;
    balance[_recipient] += _amount;
    emit Transfer(msg.sender,_recipient,_amount);
    return true;
    }

    function balanceOf(address _account) public override view returns(uint){
        require(_account != address(0),"zero address of balanceOf");
        return balance[_account];
    }

    function totalSupply() public override view returns(uint){
        return TotalSupply;
    }

    function getOwner() public override view returns(address){
       return owner();
    }

    function allowance(address _recipient,uint _amount) public {
        require(_recipient != address(0),"zero address in allowance");
        allowances[msg.sender][_recipient] = _amount;
       emit Approval(msg.sender,_recipient,_amount);
    }

    function decreaseAllowance(address _recipient,uint _amount) public {
         require(_recipient != address(0),"zero address in dec");
         require(allowances[msg.sender][_recipient]>_amount,"Not enough allowances to decrease.");
        allowances[msg.sender][_recipient] -= _amount;
    }

    function mint() external onlyOwner{
        TotalSupply += 1 ether;
        balance[_owner] += 1 ether;
        emit Transfer(address(0),msg.sender,1 ether);
    }

    function mintReward(address _account,uint _amount) external onlyOwner{
            require(_amount > 0);
            balance[_account] += _amount;
            TotalSupply += _amount;
    }

    function burn(uint _amount) public {
        require(balance[msg.sender]>_amount,"Not enough amount to burn");
        balance[msg.sender] -= _amount;
        TotalSupply -= _amount;
    }

}
