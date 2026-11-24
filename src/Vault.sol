
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Contrat de coffre-fort Ethereum
contract Vault {

    // Enregistre le solde de chaque utilisateur
    mapping(address => uint256) public balances;

    // Permet de déposer des ETH
    function deposit() external payable {
        require(msg.value > 0, "Montant invalide");

        balances[msg.sender] += msg.value;
    }

    // Permet de retirer ses ETH
    function withdraw() external {
        uint256 amount = balances[msg.sender];

        require(amount > 0, "Solde insuffisant");

        // Envoi des ETH avant la mise a jour du solde
        (bool success, ) = msg.sender.call{value: amount}("");

        require(success, "Echec du transfert");

        // Mise a zero du solde
        balances[msg.sender] = 0;
    }
}
