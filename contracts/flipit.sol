//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract flipit is ERC20 {
    address _owner_;
    uint256 private constant dec = 1e18;
    address contractAddress;
    error NoToken(string);
    error TokenClaimed(string);
    error AddressNotFound(string);
    address[] private _senderEth;
    uint public startDay;
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        //_mint(msg.sender, 1000000 * dec);
        _mint(address(this), 1_000_0000_000 * dec);
        _owner_ = msg.sender;
        contractAddress = address(this);
        startDay = block.timestamp;
    }
    function pumptit(uint256 _pumpMint) public {
        require(_owner_ == msg.sender, "Not owner!");
        _mint(msg.sender, _pumpMint * dec);
    }

    function Claim(address _addrs) external {
        if (_addrs == address(0)) {
            revert AddressNotFound("Address zero not allowed!");
        }
        if (balanceOf(_addrs) > 0) {
            revert TokenClaimed("Address Claimed!");
        }
        _transfer(contractAddress, _addrs, 5_000 * dec);
    }

    function Burn(uint256 _value) external {
        if (balanceOf(msg.sender) < 0) {
            revert NoToken("Token not Enough!");
        }
        _burn(msg.sender, _value * dec);
    }

    function Balance(address _user) external view returns (uint256) {
        return balanceOf(_user);
    }

    function flipClick(address _addrs, uint256 _amount) external {
        if (_addrs == address(0)) {
            revert AddressNotFound("Address zero not allowed!");
        }
        _transfer(_addrs, _owner_, _amount * dec);
    }

    function gain(address _addrs, uint256 _tokenStaked) public {
        _tokenStaked = _tokenStaked * dec;
        _transfer(address(this), _addrs, _tokenStaked*2);
    }

    function payContractGasFee() public payable {
        _senderEth.push(msg.sender);
    }
    function realTime(address _addrs) public view returns(uint256){
        if(balanceOf(_addrs) < dec){
            revert NoToken("Token not enough!");
        }
       return balanceOf(_addrs)/dec;
    }
    function SenderEth() public view returns(address[] memory){
        require(_owner_ == msg.sender, "Not owner!");
        return _senderEth;
    }
    function withDraw() public {
        require(_owner_ == msg.sender, "Not owner!");
        payable (_owner_).transfer(address(this).balance);
    }
    function addressBalnc(address _user) public view  returns (uint256){
        return _user.balance;   
    }
}
/* 

   ca 0xC5CaC9d5a86bB578553ee84FaeE022f8d251A9C9

*/
 //500000000000000000000
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4