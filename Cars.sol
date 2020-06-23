pragma solidity ^0.5.0;

import "./Ownable.sol";
import "./SafeMath.sol";

contract CarsCreate is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewCars(uint carsId, string name, uint Model);

  uint ModelDigits = 16;
  uint ModelModulus = 10 ** ModelDigits;
  uint cooldownTime = 1 days;

  struct Cars {
    string name;
    uint Model;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Cars[] public Car;

  mapping (uint => address) public CarsToOwner;
  mapping (address => uint) ownerCarsCount;

  function _createCars(string memory _name, uint _model) internal {
    uint id = Car.push(Cars(_name, _model, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    CarsToOwner[id] = msg.sender;
    ownerCarsCount[msg.sender] = ownerCarsCount[msg.sender].add(1);
    emit NewCars(id, _name, _model);
  }

  function _generateRandomCars(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % ModelModulus;
  }

  function createRandomCars(string memory _name) public {
    require(ownerCarsCount[msg.sender] == 0);
    uint randModel = _generateRandomCars(_name);
    randModel = randModel - randModel % 100;
    _createCars(_name, randModel);
  }

}
