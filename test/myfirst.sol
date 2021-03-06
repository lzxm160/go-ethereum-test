pragma solidity ^0.4.2;
contract Conference{
	address public organizer;
	mapping(address=>uint) public registrantsPaid;
	uint public numRegistrants;
	uint public quota;
	event Deposit(address _from,uint _amount);
	event Refund(address _to,uint _amount);
	function Conference(){
		organizer=msg.sender;
		quota=500;
		numRegistrants=0;
	}
	function buyTickets()public returns(bool success){
		if(numRegistrants>=quota){return false;}
		registrantsPaid[msg.sender]=msg.value;
		numRegistrants++;
		Deposit(msg.sender,msg.value);
		return true;
	}
	function changeQuota(uint newquota)public{
		if(msg.sender!=organizer){return;}
		quota=newquota;
	}
	function refundTicket(address recipient,uint amount)public{
		if(msg.sender!=organizer){return;}
		if(registrantsPaid[recipient]==amount){
			address myAddress=this;
			if(myAddress.balance>=amount){
				recipient.send(amount);
				registrantsPaid[recipient]=0;
				numRegistrants--;
				Refund(recipient,amount);
			}
		}
	}
	function destroy(){
		if(msg.sender==organizer){
			suicide(organizer);
		}
	}
}