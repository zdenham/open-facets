// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library TransferBlocklistNFTStorageLib {
    bytes32 constant STORAGE_POSITION =
        keccak256("open.facets.transfer.blocklist.nft.storage");

    struct TransferBlocklistNFTStorage {
        mapping(address => bool) transferBlocklist;
    }

    function layout()
        internal
        pure
        returns (TransferBlocklistNFTStorage storage s)
    {
        bytes32 position = STORAGE_POSITION;
        assembly {
            s.slot := position
        }
    }
}
