// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";

interface IManager {
    function finalize(address) external;
}

contract Pool {
    using SafeTransferLib for address;

    address public vault;
    address public manager;
    address public client;
    address public mainToken;
    
    modifier onlyManager() virtual {
        require(manager == msg.sender);
        _;
    }

    constructor(address _vault, address _manager, address _client, address _mainToken) {
        vault = _vault;
        manager = _manager;
        client = _client;
        mainToken = _mainToken;
    }


    function withdrawFromPool(address otherToken, uint256 amount) external onlyManager {
        otherToken.safeTransfer(address(vault), amount);
        uint256 balance = mainToken.balanceOf(address(this));
        if (balance > 0) {
            mainToken.safeTransfer(address(vault), balance);
        }
        IManager(manager).finalize(client);
    }
}
