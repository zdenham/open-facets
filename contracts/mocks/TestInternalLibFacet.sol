// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {InternalLib} from "./InternalLib.sol";

contract TestInternalLibFacet {
    function test1() external pure returns (uint256) {
        return InternalLib.test1();
    }
}
