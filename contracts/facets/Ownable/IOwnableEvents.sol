// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IOwnableEvents {
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
}
