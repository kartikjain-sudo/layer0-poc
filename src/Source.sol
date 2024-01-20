// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {OAppSender, MessagingFee } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppSender.sol";
import { OAppCore } from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OAppCore.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @notice THIS IS AN EXAMPLE CONTRACT. DO NOT USE THIS CODE IN PRODUCTION.
 */

contract SourceOApp is OAppSender {

     event MessageSent(string message, uint32 dstEid);

    /**
     * @notice Initializes the OApp with the source chain's endpoint address.
     * @param _endpoint The endpoint address.
     * @param _owner The OApp child contract owner.
     */
    constructor(address _endpoint, address _owner) OAppCore(_endpoint, _owner) Ownable(msg.sender) onlyOwner() {}

    /**
     * @notice Quotes the gas needed to pay for the full omnichain transaction in native gas or ZRO token.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _message The message.
     * @param _options Message execution options (e.g., for sending gas to destination).
     * @param _payInLzToken Whether to return fee in ZRO token.
     */
    function quote(
        uint32 _dstEid,
        string memory _message,
        bytes memory _options,
        bool _payInLzToken
    ) public view returns (MessagingFee memory fee) {
        bytes memory payload = abi.encode(_message);
        fee = _quote(_dstEid, payload, _options, _payInLzToken);
    }

    /**
     * @notice Sends a message from the source to destination chain.
     * @param _dstEid Destination chain's endpoint ID.
     * @param _message The message to send.
     * @param _options Message execution options (e.g., for sending gas to destination).
     */
    function send(
        uint32 _dstEid,
        string memory _message,
        bytes calldata _options
    ) external payable {
        // Encodes the message before invoking _lzSend.
        bytes memory _payload = abi.encode(_message);
        _lzSend(
            _dstEid,
            _payload,
            _options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender) 
        );

        emit MessageSent(_message, _dstEid);
    }
}


// Trial 1
// 0x669e93F08f9a099b277Eb4E36dc12DB37Cf5aB24 # MATIC

// Trial 2 Matic
// ERC20 0x740b3c169690c8f28206DAd17904e930231Df5Ba "Gold Matic" "GLDM"





// bytes memory payload = abi.encodePacked(msg.sender, quantity);

// address from;
//         uint256 quantity;

//         if(_payload.length != 52){
//             revert InvalidLZPayload();
//         }

//         assembly {
//             from := mload(add(_payload, 20))
//             quantity := mload(add(_payload, 52))
//         }

//         _mint(from, quantity);


// contract test {

//     function ax(address a, address b, uint256 c) public pure returns (bytes memory) {
//         return abi.encode(a,b,c);
//     }

//     // function dec(bytes memory payload) public pure returns(uint256) {
//     //     (address a, address b, uint256 c) = abi.decode(payload, (address, address, uint256));
//     //     console.log(a, b, c);
//     //     return c;
//     // }

//     function decodeAx(bytes memory encodedData) public pure returns (address, address, uint256) {
//         // require(encodedData.length == 84, "Invalid encoded data length");

//         address param1;
//         address param2;
//         uint256 param3;

//         assembly {
//             // Skip the first 32 bytes (length of the dynamic part)
//             let dataPtr := add(encodedData, 0x20)

//             // Load the first address (param1)
//             param1 := mload(dataPtr)

//             // Move the pointer to the next 32 bytes
//             dataPtr := add(dataPtr, 0x20)

//             // Load the second address (param2)
//             param2 := mload(dataPtr)

//             // Move the pointer to the next 32 bytes
//             dataPtr := add(dataPtr, 0x20)

//             // Load the uint256 (param3)
//             param3 := mload(dataPtr)
//         }

//         return (param1, param2, param3);
//     }
// }
