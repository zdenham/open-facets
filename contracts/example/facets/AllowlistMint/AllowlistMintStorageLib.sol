// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library AllowlistMintStorageLib {
    bytes32 constant STORAGE_POSITION =
        keccak256("open.allowlist.mint.storage");

    struct AllowlistMintStorage {
        mapping(address => bool) mintAllowlist;
    }

    function layout() internal pure returns (AllowlistMintStorage storage s) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            s.slot := position
        }
    }
}
