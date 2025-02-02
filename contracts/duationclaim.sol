// SPDX-License-Identifier: MIT


pragma solidity >=0.8.0;

contract DurationTest{

    address immutable private admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    mapping ( address => bool ( bool => uint) ) EligibleUser;
    address[] EligibleUserArr;

    error DuplicateUserAdded(string);

    function AddEligibleUser(address _user) external onlyAdmin{
        if(EligibleUser[_user]){
            revert DuplicateUserAdded("User exist");
        }
            EligibleUser[_user] = true;
            EligibleUserArr.push(_user);
    }

    function AddMultipleEliglibleUser(address[] memory _users) external  onlyAdmin{
        for( uint16 i; i < _users.length; i++){

            
            if(EligibleUser[_users[i]]){
                continue;
            }

            EligibleUser[_users[i]] = true;
            EligibleUserArr.push(_users[i]);
        }
       
    }


    function RemoveEligibleUser(address _user) external {
        uint _len = EligibleUserArr.length;

        for( uint16 i; i < _len; i++){
            //check
            if( EligibleUserArr[i] == _user ){
                //shift & pop out
                for ( uint16 j = i; j < _len - 1; j++ ){
                    EligibleUserArr[j] = EligibleUserArr[j+1];
                }
                EligibleUserArr.pop();
            }
        }
        delete EligibleUser[_user];
    }

    function testClaim() external{

    }


   /*  uint8[] test = [1, 2, 3, 4, 5];

    function arraytest(uint8 _index) external returns(uint8[] memory){
        
        for(uint8 i = _index; i < test.length - 1; i++){
            test[i] = test[i + 1]; 
        }
        test.pop();
        return test;
    } */

    function lis() external view returns(address[] memory){
        return EligibleUserArr;
    }

    function returndf(address _user) external view returns(bool) {
        return EligibleUser[_user];
    }


    modifier onlyAdmin(){
        require(admin == msg.sender, "only admin can invoke this function");
        _;
    }

}
