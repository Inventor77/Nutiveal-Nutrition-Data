// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.4.2/utils/Counters.sol";
import "@openzeppelin/contracts@4.4.2/utils/Strings.sol";

contract MyToken is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    // this will be the locked or placeholder image folder's cid 
    string public baseURI = "https://gateway.pinata.cloud/ipfs/QmRWUdVa8BbtippgoSKasJaAtYcDKmSPyi6K4v6MNaxv25/placeholder.json";
    bool public revealed = false;

    constructor() ERC721("MyToken", "MTK") {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function changeBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function changeRevealed(bool _revealed) public onlyOwner {
        revealed = _revealed;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        // starts the token minting from token1 
        _safeMint(to, tokenId + 1);
    }

     function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "token does not exist");

        string memory baseURI_ = _baseURI();

        if (revealed) {
            // for this the metadata for the original image has to be 1.json and so on 
            return string(abi.encodePacked(baseURI_, Strings.toString(tokenId), ".json")) ;
        } else {
            // placeholder.json is the file used for placeholder
            return baseURI_ ;
        }
    }
}