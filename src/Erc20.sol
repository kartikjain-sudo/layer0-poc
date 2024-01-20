// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
    }

    function mint(address _address, uint256 amount) external {
        _mint(_address, amount);
    }
}