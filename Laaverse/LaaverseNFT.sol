// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract LaaverseNFT is ERC721, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    address private operator;

    string constant NOT_OPERATOR = "LAV1";

    mapping(address => uint256[]) private ownerToTokenId;
    
    modifier onlyOperator(){
        require(msg.sender == operator, NOT_OPERATOR);
        _;
    }

    constructor(address _operator) ERC721("Laaverse", "LAV") {
        operator = _operator;
    }

    function safeMint() public onlyOperator{
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(operator, tokenId);
        ownerToTokenId[operator].push(tokenId);
    }
    
    function mainTransfer(address to, uint256 tokenId) public{
        require(ownerOf(tokenId) == msg.sender, "NON_OWNER");

        for(uint i; i < ownerToTokenId[msg.sender].length; i++){
            if(ownerToTokenId[msg.sender][i] == tokenId){
                ownerToTokenId[msg.sender][i] = ownerToTokenId[msg.sender][ownerToTokenId[msg.sender].length-1];
                break;
            }
        }
        ownerToTokenId[msg.sender].pop();
        
        super._transfer(msg.sender, to, tokenId);
        ownerToTokenId[to].push(tokenId);
    }

    function setOperator(address _operator) public onlyOwner{
        operator = _operator;
    }

    function getOperator() public view returns(address _operator){
        return operator;
    }

    function getOwnerToTokenId(address user) public view returns(uint256[] memory tokenIds){
        return ownerToTokenId[user];
    }
}
