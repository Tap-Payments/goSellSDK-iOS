//
//  SettingsDataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func TapSwiftFixesV2.synchronized

/// Settings data manager.
internal final class SettingsDataManager {
    
    // MARK: - Internal -
    
    internal typealias OptionalErrorClosure = (TapSDKError?) -> Void
    
    // MARK: Properties
    
    /// SDK settings.
    internal var settings: SDKSettingsData? {
        
        didSet {
            
            if let deviceID = self.settings?.deviceID {
                
                KeychainManager.deviceID = deviceID
            }
        }
    }
    
    // MARK: Methods
    
    internal func checkInitializationStatus(_ completion: @escaping OptionalErrorClosure) {
        
        synchronized(self) { [unowned self] in
            
            switch self.status {
                
            case .notInitiated:
                
                self.append(completion)
                self.callInitializationAPI()
                
            case .initiated:
                
                self.append(completion)
                
            case .succeed:
                
                guard self.settings != nil else {
                    
                    completion(TapSDKUnknownError(dataTask: nil))
                    return
                }
                
                completion(nil)
            }
        }
    }
	
	internal static func resetAllSettings() {
		
		self.storages?.values.forEach { $0.reset() }
	}
	
    // MARK: - Private -
    // MARK: Properties
    
    private var status: InitializationStatus = .notInitiated
    
    private var pendingCompletions: [OptionalErrorClosure] = []
    
    private static var storages: [SDKMode: SettingsDataManager]? = [:]
    
    // MARK: Methods
    
	private init() {}
    
    private func append(_ completion: @escaping OptionalErrorClosure) {
        
        self.pendingCompletions.append(completion)
    }
    
    private func callInitializationAPI() {
        
        self.status = .initiated
        
        APIClient.shared.initSDK { [unowned self] (settings, error) in
            
			self.update(settings: settings, error: error)
        }
    }
	
	private func update(settings updatedSettings: SDKSettings?, error: TapSDKError?) {
        let unVerifiedApplicationError =  (SettingsDataManager.shared.settings?.verifiedApplication ?? true) ? nil : TapSDKError(type: .unVerifiedApplication)
        
        var finalError:TapSDKError?
        
        if let nonnullError = error
        {
            finalError = nonnullError
        }else if let nonnullError = unVerifiedApplicationError
        {
            finalError = nonnullError
            print(nonnullError.description)
        }
        
		if let nonnullError = finalError {
			
			self.status = .notInitiated
			
			if self.pendingCompletions.count > 0 {
				
				self.callAllPendingCompletionsAndEmptyStack(nonnullError)
			}
			else {
				
				ErrorDataManager.handle(nonnullError, retryAction: { self.callInitializationAPI() }, alertDismissButtonClickHandler: nil)
			}
		}
		else {
			
			self.settings = updatedSettings?.data
			self.status = .succeed
			self.callAllPendingCompletionsAndEmptyStack(nil)
		}
	}
    
    private func callAllPendingCompletionsAndEmptyStack(_ error: TapSDKError?) {
        
        synchronized(self) { [unowned self] in
            
            for completion in self.pendingCompletions {
                
                completion(error)
            }
            
            self.pendingCompletions.removeAll()
        }
    }
	
	private func reset() {
		
		let userInfo: [String: String] = [
			
			NSLocalizedDescriptionKey: "Merchant account data is missing."
		]
		
		let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.noMerchantData.rawValue, userInfo: userInfo)
		let error = TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
		
		self.update(settings: nil, error: error)
	}
}

// MARK: - Singleton
extension SettingsDataManager: Singleton {
    
    internal static var shared: SettingsDataManager {
        
        if let existing = self.storages?[GoSellSDK.mode] {
            
            return existing
        }
        
        let instance = SettingsDataManager()
		
		var stores = self.storages ?? [:]
		stores[GoSellSDK.mode] = instance
		
		self.storages = stores
		
        return instance
    }
}

// MARK: - ImmediatelyDestroyable
extension SettingsDataManager: ImmediatelyDestroyable {
	
	internal static func destroyInstance() {
		
		self.storages = nil
	}
	
	internal static var hasAliveInstance: Bool {
		
		return !(self.storages?.isEmpty ?? true)
	}
}
