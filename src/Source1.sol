// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {OAppSender, MessagingFee } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppSender.sol";
import { OAppCore } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppCore.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function balanceOf(address) external view returns(uint256);
}

contract bal {

    function check(address _add) public view returns(uint256) {
        return IERC20(_add).balanceOf(msg.sender);
    }

    function encode() public view returns(bytes memory) {
        return abi.encode(123456789, 9876543210, msg.sender);
    }

    function decode(bytes memory _payload) public pure returns(uint256, uint256, address) {
        (uint256 a, uint256 b, address c) = abi.decode(_payload, (uint256, uint256, address));
        return (b, a, c);
    }

    function addressToBytes32(address inputAddress) public pure returns (bytes32) {
        return bytes32(uint256(uint160(inputAddress)));
    }
    
    function getAddressBytes32() public pure returns (bytes32) {
        return addressToBytes32(0xA3e65eB64FE6d20B9FD22720524EB1FFA2D6dF10);
    }
}

/**
 * @notice THIS IS AN EXAMPLE CONTRACT. DO NOT USE THIS CODE IN PRODUCTION.
 */

contract SourceOApp is OAppSender {

     event MessageSent(bytes message, uint32 dstEid);

    /**
     * @notice Initializes the OApp with the source chain's endpoint address.
     * @param _endpoint The endpoint address.
     * @param _owner The OApp child contract owner.
     */
    constructor(address _endpoint, address _owner) OAppCore(_endpoint, _owner) Ownable(msg.sender) onlyOwner() {}

    /**
     * @notice Quotes the gas needed to pay for the full omnichain transaction in native gas or ZRO token.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _amount The message.
     * @param _options Message execution options (e.g., for sending gas to destination).
     * @param _payInLzToken Whether to return fee in ZRO token.
     */
    function quote(
        uint32 _dstEid,
        uint256 _amount,
        bytes memory _options,
        bool _payInLzToken
    ) public view returns (MessagingFee memory fee) {
        uint256 balance = IERC20(0x740b3c169690c8f28206DAd17904e930231Df5Ba).balanceOf(msg.sender);
        bytes memory payload = abi.encode(balance, _amount, msg.sender);
        fee = _quote(_dstEid, payload, _options, _payInLzToken);
    }

    /**
     * @notice Sends a message from the source to destination chain.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _amount The amount to mint.
     * @param _options Message execution options (e.g., for sending gas to destination).
     */
    function send(
        uint32 _dstEid,
        uint256 _amount,
        bytes calldata _options
    ) external payable {
        // Encodes the message before invoking _lzSend.
        uint256 balance = IERC20(0x740b3c169690c8f28206DAd17904e930231Df5Ba).balanceOf(msg.sender);
        bytes memory _payload = abi.encode(balance, _amount, msg.sender);
        _lzSend(
            _dstEid,
            _payload,
            _options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender) 
        );

        emit MessageSent(_payload, _dstEid);
    }
}

// Trial 2 Matic
// ERC20 0x740b3c169690c8f28206DAd17904e930231Df5Ba "Gold Matic" "GLDM"
// source 0x285140A7D5EeB47D0373f3A06032077fcbD92903  # 0x4C80D888674e71DB5a044908f981C22ae77881B8
// options: 0x00030100110100000000000000000000000000030d40
// endpoint: 0x464570adA09869d8741132183721B4f0769a0287
// id matic: 40109

// https://testnet.layerzeroscan.com/address/0x50822c1dffc99f9bed08fb70c187949d5bdcea83


// Trial 3 BNB
// source 0x285140A7D5EeB47D0373f3A06032077fcbD92903
