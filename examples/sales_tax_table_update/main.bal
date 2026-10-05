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

// Reviews the sales tax table of an eBay seller account for a country, optionally sets the
// tax rate of one jurisdiction and reads the entry back to confirm the change.

import ballerina/io;
import ballerinax/ebay.account;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string countryCode = ?;
configurable string jurisdictionId = ?;
configurable string salesTaxPercentage = ?;
configurable boolean applyChanges = false;

public function main() returns error? {
    account:Client ebay = check new ({
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            refreshUrl
        }
    });

    // Step 1: Review the current sales tax table of the country
    account:SalesTaxes current = check ebay->getSalesTaxes(countryCode = countryCode);
    account:SalesTax[] entries = current?.salesTaxes ?: [];
    io:println(string `The ${countryCode} sales tax table has ${entries.length()} entries`);
    foreach account:SalesTax entry in entries {
        io:println(string `  ${entry?.salesTaxJurisdictionId ?: "<unknown>"}: ${entry?.salesTaxPercentage ?: "<unknown>"}%`);
    }

    if !applyChanges {
        io:println("applyChanges is false, so the sales tax table is left unchanged");
        return;
    }

    // Step 2: Create or replace the entry of the jurisdiction
    check ebay->createOrReplaceSalesTax(countryCode, jurisdictionId, {contentType: "application/json"}, {
        salesTaxPercentage,
        shippingAndHandlingTaxed: true
    });

    // Step 3: Read the entry back to confirm the change
    account:SalesTax? updated = check ebay->getSalesTax(countryCode, jurisdictionId);
    if updated is () {
        return error(string `No sales tax entry found for ${countryCode}/${jurisdictionId} after the update`);
    }
    io:println(string `${countryCode}/${jurisdictionId} is now taxed at ${updated?.salesTaxPercentage ?: "<unknown>"}%`);
}
