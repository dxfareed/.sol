//SPDX-License-Identifier:MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Claim{
    address immutable token = 0x1241676d45b1Cb5B573b6258C4A838e149A1D191;
    uint immutable dec = 1e6;
    address private owner;

    constructor() {
         owner = msg.sender;
     }

    error UserClaimedToken();
    function getToken(address _user) public onlyAdmin {
        
        if ( IERC20(token).balanceOf(_user) > 2000 * dec){
            revert UserClaimedToken();
        }
     IERC20(token).transfer(_user, 5000 * dec);
}

    modifier onlyAdmin(){
        require(msg.sender == owner );
        _;
    }

}