// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {InternalContract} from "./InternalContract.sol";

contract TestInternalCallFacet is InternalContract {
    function test1() external pure returns (uint256) {
        return _test1();
    }
}
