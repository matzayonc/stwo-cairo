use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

use fact_registry::IFactRegistryDispatcher;
use fact_registry::IFactRegistryDispatcherTrait;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_register_fact() {
    let contract_address = deploy_contract("FactRegistry");

    let dispatcher = IFactRegistryDispatcher { contract_address };

    // let balance_before = dispatcher.get_balance();
    // assert(balance_before == 0, 'Invalid balance');

    // dispatcher.register_fact(42);

    let is_registered = dispatcher.is_registered(0);
    assert(is_registered == false, 'Invalid balance');
}
