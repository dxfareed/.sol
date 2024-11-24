//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract TriviaBase{
    address constant usdctokenAddress= 0xb53007d5525F05AD16C16e0012a8795f156213cE;
    uint private constant dec = 1*1e6;
    error insufficientContractBalance();
    TriviaBaseCreate storeUserData = TriviaBaseCreate(0xB825b9D50D093d6EC49e4f3D43AD9915eb6CcCc3); 
    //ca transfer done

        //func trnasfer token from _user to ca
        function transfer2CA(uint _amount) external returns(address _sender) {
            require(IERC20(usdctokenAddress).balanceOf(msg.sender)>=_amount, "Insufficent Balance");
            IERC20(usdctokenAddress).transferFrom(msg.sender, address(this), _amount);
            return msg.sender;
        }

        address[] winners;
        address[] losers;
        function sendInfo(address[] memory _users) external {
            for (uint i; i < 3; i++){
                winners.push(_users[i]);
                storeUserData.incrementTotalWon(_users[i]);
            }
            
             for (uint i; i < _users.length; i++) {
                storeUserData.incrementTotalPlayed(_users[i]);
            }

            for (uint i=3; i < _users.length; i++){
                //losers.push(_users[i]);
                storeUserData.userTotalLoss(_users[i]);
            }
        }

        function sendRewards() external {
            uint contractRewards =  IERC20(usdctokenAddress).balanceOf(address(this));
            if(contractRewards == 0){
                revert insufficientContractBalance();
            }
            uint firstPlayer = (58 * contractRewards * dec)/(100 * dec);
            uint secondPlayer = (29 * contractRewards * dec)/(100 * dec);
            uint thirdPlayer = (9 * contractRewards * dec)/(100 * dec);

            IERC20(usdctokenAddress).transfer(winners[0],firstPlayer);
            IERC20(usdctokenAddress).transfer(winners[1],secondPlayer);
            IERC20(usdctokenAddress).transfer(winners[2],thirdPlayer);
            delete winners;
           // return (firstPlayer, secondPlayer, thirdPlayer,(firstPlayer+secondPlayer+thirdPlayer)/dec);
        }

        function callPLayed(address _user)external view returns(uint, uint){
           return (storeUserData.displayTotalPlayed(_user), storeUserData.displayTotalWon(_user));
        }

        function balance( address _user) external view returns(uint){
            uint ownerBalance =  IERC20(usdctokenAddress).balanceOf(_user);
            return ownerBalance;
        }
}
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//0x03588888D41550112f64f56574A30EA86972FE4F
//[0x617F2E2fD72FD9D5503197092aC168c91465E7f2,0x17F6AD8Ef982297579C203069C1DbfFE4348c372,0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,0x03588888D41550112f64f56574A30EA86972FE4F]
contract TriviaBaseCreate{
    mapping ( address => uint )  userTotalPlayed;
    mapping ( address => uint )  userTotalCreated;
    mapping ( address => uint ) public userTotalLoss;
    mapping ( address => uint )  userTotalWon;
    
    
    function createTriviaContract() external returns(address) {
        TriviaBase _trivia = new TriviaBase();
        userTotalCreated[msg.sender]++;
        return address(_trivia);
    }

    function incrementTotalWon(address _sender)external {
        userTotalWon[_sender]=userTotalWon[_sender]+1;   
    }

    function incrementTotalPlayed(address _sender) external {
        userTotalPlayed[_sender]++; 
    }

    function incrementTotalLoss (address _sender) external {
        userTotalLoss[_sender]++;
    }

    //call fe
    function displayTotalWon(address _sender) external view returns(uint){
        return userTotalWon[_sender];
    }
     function displayTotalCreated(address _sender) external view returns(uint){
        return userTotalCreated[_sender];
    }
    function displayTotalPlayed(address _sender)external view returns(uint){
        return userTotalPlayed[_sender]; 
    }
    function displayTotalLoss(address _sender) external view {
        userTotalLoss[_sender];
    }
    
   /*  function userTotalCreatedFunc() public returns(uint){
       // return address(this).balance;
        return userTotalCreated[address(this)];
    }

   /*  function userTotalLossFunc(address _user) public returns(uint){
        userTotalLoss[_user]++;
        return userTotalLoss[_user];
    } */

}

