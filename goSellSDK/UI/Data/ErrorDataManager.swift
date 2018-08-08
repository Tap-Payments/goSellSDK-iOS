//
//  ErrorDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct TapAdditionsKit.TypeAlias

internal class ErrorDataManager {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func handle(_ error: TapSDKError, retryAction: TypeAlias.ArgumentlessClosure? = nil) {
        
        if let apiError = error as? TapSDKAPIError {
            
            self.handleAPIError(apiError, retryAction: retryAction)
        }
        else if let knownError = error as? TapSDKKnownError {
            
            self.handleKnownError(knownError, retryAction: retryAction)
        }
        else if let unknownError = error as? TapSDKUnknownError {
            
            self.handleUnknownError(unknownError, retryAction: retryAction)
        }
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private static func handleAPIError(_ error: TapSDKAPIError, retryAction: TypeAlias.ArgumentlessClosure?) {
        
        guard let firstError = error.error.details.first else { return }
        self.handleErrorDetails(error.error.details, current: firstError, retryAction: retryAction)
    }
    
    private static func handleErrorDetails(_ errorDetails: [ErrorDetail], current: ErrorDetail, retryAction: TypeAlias.ArgumentlessClosure?) {
        
        self.handleErrorDetail(current, retryAction: retryAction) { (retryUsed) in
            
            guard !retryUsed else { return }
            
            guard let index = errorDetails.index(of: current), index < errorDetails.endIndex else { return }
            
            let nextIndex = errorDetails.index(after: index)
            self.handleErrorDetails(errorDetails, current: errorDetails[nextIndex], retryAction: retryAction)
        }
    }
    
    private static func handleKnownError(_ error: TapSDKKnownError, retryAction: TypeAlias.ArgumentlessClosure?) {
        
        switch error.type {
            
        case .internal:
            
            guard let nsError = error.error as NSError? else { return }
            
            guard let internalErrorCode = InternalError(rawValue: nsError.code) else { return }
            let errorCode = self.errorCode(from: internalErrorCode)
            
            let errorDetail = ErrorDetail(code: errorCode)
            self.handleErrorDetail(errorDetail, retryAction: retryAction)
            
        case .serialization:
            
            let errorDetail = ErrorDetail(code: .serialization)
            self.handleErrorDetail(errorDetail, retryAction: retryAction)
            
        case .network:
            
            if let nsError = error.error as NSError?, nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorCancelled {
                
                let errorDetail = ErrorDetail(code: .cancel)
                self.handleErrorDetail(errorDetail, retryAction: retryAction)
            }
            else {
            
                let errorDetail = ErrorDetail(code: .network)
                self.handleErrorDetail(errorDetail, retryAction: retryAction)
            }
            
        case .unknown:
            
            let errorDetail = ErrorDetail(code: .unknown)
            self.handleErrorDetail(errorDetail, retryAction: retryAction)
            
        case .api:
        
            let errorDetail = ErrorDetail(code: .unknown)
            self.handleErrorDetail(errorDetail, retryAction: retryAction)
        }
    }
    
    private static func handleUnknownError(_ error: TapSDKUnknownError, retryAction: TypeAlias.ArgumentlessClosure?) {
        
        let errorDetail = ErrorDetail(code: .unknown)
        self.handleErrorDetail(errorDetail, retryAction: retryAction)
    }
    
    private static func errorCode(from internalErrorCode: InternalError) -> ErrorCode {
        
        switch internalErrorCode {
            
        case .invalidCountryCode:           return .invalidCountryCode
        case .invalidAmountModificatorType: return .invalidAmountModificatorType
        case .invalidCurrency:              return .invalidCurrency
        case .invalidCustomerInfo:          return .missingCustomerIDOrCustomerInformation
        case .invalidEmail:                 return .invalidEmailAddress
        case .invalidISDNumber:             return .invalidPhoneNumberCountryCode
        case .invalidPhoneNumber:           return .invalidPhoneNumber
        case .invalidUnitOfMeasurement:     return .invalidUnitOfMeasurement
        case .invalidMeasurement:           return .invalidMeasurement
            
        }
    }
    
    private static func handleErrorDetail(_ error: ErrorDetail, retryAction: TypeAlias.ArgumentlessClosure?, completion: TypeAlias.BooleanClosure? = nil) {
        
        let action = self.action(for: error.code)
        
        let paymentPotentiallyClosedClosure: TypeAlias.ArgumentlessClosure = {
            
            if action.contains(.alert) {
                
                let titleKey = LocalizationStorage.alertTitleKey(for: error.code)
                let messageKey = LocalizationStorage.alertMessageKey(for: error.code)
                
                let alertTitle = LocalizationStorage.localizedString(for: titleKey)
                let alertMessage = LocalizationStorage.localizedString(for: messageKey)
                
                if action.contains(.retry) {
                    
                    ErrorActionExecutor.showAlert(with: alertTitle, message: alertMessage, retryAction: retryAction, completion: completion)
                }
                else {
                    
                    ErrorActionExecutor.showAlert(with: alertTitle, message: alertMessage, completion: completion)
                }
            }
        }
        
        if action.contains(.closePayment) {
            
            ErrorActionExecutor.closePayment(paymentPotentiallyClosedClosure)
        }
        else {
            
            paymentPotentiallyClosedClosure()
        }
    }
    
    private static func action(for code: ErrorCode) -> ErrorAction {
        
        switch code {
            
        case .requestHeadersMissing,
             .keyAndEnvironmentMismatch,
             .emptyRequest,
             .invalidCustomerID,
             .customerNotFound,
             .customerIDMismatch,
             .redirectURLMissing,
             .redirectURLInvalid,
             .invalidMerchantOrderReference,
             .invalidMerchantTransactionReference,
             .invalidStatementDescriptor,
             .invalidDescription,
             .missingSourceID,
             .invalidSourceID,
             .invalidMetadataKey,
             .invalidMetadataValue,
             .invalidJSONRequest,
             .applicationRequired:
            
            return .closePayment
            
        case .invalidInput,
             .saveCardFeatureDisabled,
             .non3DSecureTransactionsForbidden,
             .authorizeIDMissing,
             .authorizeIDInvalid,
             .authorizeStatus,
             .authorizeIDNotFound,
             .saveCardFeatureNotSupported,
             .invalidCardNumber,
             .invalidExpirationDate,
             .missingChargeID,
             .invalidChargeID,
             .chargeIDNotFound,
             .missingConfirmationCode,
             .invalidConfirmationCode,
             .currencyCodeMismatch,
             .captureAmountExceeds,
             .invalidCountryCode,
             .serialization:
            
            return .alert
            
        case .sourceAlreadyUsed,
             .gatewayTimeout,
             .serverUnavailable,
             .requestNotFound,
             .network,
             .unknown:
            
            return [.retry, .alert]
            
        case .missingCustomerIDOrCustomerInformation,
             .missingCustomerFirstName,
             .missingCustomerLastName,
             .invalidCustomerFirstName,
             .invalidCustomerLastName,
             .invalidCustomerMiddleName,
             .missingPhoneNumber,
             .invalidPhoneNumberCountryCode,
             .invalidPhoneNumber,
             .invalidEmailAddress,
             .missingCustomerPhoneNumberAndEmail,
             .missingAuthenticationType,
             .invalidAuthorizeAutoScheduleType,
             .invalidAuthorizeAutoScheduleTime,
             .invalidAuthenticationType,
             .invalidAmountModificatorType,
             .invalidUnitOfMeasurement,
             .invalidMeasurement,
             .invalidAmount,
             .invalidCurrency,
             .unsupportedCurrency,
             .missingCustomerID,
             .invalidAPIKey,
             .missingAPICredentials,
             .publicKeyGivenInsteadOfSecret,
             .permissionDenied:
            
            return [.alert, .closePayment]
            
        case .missingBINNumber,
             .invalidBINNumber,
             .cancel:
            
            return .none
        }
    }
}
