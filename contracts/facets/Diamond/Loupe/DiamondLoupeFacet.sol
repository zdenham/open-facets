// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
/******************************************************************************/

import {DiamondLoupeLib} from "./DiamondLoupeLib.sol";
import {IDiamondLoupe} from "./IDiamondLoupe.sol";
import {IERC165} from "./IERC165.sol";

// The functions in DiamondLoupeFacet MUST be added to a diamond.
// The EIP-2535 Diamond standard requires these functions.

contract DiamondLoupeFacet is IDiamondLoupe, IERC165 {
    // Diamond Loupe Functions
    ////////////////////////////////////////////////////////////////////
    /// These functions are expected to be called frequently by tools.
    //
    // struct Facet {
    //     address facetAddress;
    //     bytes4[] functionSelectors;
    // }

    /// @notice Gets all facets and their selectors.
    /// @return facets_ Facet
    function facets()
        external
        view
        virtual
        override
        returns (Facet[] memory facets_)
    {
        return DiamondLoupeLib.facets();
    }

    /// @notice Gets all the function selectors provided by a facet.
    /// @param _facet The facet address.
    /// @return facetFunctionSelectors_
    function facetFunctionSelectors(address _facet)
        external
        view
        virtual
        override
        returns (bytes4[] memory facetFunctionSelectors_)
    {
        return DiamondLoupeLib.facetFunctionSelectors(_facet);
    }

    /// @notice Get all the facet addresses used by a diamond.
    /// @return facetAddresses_
    function facetAddresses()
        external
        view
        virtual
        override
        returns (address[] memory facetAddresses_)
    {
        return DiamondLoupeLib.facetAddresses();
    }

    /// @notice Gets the facet that supports the given selector.
    /// @dev If facet is not found return address(0).
    /// @param _functionSelector The function selector.
    /// @return facetAddress_ The facet address.
    function facetAddress(bytes4 _functionSelector)
        external
        view
        virtual
        override
        returns (address facetAddress_)
    {
        return DiamondLoupeLib.facetAddress(_functionSelector);
    }

    // This implements ERC-165.
    function supportsInterface(bytes4 _interfaceId)
        external
        view
        virtual
        override
        returns (bool)
    {
        return DiamondLoupeLib.supportsInterface(_interfaceId);
    }
}
