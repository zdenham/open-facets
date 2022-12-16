// SPDX-License-Identifier: MIT
// Open zeppelin port

pragma solidity ^0.8.0;

library OwnableStorageLib {
    bytes32 constant STORAGE_POSITION =
        keccak256("open.facets.ownable.storage");

    struct OwnableStorage {
        address _owner;
    }

    function layout() internal pure returns (OwnableStorage storage s) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            s.slot := position
        }
    }
}
