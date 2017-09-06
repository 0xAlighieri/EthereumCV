pragma solidity ^0.4.8;

import "./CVExtender.sol";
import "./mortal.sol";


contract Resume is CVExtender, mortal {
    event visitorEnteredInput(bytes32 visitorName, bytes32 visitorMessage);
    event identityHasBeenSet(string message);
    event visitorIndexRetrieved(uint256 index);
    event messagesHaveBeenGathered(string messageGathered);
    
    
    uint visitorNum;
    Identity myIdentity;
    
    mapping (uint => visitorInput) visitors;
    
    struct Identity {
        string _url;
        string _description;
        string _title;
        string _author;
        string _email;
    }
    struct visitorInput {
        bytes32 visitorName;
        bytes32 visitorMessage;
    }
    
    function Resume() {
        setIdentity("mywebsite.com", "Resume", "Blockchain CV", "Taylor French", "taylor.french@protonmail.com");
        identityHasBeenSet("Identity is set.");
    }
    function enterVisitorInput(bytes32 theirName, bytes32 theirMessage) {
        visitorNum++;
        visitors[visitorNum] = visitorInput(theirName, theirMessage);
        visitorEnteredInput(theirName, theirMessage);
    }
    function getVisitorInputByIndex (uint256 indexId) returns (bytes32 theirName, bytes32 theirMessage) {
        visitorIndexRetrieved(indexId);
        return (visitors[indexId].visitorName, visitors[indexId].visitorMessage);
    }
    function setIdentity(string url, string desc, string title, string author, string email) onlyowner {
        myIdentity = Identity(url, desc, title, author, email);
    }
    function gatherMessages() public constant returns (uint256[] messageIds, bytes32[] visitorNames, bytes32[] visitorMessages) {
        require(visitorNum > 0);
        
        //prepare output arrays
        uint256[] memory messageId = new uint256[](visitorNum);
        bytes32[] memory visitorName = new bytes32[](visitorNum);
        bytes32[] memory visitorMessage = new bytes32[](visitorNum);
        
        for (uint i = 1; i <= visitorNum; i++) {
            visitorInput memory visitorinput = visitors[i];
            messageId[i - 1] = i;
            visitorName[i - 1] = visitorinput.visitorName;
            visitorMessage[i - 1] = visitorinput.visitorMessage;
        }
        messagesHaveBeenGathered("Messages have been gathered");
        return (messageId, visitorName, visitorMessage);
    }
    
    
     /**
      * Below is for our CV!
      * */
    function getAddress() constant returns(string) {
        return myIdentity._url;
    }
    
    function getDescription() constant returns(string) {
        return myIdentity._description;
    }
    function getTitle() constant returns(string) {
        return myIdentity._title;
    }
    function getAuthor() constant returns(string, string) {
        return (myIdentity._author, myIdentity._email);
    }
}