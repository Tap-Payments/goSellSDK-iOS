//
//  OTPScreenStyle.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal struct OTPScreenStyle: Decodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal let digits: TextStyle
	
	internal let timer: TextStyle
	
	internal let resend: TextStyle
	
	internal let descriptionText: TextStyle
	
	internal let descriptionNumber: TextStyle
	
	internal let arrowIcon: ResourceImage
	
    internal let otpDigitsBackgroundColor: HexColor
    
    internal let otpDigitsBorderColor: HexColor
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case digits 			        = "digits_style"
		case timer 				        = "timer_style"
		case resend 			        = "resend_style"
		case descriptionText 	        = "description_style"
		case descriptionNumber	        = "description_number_style"
		case arrowIcon                  = "arrow_icon"
        case otpDigitsBackgroundColor   = "otp_digits_holder_background"
        case otpDigitsBorderColor       = "otp_digits_holder_border"
	}
}
