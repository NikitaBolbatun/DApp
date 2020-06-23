pragma solidity ^0.5.0;

import "./CarsFuel.sol";

contract CarsHelper is CarsFuel {

  uint levelUpFee = 0.001 ether;

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _CarsId) external payable {
    require(msg.value == levelUpFee);
    Car[_CarsId].level = Car[_CarsId].level.add(1);
  }

  function changeName(uint _CarsId, string calldata _newName) external aboveLevel(10, _CarsId) onlyOwnerOf(_CarsId) {
    Car[_CarsId].name = _newName;
  }

  function changeDna(uint _CarsId, uint _newModel) external aboveLevel(20, _CarsId) onlyOwnerOf(_CarsId) {
    Car[_CarsId].Model = _newModel;
  }

  function withdraw() external onlyOwner {
    address payable _owner = address(uint160((owner())));
    _owner.transfer(address(this).balance);
  }

  modifier aboveLevel(uint _level, uint _CarsId) {
    require(Car[_CarsId].level >= _level);
    _;
  }
  function getCarByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerCarsCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < Car.length; i++) {
      if (CarsToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
