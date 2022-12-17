/* global describe it before ethers */

const {
  getSelectors,
  FacetCutAction,
  removeSelectors,
} = require('../scripts/libraries/diamond.js');

const { deployDiamond } = require('../scripts/deploy.js');

const { assert, expect } = require('chai');
const { ethers } = require('hardhat');

describe('DiamondTest', async function () {
  let diamondAddress;
  let diamondCutFacet;
  let diamondLoupeFacet;
  let ownershipFacet;
  let tx;
  let receipt;
  let result;
  const addresses = [];
  let signers;

  before(async function () {
    diamondAddress = await deployDiamond();
    diamondCutFacet = await ethers.getContractAt(
      'DiamondCutFacet',
      diamondAddress
    );
    diamondLoupeFacet = await ethers.getContractAt(
      'DiamondLoupeFacet',
      diamondAddress
    );
    ownershipFacet = await ethers.getContractAt('OwnableFacet', diamondAddress);

    signers = await ethers.getSigners();
  });

  it('should allow minting from the allowlist, and block transferring to the blocklist', async () => {
    const ownerSigner = signers[0];
    const otherSigner = signers[1];
    const allowlistMintFacet = await ethers.getContractAt(
      'AllowlistMintFacet',
      diamondAddress
    );

    await allowlistMintFacet.setIsAllowlisted(ownerSigner.address, true);

    const isOnAllowlist = await allowlistMintFacet.isAllowlisted(
      ownerSigner.address
    );
    expect(isOnAllowlist).to.equal(true);

    await allowlistMintFacet.mint(ownerSigner.address, 1);

    const nftFacet = await ethers.getContractAt(
      'TransferBlocklistNFTFacet',
      diamondAddress
    );

    const owner = await nftFacet.ownerOf(1);

    expect(owner).to.equal(ownerSigner.address);

    await nftFacet.setIsBlocked(otherSigner.address, true);

    const isBlocked = await nftFacet.isBlocked(otherSigner.address);

    expect(isBlocked).to.equal(true);

    await expect(
      nftFacet.transferFrom(ownerSigner.address, otherSigner.address, 1)
    ).to.be.reverted;

    await nftFacet.transferFrom(ownerSigner.address, signers[2].address, 1);
    const newOwner = await nftFacet.ownerOf(1);

    expect(newOwner).to.equal(signers[2].address);
  });

  it('should have five facets -- call to facetAddresses function', async () => {
    for (const address of await diamondLoupeFacet.facetAddresses()) {
      addresses.push(address);
    }

    assert.equal(addresses.length, 5);
  });

  it('facets should have the right function selectors -- call to facetFunctionSelectors function', async () => {
    let selectors = getSelectors(diamondCutFacet);
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[0]);
    assert.sameMembers(result, selectors);
    selectors = getSelectors(diamondLoupeFacet);
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[1]);
    assert.sameMembers(result, selectors);
    selectors = getSelectors(ownershipFacet);
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[2]);
    assert.sameMembers(result, selectors);
  });

  it('selectors should be associated to facets correctly -- multiple calls to facetAddress function', async () => {
    assert.equal(
      addresses[0],
      await diamondLoupeFacet.facetAddress('0x1f931c1c')
    );
    assert.equal(
      addresses[1],
      await diamondLoupeFacet.facetAddress('0xcdffacc6')
    );
    assert.equal(
      addresses[1],
      await diamondLoupeFacet.facetAddress('0x01ffc9a7')
    );
    assert.equal(
      addresses[2],
      await diamondLoupeFacet.facetAddress('0xf2fde38b')
    );
  });

  it('should add test1 functions', async () => {
    const Test1Facet = await ethers.getContractFactory('Test1Facet');
    const test1Facet = await Test1Facet.deploy();
    await test1Facet.deployed();
    addresses.push(test1Facet.address);
    const selectors = getSelectors(test1Facet).remove([
      'supportsInterface(bytes4)',
    ]);
    tx = await diamondCutFacet.diamondCut(
      [
        {
          facetAddress: test1Facet.address,
          action: FacetCutAction.Add,
          functionSelectors: selectors,
        },
      ],
      ethers.constants.AddressZero,
      '0x',
      { gasLimit: 800000 }
    );
    receipt = await tx.wait();
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    result = await diamondLoupeFacet.facetFunctionSelectors(test1Facet.address);
    assert.sameMembers(result, selectors);
  });

  it('should test function call', async () => {
    const test1Facet = await ethers.getContractAt('Test1Facet', diamondAddress);
    await test1Facet.test1Func10();
  });

  it('should replace supportsInterface function', async () => {
    const Test1Facet = await ethers.getContractFactory('Test1Facet');
    const selectors = getSelectors(Test1Facet).get([
      'supportsInterface(bytes4)',
    ]);
    const testFacetAddress = addresses[5];
    tx = await diamondCutFacet.diamondCut(
      [
        {
          facetAddress: testFacetAddress,
          action: FacetCutAction.Replace,
          functionSelectors: selectors,
        },
      ],
      ethers.constants.AddressZero,
      '0x',
      { gasLimit: 800000 }
    );
    receipt = await tx.wait();
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    result = await diamondLoupeFacet.facetFunctionSelectors(testFacetAddress);
    assert.sameMembers(result, getSelectors(Test1Facet));
  });

  it('should add test2 functions', async () => {
    const Test2Facet = await ethers.getContractFactory('Test2Facet');
    const test2Facet = await Test2Facet.deploy();
    await test2Facet.deployed();
    addresses.push(test2Facet.address);
    const selectors = getSelectors(test2Facet);
    tx = await diamondCutFacet.diamondCut(
      [
        {
          facetAddress: test2Facet.address,
          action: FacetCutAction.Add,
          functionSelectors: selectors,
        },
      ],
      ethers.constants.AddressZero,
      '0x',
      { gasLimit: 800000 }
    );
    receipt = await tx.wait();
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    result = await diamondLoupeFacet.facetFunctionSelectors(test2Facet.address);
    assert.sameMembers(result, selectors);
  });

  it('should remove some test2 functions', async () => {
    const test2Facet = await ethers.getContractAt('Test2Facet', diamondAddress);
    const functionsToKeep = [
      'test2Func1()',
      'test2Func5()',
      'test2Func6()',
      'test2Func19()',
      'test2Func20()',
    ];
    const selectors = getSelectors(test2Facet).remove(functionsToKeep);
    tx = await diamondCutFacet.diamondCut(
      [
        {
          facetAddress: ethers.constants.AddressZero,
          action: FacetCutAction.Remove,
          functionSelectors: selectors,
        },
      ],
      ethers.constants.AddressZero,
      '0x',
      { gasLimit: 800000 }
    );
    receipt = await tx.wait();
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[6]);
    assert.sameMembers(result, getSelectors(test2Facet).get(functionsToKeep));
  });

  it('should remove some test1 functions', async () => {
    const test1Facet = await ethers.getContractAt('Test1Facet', diamondAddress);
    const functionsToKeep = ['test1Func2()', 'test1Func11()', 'test1Func12()'];
    const selectors = getSelectors(test1Facet).remove(functionsToKeep);
    tx = await diamondCutFacet.diamondCut(
      [
        {
          facetAddress: ethers.constants.AddressZero,
          action: FacetCutAction.Remove,
          functionSelectors: selectors,
        },
      ],
      ethers.constants.AddressZero,
      '0x',
      { gasLimit: 800000 }
    );
    receipt = await tx.wait();
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    result = await diamondLoupeFacet.facetFunctionSelectors(addresses[5]);
    assert.sameMembers(result, getSelectors(test1Facet).get(functionsToKeep));
  });

  it("remove all functions and facets except 'diamondCut' and 'facets'", async () => {
    let selectors = [];
    let facets = await diamondLoupeFacet.facets();
    for (let i = 0; i < facets.length; i++) {
      selectors.push(...facets[i].functionSelectors);
    }
    selectors = removeSelectors(selectors, [
      'facets()',
      'diamondCut(tuple(address,uint8,bytes4[])[],address,bytes)',
    ]);
    tx = await diamondCutFacet.diamondCut(
      [
        {
          facetAddress: ethers.constants.AddressZero,
          action: FacetCutAction.Remove,
          functionSelectors: selectors,
        },
      ],
      ethers.constants.AddressZero,
      '0x',
      { gasLimit: 800000 }
    );
    receipt = await tx.wait();
    if (!receipt.status) {
      throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    facets = await diamondLoupeFacet.facets();
    assert.equal(facets.length, 2);
    assert.equal(facets[0][0], addresses[0]);
    assert.sameMembers(facets[0][1], ['0x1f931c1c']);
    assert.equal(facets[1][0], addresses[1]);
    assert.sameMembers(facets[1][1], ['0x7a0ed627']);
  });
});
