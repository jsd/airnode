// SPDX-License-Identifier: MIT
pragma solidity 0.6.8;
pragma experimental ABIEncoderV2;

import "./interfaces/ITemplateStore.sol";


/// @title The contract where request templates are stored
/// @notice Most requests are repeated many times with the same parameters.
/// This contract allows the requester to announce their parameters once, then
/// refer to that announcement when they are making a request, instead of
/// passing the same parameters repeatedly.
/// @dev A template is composed of two groups of parameters. The first group is
/// requester-agnostic (providerId, endpointInd, parameters), while the second
/// group is requester-specific (requesterInd, designatedWallet, fulfillAddress,
/// errorAddress, fulfillFunctionId, errorFunctionId). Short requests refer to
/// a template and use both of these groups of parameters. Regular requests
/// refer to a template, but only use the requester-agnostic parameters of it,
/// and require the client to provide the requester-specific parameters. In
/// addition, both regular and short requests can overwrite parameters encoded
/// in the parameters field of the template at request-time. See Airnode.sol
/// for more information (specifically makeShortRequest() and makeRequest()).
contract TemplateStore is ITemplateStore {
    mapping(bytes32 => Template) internal templates;


    /// @notice Creates a request template with the given parameters,
    /// addressable by the ID it returns
    /// @dev A specific set of request parameters will always have
    /// the same ID. This means a few things: (1) You can compute the expected
    /// ID of a set of parameters off-chain, (2) creating a new template with
    /// the same parameters will overwrite the old one and return the same
    /// template ID, (3) after you query a template with its ID, you can verify
    /// its integrity by applying the hash and comparing the result with the
    /// ID.
    /// @param providerId Provider ID from ProviderStore
    /// @param endpointId Endpoint ID from EndpointStore
    /// @param requesterInd Requester index from RequesterStore
    /// @param designatedWallet Designated wallet that is requested to fulfill
    /// the request
    /// @param fulfillAddress Address that will be called to fulfill
    /// @param errorAddress Address that will be called to error
    /// @param fulfillFunctionId Signature of the function that will be called
    /// to fulfill
    /// @param errorFunctionId Signature of the function that will be called
    /// to error
    /// @param parameters Static request parameters (i.e., parameters that will
    /// not change between requests, unlike the dynamic parameters determined
    /// at runtime)
    /// @return templateId Request template ID
    function createTemplate(
        bytes32 providerId,
        bytes32 endpointId,
        uint256 requesterInd,
        address designatedWallet,
        address fulfillAddress,
        address errorAddress,
        bytes4 fulfillFunctionId,
        bytes4 errorFunctionId,
        bytes calldata parameters
        )
        external
        override
        returns (bytes32 templateId)
    {
        templateId = keccak256(abi.encodePacked(
            providerId,
            endpointId,
            requesterInd,
            designatedWallet,
            fulfillAddress,
            errorAddress,
            fulfillFunctionId,
            errorFunctionId,
            parameters
            ));
        templates[templateId] = Template({
            providerId: providerId,
            endpointId: endpointId,
            requesterInd: requesterInd,
            designatedWallet: designatedWallet,
            fulfillAddress: fulfillAddress,
            errorAddress: errorAddress,
            fulfillFunctionId: fulfillFunctionId,
            errorFunctionId: errorFunctionId,
            parameters: parameters
        });
        emit TemplateCreated(
          templateId,
          providerId,
          endpointId,
          requesterInd,
          designatedWallet,
          fulfillAddress,
          errorAddress,
          fulfillFunctionId,
          errorFunctionId,
          parameters
          );
    }

    /// @notice Retrieves the request template addressed by the ID
    /// @param templateId Request template ID
    /// @return template Request template
    function getTemplate(bytes32 templateId)
        external
        view
        override
        returns (Template memory template)
    {
        template = templates[templateId];
    }
}
