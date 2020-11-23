
//
//  APIClient.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    TapApplicationV2.TapApplicationPlistInfo
import class    TapApplicationV2.TapBundlePlistInfo
import func     TapSwiftFixesV2.performOnBackgroundThread
import func     TapSwiftFixesV2.performOnMainThread
import class    TapNetworkManagerV2.TapNetworkManager
import class    TapNetworkManagerV2.TapNetworkRequestOperation
import class    UIKit.UIDevice.UIDevice
import CoreTelephony
/// API client.
internal final class APIClient {
    
    // MARK: - Internal -
    
	internal typealias Completion<Response: Decodable> = (Response?, TapSDKError?) -> Void
    
    // MARK: Properties
    
    /// Static HTTP headers sent with each request.
    internal var staticHTTPHeaders: [String: String] {
        
        let secretKey = self.sdkSecretKey
        
        guard secretKey.tap_length > 0 else {
            
            fatalError("Secret key must be set in order to use goSellSDK.")
        }
        
        let applicationValue = self.applicationHeaderValue
        
        var result = [
            
            Constants.HTTPHeaderKey.authorization: "Bearer \(secretKey)",
            Constants.HTTPHeaderKey.application: applicationValue
        ]
        
        if let sessionToken = SettingsDataManager.shared.settings?.sessionToken, !sessionToken.isEmpty {
            
            result[Constants.HTTPHeaderKey.sessionToken] = sessionToken
        }
        
        return result
    }
    
    internal var activeRequests: [TapNetworkRequestOperation] {
        
        return self.networkManager.currentRequestOperations
    }
    
    // MARK: Methods
    
    /// Performs request.
    ///
    /// - Parameters:
    ///   - operation: Request operation.
    ///   - decoder: Response decoder.
    ///   - checkSDKInitializationStatus: Defines if SDK initialization status is checked before the request.
    ///   - completion: Completion closure.
    ///   - response: Response object in case of success.
    ///   - error: Error in case of failure.
    internal func performRequest<Response>(_ operation: TapNetworkRequestOperation, using decoder: JSONDecoder, checkSDKInitializationStatus: Bool = true, completion: @escaping Completion<Response>) where Response: Decodable {
        
        performOnBackgroundThread { [unowned self] in
            
            let requestClosure: SettingsDataManager.OptionalErrorClosure = { initializationError in
                
                guard initializationError == nil else {
                    
                    performOnMainThread {
                        
                        completion(nil, initializationError)
                    }
                    
                    return
                }
                
                self.networkManager.performRequest(operation) { (dataTask, response, error) in
                    
                    self.handleResponse(response, error: error, in: dataTask, using: decoder, completion: completion)
                }
            }
            
            if checkSDKInitializationStatus {
                
                SettingsDataManager.shared.checkInitializationStatus(requestClosure)
            }
            else {
                
                requestClosure(nil)
            }
        }
    }
    
    internal func cancelAllRequests() {
        
        self.networkManager.currentRequestOperations.forEach { self.networkManager.cancelRequest($0) }
    }
    
    /// Converts Encodable model into its dictionary representation. Calls completion closure in case of failure.
    ///
    /// - Parameters:
    ///   - model: Model to encode.
    ///   - completion: Failure completion closure.
    ///   - response: Response object in case of success. Here - always nil.
    ///   - error: Error in case of failure. If the closure is called it will never become nil.
    /// - Returns: Dictionary.
    internal func convertModelToDictionary<Response>(_ model: Encodable, callingCompletionOnFailure completion: Completion<Response>) -> [String: Any]? where Response: Decodable {
        
        var modelDictionary: [String: Any]
        
        do {
            if let applePayModel:CreateTokenWithApplePayRequest = model as? CreateTokenWithApplePayRequest
            {
                modelDictionary = try applePayModel.applePayToken.tap_asDictionary()
            }else
            {
                modelDictionary = try model.tap_asDictionary()
            }
        }
        catch let error {
			
			completion(nil, TapSDKKnownError(type: .serialization, error: error, response: nil, body: model))
            return nil
        }
        
        return modelDictionary
    }
    
    // MARK: - Private -
    
    internal struct Constants {
        
        internal static let authenticateParameter = "authenticate"
        
        fileprivate static let baseURL: URL = {
            
            guard let result = URL(string: Constants.baseURLString) else {
                
                fatalError("Wrong base URL: \(Constants.baseURLString)")
            }
            
            return result
        }()
        
        fileprivate static let timeoutInterval: TimeInterval            = 60.0
        fileprivate static let cachePolicy:     URLRequest.CachePolicy  = .reloadIgnoringCacheData
        
        fileprivate static let successStatusCodes = 200...299
        
        fileprivate struct HTTPHeaderKey {
            
            fileprivate static let authorization    = "Authorization"
            fileprivate static let application      = "application"
            fileprivate static let sessionToken     = "session_token"
            
            //@available(*, unavailable) private init() { }
        }
        
        fileprivate struct HTTPHeaderValueKey {
            
            fileprivate static let appID				= "app_id"
            fileprivate static let appLocale				= "app_locale"
            fileprivate static let deviceID				= "device_id"
            fileprivate static let requirer				= "requirer"
            fileprivate static let requirerOS			= "requirer_os"
            fileprivate static let requirerOSVersion		= "requirer_os_version"
            fileprivate static let requirerValue			= "SDK"
            fileprivate static let requirerVersion		= "requirer_version"
            fileprivate static let requirerDeviceName		= "requirer_device_name"
            fileprivate static let requirerDeviceType		= "requirer_device_type"
            fileprivate static let requirerDeviceModel	= "requirer_device_model"
            fileprivate static let requirerSimNetworkName	= "requirer_sim_network_name"
            fileprivate static let requirerSimCountryIso	= "requirer_sim_country_iso"

            //@available(*, unavailable) private init() { }
        }
        
        private static let baseURLString = "https://api.tap.company/v2/"
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private let networkManager: TapNetworkManager = {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = Constants.timeoutInterval
        configuration.requestCachePolicy = Constants.cachePolicy
        
        let manager = TapNetworkManager(baseURL: Constants.baseURL, configuration: configuration)
        manager.isRequestLoggingEnabled = true

        return manager
    }()
    
    private static var storage: APIClient?
    
    private let applicationStaticDetails: [String: Any] = {
        
        guard let bundleID = TapApplicationPlistInfo.shared.bundleIdentifier, !bundleID.isEmpty else {
            
            fatalError("Application must have bundle identifier in order to use goSellSDK.")
        }
        
        let sdkPlistInfo = TapBundlePlistInfo(bundle: Bundle(for: GoSellSDK.self))
        
        guard let requirerVersion = sdkPlistInfo.shortVersionString, !requirerVersion.isEmpty else {
            
            fatalError("Seems like SDK is not integrated well.")
        }
		let networkInfo = CTTelephonyNetworkInfo()
		let carrier = networkInfo.subscriberCellularProvider
		
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
		let deviceName = UIDevice.current.name
		let deviceNameFiltered =  deviceName.tap_byRemovingAllCharactersExcept("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789")
		let deviceType = UIDevice.current.model
		let deviceModel = UIDevice.current.localizedModel
		let simNetWorkName = carrier?.carrierName
		let simCountryISO = carrier?.isoCountryCode

		
        let result: [String: Any] = [
        
            Constants.HTTPHeaderValueKey.appID: bundleID,
            Constants.HTTPHeaderValueKey.requirer: Constants.HTTPHeaderValueKey.requirerValue,
            Constants.HTTPHeaderValueKey.requirerVersion: requirerVersion,
            Constants.HTTPHeaderValueKey.requirerOS: osName,
            Constants.HTTPHeaderValueKey.requirerOSVersion: osVersion,
			Constants.HTTPHeaderValueKey.requirerDeviceName: deviceNameFiltered,
			Constants.HTTPHeaderValueKey.requirerDeviceType: deviceType,
			Constants.HTTPHeaderValueKey.requirerDeviceModel: deviceModel,
			Constants.HTTPHeaderValueKey.requirerSimNetworkName: simNetWorkName ?? "",
			Constants.HTTPHeaderValueKey.requirerSimCountryIso: simCountryISO ?? "",
        ]
        
        return result
    }()
    
    private var applicationHeaderValue: String {
        
        var applicationDetails = self.applicationStaticDetails
        
        let localeIdentifier = LocalizationManager.shared.selectedLanguage
        applicationDetails[Constants.HTTPHeaderValueKey.appLocale] = localeIdentifier
        
        if let deviceID = KeychainManager.deviceID {
            
            applicationDetails[Constants.HTTPHeaderValueKey.deviceID] = deviceID
        }
        
        let result = (applicationDetails.map { "\($0.key)=\($0.value)" }).joined(separator: "|")
        
        return result
    }
    
    private var sdkSecretKey: String {
        
        switch GoSellSDK.mode {
            
        case .sandbox:      return GoSellSDK.secretKey.sandbox
        case .production:   return GoSellSDK.secretKey.production
            
        }
    }
    
    // MARK: Methods
    
    private init() {
        
        KnownStaticallyDestroyableTypes.add(APIClient.self)
    }
    
    private func handleResponse<Response>(_ response: Any?, error: Error?, in dataTask: URLSessionDataTask?, using decoder: JSONDecoder, completion: @escaping Completion<Response>) where Response: Decodable {
        
        if let nonnullError = error {
            
            performOnMainThread {
                
				completion(nil, TapSDKKnownError(type: .network, error: nonnullError, response: dataTask?.response, body: response))
            }
            return
        }
        
        if let dataTaskError = dataTask?.error {
            
            performOnMainThread {
                
				completion(nil, TapSDKKnownError(type: .network, error: dataTaskError, response: dataTask?.response, body: response))
            }
            
            return
        }
        
        if let dictionary = response as? [String: Any], let httpResponse = dataTask?.response as? HTTPURLResponse {
            
            let statusCode = httpResponse.statusCode
			if statusCode.tap_isIn(Constants.successStatusCodes) {
                
                do {
                    
                    let parsedResponse = try Response(dictionary: dictionary, using: decoder)
                    performOnMainThread {
                        
                        completion(parsedResponse, nil)
                    }
                    
                    return
                }
                catch let parsingError {
                    
                    performOnMainThread {
                        
						completion(nil, TapSDKKnownError(type: .serialization, error: parsingError, response: httpResponse, body: dictionary))
                    }
                    
                    return
                }
            }
            else {
                
                do {
                    
                    let parsedError = try APIError(dictionary: dictionary, using: decoder)
                    
                    performOnMainThread {
                        
                        completion(nil, TapSDKAPIError(error: parsedError, response: httpResponse))
                    }
                    
                    return
                }
                catch let parsingError {
                    
                    performOnMainThread {
                         let errorReturn = TapSDKKnownError(type: .serialization, error: parsingError, response: httpResponse, body: dictionary)
                         print(errorReturn)
						completion(nil, errorReturn)
                    }
                    
                    return
                }
            }
        }
        else {
            
            performOnMainThread {
                
                completion(nil, TapSDKUnknownError(dataTask: dataTask))
            }
            
            return
        }
    }
}

// MARK: - ImmediatelyDestroyable
extension APIClient: ImmediatelyDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}

// MARK: - Singleton
extension APIClient: Singleton {
    
    internal static var shared: APIClient {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = APIClient()
        self.storage = instance
        
        return instance
    }
}
