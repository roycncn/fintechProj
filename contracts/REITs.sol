pragma solidity ^0.8.0;

import "./HouseNFT.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract REITs is IERC721Receiver {
    
    address public owner;
    address public houseNFT;
    string public name;
    uint256 public numOfHouse = 0;
    uint256 public numOfInvestor = 0;
    uint256 public totalShares;
    mapping (uint256 => address) public investor;
    mapping (address => uint256) public sharesOf;
    mapping (uint256 => uint256) public owningHouse;
    
    event LogCreate(string information, uint balance);

    constructor(string memory _name, uint256 _totalShares,address _houseNFT) {
        owner = msg.sender;
        name = _name;
        totalShares = _totalShares;
        houseNFT=_houseNFT;
    }
    
    function setShares(uint256 _shares,address _shareHolder) public {
        require(msg.sender == owner, "Only owner can setShares");
        require(_shares <= totalShares, "Insufficient shares");
        if (sharesOf[_shareHolder] == 0){
            numOfInvestor+=1;
            investor[numOfInvestor]=_shareHolder;
        }
        sharesOf[_shareHolder] = _shares;
    }
    

    function withdrawAll() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }
    

    function updateOwning(uint houseID) public {
        require(HouseToken(houseNFT).ownerOf(houseID) == address(this),"REITs don't own this house!");
        numOfHouse += 1;
        owningHouse[numOfHouse] = houseID;

    }
    
    function collectRent() public {
        for(uint i=1;i<=numOfHouse;i++){
            uint256 payment = HouseToken(houseNFT).collect(payable(address(this)), owningHouse[i]);
            emit LogCreate("Collect",payment);
        }
    }
    

    function sendDividend() public {
        require(msg.sender == owner, "Only owner can send Dividend");
        uint256 total = address(this).balance;
        uint256 dividentPerShare = total/totalShares;
        for(uint i=1;i<=numOfInvestor;i++){
            uint256 toPay = sharesOf[investor[i]]*dividentPerShare;
            payable(investor[i]).transfer(toPay);
            total-=toPay;
        }
            payable(owner).transfer(total);
    }

   function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    
    fallback() external payable {
        // custom function code
    }

    receive() external payable {
        // custom function code
    }
}
