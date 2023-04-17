pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract HouseToken is ERC721, Ownable {
    
    uint256 public tokenId = 1;
    

    mapping (uint256 => uint256) public rents;
    mapping (uint256 => uint256) public valut;
    
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
    
    function mint(address _to, uint256 _rent) public onlyOwner {
        _safeMint(_to, tokenId);
        rents[tokenId] = _rent;
        tokenId += 1;
    }
    
    function payRent(uint256 _tokenId) public payable {
        require(_exists(_tokenId), "Token does not exist");
        require(msg.value == rents[_tokenId], "Insufficient payment");
        valut[_tokenId]+=msg.value;
    }

    function collect(address payable _owner,uint256 _tokenId) public payable returns(uint256){
        require(_exists(_tokenId), "Token does not exist");
        require(ownerOf(_tokenId) == address(_owner), "Payee are not the owner of the token");
        uint256 amount = valut[_tokenId];
        payable(_owner).transfer(amount);
        valut[_tokenId] = 0;
        return amount;
    }

    function totalAmount() public view returns(uint256){
        return address(this).balance;
    }
     
}
