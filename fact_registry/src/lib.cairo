use stwo_cairo_air::{CairoProof};

#[starknet::interface]
pub trait IFactRegistry<TContractState> {
    /// Register a fact.
    fn register_fact(ref self: TContractState, fact: CairoProof);
    /// Check if a fact is registered.
    fn is_registered(self: @TContractState, fact: felt252) -> bool;
    /// Verify a stwo proof.
    fn verify(self: @TContractState, proof: CairoProof) -> bool;
}

#[starknet::contract]
mod FactRegistry {
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use stwo_cairo_air::{CairoProof, verify_cairo};
    use core::poseidon::{poseidon_hash_span};

    #[storage]
    struct Storage {
        facts: Map<felt252, felt252>,
    }

    #[abi(embed_v0)]
    impl FactRegistryImpl of super::IFactRegistry<ContractState> {
        fn register_fact(ref self: ContractState, fact: CairoProof) {
            let mut serialized = array![];
            fact.serialize(ref serialized);

            verify_cairo(fact).unwrap();

            let fact_hash = poseidon_hash_span(serialized.span());
            self.facts.entry(fact_hash).write(1);
        }

        fn is_registered(self: @ContractState, fact: felt252) -> bool {
            self.facts.entry(fact).read() == 1
        }

        fn verify(self: @ContractState, proof: CairoProof) -> bool {
            verify_cairo(proof).is_ok()
        }
    }
}
