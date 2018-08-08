//
//  ErrorCode.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum ErrorCode: Int, Decodable {
    
    // API codes
    
    case requestHeadersMissing                  = 1100
    case keyAndEnvironmentMismatch              = 1101
    case emptyRequest                           = 1102
    case invalidInput                           = 1103
    case missingCustomerID                      = 1104
    case invalidCustomerID                      = 1105
    case customerNotFound                       = 1106
    case customerIDMismatch                     = 1107
    case saveCardFeatureDisabled                = 1108
    case non3DSecureTransactionsForbidden       = 1109
    case redirectURLMissing                     = 1110
    case redirectURLInvalid                     = 1111
    case authorizeIDMissing                     = 1112
    case authorizeIDInvalid                     = 1113
    case authorizeStatus                        = 1114
    case authorizeIDNotFound                    = 1115
    case saveCardFeatureNotSupported            = 1116
    case invalidAmount                          = 1117
    case invalidCurrency                        = 1118
    case unsupportedCurrency                    = 1119
    case invalidStatementDescriptor             = 1120
    case invalidDescription                     = 1121
    case invalidMerchantOrderReference          = 1122
    case invalidMerchantTransactionReference    = 1123
    case missingSourceID                        = 1124
    case invalidSourceID                        = 1125
    case sourceAlreadyUsed                      = 1126
    case invalidMetadataKey                     = 1127
    case invalidMetadataValue                   = 1128
    case missingCustomerIDOrCustomerInformation = 1129
    case missingCustomerFirstName               = 1130
    case invalidCustomerFirstName               = 1131
    case missingCustomerLastName                = 1132
    case invalidCustomerLastName                = 1133
    case invalidCustomerMiddleName              = 1134
    case missingPhoneNumber                     = 1135
    case invalidPhoneNumberCountryCode          = 1136
    case invalidPhoneNumber                     = 1137
    case invalidEmailAddress                    = 1138
    case missingCustomerPhoneNumberAndEmail     = 1139
    case invalidCardNumber                      = 1140
    case invalidExpirationDate                  = 1141
    case missingChargeID                        = 1142
    case invalidChargeID                        = 1143
    case chargeIDNotFound                       = 1144
    case missingAuthenticationType              = 1145
    case invalidAuthenticationType              = 1146
    case missingConfirmationCode                = 1147
    case invalidConfirmationCode                = 1148
    case currencyCodeMismatch                   = 1149
    case captureAmountExceeds                   = 1150
    case gatewayTimeout                         = 1151
    case invalidAuthorizeAutoScheduleType       = 1152
    case invalidAuthorizeAutoScheduleTime       = 1153
    case missingBINNumber                       = 1154
    case invalidBINNumber                       = 1155
    
    case invalidJSONRequest                     = 2100
    case serverUnavailable                      = 2101
    case requestNotFound                        = 2102
    case applicationRequired                    = 2103
    case invalidAPIKey                          = 2104
    case missingAPICredentials                  = 2105
    case publicKeyGivenInsteadOfSecret          = 2106
    
    case permissionDenied                       = 3100
    
    // SDK codes
    
    case invalidCountryCode                     = 8000
    case invalidAmountModificatorType           = 8001
    case invalidUnitOfMeasurement               = 8002
    case invalidMeasurement                     = 8003
    
    case serialization                          = 8100
    
    case network                                = 8200
    case cancel                                 = 8201
    
    case unknown                                = 9999
}
