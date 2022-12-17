// SPDX-License-Identifier: MIT
// OpenZeppelin port

pragma solidity ^0.8.0;

import {OwnableModifiers} from "./OwnableModifiers.sol";
import {IERC173} from "./IERC173.sol";
import {OwnableLib} from "./OwnableLib.sol";

contract OwnableFacet is OwnableModifiers, IERC173 {
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual override returns (address) {
        return OwnableLib.owner();
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        return OwnableLib.renounceOwnership();
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner)
        public
        virtual
        override
        onlyOwner
    {
        return OwnableLib.transferOwnership(newOwner);
    }
}
