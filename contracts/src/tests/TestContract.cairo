use contracts::MintIpfs::{IMintIpfsDispatcher, IMintIpfsDispatcherTrait};

use contracts::components::Counter::CounterComponent;

use snforge_std::{declare, ContractClassTrait, cheat_caller_address, CheatSpan};
use snforge_std::cheatcodes::contract_class;

#[test]
fn test_all(){
    let contract = declare("MintIpfs").unwrap().contract_class();

    let(contract_address, _) = contract.deploy(@array![]).unwrap();

    let dispatcher = IMintIpfsDispatcher{contract_address};

    let hash_storage = dispatcher.storage_hash("meuhash");

    assert(hash_storage == "meuhash", "storaging working");

    let token_id:u256 = 5;
        
    let hash_define = dispatcher.define_hash(token_id,  "ipfsteste");

    assert( "ipfsteste" == dispatcher.return_hash(token_id), "map working");

}
