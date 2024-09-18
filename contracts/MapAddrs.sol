//SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

contract FavoriteRecords{
    mapping (string => bool) approvedRecords;
    mapping (address => mapping (string => bool)) userFavorites;
    constructor(){
        approvedRecords["Thriller"] = true;
        approvedRecords["Back in Black"] = true;
        approvedRecords["The Bodyguard"] = true;
        approvedRecords["The Dark Side of the Moon"] = true;
        approvedRecords["Their Greatest Hits (1971-1975)"] = true;
        approvedRecords["Hotel California"] = true;
        approvedRecords["Come On Over"] = true;
        approvedRecords["Rumours"] = true;
        approvedRecords["Saturday Night Fever"] = true;
    }
    error NotApproved(string);
    string[] approvedRecordsList=[
        "Thriller",
        "Back in Black",
        "The Bodyguard",
        "The Dark Side of the Moon",
        "Their Greatest Hits (1971-1975)",
        "Hotel California",
        "Come On Over",
        "Rumours",
        "Saturday Night Fever"
    ];
    function getApprovedRecords() external view  returns (string[] memory){
        return approvedRecordsList;
    }
    function addRecord( string memory _album) external{
            if (!approvedRecords[_album]){
                revert NotApproved(_album);
            }
        userFavorites[msg.sender][_album]=true;
    } 
    function getUserFavorites(address addr) external view returns(string[] memory){
        string[] memory favorites= new string[](approvedRecordsList.length);
        uint8 count=0;
        for(uint8 i=0; i<favorites.length; i++){
            if(userFavorites[addr][approvedRecordsList[i]]){
                favorites[count]=approvedRecordsList[i];
                count++;
            }
        }
        string[] memory usrcnt= new string[] (count);
        for(uint8 i=0; i<count; i++){
                usrcnt[i]=favorites[i];
        }
        //favorites=usrcnt;
        return usrcnt;
    }
    function resetUserFavorites() external {
        for (uint256 i = 0; i < 9; i++) {
            string memory album = approvedRecordsList[i];
            delete userFavorites[msg.sender][album];
        }
    }
}