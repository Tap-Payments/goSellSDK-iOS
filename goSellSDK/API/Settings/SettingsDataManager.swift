//
//  SettingsDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import func TapSwiftFixes.synchronized

/// Settings data manager.
internal class SettingsDataManager {
    
    // MARK: - Internal -
    
    internal typealias OptionalErrorClosure = (TapSDKError?) -> Void
    
    // MARK: Properties
    
    internal static let shared = SettingsDataManager()
    
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
    
    // MARK: Methods
    
    private init() { }
    
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
