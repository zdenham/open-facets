// SPDX-License-Identifier: MIT
// Open zeppelin port

pragma solidity ^0.8.0;

import {ERC721Lib} from "../../../facets/ERC721/ERC721Lib.sol";
import {TransferBlocklistNFTStorageLib} from "./TransferBlocklistNFTStorageLib.sol";

library TransferBlocklistNFTLib {
    function setIsBlocked(address _address, bool _isBlocked) internal {
        TransferBlocklistNFTStorageLib.layout().transferBlocklist[
            _address
        ] = _isBlocked;
    }

    function isBlocked(address _address) internal view returns (bool) {
        return
            TransferBlocklistNFTStorageLib.layout().transferBlocklist[_address];
    }

    function _enforceIsNotBlocked(address _address) internal view {
        require(
            !isBlocked(_address),
            "TransferBlocklistNFT: Address is blocked"
        );
    }

    // ERC721 Overrides
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        _enforceIsNotBlocked(to);
        ERC721Lib.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        _enforceIsNotBlocked(to);
        ERC721Lib.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _enforceIsNotBlocked(to);
        ERC721Lib.safeTransferFrom(from, to, tokenId, data);
    }
}
