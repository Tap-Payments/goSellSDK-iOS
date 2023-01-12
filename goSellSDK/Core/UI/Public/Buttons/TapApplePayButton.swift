//
//  TapApplePayButton.swift
//  goSellSDK
//
//  Created by Osama Rabie on 11/12/2022.
//

import Foundation
import TapNibViewV2
import PassKit

/// Tap Apple Pay button.
@objcMembers public final class TapApplePayButton: TapNibView {
    
    /// The apple button UI outlet
    internal var applePayButton: PKPaymentButton?
    
    /// The session data source
    @objc public var dataSource:ApplePayButtonDataSource? {
        didSet{
            setup()
        }
    }
    
    /// Bundle to load nib from.
    public override class var bundle: Bundle {
        
        return .goSellSDKResources
    }
    
    
    public override func setup() {
        
        super.setup()
        applePayButton?.setTitle("", for: .normal)
        let applePayButtonStyle:PKPaymentButtonStyle = dataSource?.applePayButtonStyle ?? .whiteOutline
        
        let applePayButtonType:PKPaymentButtonType = dataSource?.applePayButtonType ?? .plain
        
        applePayButton = .init(paymentButtonType: applePayButtonType, paymentButtonStyle: applePayButtonStyle)
        
        applePayButton?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(applePayButton!)
        
        
        applePayButton?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        applePayButton?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        applePayButton?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        applePayButton?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        applePayButton?.layoutIfNeeded()
        
        applePayButton?.removeTarget(self, action: #selector(self.applePayButtonPressed), for: .touchUpInside)
        
        applePayButton?.addTarget(self, action: #selector(self.applePayButtonPressed), for: .touchUpInside)
        
    }
    
    internal func applePayButtonPressed() {
        guard let session = dataSource?.applePaySession else { return }
        Process.shared.applePayDataSource = dataSource
        session.startApplePay()
    }
    
}
