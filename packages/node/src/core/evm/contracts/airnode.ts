import { ethers } from 'ethers';
import compiledContract from './json/airnode.json';
import { Contract } from './types';

const ApiCallRequestTopic = ethers.utils.id(
  'ClientRequestCreated(bytes32,bytes32,uint256,address,bytes32,uint256,address,address,bytes4,bytes)'
);
const ApiCallShortRequestTopic = ethers.utils.id(
  'ClientShortRequestCreated(bytes32,bytes32,uint256,address,bytes32,bytes)'
);
const ApiCallFullRequestTopic = ethers.utils.id(
  'ClientFullRequestCreated(bytes32,bytes32,uint256,address,bytes32,uint256,address,address,bytes4,bytes)'
);

const ApiCallFulfilledTopic = ethers.utils.id('ClientRequestFulfilled(bytes32,bytes32,uint256,bytes32)');
const ApiCallFulfilledBytesTopic = ethers.utils.id('ClientRequestFulfilledWithBytes(bytes32,bytes32,uint256,bytes)');
const ApiCallFulfilledFailedTopic = ethers.utils.id('ClientRequestFailed(bytes32,bytes32)');

const WithdrawalRequestedTopic = ethers.utils.id('WithdrawalRequested(bytes32,bytes32,bytes32,address)');
const WithdrawalFulfilledTopic = ethers.utils.id('WithdrawalFulfilled(bytes32,bytes32,bytes32,address,uint256)');

export const Airnode: Contract = {
  addresses: {
    1: '<TODO>',
    3: '<TODO>',
    1337: '0xe60b966B798f9a0C41724f111225A5586ff30656',
  },
  ABI: compiledContract.abi,
  topics: {
    // API calls
    ApiCallRequest: ApiCallRequestTopic,
    ApiCallShortRequest: ApiCallShortRequestTopic,
    ApiCallFullRequest: ApiCallFullRequestTopic,

    ApiCallFulfilled: ApiCallFulfilledTopic,
    ApiCallFulfilledBytes: ApiCallFulfilledBytesTopic,
    ApiCallFailed: ApiCallFulfilledFailedTopic,

    // Withdrawals
    WithdrawalRequested: WithdrawalRequestedTopic,
    WithdrawalFulfilled: WithdrawalFulfilledTopic,
  },
};
