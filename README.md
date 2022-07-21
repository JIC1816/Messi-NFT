This is a simple NFT contract. I added some features to it, in order to make it more secure and
also reusable. The main changes in this second version of the contract are:

1. I deployed the contract in Rinkeby testnet. See: 0xBeB86BB0AB3F652E60E932d864B5e9B0Ea188663
2. I added a payable modifier into the constructor function. This way, the contract can have an initial ETH balance when deployed.
3. I tested the contract by minting a few NFTs (both presale and public minting).
4. With the new getContractBalance function, you can see how the contract balance grew after deployment.
5. I also added a Whitelist system (with four new functions) in order to fulfill the originality criteria.

I hope this changes represents critical improvements to the issues pointed out by the evaluators.

Of course, I'm still open to suggestions and more feedback. Thanks!

PS: It didn't seem fair to include mrraymoon's feedback, despite it being a very good one. That's why I didn't merge his pull request. Although I must admit that much of my improvement in the documentation part I owe it to him.
