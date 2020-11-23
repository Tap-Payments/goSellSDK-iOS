//
//  BINDataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func TapSwiftFixesV2.performOnMainThread

/// BIN Data manager.
internal final class BINDataManager {
    
    // MARK: - Internal -
    
    internal typealias BINResult = (BINResponse) -> Void
    
    // MARK: Methods
    
    internal func retrieveBINData(for binNumber: String, success: @escaping BINResult) {
        
        if let cachedResponse = self.cachedBINData(for: binNumber) {
            
            self.callCompletion(success, with: cachedResponse)
            return
        }
        
        guard !self.pendingBINs.contains(binNumber) else { return }
        self.pendingBINs.append(binNumber)
        
        APIClient.shared.getBINDetails(for: binNumber) { [weak self] (response, error) in
            
            if let index = self?.pendingBINs.firstIndex(of: binNumber) {
                
                self?.pendingBINs.remove(at: index)
            }
            
            if let nonnullError = error {
                
                ErrorDataManager.handle(nonnullError, retryAction: { self?.retrieveBINData(for: binNumber, success: success) }, alertDismissButtonClickHandler: nil)
            }
            else if let nonnullResponse = response {
                
                self?.cachedBINData[binNumber] = nonnullResponse
                self?.callCompletion(success, with: nonnullResponse)
            }
        }
    }
    
    internal func cachedBINData(for binNumber: String) -> BINResponse? {
        
        return self.cachedBINData[binNumber]
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private lazy var cachedBINData: [String: BINResponse] = [:]
    private lazy var pendingBINs: [String] = []
    
    private static var storage: BINDataManager?
    
    // MARK: Methods
    
    private init() {
        
        KnownStaticallyDestroyableTypes.add(BINDataManager.self)
    }
    
    private func callCompletion(_ closure: @escaping BINResult, with result: BINResponse) {
        
        performOnMainThread {
            
            closure(result)
        }
    }
}

// MARK: - ImmediatelyDestroyable
extension BINDataManager: ImmediatelyDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance() {
        
        self.storage = nil
    }
}

// MARK: - Singleton
extension BINDataManager: Singleton {
    
    internal static var shared: BINDataManager {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = BINDataManager()
        self.storage = instance
        
        return instance
    }
}
