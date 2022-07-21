// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MessiCollection is ERC721Enumerable, Ownable {
    uint256 public _price = 0.01 ether;

    bool public _paused;

    uint256 public maxTokenIds = 10;

    uint256 public tokenIds;

    string _baseTokenURI;

    uint8 public maxWhitelistedAddresses = 3;

    uint8 public numAddressesWhitelisted;

    mapping(address => bool) public whitelistedAddresses;

    bool public presaleStarted;

    uint256 public presaleEnded;

    //I learned that this is an importante feature if you want to prevent a security problem from escalating.

    modifier onlyWhenNotPaused() {
        require(
            !_paused,
            "This contract is currently in pause. Please wait until we fix the issue."
        );
        _;
    }

    // As you can see, it's possible to set the baseURI when you first deploy this contract. This way, this contract
    // can be used in more than a deployment, because the baseURI isn't static.
    // I also made this function payable. This way, the contract can have an initial ETH balance when deployed.

    constructor(string memory baseURI)
        payable
        ERC721("Messi Collection", "M10")
    {
        _baseTokenURI = baseURI;
    }

    // This function allows anyone to get the contract balance.

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    // This function allows the owner to add an address to the whitelist mapping.

    function addToWhitelist(address whitelisted) public onlyOwner {
        whitelistedAddresses[whitelisted] = true;
        require(
            numAddressesWhitelisted < maxWhitelistedAddresses,
            "You can't add more addresses."
        );
        numAddressesWhitelisted += 1;
    }

    // Through this function you can check if an address is whitelisted or not.

    function isWhitelisted(address _address) public view returns (bool) {
        if (whitelistedAddresses[_address]) {
            return true;
        } else {
            return false;
        }
    }

    // This function allows the owner to start the NFTs presale for whitelisted addresses.

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 15 minutes;
    }

    // The presale minting function.

    function presaleMint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp < presaleEnded,
            "The presale isn't open yet"
        );
        require(whitelistedAddresses[msg.sender], "You are not whitelisted!");
        require(tokenIds < maxTokenIds, "Exceeded maximum supply!");
        require(msg.value >= _price, "Ether sent is not enough.");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    // The public minting function is available only after the presale ended.

    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp >= presaleEnded,
            "Presale has not started or it started but not ended yet."
        );
        require(tokenIds < maxTokenIds, "Exceed maximum supply!");
        require(msg.value >= _price, "Ether sent is not enough.");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    // This function overrides the implementation from OZ, returning our _baseTokenURI instead.

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // In case of emergency, we can pause the contract with this function.

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    // This function uses onlyOwner modifier and is useful to withdraw the ether obtained from minting.

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // As Solidity by example explains, this functions are required if some people make errors when sending transactions.
    // But also this functions are useful if someone wants to donate ETH directly to the contract without calling a function.

    receive() external payable {}

    fallback() external payable {}
}
