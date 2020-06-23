pragma solidity ^0.5.0;

import "./CarsHelper.sol";

contract CarsSprint is CarsHelper {
  uint randNonce = 0;
  uint SprintVictoryProbability = 50;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function Sprint(uint _CarsId, uint _targetId) external onlyOwnerOf(_CarsId) {
    Cars storage myCars = Car[_CarsId];
    Cars storage enemyCars = Car[_targetId];
    uint rand = randMod(100);
    if (rand <= SprintVictoryProbability) {
      myCars.winCount = myCars.winCount.add(1);
      myCars.level = myCars.level.add(1);
      enemyCars.lossCount = enemyCars.lossCount.add(1);
      feedAndMultiply(_CarsId, enemyCars.Model, "model");
    } else {
      myCars.lossCount = myCars.lossCount.add(1);
      enemyCars.winCount = enemyCars.winCount.add(1);
      _triggerCooldown(myCars);
    }
  }
}
