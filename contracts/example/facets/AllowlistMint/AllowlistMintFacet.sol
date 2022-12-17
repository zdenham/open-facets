// SPDX-License-Identifier: MIT
// Open zeppelin port

pragma solidity ^0.8.0;

import {AllowlistMintLib} from "./AllowlistMintLib.sol";
import {OwnableModifiers} from "../../../facets/Ownable/OwnableModifiers.sol";

contract AllowlistMintFacet is OwnableModifiers {
    function setIsAllowlisted(address _address, bool _isAllowlisted)
        external
        virtual
        onlyOwner
    {
        return AllowlistMintLib.setIsAllowlisted(_address, _isAllowlisted);
    }

    function isAllowlisted(address _address)
        external
        view
        virtual
        returns (bool)
    {
        return AllowlistMintLib.isAllowlisted(_address);
    }

    function enforceIsAllowlisted(address _address) external view virtual {
        return AllowlistMintLib.enforceIsAllowlisted(_address);
    }

    function mint(address to, uint256 tokenId) internal {
        return AllowlistMintLib.mint(to, tokenId);
    }
}
