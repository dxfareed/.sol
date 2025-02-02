// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

//100_000_000_000_000_000_000_000_000


//10000000000000




contract DurationTest {
    address private immutable admin;
    uint256 private immutable PERIOD;
    address private immutable MOCK_BUILD;
    uint256 immutable POOL_AMOUNT; 
    constructor() {
        admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        MOCK_BUILD = 0xa1fFfD1Ae86153799DB6C8c9C0e57602545b280e;
        POOL_AMOUNT = 10**7; 
        PERIOD = 10 weeks;
    }

    mapping(address => uint256) EligibleUser;
    address[] EligibleUserArr;

    error DuplicateUserAdded(string);
    error IneligibleUser(string);

    function AddEligibleUser(address _user) external onlyAdmin {
        if (EligibleUser[_user] > 0) {
            revert DuplicateUserAdded("User exist");
        }

        EligibleUser[_user] = 1;
        EligibleUserArr.push(_user);
    }

    function AddMultipleEliglibleUser(address[] memory _users)
        external
        onlyAdmin
    {
        for (uint16 i; i < _users.length; i++) {
            if (EligibleUser[_users[i]] > 0) {
                continue;
            }

            EligibleUser[_users[i]] = 1;
            EligibleUserArr.push(_users[i]);
        }
    }

    function RemoveEligibleUser(address _user) external onlyAdmin {
        uint256 _len = EligibleUserArr.length;

        delete EligibleUser[_user];

        for (uint16 i; i < _len; i++) {
            //check
            if (EligibleUserArr[i] == _user) {
                //shift
                for (uint16 j = i; j < _len - 1; j++) {
                    EligibleUserArr[j] = EligibleUserArr[j + 1];
                }
                //then pop out
                EligibleUserArr.pop();
                break;
            }
        }

    }
//[0xfD480aC8eC0982F3ab4c05ebBc979D906fde6830,0x4f1EF4d30b98914CcB6cf2A464644791e3e98DE3,0xF17a53e34A42B465b0A69783F2e480E460F84252]
    function test5minsClaim() external returns (uint256) {
        uint256 _lastTime;
        uint256 _totalUser = EligibleUserArr.length;
        if (EligibleUser[msg.sender] == 0) {
            revert IneligibleUser("Not an eligible user!");
        }

        if (EligibleUser[msg.sender] == 1) {
            // remove 1 after check :)
            _lastTime = (EligibleUser[msg.sender] + 5 minutes) - 1;
        }

        _lastTime = (EligibleUser[msg.sender] +  5 minutes);

        require(block.timestamp >= _lastTime, "Claim after 5 minutes");
        require(
            IERC20(MOCK_BUILD).balanceOf(address(this)) > 0,
            "Empty vault!"
        );
        //end check, get reward
        //pool of 10m, share reward based on total num of users in the pool.

        uint256 each_portion = 10 / _totalUser;

        IERC20(MOCK_BUILD).transfer(msg.sender, each_portion);

        EligibleUser[msg.sender] = block.timestamp;
        return 0;
    }

    function testClaim() external returns (uint256) {
        uint256 _lastTime;
        uint256 _totalUser = EligibleUserArr.length;
        if (EligibleUser[msg.sender] == 0) {
            revert IneligibleUser("Not an eligible user!");
        }

        if (EligibleUser[msg.sender] == 1) {
            // remove 1 after check :)
            _lastTime = (EligibleUser[msg.sender] + 1 weeks) - 1;
        }

        _lastTime = (EligibleUser[msg.sender] + 1 weeks);

        require(block.timestamp >= _lastTime, "Once per week");
        require(
            IERC20(MOCK_BUILD).balanceOf(address(this)) > 0,
            "Empty vault!"
        );
        //end check, get reward
        //pool of 10m, share reward based on total num of users in the pool.

        uint256 each_portion = 10 / _totalUser;

        IERC20(MOCK_BUILD).transfer(msg.sender, each_portion);

        EligibleUser[msg.sender] = block.timestamp;
        return 0;
    }

    /*  uint8[] test = [1, 2, 3, 4, 5];

    function arraytest(uint8 _index) external returns(uint8[] memory){
        
        for(uint8 i = _index; i < test.length - 1; i++){
            test[i] = test[i + 1]; 
        }
        test.pop();
        return test;
    } */

    function lis() external view returns (address[] memory) {
        return EligibleUserArr;
    }

    function ReadOnlyBalance4Dev() external view returns (uint256) {
        return IERC20(MOCK_BUILD).balanceOf(address(this)) / 10**18;
    }

    function returndf(address _user) external view returns (uint256) {
        return EligibleUser[_user];
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "only admin can invoke this function");
        _;
    }
}
