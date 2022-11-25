// SPDX-License-Identifier:- MIT
pragma solidity ^0.8.8;


contract Ownable{
    address public owner;

    event TransferOwner(address previousOwner,address newOwner);
    event chargeChanged(uint ChargeValue, uint chargeDecimal);
    event rateChanged(uint newRate);

    constructor(){
       owner = msg.sender;
       emit TransferOwner(address(0),owner);
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Only admin can call");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner{
        owner = _newOwner;
        emit TransferOwner(msg.sender,_newOwner);
    }

  function renounceOwnership() public onlyOwner{
        owner = address(0);
    emit TransferOwner(owner,address(0));
    }  

}


interface Token{
    function transfer(address _recipient,uint _amount) external returns(bool);
}


contract PayableExchangeContract is Ownable{


    struct claimHolder{
        address recivier;
        uint mtoToken;
        uint timeStamp;
    }

    

    uint _token;
    uint chargeValue = 5;
    uint chargeDecimal = 1000;

    address ContractOwnerAddress = 0xb1c01b3e47354feD29Bde2FEbaFAdbBC9f21b1F7;
    address  tokenAddress = 0x3fA7D2376408c31a2cf5df6ee7e1f0C4F45dea81;
    

    mapping(address => uint) public HoldByAddress;
    mapping(address => claimHolder) public Claim;

    function changeTokenAddress(address _tokenAddress) public {
        tokenAddress = _tokenAddress;
    }

    function changeChargeData(uint _chargeValue,uint _chargeDecimal) public onlyOwner returns(bool){
        chargeValue = _chargeValue;
        chargeDecimal = _chargeDecimal;
        emit chargeChanged(_chargeValue,_chargeDecimal);
        return true;
    }

    uint start = 1669371900;
    
    uint end = 1669372500;

    function changeTime(uint _start,uint _end) public onlyOwner returns(bool){
        start = _start;
        end = _end;
        return true;
    }


    function exchangeToken() public payable returns(bool){
        require(block.timestamp >= start,"ICO has not started yet");
        require(block.timestamp <= end,"ICO has ended");

        _token = (msg.value*chargeDecimal) /chargeValue;

        HoldByAddress[msg.sender] += _token;

       payable(ContractOwnerAddress).transfer(msg.value);

        Claim[msg.sender].recivier = msg.sender;
        Claim[msg.sender].mtoToken += _token;
        Claim[msg.sender].timeStamp = block.timestamp;

        return true;
    }

    function getHolderData(address _address) public view returns(address,uint,uint){
        return (Claim[_address].recivier,
        Claim[_address].mtoToken,
        Claim[_address].timeStamp);
    }


}
