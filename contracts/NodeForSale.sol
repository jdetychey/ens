pragma solidity ^0.4.10;
//work in progress
/*usage: deploy this contract with the price you wish to sell a ENS name
you own or more precisely the ENS node you own.
FYI: The ENS stores the name you won under a bytes32 called "node", 
you can retrieve this bytes32 via the Namehash function, see
https://github.com/ethereum/EIPs/issues/137
At the deployment of this NodeForSale contract you set the selling price
and the node you wish to sell. After the contract is deployed you have to
call the setOwner of the ENS to change your address by the address of this
contract.
A potential buyer can check that the name match to this contract by querying
the ENS, he can also verify the source code and read the sellingPrice.
Sending the proper value to this contract will trigger a change of ownership
in the ENS and the transfer of value to the seller*/
import './ENS.sol';

contract NodeForSale{
    
    address public seller;
    uint public sellingPrice;
    bytes32 public nodeForSale;
    ENS registrar=ENS(0x314159265dD8dbb310642f98f50C066173C1259b);
    
    function NodeForSale(uint _sellingPrice, bytes32 _nodeForSale){
        seller = msg.sender;
        sellingPrice = _sellingPrice;
        nodeForSale = _nodeForSale;
    }
    
    modifier onlySeller() {
        require(msg.sender==seller);
        _;
    }
    
    function() payable {
        require(msg.value >= sellingPrice);
        registrar.setOwner(nodeForSale, msg.sender);
        selfdestruct(seller);
    }
    
    function cancelSale() onlySeller{
        registrar.setOwner(nodeForSale, seller);
        selfdestruct(seller);
    }
}
