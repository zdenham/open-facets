# Open Facets POC

This is a proof of concept of what a smart contract development library for EIP-2535 diamonds could look like, using ERC721 as an example.

The "contracts/example" directory includes what an implementation using the library could look like. The example shows an ERC721 with an allowlist gated mint, and special functionality that prevents transferring tokens to blocked addresses. This example was chosen to showcase both inheritance and composability with the library. I summarize some of the design choices below, but would love to hear critiques of the layout.

## Design Choices / Features / Rationale

### Facet Folders

Because we break facets down into various parts (handlers, logic, storage, modifiers, interfaces), it constitutes having a separate folder for each facet rather than just a single file.

### Storage Libraries

Diamond storage is used in this implementation, but storage is also kept in its own library with no other logic. This convention is useful because changes to the storage library can be treated separately and with more care than logic changes, sort of analogous to a migrations directory in a web server codebase.


### Logic Libraries

All business logic goes in libraries with internal functions. This is important as diamond codebases grow, because multiple facets can share the same library functions with merely a `JUMP` operator, more info on sharing functionality [here](https://eip2535diamonds.substack.com/p/how-to-share-functions-between-facets?s=w). In my experience, this becomes a huge DRY win over time. **Note** By keeping all business logic in libraries, you also potentially future proof your facets if pure library facets become the norm.


### Lightweight External Facet Contracts

With the exception of modifiers, the facet contracts have no logic, they simply make calls to underlying logic libraries. 

If they don't do anything meaningful, then why have contract facets at all? **Why not just library facets?** So glad you asked:

- Inheritance. If implementers need to override functionality in a standard contract, in many cases inheritance is still the cleanest way to do it. Libraries can't inherit. You can see an example of the inheritance use case in the `TransferBlocklistNFT` which inherits ERC721 and overrides transfer functionality.
- ABI. The abi that is generated for libraries is different than contracts. As a result, many popular off chain tools such as typechain, hardhat, etc... do not behave as you might expect with things like events and function signatures that encode struct arguments.
- Shareable modifiers (See below)

### Portable Modifiers

I like modifiers a lot for concise access control checks, but because solidity libraries don't have inheritance, its not possible to share modifiers between libraries. As such, we declare separate shareable modifier contracts which can be shared amongst the lightweight facets, see "OwnableModifiers."

### Virtual External Facet Functions

Public function signatures are all virtual, meaning implementers can choose to inherit facets should they need to. This gives a good amount of choice (perhaps too much?) to the implementer. They can choose to deploy the entire facet & turn off specific functions via diamond cut, or inherit and modify the facets.

## Small Logic Functions

I've found breaking the logic facets down into very small, granular functions is useful for code reusability / composability across facets, and tends to be good programming practice in general.

### Duplicate Event Declarations

Unfortunately, events (and custom errors) declared / emitted in libraries do not show up in the calling contract's ABI. There are a few [issues](https://github.com/ethereum/solidity/issues/9765) about this in the solidity language repo.

To get events to show up properly in the ABI, we redeclare events both in the library and the contract. To make the event declarations shareable between contract facets, it may be worth breaking them into a separate IFacetEvents interface, but there is no getting around redeclaring them in the library at this point.

