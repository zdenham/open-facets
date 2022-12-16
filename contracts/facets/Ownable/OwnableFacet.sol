// SPDX-License-Identifier: MIT
// OpenZeppelin port

pragma solidity ^0.8.0;

import {OwnableModifiers} from "./OwnableModifiers.sol";
import {IOwnableEvents} from "./IOwnableEvents.sol";
import {OwnableLib} from "./OwnableLib.sol";

contract Ownable is OwnableModifiers, IOwnableEvents {
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
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
    function transferOwnership(address newOwner) public virtual onlyOwner {
        return OwnableLib.transferOwnership(newOwner);
    }
}
