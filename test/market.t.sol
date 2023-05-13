//SPDX-License-Identifier: MIT
pragma solidity^0.8.19;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "forge-std/Test.sol";
import "../src/nft.sol";

contract Testnft is FoundryMocks {
    using SafeMath for uint256;

    MyNFT myNFT;
    address private constant _owner = address(0x123);
    uint256 private constant _tokenId = 1;

    function beforeEach() public {
        myNFT = new MyNFT();
    }

    function testMint() public {
        myNFT.mint(_owner, _tokenId);
        require(myNFT.balanceOf(_owner) == 1, "Token was not minted correctly");
    }

    function testBurn() public {
        myNFT.mint(_owner, _tokenId);
        myNFT.burn(_tokenId);
        require(myNFT.balanceOf(_owner) == 0, "Token was not burned correctly");
    }

    function testBurnFailure() public {
        myNFT.mint(_owner, _tokenId);
        address notOwner = address(0x456);
        try myNFT.burn(_tokenId, { from: notOwner }) {
            revert("Burn should have failed");
        } catch Error(string memory reason) {
            require(
                keccak256(bytes(reason)) ==
                    keccak256("MyNFT: not owner"),
                "Unexpected error message"
            );
        } catch {
            revert("Unexpected error");
        }
    }
}

