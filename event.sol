// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0;

contract Event {
    struct CreateEvent {
        address admin;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint remainingTicket;
    }
    address owner;
    
    uint NumberOfEvent;
    mapping (uint=>CreateEvent) public DeclareEvent;
    mapping (address => mapping(uint => uint)) public ticketsDetail;

    function EventInof(string memory _name,uint _data , uint _price, uint _ticketCount) public {
        require(_ticketCount > 0,"event must have more than 0 tickets");
        require(_data > 0,"time must be greater than the current time");
            DeclareEvent[++NumberOfEvent]=CreateEvent(msg.sender, _name, (block.timestamp*(_data * 1 minutes)) , _price, _ticketCount,_ticketCount);
    }
    
    function buyTickets(uint id, uint quantity) external payable{
        require(DeclareEvent[id].date != 0,"there is no event id exist");
        require(quantity <= DeclareEvent[id].remainingTicket,"not enough tickets avaible");
        require(block.timestamp <= DeclareEvent[id].date,"the particular event has been finished");
        CreateEvent storage _event = DeclareEvent[id];
        require(msg.value == (_event.price * quantity),"insuffient balance");
        _event.remainingTicket -= quantity; 
        ticketsDetail[msg.sender][id] += quantity;
    }
    function transferTicket(uint id ,uint quantity, address recipient)external{
         require(ticketsDetail[msg.sender][id] >= quantity,"you dont have enough tickets");
         require(DeclareEvent[id].date !=0,"no event exist");
         require(block.timestamp <= DeclareEvent[id].date,"your ticket are expired");
         ticketsDetail[msg.sender][id] -=quantity;
         ticketsDetail[recipient][id] +=quantity;
    }
}