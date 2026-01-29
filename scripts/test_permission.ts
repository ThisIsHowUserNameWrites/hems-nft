import { deploy } from './ethers-lib'
import { ethers } from 'ethers'

/**
 * Script de test de sécurité : Admin vs Non-Admin
 */
(async () => {
  try {
    console.log("--- Test de Sécurité du PermissionManager ---");

    // 1. Initialisation des comptes Remix
    const provider = new ethers.providers.Web3Provider(web3Provider);
    const adminSigner = provider.getSigner(0); // Premier compte (Admin)
    const userSigner = provider.getSigner(1);  // Deuxième compte (Non-Admin)
    
    const adminAddr = await adminSigner.getAddress();
    const userAddr = await userSigner.getAddress();

    // 2. Déploiement par l'Admin
    const pm = await deploy('PermissionManager', [], 0);
    console.log(`Contrat déployé par l'Admin : ${adminAddr}`);

    // 3. TEST 1 : L'Admin active le mint (Doit réussir)
    console.log("\nTentative d'activation par l'Admin...");
    await pm.toggleMintPermission();
    console.log("✅ Succès : L'Admin a pu changer la permission.");

    // 4. TEST 2 : L'User tente de désactiver le mint (Doit échouer)
    console.log("\nTentative de désactivation par un non-admin...");
    
    try {
        await pm.connect(userSigner).callStatic.toggleMintPermission();
        console.error("❌ Erreur : L'utilisateur a réussi à bypasser la sécurité !");
    } catch (error) {
        console.log("✅ Succès du test : L'accès a été refusé (Revert expected).");
        console.log(`Message d'erreur reçu : ${error.reason}`);
    }

    // 5. TEST 3 : Promotion et nouvel essai
    console.log("\nPromotion de l'utilisateur au rang d'Admin...");
    await pm.promoteToAdmin(userAddr);
    
    console.log("Nouvelle tentative par l'utilisateur promu...");
    await pm.connect(userSigner).toggleMintPermission();
    console.log("✅ Succès : L'utilisateur promu est désormais Admin.");

    console.log("\n--- Fin des tests de sécurité ---");

  } catch (e) {
    console.error("❌ Erreur critique lors du script :");
    console.error(e);
  }
})()