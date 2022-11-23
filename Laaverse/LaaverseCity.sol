// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract LaaverseCity is ERC721, ERC721URIStorage, ERC721Burnable, Ownable{

    bool private canBuy;
    uint256 private price;
    uint256 private maxClaimLimit;

    string constant NOT_AUTHORIZED = "LND1"; 
    string constant BUYING_IS_OPEN = "LND2"; 
    string constant BUYING_IS_CLOSED = "LND3"; 
    string constant PAY_EXACT_PRICE = "LND4"; 
    string constant NO_LAND_OWNED = "LND5"; 
    string constant REACHED_MAX_CLAIM_LIMIT = "LND6"; 

    mapping(address => uint256) private ownerToLand;
    mapping(uint256 => address) private landToOwner;

    uint256[] private landArray;

    constructor()ERC721("Laaverse City", "LAVC") {
        maxClaimLimit = 1;
    }

    function claimLand(string memory landName, uint256 tokenId, address _addressNFT) public {
        IERC721 nft = IERC721(_addressNFT);
        require(nft.balanceOf(msg.sender) > 0, NO_LAND_OWNED);
        require(balanceOf(msg.sender) < maxClaimLimit, REACHED_MAX_CLAIM_LIMIT);

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, landName);
        
        ownerToLand[msg.sender] = tokenId;
        landToOwner[tokenId] = msg.sender;
        landArray.push(tokenId);
    }

    function buyLand(string memory landName, uint tokenId) payable public {
        require(!canBuy, BUYING_IS_CLOSED);
        require(msg.value == price, PAY_EXACT_PRICE);

        payable(owner()).transfer(msg.value);
        _safeMint(msg.sender,tokenId);
        _setTokenURI(tokenId, landName);

        ownerToLand[msg.sender] = tokenId;
        landToOwner[tokenId] = msg.sender;
        landArray.push(tokenId);
    }
    
    function setMaxClaimLimit(uint256 _maxClaimLimit) public onlyOwner{
        maxClaimLimit = _maxClaimLimit;
    }

    function getMaxClaimLimit() public view returns(uint256 _maxClaimLimit){
        return maxClaimLimit;
    }

    function changeLandPrice(uint _price) public onlyOwner{
        price = _price;
    }

    function closeBuying() public onlyOwner{
        require(!canBuy, BUYING_IS_CLOSED);
        canBuy = true;
    }

    function startBuying(uint _price) public onlyOwner{
        require(canBuy, BUYING_IS_OPEN);

        canBuy = false;
        price = _price;
    }

    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(_tokenId);
        delete ownerToLand[msg.sender];
        delete landToOwner[_tokenId];
    }

    function getMintedLand() public view returns(uint256[] memory _landArray){
        return landArray;
    }
    
    function getLandToOwner(uint256 _tokenId) public view returns(address _landOwner){
        return landToOwner[_tokenId];
    }

    function getOwnerToLand(address _landOwner) public view returns(uint256 _tokenId){
        return ownerToLand[_landOwner];
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
