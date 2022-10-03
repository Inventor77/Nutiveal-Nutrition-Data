// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract MyNFT is ERC721,ERC721Burnable, Ownable {
    using Counters for Counters.Counter;
    // this will be the tokenaddress of the ERC20 token
    IERC20 public tokenAddress;
    // when doing multiple mints we can multiply this with the count  to get the total price to be paid
    uint256 public price = 10 * 10 ** 18;

    Counters.Counter private _tokenIdCounter;

    constructor(address _tokenAddress) ERC721("MyNFT", "MTK") {
        tokenAddress = IERC20(_tokenAddress);
    }

    function safeMint() public {
        // transfer the required amount form the deployer of this contract to the current address of the NFT contract
        tokenAddress.transferFrom(msg.sender, address(this), price);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function withdrawToken() public onlyOwner {
        tokenAddress.transfer(msg.sender, tokenAddress.balanceOf(address(this)));
    }
}