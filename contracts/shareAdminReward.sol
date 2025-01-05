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

    address[2] admins = [0x52c043C7120d7DA35fFdDF6C5c2359d503ceE5F8, 0x70ca4a44A227645BB4815AE4d68098eA68aB926F] ;
    
    function Withdrawal4Work(uint _amount,address _userAddr2send) external onlyVerfAdd {
        IERC20(MOCK_USDC).transfer(_userAddr2send, _amount);
    }

    function ContractTriviaBalance() public view returns (uint){
        return IERC20(MOCK_USDC).balanceOf(address(this));
    }

    /* function PayAdmins(address[7] memory _admins, uint amount) external onlyVerfAdd {
        for (uint i = 1; i < _admins.length; ++i) {
            IERC20(MOCK_USDC).transfer(_admins[i], amount); 
        }        
    } */

    modifier onlyVerfAdd(){
        if( (msg.sender == address(admins[0])) || (msg.sender == address(admins[1])) ){
            revert("Caller is not Admin");
        }
        _;
    }

    /* 
    
    function EmergencyWithdrawalAdmin() external onlyAddress{
        uint contractBalance = IERC20(MAINNET_USDC).balanceOf(address(this));
        IERC20(MAINNET_USDC).transfer(ADMIN, contractBalance);
        
   

    */


}