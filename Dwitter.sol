// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Twitter{
    struct tweet{
        uint id;
        address from;
        string message;
        uint timeStamp;
    }

    uint id;

    tweet[] public tweets;

    mapping(address => tweet) userTweets;
    mapping(address => address[]) followers;
    mapping(address => address[]) following;
    mapping(address => tweet[]) bookmarks;

    event newTweet(address user, string message, uint timeStamp, uint id) ;


    function createTweet(string memory _message) public{
        id++;
        uint time = block.timestamp;
        userTweets[msg.sender] = tweet(id, msg.sender, _message, time);
        tweets.push(userTweets[msg.sender]);

        emit newTweet(msg.sender, _message, time, id);
    }

    function getTweets(uint _id) public view returns(tweet memory){
        return(tweets[_id]);
    }

    function follow(address _user) public payable{
        followers[_user].push(msg.sender);
        following[msg.sender].push(_user);
    }

    function getFollowers(address _user) public view returns(address[] memory){
        return(followers[_user]);
    }

    function getFollowing(address _user) public view returns(address[] memory){
        return(following[_user]);
    }

    function retweet(uint _id) public{
        id++;
        _id = _id - 1;
        string memory message = tweets[_id].message;
        uint time = block.timestamp;
        userTweets[msg.sender] = tweet(id, msg.sender, message, block.timestamp);
        tweets.push(userTweets[msg.sender]);
        emit newTweet(msg.sender, message, time, id);
    }

    function addBookmark(uint _id) public{
        _id = _id - 1;
        bookmarks[msg.sender].push(tweets[_id]);
    }

    function getBookmarks() public view returns(tweet[] memory){
        return(bookmarks[msg.sender]);
    }

}
