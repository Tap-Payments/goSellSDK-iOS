//
//  TapSDKUnknownError.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Unknown or unhandled error.
@objcMembers public final class TapSDKUnknownError: TapSDKError {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Data task to understand what is going on. If data task is nil that means that request hasn't even started.
    public private(set) var dataTask: URLSessionDataTask?
    
    /// Readable description of the error.
    public override var description: String {
        
        let dataTaskDescription = self.dataTask?.description ?? "nil"
        return "\(super.description)\nData task: \(dataTaskDescription)"
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    /// Initializes an error with data task.
    ///
    /// - Parameter dataTask: Data task.
    internal init(dataTask: URLSessionDataTask?) {
        
        super.init(type: .unknown)
        self.dataTask = dataTask
    }
}
