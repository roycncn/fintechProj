const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("HouseNFT.sol", () => {
    let houseContractFactory;
    let contract;
    let owner;
    let alice;
    let bob;
    let initialSupply;
    let ownerAddress;
    let aliceAddress;
    let bobAddress;

    beforeEach(async () => {
        [owner, alice, bob] = await ethers.getSigners();
        ownerAddress = await owner.getAddress();
        aliceAddress = await alice.getAddress();
        bobAddress = await bob.getAddress();
        houseContractFactory = await ethers.getContractFactory("HouseToken");
        houseNFT = await houseContractFactory.deploy("DEMO BUILDING","HK001");

    });

    describe("Correct setup", () => {
        it("should be named 'DEMO BUILDING", async () => {
            const name = await houseNFT.name();
            expect(name).to.equal("DEMO BUILDING");
        });
    });

    // describe("Core", () => {
    //     it("owner should transfer to Alice and update balances", async () => {
    //         const transferAmount = ethers.utils.parseEther("1000");
    //         let aliceBalance = await contract.balanceOf(aliceAddress);
    //         expect(aliceBalance).to.equal(0);
    //         await contract.transfer(aliceAddress,transferAmount);
    //         aliceBalance = await contract.balanceOf(aliceAddress);
    //         expect(aliceBalance).to.equal(transferAmount);
    //     });
    //     it("owner should transfer to Alice and Alice to Bob", async () => {
    //         const transferAmount = ethers.utils.parseEther("1000");
    //         await contract.transfer(aliceAddress,transferAmount); // contract is connected to the owner.
    //         let bobBalance = await contract.balanceOf(bobAddress);
    //         expect(bobBalance).to.equal(0);
    //         await contract.connect(alice).transfer(bobAddress,transferAmount);
    //         bobBalance = await contract.balanceOf(bobAddress);
    //         expect(bobBalance).to.equal(transferAmount);
    //     });
    //     it("should fail by depositing more than current balance", async () => {
    //         const txFailure = initialSupply + 1;
    //         await expect(contract.transfer(aliceAddress,txFailure)).to.be.revertedWith("ERC20: transfer amount exceeds balance");
    //     });
    // });


});