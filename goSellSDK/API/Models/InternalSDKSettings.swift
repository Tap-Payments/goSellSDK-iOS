//
//  InternalSDKSettings.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Internal SDK settings model
internal struct InternalSDKSettings: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Visibility duration of payment status popup.
    internal let statusPopupVisibilityDuration: TimeInterval
    
    /// Time interval between OTP resends.
    internal let resendOTPTimeInterval: TimeInterval
    
    /// Number of attempts to resend OTP.
    internal let resendOTPAttemptsCount: Int
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case statusPopupVisibilityDuration = "status_popup_duration"
        case resendOTPTimeInterval = "resend_interval"
        case resendOTPAttemptsCount = "resend_number_attempts"
    }
}
