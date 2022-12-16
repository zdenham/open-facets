// SPDX-License-Identifier: MIT
// Open zeppelin port

pragma solidity ^0.8.0;

import {OwnableLib} from "./OwnableLib.sol";

contract OwnableModifiers {
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        OwnableLib._checkOwner();
        _;
    }
}
