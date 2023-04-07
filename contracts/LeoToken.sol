//deploying my first ERC20 token

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

//importing directly from github as we are on remix:
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// mint 100M tokens, send 70% to the contract owner
// Make token burnable

contract LeoToken is ERC20Capped, ERC20Burnable {
    address payable public owner;

    constructor(
        uint256 cap
    ) ERC20("LeoToken", "LEO") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals()));
    }

    // copy paste _mint() from node_modules>openzeppelin/contracts>token>ERC20Capped
    function _mint(
        address account,
        uint256 amount
    ) internal virtual override(ERC20, ERC20Capped) {
        require(
            ERC20.totalSupply() + amount <= cap(),
            "ERC20Capped: cap exceeded"
        );
        super._mint(account, amount);
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only the Owner can call this function");
        _;
    }
}
