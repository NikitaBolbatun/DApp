pragma solidity ^0.5.0;

import "./CarsSprint.sol";
import "./ERC721.sol";
import "./SafeMath.sol";

contract CarsOwner is CarsSprint, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) CarsApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerCarsCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return CarsToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerCarsCount[_to] = ownerCarsCount[_to].add(1);
    ownerCarsCount[msg.sender] = ownerCarsCount[msg.sender].sub(1);
    CarsToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (CarsToOwner[_tokenId] == msg.sender || CarsApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    CarsApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
