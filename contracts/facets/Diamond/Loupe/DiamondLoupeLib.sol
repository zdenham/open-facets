// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
/******************************************************************************/

import {IDiamondLoupe} from "./IDiamondLoupe.sol";
import {DiamondStorageLib} from "../DiamondStorageLib.sol";

// The functions in DiamondLoupeFacet MUST be added to a diamond.
// The EIP-2535 Diamond standard requires these functions.

library DiamondLoupeLib {
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
        internal
        view
        returns (IDiamondLoupe.Facet[] memory facets_)
    {
        DiamondStorageLib.DiamondStorage storage ds = DiamondStorageLib
            .layout();
        uint256 numFacets = ds.facetAddresses.length;
        facets_ = new IDiamondLoupe.Facet[](numFacets);
        for (uint256 i; i < numFacets; i++) {
            address facetAddress_ = ds.facetAddresses[i];
            facets_[i].facetAddress = facetAddress_;
            facets_[i].functionSelectors = ds
                .facetFunctionSelectors[facetAddress_]
                .functionSelectors;
        }
    }

    /// @notice Gets all the function selectors provided by a facet.
    /// @param _facet The facet address.
    /// @return facetFunctionSelectors_
    function facetFunctionSelectors(address _facet)
        internal
        view
        returns (bytes4[] memory facetFunctionSelectors_)
    {
        DiamondStorageLib.DiamondStorage storage ds = DiamondStorageLib
            .layout();
        facetFunctionSelectors_ = ds
            .facetFunctionSelectors[_facet]
            .functionSelectors;
    }

    /// @notice Get all the facet addresses used by a diamond.
    /// @return facetAddresses_
    function facetAddresses()
        internal
        view
        returns (address[] memory facetAddresses_)
    {
        DiamondStorageLib.DiamondStorage storage ds = DiamondStorageLib
            .layout();
        facetAddresses_ = ds.facetAddresses;
    }

    /// @notice Gets the facet that supports the given selector.
    /// @dev If facet is not found return address(0).
    /// @param _functionSelector The function selector.
    /// @return facetAddress_ The facet address.
    function facetAddress(bytes4 _functionSelector)
        internal
        view
        returns (address facetAddress_)
    {
        DiamondStorageLib.DiamondStorage storage ds = DiamondStorageLib
            .layout();
        facetAddress_ = ds
            .selectorToFacetAndPosition[_functionSelector]
            .facetAddress;
    }

    // This implements ERC-165.
    function supportsInterface(bytes4 _interfaceId)
        internal
        view
        returns (bool)
    {
        DiamondStorageLib.DiamondStorage storage ds = DiamondStorageLib
            .layout();
        return ds.supportedInterfaces[_interfaceId];
    }
}
