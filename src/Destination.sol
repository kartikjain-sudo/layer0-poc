// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import { OAppReceiver, Origin } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppReceiver.sol";
import { OAppCore } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppCore.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @notice THIS IS AN EXAMPLE CONTRACT. DO NOT USE THIS CODE IN PRODUCTION.
 */

contract DestinationOApp is OAppReceiver {

    string public data = "Nothing received yet";  // Our data, in this case a string.

    
    /// @notice Emitted when a message is received through _lzReceive.
    /// @param message The content of the received message.
    /// @param senderEid What LayerZero Endpoint sent the message.
    /// @param sender The sending OApp's address.
    event MessageReceived(string message, uint32 senderEid, bytes32 sender);

    /**
     * @notice Initializes the OApp with the source chain's endpoint address.
     * @param _endpoint The endpoint address.
     * @param _owner The OApp child contract owner.
     */
    constructor(address _endpoint, address _owner) OAppCore(_endpoint, _owner) Ownable(msg.sender) onlyOwner() {}
    
    /**
     * @dev Called when data is received from the protocol. It overrides the equivalent function in the parent contract.
     * Protocol messages are defined as packets, comprised of the following parameters.
     * @param _origin A struct containing information about where the packet came from.
     * @param _guid A global unique identifier for tracking the packet.
     * @param payload Encoded message.
     */
    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address,  // Executor address as specified by the OApp.
        bytes calldata  // Any extra data or options to trigger on receipt.
    ) internal override {
        // Decode the payload to get the message
        data = abi.decode(payload, (string));
        // Extract the sender's EID from the origin
        uint32 senderEid = _origin.srcEid;
        bytes32 sender = _origin.sender;
        // Emit the event with the decoded message and sender's EID
        emit MessageReceived(data, senderEid, sender);
    }
}

// 0x740b3c169690c8f28206DAd17904e930231Df5Ba # BNB

// Trial 2
// ERC20 0x0ba51eB3dFf2ec198a46E88950775212db65f318 "Gold Binance" "GLDB"