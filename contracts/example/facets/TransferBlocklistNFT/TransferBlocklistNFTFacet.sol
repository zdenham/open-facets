// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC721Facet} from "../../../facets/ERC721/ERC721Facet.sol";
import {TransferBlocklistNFTLib} from "./TransferBlocklistNFTLib.sol";
import {OwnableModifiers} from "../../../facets/Ownable/OwnableModifiers.sol";

contract TransferBlocklistNFTFacet is ERC721Facet, OwnableModifiers {
    function setIsBlocked(address _address, bool _isBlocked)
        external
        virtual
        onlyOwner
    {
        TransferBlocklistNFTLib.setIsBlocked(_address, _isBlocked);
    }

    function isBlocked(address _address) external view virtual returns (bool) {
        return TransferBlocklistNFTLib.isBlocked(_address);
    }

    // override default behavior from ERC721Facet
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        TransferBlocklistNFTLib.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        TransferBlocklistNFTLib.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        TransferBlocklistNFTLib.safeTransferFrom(from, to, tokenId, data);
    }
}
