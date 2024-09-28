use starknet::ContractAddress;

#[starknet::interface]
pub trait IMintIpfs<T> {
    fn storage_hash(ref self:T, ipfs: ByteArray);
    fn define_hash(ref self: T, token_id: u256);
    fn return_hash(ref self: T, token_id: u256);

    fn mint_item(ref self: T, recipient: ContractAddress)->u256;
}

mod MintIpfs {
    use core::num::traits::zero::Zero;

    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::introspection::src5::SRC5Component;

    use contracts::components::Counter::CounterComponent;
    
    // use openzeppelin::token::erc721::{
    //     ERC721Component, interface::{IERC721Metadata, IERC721MetadataCamelOnly}
    // };

    use super::{IMintIpfs, ContractAddress};

    // Expose entrypoints
    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    #[abi(embed_v0)]
    impl CounterImpl = CounterComponent::CounterImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721CamelOnlyImpl = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

     
    #[storage]
    struct Storage{
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        token_id_counter: CounterComponent::Storage,

        ipfs_hash: ByteArray,
        hashes: LegacyMap<u256, ByteArray>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,    
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        CounterEvent: CounterComponent::Event,
    }

    
    // #[constructor]
    // fn constructor(ref self:ContractState, owner: ContractAddress){
    //     let name: ByteArray = "MintIpfs";
    //     let symbol: ByteArray = "MIP";
    //     let base_uri: ByteArray = "https://ipfs.io/ipfs/";

    //     self.erc721.initializer(name,symbol,base_uri);
    //     self.ownable.initializer(owner);
    // }

    #[abi(embed_v0)]
    impl MintIpfs of IMintIpfs<ContractState>{
        fn storage_hash(ref self: ContractState, ipfs: ByteArray){
            ipfs_hash = ipfs;
        }    
        fn define_hash(ref self: ContractState, token_id: u256, ipfs: ByteArray){
            self.hashes.write(token_id, ipfs);
        }
        fn return_hash(ref self: ContractState, token_id: u256)-> ByteArray{
            return self.hashes.read(token_id);
        } //aí o contrato passa esse return_hash pro front e o front dá um fetch na url    
        
        fn mint_item(ref self: ContractState, recipient:ContractAddress) -> u256 {
            self.token_id_counter.increment();
            let token_id = self.token_id_counter.current();

            //deixar mockado um token_id
            //let token_id = 22;

            self.erc721.mint(recipient, token_id);
            token_id
        }
    }

}