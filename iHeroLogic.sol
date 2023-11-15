pragma solidity ^0.8.0;

import {Bubble} from "./bubbleLib/bubble.sol";


contract iHeroLogic {
    address constant _bubble = 0x2000000000000000000000000000000000000002;
    address constant _creator = 0x36c756417E63F740d83908d5216310A4603d6ecc;
    uint32 _popular;

    event AddPopular(address sender);
    event EndGame(uint256 blockNumber);

    modifier onlyBubble() {
        require(msg.sender == _bubble, "sender must be bubble contract");
        _;
    }

    modifier onlyCreator() {
        require(msg.sender == _creator, "sender must be contract creator");
        _;
    }

    // 进行游戏：在bubble链上为英雄增加人气
    function addPopular() public {
        _popular++;

        emit AddPopular(msg.sender);
    }

    // 游戏结束：手动结束游戏，将bubble链累积的人气结算到主链
    function delImage() public onlyCreator {
        bytes memory callData = abi.encodeWithSignature("delImage(uint32 popular)", _popular);
        Bubble.remoteCallBack(address(this), callData);

        emit EndGame(block.number);
    }

    // 游戏结束：将bubble链累积的人气结算到主链
    // ps：仅在bubble链销毁时自动执行，不可被调用
    function destroy() public onlyBubble {
        bytes memory callData = abi.encodeWithSignature("delImage(uint32 popular)", _popular);
        Bubble.remoteCallBack(address(this), callData);

        emit EndGame(block.number);
    }
}