// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract LaaverseUser {
    
    struct UserData {    
        string name;
        string dpPicture;
        string facebook;
        string twitter;
        string instagram;
        string linkedin;
    }

    event Registered(
        address indexed reqUser,
        string dpPicture,
        string _username,
        string _facebook,
        string _twitter,
        string _instagram,
        string _linkedin
    );

    mapping(address => UserData) public addressToUserData;
    mapping(address => bool) public userStatus;

    string constant USER_ALREADY_REGISTERED = "LAU1";
    string constant NO_LAND_OWNED = "LAU2";
    string constant USER_NOT_REGISTERED = "LAU3";

    modifier alreadyRegistered{
        require(!userStatus[msg.sender], USER_ALREADY_REGISTERED);
        _;
    }

    function getUserDetail(address user) public view returns(string memory _username, string memory _dpPicture, 
                string memory _facebook, string memory _twitter, string memory _instagram, string memory _linkedin){

        return(addressToUserData[user].name, addressToUserData[user].dpPicture, addressToUserData[user].facebook, addressToUserData[user].twitter, 
            addressToUserData[user].instagram, addressToUserData[user].linkedin);
    }
    
    function register(string memory _username,string memory _dpPicture, string memory _facebook, 
                      string memory _twitter, string memory _instagram, 
                      string memory _linkedin, address _laaverse) public alreadyRegistered{
        IERC721 nft = IERC721(_laaverse);
        if(nft.balanceOf(msg.sender) == 0){
            revert (NO_LAND_OWNED);
        }
        addressToUserData[msg.sender] = UserData(_username,_dpPicture,_facebook,_twitter,_instagram,_linkedin);
        userStatus[msg.sender] = true;

        emit Registered(msg.sender, _username, _dpPicture, _facebook, _twitter, _instagram, _linkedin);
    }

    function changeName(string memory _username) public {
        require(userStatus[msg.sender], USER_NOT_REGISTERED);
        addressToUserData[msg.sender].name = _username;
    }

    function changeDpPicture(string memory _dpPicture) public {
        require(userStatus[msg.sender], USER_NOT_REGISTERED);
        addressToUserData[msg.sender].dpPicture = _dpPicture;
    }

    function changeFacebook(string memory _facebook) public {
        require(userStatus[msg.sender], USER_NOT_REGISTERED);
        addressToUserData[msg.sender].facebook = _facebook;
    }

    function changeTwitter(string memory _twitter) public {
        require(userStatus[msg.sender], USER_NOT_REGISTERED);
        addressToUserData[msg.sender].twitter = _twitter;
    }

    function changeInstagram(string memory _instagram) public {
        require(userStatus[msg.sender], USER_NOT_REGISTERED);
        addressToUserData[msg.sender].instagram = _instagram;
    }

    function changeLinkedin(string memory _linkedin) public {
        require(userStatus[msg.sender], USER_NOT_REGISTERED);
        addressToUserData[msg.sender].linkedin = _linkedin;
    }
}