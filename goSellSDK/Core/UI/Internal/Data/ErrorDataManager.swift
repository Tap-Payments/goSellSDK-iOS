//
//  ErrorDataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapAdditionsKitV2.TypeAlias

internal class ErrorDataManager {
	
	// MARK: - Internal -
	// MARK: Methods
	
	internal static func handle(_ code: ErrorCode) {
		
		let title = LocalizationManager.shared.localizedErrorTitle(for: code)
		let message = LocalizationManager.shared.localizedErrorMessage(for: code)
		
		ErrorActionExecutor.showAlert(for: nil, with: title, message: message, retryAction: nil, report: false, completion: nil)
	}
	
	internal static func handle(_ error: TapSDKError, retryAction: TypeAlias.ArgumentlessClosure?, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
        if let apiError = error as? TapSDKAPIError {
            print("TAP API SDK ERROR \(apiError.error)")
            self.handleAPIError(apiError, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
        }
        else if let knownError = error as? TapSDKKnownError {
            print("TAP KNOWN SDK ERROR \(knownError.error)")
            
            self.handleKnownError(knownError, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
        }
        else if let unknownError = error as? TapSDKUnknownError {
            self.handleUnknownError(unknownError, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
        }
    }
	
	// MARK: - Private -
	// MARK: Methods
	
	private static func handleAPIError(_ error: TapSDKAPIError, retryAction: TypeAlias.ArgumentlessClosure?, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		guard let firstError = error.error.details.first else { return }
		self.handleErrorDetails(error.error.details, in: error, current: firstError, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
	}
	
	private static func handleErrorDetails(_ errorDetails: [ErrorDetail], in error: TapSDKError, current: ErrorDetail, retryAction: TypeAlias.ArgumentlessClosure?, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		self.handleErrorDetail(current, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler) { (retryUsed) in
			
			guard !retryUsed else { return }
			
			guard let index = errorDetails.firstIndex(of: current), index < errorDetails.count - 1 else { return }
			
			let nextIndex = errorDetails.index(after: index)
			self.handleErrorDetails(errorDetails, in: error, current: errorDetails[nextIndex], retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
		}
	}
	
	private static func handleKnownError(_ error: TapSDKKnownError, retryAction: TypeAlias.ArgumentlessClosure?, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		switch error.type {
			
		case .internal:
			
			guard let nsError = error.error as NSError? else { return }
			
			guard let internalErrorCode = InternalError(rawValue: nsError.code) else { return }
			let errorCode = self.errorCode(from: internalErrorCode)
			
			let errorDetail = ErrorDetail(code: errorCode)
			self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
			
		case .serialization:
			
			let errorDetail = ErrorDetail(code: .serialization)
			self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
			
		case .network:
			
			if let nsError = error.error as NSError?, nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorCancelled {
				
				let errorDetail = ErrorDetail(code: .cancel)
				self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
			}
			else {
				
				let errorDetail = ErrorDetail(code: .network)
				self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
			}
			
		case .unknown:
			
			let errorDetail = ErrorDetail(code: .unknown)
			self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
			
		case .api:
			
			let errorDetail = ErrorDetail(code: .unknown)
			self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
            
        case .unVerifiedApplication:
        
        let errorDetail = ErrorDetail(code: .unknown,description: "Un verified Application")
        self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
		}
	}
	
	private static func handleUnknownError(_ error: TapSDKUnknownError, retryAction: TypeAlias.ArgumentlessClosure?, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?) {
		
		let errorDetail = ErrorDetail(code: .unknown)
		self.handleErrorDetail(errorDetail, in: error, retryAction: retryAction, alertDismissButtonClickHandler: alertDismissButtonClickHandler)
	}
	
	private static func errorCode(from internalErrorCode: InternalError) -> ErrorCode {
		
		switch internalErrorCode {
			
		case .invalidCountryCode:           return .invalidCountryCode
		case .invalidAmountModificatorType: return .invalidAmountModificatorType
		case .invalidAuthorizeActionType:   return .invalidAuthorizeAutoScheduleType
		case .invalidCurrency:              return .invalidCurrency
		case .invalidCustomerInfo:          return .missingCustomerIDOrCustomerInformation
		case .customerAlreadyExists:		return .customerAlreadyExists
		case .cardAlreadyExists:			return .cardAlreadyExists
		case .invalidEmail:                 return .invalidEmailAddress
		case .invalidISDNumber:             return .invalidPhoneNumberCountryCode
		case .invalidPhoneNumber:           return .invalidPhoneNumber
		case .invalidUnitOfMeasurement:     return .invalidUnitOfMeasurement
		case .invalidMeasurement:           return .invalidMeasurement
		case .invalidEnumValue:             return .invalidEnumValue
		case .invalidAddressType:			return .invalidAddressType
		case .invalidTokenType:				return .invalidTokenType
		case .noMerchantData:				return .noMerchantData

		}
	}
	
	private static func handleErrorDetail(_ errorDetail: ErrorDetail, in error: TapSDKError, retryAction: TypeAlias.ArgumentlessClosure?, alertDismissButtonClickHandler: TypeAlias.ArgumentlessClosure?, completion: TypeAlias.BooleanClosure? = nil) {
		
		let action = self.action(for: errorDetail.code)
		
		let paymentPotentiallyClosedClosure: TypeAlias.ArgumentlessClosure = {
			
			if action.contains(.alert) {
				// Stop showing alerts for serialization errors and just pass it back to the user
                if error.type == .serialization,
                   let knownError: TapSDKKnownError = error as? TapSDKKnownError {
                     print("Error occured but you didn't implement the session delegate so we can pass the error to you.\n\(knownError.description)")
                    ErrorActionExecutor.closePayment(with: knownError, nil)
                }else {
                    let alertTitle = LocalizationManager.shared.localizedErrorTitle(for: errorDetail.code)
                    let alertMessage = LocalizationManager.shared.localizedErrorMessage(for: errorDetail.code)
                    
                    let localCompletion: TypeAlias.BooleanClosure  = { (retryClicked) in
                        
                        if !retryClicked {
                            
                            alertDismissButtonClickHandler?()
                        }
                        
                        completion?(retryClicked)
                    }
                    
                    #if GOSELLSDK_ERROR_REPORTING_AVAILABLE
                    
                        let report = action.contains(.report)
                    
                    #else
                    
                        let report = false
                    
                    #endif
                    
                    if action.contains(.retry) {
                        
                        ErrorActionExecutor.showAlert(for: error, with: alertTitle, message: alertMessage, retryAction: retryAction, report: report, completion: localCompletion)
                    }
                    else {
                        
                        ErrorActionExecutor.showAlert(for: error, with: alertTitle, message: alertMessage, retryAction: nil, report: report, completion: localCompletion)
                    }
                }
			}
		}
		
		if action.contains(.closePayment) {
			
			ErrorActionExecutor.closePayment(with: error, paymentPotentiallyClosedClosure)
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
			 .customerAlreadyExists,
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
			 .applicationRequired,
			 .noMerchantData:
			
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
			 .invalidEnumValue,
			 .cardAlreadyExists,
			 .unsupportedCard,
			 .invalidCVV,
			 .invalidAddress,
			 .invalidCardholderName:
			
			return .alert
			
		case .serialization:
			
			#if GOSELLSDK_ERROR_REPORTING_AVAILABLE
			
				return Reporter.canReport ? [.alert, .report] : [.alert]
			
			#else
			
				return [.alert]
			
			#endif
			
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
			 .invalidAddressType,
			 .invalidTokenType,
			 .invalidMeasurement,
			 .invalidAmount,
			 .invalidCurrency,
			 .unsupportedCurrency,
			 .missingCustomerID,
			 .invalidAPIKey,
			 .missingAPICredentials,
			 .publicKeyGivenInsteadOfSecret,
			 .permissionDenied:
			
			return [.closePayment]
			
		case .missingBINNumber,
			 .invalidBINNumber,
			 .cancel:
			
			return .tap_none
		}
	}
}
