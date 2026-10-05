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

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.ebay.com/sell/account/v1" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("EBAY_ACCESS_TOKEN") : "test_token";
final string marketplaceId = "EBAY_US";
final string jsonContentType = "application/json";

final Client ebay = check new ({
    auth: {token},
    httpVersion: isLiveServer ? http:HTTP_2_0 : http:HTTP_1_1
}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetCustomPolicies() returns error? {
    CustomPolicyResponse response = check ebay->getCustomPolicies(policyTypes = "PRODUCT_COMPLIANCE");
    test:assertTrue(response?.customPolicies is CompactCustomPolicyResponse[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateCustomPolicy() returns error? {
    if isLiveServer {
        return;
    }
    record {} response = check ebay->createCustomPolicy({contentType: jsonContentType}, {
        policyType: "PRODUCT_COMPLIANCE",
        name: "Battery safety",
        label: "Product Compliance",
        description: "Contains lithium batteries; ship with care"
    });
    test:assertEquals(response, {});
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetCustomPolicy() returns error? {
    if isLiveServer {
        return;
    }
    CustomPolicy response = check ebay->getCustomPolicy("551111000");
    test:assertEquals(response?.customPolicyId, "551111000");
    test:assertEquals(response?.policyType, "PRODUCT_COMPLIANCE");
}

@test:Config {groups: ["mock_tests"]}
isolated function testUpdateCustomPolicy() returns error? {
    if isLiveServer {
        return;
    }
    error? response = ebay->updateCustomPolicy("551111000", {contentType: jsonContentType}, {
        name: "Battery safety",
        label: "Product Compliance",
        description: "Updated description"
    });
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetFulfillmentPolicies() returns error? {
    FulfillmentPolicyResponse response = check ebay->getFulfillmentPolicies(marketplaceId = marketplaceId);
    test:assertTrue(response?.fulfillmentPolicies is FulfillmentPolicy[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateFulfillmentPolicy() returns error? {
    if isLiveServer {
        return;
    }
    SetFulfillmentPolicyResponse response = check ebay->createFulfillmentPolicy({contentType: jsonContentType}, {
        name: "Domestic free shipping",
        marketplaceId,
        categoryTypes: [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}],
        handlingTime: {unit: "DAY", value: 1}
    });
    test:assertEquals(response?.fulfillmentPolicyId, "6196932001");
    test:assertEquals(response?.name, "Domestic free shipping");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetFulfillmentPolicy() returns error? {
    if isLiveServer {
        return;
    }
    FulfillmentPolicy response = check ebay->getFulfillmentPolicy("6196932000");
    test:assertEquals(response?.fulfillmentPolicyId, "6196932000");
    test:assertEquals(response?.marketplaceId, "EBAY_US");
}

@test:Config {groups: ["mock_tests"]}
isolated function testUpdateFulfillmentPolicy() returns error? {
    if isLiveServer {
        return;
    }
    SetFulfillmentPolicyResponse response = check ebay->updateFulfillmentPolicy("6196932000", {contentType: jsonContentType}, {
        name: "Domestic flat rate",
        marketplaceId,
        categoryTypes: [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}]
    });
    test:assertEquals(response?.fulfillmentPolicyId, "6196932000");
    test:assertEquals(response?.name, "Domestic flat rate");
}

@test:Config {groups: ["mock_tests"]}
isolated function testDeleteFulfillmentPolicy() returns error? {
    if isLiveServer {
        return;
    }
    SetFulfillmentPolicyResponse created = check ebay->createFulfillmentPolicy({contentType: jsonContentType}, {
        name: "Policy to delete",
        marketplaceId,
        categoryTypes: [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}]
    });
    string policyId = created?.fulfillmentPolicyId ?: "";
    test:assertNotEquals(policyId, "");
    error? response = ebay->deleteFulfillmentPolicy(policyId);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetFulfillmentPolicyByName() returns error? {
    if isLiveServer {
        return;
    }
    FulfillmentPolicy response = check ebay->getFulfillmentPolicyByName(marketplaceId = marketplaceId, name = "Domestic free shipping");
    test:assertEquals(response?.name, "Domestic free shipping");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPaymentPolicies() returns error? {
    PaymentPolicyResponse response = check ebay->getPaymentPolicies(marketplaceId = marketplaceId);
    test:assertTrue(response?.paymentPolicies is PaymentPolicy[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreatePaymentPolicy() returns error? {
    if isLiveServer {
        return;
    }
    SetPaymentPolicyResponse response = check ebay->createPaymentPolicy({contentType: jsonContentType}, {
        name: "Immediate payment",
        marketplaceId,
        categoryTypes: [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}],
        immediatePay: true
    });
    test:assertEquals(response?.paymentPolicyId, "6196933001");
    test:assertEquals(response?.immediatePay, true);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPaymentPolicy() returns error? {
    if isLiveServer {
        return;
    }
    PaymentPolicy response = check ebay->getPaymentPolicy("6196933000");
    test:assertEquals(response?.paymentPolicyId, "6196933000");
}

@test:Config {groups: ["mock_tests"]}
isolated function testDeletePaymentPolicy() returns error? {
    if isLiveServer {
        return;
    }
    SetPaymentPolicyResponse created = check ebay->createPaymentPolicy({contentType: jsonContentType}, {
        name: "Policy to delete",
        marketplaceId,
        categoryTypes: [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}]
    });
    string policyId = created?.paymentPolicyId ?: "";
    test:assertNotEquals(policyId, "");
    error? response = ebay->deletePaymentPolicy(policyId);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetReturnPolicies() returns error? {
    ReturnPolicyResponse response = check ebay->getReturnPolicies(marketplaceId = marketplaceId);
    test:assertTrue(response?.returnPolicies is ReturnPolicy[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateReturnPolicy() returns error? {
    if isLiveServer {
        return;
    }
    SetReturnPolicyResponse response = check ebay->createReturnPolicy({contentType: jsonContentType}, {
        name: "30 day returns",
        marketplaceId,
        categoryTypes: [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}],
        returnsAccepted: true,
        returnPeriod: {unit: "DAY", value: 30}
    });
    test:assertEquals(response?.returnPolicyId, "6196934001");
    test:assertEquals(response?.returnsAccepted, true);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetReturnPolicy() returns error? {
    if isLiveServer {
        return;
    }
    ReturnPolicy response = check ebay->getReturnPolicy("6196934000");
    test:assertEquals(response?.returnPolicyId, "6196934000");
}

@test:Config {groups: ["mock_tests"]}
isolated function testDeleteReturnPolicy() returns error? {
    if isLiveServer {
        return;
    }
    SetReturnPolicyResponse created = check ebay->createReturnPolicy({contentType: jsonContentType}, {
        name: "Policy to delete",
        marketplaceId,
        categoryTypes: [{name: "ALL_EXCLUDING_MOTORS_VEHICLES"}]
    });
    string policyId = created?.returnPolicyId ?: "";
    test:assertNotEquals(policyId, "");
    error? response = ebay->deleteReturnPolicy(policyId);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPrivileges() returns error? {
    SellingPrivileges response = check ebay->getPrivileges();
    test:assertTrue(response?.sellerRegistrationCompleted is boolean);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetOptedInPrograms() returns error? {
    Programs response = check ebay->getOptedInPrograms();
    test:assertTrue(response?.programs is Program[]);
}

@test:Config {groups: ["mock_tests"]}
isolated function testOptInToProgram() returns error? {
    if isLiveServer {
        return;
    }
    record {} response = check ebay->optInToProgram({contentType: jsonContentType}, {programType: "SELLING_POLICY_MANAGEMENT"});
    test:assertEquals(response, {});
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetRateTables() returns error? {
    RateTableResponse response = check ebay->getRateTables(countryCode = "US");
    test:assertTrue(response?.rateTables is RateTable[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSalesTaxes() returns error? {
    SalesTaxes response = check ebay->getSalesTaxes(countryCode = "US");
    test:assertTrue(response?.salesTaxes is SalesTax[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSalesTax() returns error? {
    if isLiveServer {
        return;
    }
    SalesTax? response = check ebay->getSalesTax("US", "GU");
    test:assertTrue(response is SalesTax);
    if response is SalesTax {
        test:assertEquals(response?.countryCode, "US");
        test:assertEquals(response?.salesTaxJurisdictionId, "GU");
    }
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateOrReplaceSalesTax() returns error? {
    if isLiveServer {
        return;
    }
    error? response = ebay->createOrReplaceSalesTax("US", "GU", {contentType: jsonContentType}, {
        salesTaxPercentage: "7.5",
        shippingAndHandlingTaxed: true
    });
    test:assertTrue(response is ());
}
