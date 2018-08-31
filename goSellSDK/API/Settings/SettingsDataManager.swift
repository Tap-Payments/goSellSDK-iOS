//
//  SettingsDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import func TapSwiftFixes.synchronized

/// Settings data manager.
internal final class SettingsDataManager {
    
    // MARK: - Internal -
    
    internal typealias OptionalErrorClosure = (TapSDKError?) -> Void
    
    // MARK: Properties
    
    /// SDK settings.
    internal private(set) var settings: SDKSettingsData? {
        
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
    
    // MARK: - Private -
    // MARK: Properties
    
    private var status: InitializationStatus = .notInitiated
    
    private var pendingCompletions: [OptionalErrorClosure] = []
    
    private static var storage: SettingsDataManager?
    
    // MARK: Methods
    
    private init() {
        
        KnownStaticallyDestroyableTypes.add(SettingsDataManager.self)
    }
    
    private func append(_ completion: @escaping OptionalErrorClosure) {
        
        self.pendingCompletions.append(completion)
    }
    
    private func callInitializationAPI() {
        
        self.status = .initiated
        
        APIClient.shared.initSDK { [unowned self] (settings, error) in
            
            if let nonnullError = error {
                
                if self.pendingCompletions.count > 0 {
                
                    self.callAllPendingCompletionsAndEmptyStack(nonnullError)
                }
                else {

                    ErrorDataManager.handle(nonnullError, retryAction: { self.callInitializationAPI() }, alertDismissButtonClickHandler: nil)
                }
            }
            else {
                
                self.settings = settings?.data
                self.status = .succeed
                self.callAllPendingCompletionsAndEmptyStack(nil)
            }
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
}

// MARK: - ImmediatelyDestroyable
extension SettingsDataManager: ImmediatelyDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}

// MARK: - Singleton
extension SettingsDataManager: Singleton {
    
    internal static var shared: SettingsDataManager {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = SettingsDataManager()
        self.storage = instance
        
        return instance
    }
    
    
}

