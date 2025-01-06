//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TrivBank{


    //address private immutable MAINNET_USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address private immutable MOCK_USDC = 0x1241676d45b1Cb5B573b6258C4A838e149A1D191;

    address private immutable admin1 = 0x70ca4a44A227645BB4815AE4d68098eA68aB926F;
    address private immutable admin2 = 0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8;
 
    function Withdrawal4Work(uint _amount,address _userAddr2send) external onlyVerfAdd {
        IERC20(MOCK_USDC).transfer(_userAddr2send, _amount);
    }

    function ContractTriviaBalance() public view onlyVerfAdd returns (uint){
        return IERC20(MOCK_USDC).balanceOf(address(this));
    }

    modifier onlyVerfAdd(){
        require( (msg.sender == admin1) || (msg.sender == admin2),"Caller not valid");
        _;
    }

}