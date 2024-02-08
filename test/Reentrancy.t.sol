// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "src/Reentrancy.sol";

contract CounterTest is Test {
    EtherStore public simple_wallet;
    EtherStoreProtected public protected_wallet;
    Attack public snippet_sw;
    Attack public snippet_pw;

    function setUp() public {
        simple_wallet = new EtherStore();
        protected_wallet = new EtherStoreProtected();
        snippet_sw = new Attack(address(simple_wallet));
        snippet_pw = new Attack(address(protected_wallet));
    }

    function test_try_reenter_simple_wallet() public {
        simple_wallet.deposit{value:10 ether}();
        assertEq(address(simple_wallet).balance, 10 ether);

        snippet_sw.attack{value: 1 ether}();
        assertEq(address(simple_wallet).balance, 0 ether);
    }

    function testFail_reenter() public {
        protected_wallet.deposit{value:10 ether}();
        snippet_pw.attack{value: 1 ether}();
        assertEq(address(protected_wallet).balance, 0 ether);
    }
    
}
