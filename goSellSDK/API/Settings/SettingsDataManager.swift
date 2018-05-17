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
    internal var settings: SDKSettingsData?
    
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
        
        KnownSingletonTypes.add(SettingsDataManager.self)
    }
    
    private func append(_ completion: @escaping OptionalErrorClosure) {
        
        self.pendingCompletions.append(completion)
    }
    
    private func callInitializationAPI() {
        
        self.status = .initiated
        
        APIClient.shared.initSDK { [unowned self] (settings, error) in
            
            self.settings = settings?.data
            self.status = error == nil ? .succeed : .notInitiated
            
            self.callAllPendingCompletionsAndEmptyStack(error)
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
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}

