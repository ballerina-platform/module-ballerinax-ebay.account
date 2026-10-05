// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Sets up the business policies (fulfillment, payment and return) of an eBay seller account
// for a marketplace. Existing policies are listed first, and a policy is created only when
// one with the configured name does not exist yet.

import ballerina/io;
import ballerinax/ebay.account;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string marketplaceId = ?;
configurable string policyNamePrefix = ?;
configurable boolean createPolicies = false;

public function main() returns error? {
    account:Client ebay = check new ({
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            refreshUrl
        }
    });

    account:CategoryType[] categoryTypes = [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}];
    string fulfillmentName = policyNamePrefix + " fulfillment";
    string paymentName = policyNamePrefix + " payment";
    string returnName = policyNamePrefix + " returns";

    // Step 1: List the existing business policies of the marketplace
    account:FulfillmentPolicyResponse fulfillmentPolicies = check ebay->getFulfillmentPolicies(marketplaceId = marketplaceId);
    account:PaymentPolicyResponse paymentPolicies = check ebay->getPaymentPolicies(marketplaceId = marketplaceId);
    account:ReturnPolicyResponse returnPolicies = check ebay->getReturnPolicies(marketplaceId = marketplaceId);

    account:FulfillmentPolicy[] existingFulfillment = fulfillmentPolicies?.fulfillmentPolicies ?: [];
    account:PaymentPolicy[] existingPayment = paymentPolicies?.paymentPolicies ?: [];
    account:ReturnPolicy[] existingReturn = returnPolicies?.returnPolicies ?: [];
    io:println(string `Found ${existingFulfillment.length()} fulfillment, ${existingPayment.length()} payment and ${existingReturn.length()} return policies in ${marketplaceId}`);

    if !createPolicies {
        io:println("createPolicies is false, so no policy is created");
        return;
    }

    // The fulfillment policy below ships with USPS, which is valid only on the US marketplace
    if marketplaceId != "EBAY_US" {
        return error(string `Policy creation is supported only for EBAY_US, not ${marketplaceId}`);
    }

    // Step 2: Create the fulfillment policy when it does not exist
    boolean hasFulfillment = existingFulfillment.some(policy => policy?.name == fulfillmentName);
    if hasFulfillment {
        io:println(string `Fulfillment policy "${fulfillmentName}" already exists`);
    } else {
        account:SetFulfillmentPolicyResponse created = check ebay->createFulfillmentPolicy({contentType: "application/json"}, {
            name: fulfillmentName,
            marketplaceId,
            categoryTypes,
            handlingTime: {unit: "DAY", value: 1},
            shippingOptions: [
                {
                    optionType: "DOMESTIC",
                    costType: "FLAT_RATE",
                    shippingServices: [
                        {
                            sortOrder: 1,
                            shippingCarrierCode: "USPS",
                            shippingServiceCode: "USPSPriority",
                            freeShipping: true
                        }
                    ]
                }
            ]
        });
        io:println(string `Created fulfillment policy ${created?.fulfillmentPolicyId ?: "<unknown>"}`);
    }

    // Step 3: Create the payment policy when it does not exist
    boolean hasPayment = existingPayment.some(policy => policy?.name == paymentName);
    if hasPayment {
        io:println(string `Payment policy "${paymentName}" already exists`);
    } else {
        account:SetPaymentPolicyResponse created = check ebay->createPaymentPolicy({contentType: "application/json"}, {
            name: paymentName,
            marketplaceId,
            categoryTypes,
            immediatePay: true
        });
        io:println(string `Created payment policy ${created?.paymentPolicyId ?: "<unknown>"}`);
    }

    // Step 4: Create the return policy when it does not exist
    boolean hasReturn = existingReturn.some(policy => policy?.name == returnName);
    if hasReturn {
        io:println(string `Return policy "${returnName}" already exists`);
    } else {
        account:SetReturnPolicyResponse created = check ebay->createReturnPolicy({contentType: "application/json"}, {
            name: returnName,
            marketplaceId,
            categoryTypes,
            returnsAccepted: true,
            returnPeriod: {unit: "DAY", value: 30},
            refundMethod: "MONEY_BACK",
            returnShippingCostPayer: "BUYER"
        });
        io:println(string `Created return policy ${created?.returnPolicyId ?: "<unknown>"}`);
    }
}
