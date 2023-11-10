pragma solidity ^0.8.9;

import {RLPReader} from "./rlp/RLPReader.sol";
import {RLPWriter} from "./rlp/RLPWriter.sol";

library Bubble {
    event LogMessage(string message);

    function bytesToHex(bytes memory data) public pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(2 * data.length + 2);

        str[0] = "0";
        str[1] = "x";

        for (uint i = 0; i < data.length; i++) {
            str[2 * i + 2] = alphabet[uint(uint8(data[i] >> 4))];
            str[2 * i + 3] = alphabet[uint(uint8(data[i] & 0x0f))];
        }

        return string(str);
    }

    function selectBubble(uint8 size) internal returns (uint32) {
        bytes[] memory dataArrays = new bytes[](2);

        bytes memory fnData = RLPWriter.writeBytes(RLPWriter.writeUint(8001));
        bytes memory sizeData = RLPWriter.writeBytes(RLPWriter.writeUint(size));
        dataArrays[0] = fnData;
        dataArrays[1] = sizeData;

        bytes memory rlpData = RLPWriter.writeList(dataArrays);
        
        (bool success, bytes memory returnData) = address(0x2000000000000000000000000000000000000002).call(rlpData);
        if (!success) {
            revert("call selectBubble failed");
        }

        emit LogMessage(bytesToHex(returnData));
//        uint result = abi.decode(returnData, (uint));
        return 0;
    }

    function remoteDeploy(uint64 bubbleID, address target, uint256 amount, bytes memory data) internal {
        bytes[] memory dataArrays = new bytes[](5);

        bytes memory fnData = RLPWriter.writeBytes(RLPWriter.writeUint(8006));
        bytes memory bubidData = RLPWriter.writeBytes(RLPWriter.writeUint(bubbleID));
        bytes memory targetData = RLPWriter.writeBytes(RLPWriter.writeAddress(target));
        bytes memory amountData = RLPWriter.writeBytes(RLPWriter.writeUint(amount));
        bytes memory dataData = RLPWriter.writeBytes(RLPWriter.writeBytes(data));
        dataArrays[0] = fnData;
        dataArrays[1] = bubidData;
        dataArrays[2] = targetData;
        dataArrays[3] = amountData;
        dataArrays[4] = dataData;

        bytes memory rlpData = RLPWriter.writeList(dataArrays);
        
        (bool success, bytes memory returnData) = address(0x2000000000000000000000000000000000000002).call(rlpData);
        if (!success) {
            revert("call remoteDeploy failed");
        }

        emit LogMessage(bytesToHex(returnData));
    }

    function remoteCall(uint64 bubbleID, address target, bytes memory data) internal {
        bytes[] memory dataArrays = new bytes[](4);

        bytes memory fnData = RLPWriter.writeBytes(RLPWriter.writeUint(8007));
        bytes memory bubidData = RLPWriter.writeBytes(RLPWriter.writeUint(bubbleID));
        bytes memory targetData = RLPWriter.writeBytes(RLPWriter.writeAddress(target));
        bytes memory dataData = RLPWriter.writeBytes(RLPWriter.writeBytes(data));
        dataArrays[0] = fnData;
        dataArrays[1] = bubidData;
        dataArrays[2] = targetData;
        dataArrays[3] = dataData;

        bytes memory rlpData = RLPWriter.writeList(dataArrays);
        
        (bool success, bytes memory returnData) = address(0x2000000000000000000000000000000000000002).call(rlpData);
        if (!success) {
            revert("call remoteDeploy failed");
        }

        emit LogMessage(bytesToHex(returnData));
    }

        function remoteCallBack(address target, bytes memory data) internal {
        bytes[] memory dataArrays = new bytes[](3);

        bytes memory fnData = RLPWriter.writeBytes(RLPWriter.writeUint(8003));
        bytes memory targetData = RLPWriter.writeBytes(RLPWriter.writeAddress(target));
        bytes memory dataData = RLPWriter.writeBytes(RLPWriter.writeBytes(data));
        dataArrays[0] = fnData;
        dataArrays[1] = targetData;
        dataArrays[2] = dataData;

        bytes memory rlpData = RLPWriter.writeList(dataArrays);
        
        (bool success, bytes memory returnData) = address(0x2000000000000000000000000000000000000002).call(rlpData);
        if (!success) {
            revert("call remoteDeploy failed");
        }

        emit LogMessage(bytesToHex(returnData));
    }


}