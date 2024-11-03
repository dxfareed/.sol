//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract flipit is ERC20 {
    address _ownerFirstToken;
    uint256 private constant dec= 1e18;
    address itn;
    error NoToken( string );
    error TokenClaimed( string );
    error AddressNotFound(string);
    //address[] public gasFee;
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        //_mint(msg.sender, 1000000 * dec);
        _mint(address(this), 1000000 * dec);
        _ownerFirstToken=msg.sender;
        itn = address(this);
    }

    function pumptit(uint256 _pumpMint) public {
        require(_ownerFirstToken == msg.sender, "Not owner!");
        _mint(msg.sender, _pumpMint*dec);
    }
    function Claim(address _addrs) external {
        if( _addrs == address(0)){
            revert AddressNotFound("Address zero not allowed!");
        }
        if (balanceOf(_addrs)>0){
            revert TokenClaimed("Address Claimed!");
        }
        _transfer(_ownerFirstToken, _addrs, 50*dec);
    }
    function Burn(uint256 _value) external {
        if(balanceOf(msg.sender)<0){
            revert NoToken("Token not Enough!");
        }
        _burn(msg.sender, _value*dec);
    }
    function Balance(address _user) external  view returns(uint256){
        return balanceOf(_user);
    }
    function flipClick(address _addrs, uint256 _amount) external {
        if( _addrs == address(0)){
            revert AddressNotFound("Address zero not allowed!");
        }
        _transfer( _addrs,_ownerFirstToken, _amount*dec);
    }
    function gain(address _addrs) public{

    }
    /* function payContractGasFee() public payable{
        gasFee.push(msg.sender);
    }
    receive() external payable { 
        payContractGasFee();
    } */
}

//500000000000000000000
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4