pragma solidity ^0.8.0;

import {Bubble} from "./bubbleLib/bubble.sol";


contract iHeroLogic {
    address constant _bubble = 0x2000000000000000000000000000000000000002;
    uint32 _popular;

    event AddPopular(address sender);
    event Destroy(uint256 blockNumber);

    modifier onlyBubble(address sender) {
        require(sender == _bubble, "sender must be bubble contract");
        _;
    }

    function addPopular() public {
        _popular++;

        emit AddPopular(msg.sender);
    }

    function destroy() public {
        bytes memory callData = abi.encodeWithSignature("destroyImage(uint32 popular)", _popular);
        Bubble.remoteCallBack(address(this), callData);

        emit Destroy(block.number);
    }
}