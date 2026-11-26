
// SPDX-License-Identifier: MIT
pragma solidity 0.8.39;

// Contrat de coffre-fort Ethereum
contract Vault {

    // Enregistre le solde de chaque utilisateur
    mapping(address => uint256) public balances;

    // Permet de déposer des ETH
    function deposit() external payable {
        require(msg.value > 0, "Montant invalide");

        balances[msg.sender] += msg.value;
    }

    // Permet de retirer ses ETH de manière sécurisée
    function withdraw() external {
        // 1. CHECKS : vérifier le solde
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Solde insuffisant");

       // 2. EFFECTS : mettre le solde a zero AVANT le transfert
       balances[msg.sender] = 0;

      // 3. INTERACTIONS : envoyer les ETH
     (bool success, ) = msg.sender.call{value: amount}("");
     require(success, "Echec du transfert");
     }
}
