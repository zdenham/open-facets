// SPDX-License-Identifier: MIT
// Open zeppelin port

pragma solidity ^0.8.0;

library ERC721StorageLib {
    bytes32 constant STORAGE_POSITION = keccak256("open.facets.erc721.storage");

    struct ERC721Storage {
        // Token name
        string _name;
        // Token symbol
        string _symbol;
        // Mapping from token ID to owner address
        mapping(uint256 => address) _owners;
        // Mapping owner address to token count
        mapping(address => uint256) _balances;
        // Mapping from token ID to approved address
        mapping(uint256 => address) _tokenApprovals;
        // Mapping from owner to operator approvals
        mapping(address => mapping(address => bool)) _operatorApprovals;
    }

    function layout() internal pure returns (ERC721Storage storage s) {
        bytes32 position = STORAGE_POSITION;
        assembly {
            s.slot := position
        }
    }
}
