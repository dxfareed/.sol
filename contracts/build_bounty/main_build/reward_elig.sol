// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    
    function transferFrom(address sender, address recipient, uint256 amount)
        external
        returns (bool);
}

//[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db]

contract RewardElig {

    uint256 private constant POOL_AMOUNT = 10**7;
    uint256 private constant magic_num = 10**18;
    uint256 private constant DURATION_PERIOD = 5 minutes;

    
    address private immutable MOCK_BUILD;
    mapping(address => uint256) private EligibleUser;

    address[] private EligibleUserClaimWeek;
    address[] private EligibleUserArr;
    address private admin;
    uint256 public CurrentWeekStart;
    uint256 private WeekTotalBuildClaim;
    uint256 private TotalBuildClaim;
    
    struct DonateBuildRecord{
        address sender;
        uint amount;
    }

    DonateBuildRecord[] ArrayDonors;

    constructor(address _build_ca) {
        admin = msg.sender;
        MOCK_BUILD = _build_ca;
        CurrentWeekStart = block.timestamp - (block.timestamp % DURATION_PERIOD);
    }

    event ClaimRewardUser(address _user, uint256 _amount);
    event TotalUserClaim(uint256 _total_num_user);

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

    function ClaimReward() external returns (uint256) {

        if (block.timestamp >= CurrentWeekStart + DURATION_PERIOD ) {
            ResetWeekTotalClaim();
            CurrentWeekStart = block.timestamp - (block.timestamp % DURATION_PERIOD );
        }


        uint256 _lastTime;
        uint256 _totalUser = EligibleUserArr.length;
        if (EligibleUser[msg.sender] == 0) {
            revert IneligibleUser("Not an eligible user!");
        }

        if (EligibleUser[msg.sender] == 1) {
            // remove 1 after check :)
            _lastTime = (EligibleUser[msg.sender] +  DURATION_PERIOD ) - 1;
        } else if (EligibleUser[msg.sender] > 1) {
            _lastTime = (EligibleUser[msg.sender] +  DURATION_PERIOD );
        }

        require(block.timestamp >= _lastTime, "Once per week");
        require(
            IERC20(MOCK_BUILD).balanceOf(address(this)) > 0,
            "Empty vault!"
        );

        uint256 each_pool_portion = POOL_AMOUNT / _totalUser;

        bool alreadyClaimed = false;
        for (uint16 i; i < EligibleUserClaimWeek.length; i++) {
            if (EligibleUserClaimWeek[i] == msg.sender) {
                alreadyClaimed = true;
                break;
            }
        }
        if (!alreadyClaimed) {
            WeekTotalBuildClaim += each_pool_portion;
            EligibleUserClaimWeek.push(msg.sender);
        }
        TotalBuildClaim += each_pool_portion;
       
        
        IERC20(MOCK_BUILD).transfer(msg.sender, each_pool_portion * magic_num);

        EligibleUser[msg.sender] = block.timestamp;

        emit TotalUserClaim(EligibleUserClaimWeek.length);
        emit ClaimRewardUser(msg.sender, each_pool_portion);
        return 0;
    }

    //return total for the week
    function TotalClaimedWeek() external view returns(uint){
        return WeekTotalBuildClaim;
    }

    //return whole total
    function TotalBuildClaimed() external view returns(uint){
        return TotalBuildClaim;
    }

    //reset the week total claim
    function ResetWeekTotalClaim() internal {
        WeekTotalBuildClaim = 0;
        delete EligibleUserClaimWeek;
    }

    //length per week
    function WeekTotalUser() external view returns(uint){
        return EligibleUserClaimWeek.length;
    }

    //address per week in pool
    function WeekTotalUserAddress() external view returns(address[] memory){
        return EligibleUserClaimWeek;
    }
   
    
    //frontend handle. after approve then
    function DepositBuild(uint256 _amount) external {
        bool sucess = IERC20(MOCK_BUILD).transferFrom(msg.sender, address(this), _amount * magic_num);
        if(sucess){
            for (uint i; i < ArrayDonors.length; i++){
                if(msg.sender == ArrayDonors[i].sender){
                    ArrayDonors[i].amount += _amount;
                    break;
                }
            }
        }
    }
    
    //frontend call
    function CallSorted() external returns(DonateBuildRecord[] memory){
        SortDonations();
        return ArrayDonors;
    }

    function SortDonations() internal{
        for (uint i = 0 ;i < ArrayDonors.length - 1; ++ i) {
            for (uint j = i + 1;j < ArrayDonors.length;++ j){
                if(ArrayDonors[i].amount > ArrayDonors[j].amount){
                    DonateBuildRecord memory temp = ArrayDonors[i];
                    ArrayDonors[i]=ArrayDonors[j];
                    ArrayDonors[j] = temp; 
                }
            }
        } 
    }

    function ChangeAdmin(address _newAdmin) external onlyAdmin{
        admin = _newAdmin;
    }

    function CurrentAdmin() external view returns(address){
        return admin;
    }

    function lis() external view returns (address[] memory) {
        return EligibleUserArr;
    }

    function ReadOnlyBalance4Dev() external view returns (uint256) {
        return IERC20(MOCK_BUILD).balanceOf(address(this)) / magic_num;
    }

    function returndf(address _user) external view returns (uint256) {
        return EligibleUser[_user];
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "only admin can invoke this function");
        _;
    }
}
