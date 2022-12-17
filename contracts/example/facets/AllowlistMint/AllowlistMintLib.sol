// SPDX-License-Identifier: MIT
// Open zeppelin port

pragma solidity ^0.8.0;

import {ERC721Lib} from "../../../facets/ERC721/ERC721Facet.sol";
import {AllowlistMintStorageLib} from "./AllowlistMintStorageLib.sol";

library AllowlistMintLib {
    function setIsAllowlisted(address _address, bool _isAllowlisted) internal {
        AllowlistMintStorageLib.layout().mintAllowlist[
            _address
        ] = _isAllowlisted;
    }

    function isAllowlisted(address _address) internal view returns (bool) {
        return AllowlistMintStorageLib.layout().mintAllowlist[_address];
    }

    function enforceIsAllowlisted(address _address) internal view {
        require(isAllowlisted(_address), "Not allowed to mint");
    }

    function mint(address to, uint256 tokenId) internal {
        enforceIsAllowlisted(to);
        ERC721Lib._mint(to, tokenId);
    }
}
