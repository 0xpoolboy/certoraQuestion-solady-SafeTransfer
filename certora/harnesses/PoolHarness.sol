// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/Pool.sol";

contract PoolHarness is Pool {
    constructor(address _vault, address _manager, address _client, address _mainToken)
        Pool(_vault,_manager,_client,_mainToken) {}
}