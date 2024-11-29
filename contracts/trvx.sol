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
    address constant usdctokenAddress= 0xb634247Abf7A50Dd7b9Cf6671A3e83F34f5f78D0;
    uint private constant dec = 1*1e6;
    TriviaBaseCreate storeUserData;
    error insufficientContractBalance();
    constructor (address _contract) {
        storeUserData = TriviaBaseCreate(_contract);
    }
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
            address[3] memory _winners;
            for (uint i=0; i < _winners.length; i++){
                storeUserData.incrementTotalWon(_users[i]);
                _winners[i]=_users[i];
            }
            
             for (uint i=0; i < _users.length; i++) {
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
//[0x17F6AD8Ef982297579C203069C1DbfFE4348c372,0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,0x03588888D41550112f64f56574A30EA86972FE4F]
contract TriviaBaseCreate{
    mapping ( address => uint )  userTotalPlayed;
    mapping ( address => uint )  userTotalCreated;
    mapping ( address => uint ) public userTotalLoss;
    mapping ( address => uint )  userTotalWon;
    
    
    function createTriviaContract() external returns(address) {
        userTotalCreated[msg.sender]++;
        TriviaBase _trivia = new TriviaBase(address(this));
        return address(_trivia);
    }

    function incrementTotalWon(address _sender) external {
        userTotalWon[_sender]++;   
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

}

