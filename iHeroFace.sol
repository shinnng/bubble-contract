pragma solidity ^0.8.9;

import {Bubble} from "./bubbleLib/bubble.sol";
import {Log} from "./bubbleLib/log/log.sol";

// 这是一个简单的游戏，英雄可以创建分身，用户为英雄的分身点赞，就会增加英雄的人气。
contract iHeroFace {
    string internal _name;
    string internal _website;
    string internal _introduce;
    string internal _gameType;
    address internal _logicContact;
    address  internal _owner;

    uint64 public allPopular = 0;    // 总人气
    uint32 internal _imageId = 0;    // 分身Id计数器
    uint256 internal constant _stakingAmount = 10000000000000000000;
    address constant _bubble = 0x2000000000000000000000000000000000000002;

    mapping(uint32 => uint) internal dist;   // 记录分身所在bubble
    mapping(address => uint32) internal contributor;

    event GetBubble(uint bubbleId);
    event CreateGame(uint indexed boundId, uint indexed bubbleId, address indexed Creator);
    event JoinGame(uint indexed boundId, address indexed player);
    event EndGame(uint indexed boundId);

    modifier onlyBubble() {
        // 需要多签算法检查合约支持，暂无法实现
        // require(msg.sender == _bubble, "sender must be bubble contract");
        _;
    }

        constructor(string memory name, string memory website, string memory introduce, string memory gameType, address logicContact) {
        _name = name;
        _website = website;
        _introduce = introduce;
        _gameType = gameType;
        _owner = msg.sender;
        _logicContact = logicContact;
    }

    function Name() public view returns(string memory) {
        return _name;
    }

    function Website() public view returns(string memory) {
        return _website;
    }

    function Introduce() public view returns(string memory) {
        return _introduce;
    }

    function GameType() public view returns(string memory) {
        return _gameType;
    }

    function GetBubbleId(uint32 imageId) external view returns(uint) {
        return dist[imageId];
    }

    // 获取bubbleId
    function getBubble() public {
        uint bubbleId = Bubble.selectBubble(1);
        emit GetBubble(bubbleId);
    }

    // 游戏初始化：为英雄创建分身到bubble链
    function addImage(uint bubbleId) public {
        // 记录分身所在的bubble
        _imageId++;
        dist[_imageId] = bubbleId;
        // 在bubble部署逻辑合约
        Bubble.remoteDeploy(bubbleId, _logicContact, _stakingAmount, bytes(""));

        emit CreateGame(_imageId, bubbleId, msg.sender);
        emit JoinGame(_imageId, msg.sender);
    }

    // 游戏销毁：在人气被remoteCall结算的情况下，手动使用该方法销毁image
    function removeImage(uint32 imageId) public onlyBubble {
        uint bubbleId = dist[imageId];

        Bubble.remoteRemove(bubbleId, _logicContact);
        
        emit EndGame(imageId);
    }

    // 游戏结算：自动召回分身，并获取从分身的人气
    function delImage(uint32 imageId, uint32 popular) public onlyBubble {
        allPopular += popular;
        contributor[msg.sender] += popular;

        uint boundId = dist[imageId];
        emit EndGame(boundId);
    }
}