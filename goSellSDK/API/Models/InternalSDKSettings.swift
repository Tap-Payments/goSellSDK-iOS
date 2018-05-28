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
    
    /// Visibility duration of payment status.
    internal let statusDisplayDuration: TimeInterval
    
    /// Time interval between OTP resends.
    internal let otpResendInterval: TimeInterval
    
    /// Number of attempts to resend OTP.
    internal let otpResendAttempts: Int
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case statusDisplayDuration  = "status_display_duration"
        case otpResendInterval      = "otp_resend_interval"
        case otpResendAttempts      = "otp_resend_attempts"
    }
}
