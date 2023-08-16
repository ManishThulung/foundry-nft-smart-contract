// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    BasicNft basicNft;

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public constant USER = address(1); // cannot mint to the 0 address

    function setUp() external {
        DeployBasicNft deployBasicNft = new DeployBasicNft();
        basicNft = deployBasicNft.run();
    }

    function testChecksName() public view {
        string memory name = basicNft.name();
        string memory actualName = "PUPPY";
        assert(
            keccak256(abi.encodePacked(name)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUG_URI)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }

    // function testEmitsEventAfterMinted() public {
    //     vm.prank(USER);
    //     basicNft.mintNft(PUG_URI);

    //     vm.expectEmit(true, true, true, false);
    //     emit Transfer(address(0), address(USER), 0);
    //     basicNft.mintNft(PUG_URI);
    // }
}
