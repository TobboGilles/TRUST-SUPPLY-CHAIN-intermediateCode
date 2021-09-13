
pragma ton-solidity >= 0.35.0;
pragma AbiHeader pubkey;

contract supplycchain {
             
            address public forunissuer;
            uint public index;
            uint public fournisseurPubkey;
            enum Approvisionement{pasPret,
                                  pret,
                                  enRoute,
                                  livrer,
                                  receptionner}
            
           
            
               struct Item {
                
                uint productid;
                string productype;
                string productName;
                string companyName;
                string MadeIn;
                string ingrediant;
                uint fabricationYear;
                uint ExpiredYear;
                Approvisionement etat;
                address SuperMarket; // super market address.
                uint temps; // time the product is created on the plateform
                bool certified;
    
            }
            
            // address of transporter we can take anyone for testing purpose 
     uint256 transporteurPubkey =0x583031D1113aD414F02576BD6afaBfb302140225;
    
   // only transporter 
    modifier onlyTransporter(){
         
          require(msg.Publickey==transporteurPubkey,"tu n'es pas transporteur");
        
                       tvm.accept ();
                _;
  }

            
            mapping(uint=>Item) public AllItems;
            
            event Production (address indexed fournisseur,Item vaccin);
            event Transport(address indexed transporteur,Item vaccin );
            event Recu(address indexed beneficiaire,Item vaccin );
            
            // initialized manufactuer
            constructor(uint256 _fournisseurPubkey){
                
              fournisseurPubkey= _fournisseurPubkey;

                   tvm.accept ();
            
            // initialized product funtion
                produit();
            }
            
            function produit()private {
                
                Item memory vaccin=Item( index,
                                        "foodProduct", 
                                        "productName",
                                        "companyName",
                                        "MadeIn", 
                                        "ingrediant",
                                         2018,
                                         2021,
                                         Approvisionement.pasPret,
                                         msg.sender,
                                         block.timestamp,
                                         true);
                                  
                AllItems[index]=vaccin;
                
                emit Production(msg.sender,AllItems[index]);
                
            }
              // create item with arguments
            function createItem (string  _productype,
                                 string  _productName,
                                 string  _companyName,
                                 string  _MadeIn,
                                 string  _ingrediant,
                                 uint    _fabricationYear,
                                 uint    _ExpiredYear,
                                 address _SuperMarket)public {
              
              // only manufacturer can create item 
                require(msg.sender==fournisseur,"you are not supplier");
               
              // increament item created 
                index+=1;
               // stock the items created 
                AllItems[index]=Item(index,
                                    _productype, 
                                    _productName,
                                    _companyName,
                                    _MadeIn,
                                    _ingrediant,
                                    _fabricationYear,
                                    _ExpiredYear,
                                     Approvisionement.pret,
                                     _SuperMarket,
                                     block.timestamp,
                                     true);
                
                emit Production(msg.sender,AllItems[index]);
            }
            
            
            function transportProduct(uint _index)public onlyTransporter {
              
              // make syre the product is ready
                require(AllItems[_index].etat==Approvisionement.pret,"the product is not ready");
               
               // update the status of the product to "on the way"
                AllItems[_index].etat=Approvisionement.enRoute;
                
                emit Transport (transporteur,AllItems[index]);
            }
            
            // deliver the product
            function deliverProduct(uint _index)public onlyTransporter{
              
              // make sure the product is "on the way"
                require(AllItems[_index].etat==Approvisionement.enRoute,"ce n'est pas pret");
              
              // update the status of the product to "deliver"
                AllItems[_index].etat=Approvisionement.livrer;
              
                emit Transport (transporteur,AllItems[index]);
            }
            
            function reception(uint _index)public {
                
                // only SuperMarket address can recieve the product
                  require(AllItems[_index].SuperMarket==msg.sender,"tu n'as pas le droit");
                  
                  // make sure the product is "deliver"
                  require(AllItems[_index].etat==Approvisionement.livrer,"ce n'est pas pret");
                 
                 // make sure the product is receive buy supermarket
                 AllItems[_index].etat=Approvisionement.receptionner;
                  
                  emit Recu(msg.sender,AllItems[index]);
            }
        
            // costumer can chech wheter or not the product is certified
            function scanQRcode (uint _index)  public view returns (bool) {
               return AllItems[_index].certified; 
            }
    

        // return total number of Item created on the supply chain
        function totalItems() public view returns(uint) {
        return index;
    }
    
    // customer can pruchase product 
    function PayFortheItem (uint _index, address _SuperMarket, uint amount ) public {
        
    }


}


