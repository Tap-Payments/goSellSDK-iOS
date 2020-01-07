//
//  ApplePayTokenModel.swift
//  goSellSDK
//
//  Created by Osama Rabie on 06/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//
@objcMembers public final class ApplePayTokenModel: NSObject {
    
    /// Apple payment token with Data
    internal let appleTokenData: Data?
    
    /// Returns the base64 encoded string that represents the apple token data and "" if any error
    var appleTokenEncodedString: String {
        guard let appleData = appleTokenData else {return ""}
		let token = String(data: appleTokenData ?? Data(), encoding: .utf8)
        let utf8str = token!.data(using: .utf8)
		return utf8str?.base64EncodedString() ?? ""
    }
    // MARK: Methods
    
    init(appleTokenData: Data?) {
        
        self.appleTokenData = appleTokenData
    }
    
    
    
}
