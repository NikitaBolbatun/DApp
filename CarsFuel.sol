pragma solidity ^0.5.0;

import "./Cars.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract CarsFuel is CarsCreate {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _carsId) {
    require(msg.sender == CarsToOwner[_carsId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Cars storage _cars) internal {
    _cars.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Cars storage _cars) internal view returns (bool) {
      return (_cars.readyTime <= now);
  }

  function feedAndMultiply(uint _carsId, uint _targetModel, string memory _species) internal onlyOwnerOf(_carsId) {
    Cars storage myCars = Car[_carsId];
    require(_isReady(myCars));
    _targetModel = _targetModel % ModelModulus;
    uint newModel = (myCars.Model + _targetModel) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newModel = newModel - newModel % 100 + 99;
    }
    _createCars("NoName", newModel);
    _triggerCooldown(myCars);
  }

  function feedOnKitty(uint _carsId, uint _kittyId) public {
    uint kitty;
    (,,,,,,,,,kitty) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_carsId, kitty, "kitty");
  }
}
