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

listener http:Listener ep0 = new (9090);

final TimeDuration & readonly mockDuration = {unit: "DAY", value: 30};

final Amount & readonly mockAmount = {currency: "USD", value: "5.00"};

final CategoryType[] & readonly mockCategoryTypes = [{name: "ALL_EXCLUDING_MOTORS_VEHICLES", default: true}];

final FulfillmentPolicy & readonly mockFulfillmentPolicy = {
    fulfillmentPolicyId: "6196932000",
    name: "Domestic free shipping",
    description: "Free standard shipping within the US",
    marketplaceId: "EBAY_US",
    categoryTypes: mockCategoryTypes,
    handlingTime: {unit: "DAY", value: 1},
    localPickup: false,
    pickupDropOff: false,
    globalShipping: false,
    freightShipping: false,
    shippingOptions: [
        {
            optionType: "DOMESTIC",
            costType: "FLAT_RATE",
            shippingServices: [
                {
                    sortOrder: 1,
                    shippingCarrierCode: "USPS",
                    shippingServiceCode: "USPSPriority",
                    freeShipping: true,
                    buyerResponsibleForShipping: false,
                    buyerResponsibleForPickup: false
                }
            ]
        }
    ],
    shipToLocations: {regionIncluded: [{regionName: "US", regionType: "COUNTRY"}]}
};

final PaymentPolicy & readonly mockPaymentPolicy = {
    paymentPolicyId: "6196933000",
    name: "Immediate payment",
    description: "Immediate payment required",
    marketplaceId: "EBAY_US",
    categoryTypes: mockCategoryTypes,
    immediatePay: true,
    paymentMethods: [{paymentMethodType: "PERSONAL_CHECK"}],
    fullPaymentDueIn: mockDuration
};

final ReturnPolicy & readonly mockReturnPolicy = {
    returnPolicyId: "6196934000",
    name: "30 day returns",
    description: "Returns accepted within 30 days",
    marketplaceId: "EBAY_US",
    categoryTypes: mockCategoryTypes,
    returnsAccepted: true,
    returnPeriod: mockDuration,
    refundMethod: "MONEY_BACK",
    returnMethod: "REPLACEMENT",
    returnShippingCostPayer: "BUYER",
    extendedHolidayReturnsOffered: false
};

final CustomPolicy & readonly mockCustomPolicy = {
    customPolicyId: "551111000",
    policyType: "PRODUCT_COMPLIANCE",
    name: "Battery safety",
    label: "Product Compliance",
    description: "Contains lithium batteries; ship with care"
};

final SalesTax & readonly mockSalesTax = {
    countryCode: "US",
    salesTaxJurisdictionId: "GU",
    salesTaxPercentage: "7.5",
    shippingAndHandlingTaxed: true
};

service / on ep0 {
    # Delete a fulfillment policy
    #
    # + fulfillmentPolicyId - The ID of the fulfillment policy to delete
    # + return - returns can be any of following types
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function delete fulfillment_policy/[string fulfillmentPolicyId]() returns http:NoContent|http:BadRequest|http:NotFound|http:Conflict|http:InternalServerError {
        return http:NO_CONTENT;
    }

    # Delete a payment policy
    #
    # + paymentPolicyId - The ID of the payment policy to delete
    # + return - returns can be any of following types
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function delete payment_policy/[string paymentPolicyId]() returns http:NoContent|http:BadRequest|http:NotFound|http:Conflict|http:InternalServerError {
        return http:NO_CONTENT;
    }

    # Delete a return policy
    #
    # + returnPolicyId - The ID of the return policy to delete
    # + return - returns can be any of following types
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function delete return_policy/[string returnPolicyId]() returns http:NoContent|http:BadRequest|http:NotFound|http:Conflict|http:InternalServerError {
        return http:NO_CONTENT;
    }

    # List custom policies
    #
    # + policyTypes - Comma-delimited custom policy types to return
    # + return - returns can be any of following types
    # http:Ok (The retrieved custom policies)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get custom_policy(@http:Query {name: "policy_types"} string? policyTypes) returns CustomPolicyResponse|http:BadRequest|http:InternalServerError {
        return {
            total: 1,
            offset: 0,
            'limit: 20,
            href: "https://api.ebay.com/sell/account/v1/custom_policy?limit=20&offset=0",
            customPolicies: [
                {
                    customPolicyId: "551111000",
                    policyType: "PRODUCT_COMPLIANCE",
                    name: "Battery safety",
                    label: "Product Compliance"
                }
            ]
        };
    }

    # Get a custom policy
    #
    # + customPolicyId - The ID of the custom policy to retrieve
    # + return - returns can be any of following types
    # http:Ok (The retrieved custom policy)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get custom_policy/[string customPolicyId]() returns CustomPolicy|http:BadRequest|http:NotFound|http:InternalServerError {
        return {
            customPolicyId,
            policyType: "PRODUCT_COMPLIANCE",
            name: "Battery safety",
            label: "Product Compliance",
            description: "Contains lithium batteries; ship with care"
        };
    }

    # List fulfillment policies
    #
    # + contentLanguage - Content language of the request
    # + marketplaceId - The eBay marketplace ID
    # + return - returns can be any of following types
    # http:Ok (The retrieved fulfillment policies)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get fulfillment_policy(@http:Header {name: "Content-Language"} string? contentLanguage, @http:Query {name: "marketplace_id"} string marketplaceId) returns FulfillmentPolicyResponse|http:BadRequest|http:InternalServerError {
        return {
            total: 1,
            fulfillmentPolicies: [mockFulfillmentPolicy]
        };
    }

    # Get a fulfillment policy
    #
    # + fulfillmentPolicyId - The ID of the fulfillment policy to retrieve
    # + return - returns can be any of following types
    # http:Ok (The retrieved fulfillment policy)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get fulfillment_policy/[string fulfillmentPolicyId]() returns FulfillmentPolicy|http:BadRequest|http:NotFound|http:InternalServerError {
        return mockFulfillmentPolicy;
    }

    # Get a fulfillment policy by name
    #
    # + contentLanguage - Content language of the request
    # + marketplaceId - The eBay marketplace ID
    # + name - The name of the fulfillment policy
    # + return - returns can be any of following types
    # http:Ok (The retrieved fulfillment policy)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get fulfillment_policy/get_by_policy_name(@http:Header {name: "Content-Language"} string? contentLanguage, @http:Query {name: "marketplace_id"} string marketplaceId, string name) returns FulfillmentPolicy|http:BadRequest|http:InternalServerError {
        return mockFulfillmentPolicy;
    }

    # List payment policies
    #
    # + marketplaceId - The eBay marketplace ID
    # + contentLanguage - Content language of the request
    # + return - returns can be any of following types
    # http:Ok (The retrieved payment policies)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get payment_policy(@http:Query {name: "marketplace_id"} string marketplaceId, @http:Header {name: "Content-Language"} string? contentLanguage) returns PaymentPolicyResponse|http:BadRequest|http:InternalServerError {
        return {
            total: 1,
            paymentPolicies: [mockPaymentPolicy]
        };
    }

    # Get a payment policy
    #
    # + paymentPolicyId - The ID of the payment policy to retrieve
    # + return - returns can be any of following types
    # http:Ok (The retrieved payment policy)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get payment_policy/[string paymentPolicyId]() returns PaymentPolicy|http:BadRequest|http:NotFound|http:InternalServerError {
        return mockPaymentPolicy;
    }

    # Get seller privileges
    #
    # + return - returns can be any of following types
    # http:Ok (The seller privileges)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get privilege() returns SellingPrivileges|http:BadRequest|http:InternalServerError {
        return {
            sellerRegistrationCompleted: true,
            sellingLimit: {amount: {currency: "USD", value: "10000.00"}, quantity: 500}
        };
    }

    # List opted-in programs
    #
    # + return - returns can be any of following types
    # http:Ok (The opted-in programs)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get program/get_opted_in_programs() returns Programs|http:BadRequest|http:NotFound|http:InternalServerError {
        return {
            programs: [
                {programType: "SELLING_POLICY_MANAGEMENT"},
                {programType: "OUT_OF_STOCK_CONTROL"}
            ]
        };
    }

    # List shipping rate tables
    #
    # + countryCode - Two-letter country code to filter the rate tables
    # + return - returns can be any of following types
    # http:Ok (The retrieved rate tables)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get rate_table(@http:Query {name: "country_code"} string? countryCode) returns RateTableResponse|http:BadRequest|http:InternalServerError {
        return {
            rateTables: [
                {rateTableId: "5001", name: "Domestic table", countryCode: "US", locality: "DOMESTIC"}
            ]
        };
    }

    # List return policies
    #
    # + contentLanguage - Content language of the request
    # + marketplaceId - The eBay marketplace ID
    # + return - returns can be any of following types
    # http:Ok (The retrieved return policies)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get return_policy(@http:Header {name: "Content-Language"} string? contentLanguage, @http:Query {name: "marketplace_id"} string marketplaceId) returns ReturnPolicyResponse|http:BadRequest|http:InternalServerError {
        return {
            total: 1,
            returnPolicies: [mockReturnPolicy]
        };
    }

    # Get a return policy
    #
    # + returnPolicyId - The ID of the return policy to retrieve
    # + return - returns can be any of following types
    # http:Ok (The retrieved return policy)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get return_policy/[string returnPolicyId]() returns ReturnPolicy|http:BadRequest|http:NotFound|http:InternalServerError {
        return mockReturnPolicy;
    }

    # List sales tax entries
    #
    # + countryCode - Two-letter country code
    # + return - returns can be any of following types
    # http:Ok (The retrieved sales tax entries)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get sales_tax(@http:Query {name: "country_code"} string countryCode) returns SalesTaxes|http:BadRequest|http:InternalServerError {
        return {salesTaxes: [mockSalesTax]};
    }

    # Get a sales tax entry
    #
    # + countryCode - Two-letter country code
    # + jurisdictionId - The ID of the sales tax jurisdiction
    # + return - returns can be any of following types
    # http:Ok (The retrieved sales tax)
    # http:NoContent (No content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get sales_tax/[string countryCode]/[string jurisdictionId]() returns SalesTax|http:NoContent|http:BadRequest|http:NotFound|http:InternalServerError {
        return mockSalesTax;
    }

    # Create a custom policy
    #
    # + contentType - Content type of the request
    # + payload - The custom policy to create
    # + return - returns can be any of following types
    # http:Created (Created)
    # http:BadRequest (Bad Request)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function post custom_policy(@http:Header {name: "Content-Type"} string contentType, @http:Payload CustomPolicyCreateRequest payload) returns record {}|http:BadRequest|http:Conflict|http:InternalServerError {
        record {} created = {};
        return created;
    }

    # Create a fulfillment policy
    #
    # + contentType - Content type of the request
    # + payload - The fulfillment policy to create
    # + return - returns can be any of following types
    # http:Created (Created)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post fulfillment_policy(@http:Header {name: "Content-Type"} string contentType, @http:Payload FulfillmentPolicyRequest payload) returns SetFulfillmentPolicyResponse|http:BadRequest|http:InternalServerError {
        return {
            fulfillmentPolicyId: "6196932001",
            name: payload.name,
            description: payload.description,
            marketplaceId: payload.marketplaceId,
            categoryTypes: payload.categoryTypes,
            handlingTime: payload.handlingTime,
            shippingOptions: payload.shippingOptions,
            warnings: []
        };
    }

    # Create a payment policy
    #
    # + contentType - Content type of the request
    # + payload - The payment policy to create
    # + return - returns can be any of following types
    # http:Created (Created)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post payment_policy(@http:Header {name: "Content-Type"} string contentType, @http:Payload PaymentPolicyRequest payload) returns SetPaymentPolicyResponse|http:BadRequest|http:InternalServerError {
        return {
            paymentPolicyId: "6196933001",
            name: payload.name,
            description: payload.description,
            marketplaceId: payload.marketplaceId,
            categoryTypes: payload.categoryTypes,
            immediatePay: payload.immediatePay,
            warnings: []
        };
    }

    # Opt in to a program
    #
    # + contentType - Content type of the request
    # + payload - The program to opt in to
    # + return - returns can be any of following types
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function post program/opt_in(@http:Header {name: "Content-Type"} string contentType, @http:Payload Program payload) returns record {}|http:BadRequest|http:NotFound|http:Conflict|http:InternalServerError {
        record {} optedIn = {};
        return optedIn;
    }

    # Create a return policy
    #
    # + contentType - Content type of the request
    # + payload - The return policy to create
    # + return - returns can be any of following types
    # http:Created (Created)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post return_policy(@http:Header {name: "Content-Type"} string contentType, @http:Payload ReturnPolicyRequest payload) returns SetReturnPolicyResponse|http:BadRequest|http:InternalServerError {
        return {
            returnPolicyId: "6196934001",
            name: payload.name,
            description: payload.description,
            marketplaceId: payload.marketplaceId,
            categoryTypes: payload.categoryTypes,
            returnsAccepted: payload.returnsAccepted,
            returnPeriod: payload.returnPeriod,
            warnings: []
        };
    }

    # Update a custom policy
    #
    # + customPolicyId - The ID of the custom policy to update
    # + contentType - Content type of the request
    # + payload - The updated custom policy
    # + return - returns can be any of following types
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:Conflict (Conflict)
    # http:InternalServerError (Internal Server Error)
    resource function put custom_policy/[string customPolicyId](@http:Header {name: "Content-Type"} string contentType, @http:Payload CustomPolicyRequest payload) returns http:NoContent|http:BadRequest|http:NotFound|http:Conflict|http:InternalServerError {
        return http:NO_CONTENT;
    }

    # Update a fulfillment policy
    #
    # + fulfillmentPolicyId - The ID of the fulfillment policy to update
    # + contentType - Content type of the request
    # + payload - The updated fulfillment policy
    # + return - returns can be any of following types
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function put fulfillment_policy/[string fulfillmentPolicyId](@http:Header {name: "Content-Type"} string contentType, @http:Payload FulfillmentPolicyRequest payload) returns SetFulfillmentPolicyResponse|http:BadRequest|http:NotFound|http:InternalServerError {
        return {
            fulfillmentPolicyId,
            name: payload.name,
            description: payload.description,
            marketplaceId: payload.marketplaceId,
            categoryTypes: payload.categoryTypes,
            handlingTime: payload.handlingTime,
            shippingOptions: payload.shippingOptions,
            warnings: []
        };
    }

    # Create or replace a sales tax entry
    #
    # + countryCode - Two-letter country code
    # + jurisdictionId - The ID of the sales tax jurisdiction
    # + contentType - Content type of the request
    # + payload - The sales tax details
    # + return - returns can be any of following types
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function put sales_tax/[string countryCode]/[string jurisdictionId](@http:Header {name: "Content-Type"} string contentType, @http:Payload SalesTaxBase payload) returns http:NoContent|http:BadRequest|http:NotFound|http:InternalServerError {
        return http:NO_CONTENT;
    }
}
