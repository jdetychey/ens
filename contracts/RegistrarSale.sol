pragma solidity ^0.4.10;
//work in progress
import './ENS.sol';

contract RegistrarSaleContract{
    
    address public seller;
    uint public salePrice;
    bytes32 public nodeForSale;
    ENS registrar=ENS(0x314159265dD8dbb310642f98f50C066173C1259b);
    
    function RegistrarSaleContract(uint _salePrice, bytes32 _nodeForSale){
        seller = msg.sender;
        salePrice = _salePrice;
        nodeForSale = _nodeForSale;
    }
    
    modifier onlySeller() {
        require(msg.sender==seller);
        _;
    }
    
    function() payable {
        require(msg.value >= salePrice);
        registrar.setOwner(nodeForSale, msg.sender);
        selfdestruct(seller);
    }
    
    function cancelSale() onlySeller{
        registrar.setOwner(nodeForSale, seller);
        selfdestruct(seller);
    }
}
