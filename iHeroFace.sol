pragma solidity ^0.8.9;

import {Bubble} from "./bubbleLib/bubble.sol";


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
    uint256 internal constant imageAmount = 10000000000000000000;

    mapping(uint32 => uint32) internal dist;   // 记录分身所在bubble
    mapping(address => uint32) internal contributor;

    event CreateGame(uint indexed boundId, uint bubbleId, address Creator);
    event JoinGame(uint boundId, address player);
    event DestroyImage(uint32 popular);

    modifier onlyOwner(address sender) {
        // require(sender == _owner, "Condition not satisfied");
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

    function GetBubbleId(uint32 imageId) external view returns(uint32) {
        return dist[imageId];
    }

    // 英雄创建分身到bubble
    function image() external {
        // 获取一个bubble
        uint32 bubbleId = Bubble.selectBubble(1);
        // 记录分身所在的bubble
        _imageId++;
        dist[_imageId] = bubbleId;
        // 在bubble部署逻辑合约
        Bubble.remoteDeploy(bubbleId, _logicContact, imageAmount, bytes("")); // todo: 补充初始化data

        emit CreateGame(_imageId, bubbleId, msg.sender);
        emit JoinGame(bubbleId, msg.sender);
    }

    // 英雄收取从bubble过来的人气
    function destroyImage(uint32 popular) public onlyOwner(msg.sender) {
        allPopular += popular;
        contributor[msg.sender] += popular;

        emit DestroyImage(popular);
    }
}