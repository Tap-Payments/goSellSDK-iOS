//
//  AsyncPaymentResultView.swift
//  goSellSDK
//
//  Created by Osama Rabie on 06/02/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//
import class    TapNibView.TapNibView
import UIKit

class AsyncPaymentResultView: TapNibView {
    
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var smsAcknolwedgeLabel: UILabel!
    @IBOutlet weak var orderCodeTitleLabel: UILabel!
    @IBOutlet weak var codeReferenceLabel: UILabel!
    @IBOutlet weak var codeExpirationLabel: UILabel!
    @IBOutlet weak var hintFooterLabel: UILabel!
    @IBOutlet weak var closeButton: TapButton!
    
     internal override class var bundle: Bundle {
		   
		   return .goSellSDKResources
	   }

    override init(frame: CGRect) {

        super.init(frame: frame)
        self.closeButton?.setLocalizedText(.btn_async_title)
        self.closeButton?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == .async })!
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override internal func setup() {
        super.setup()
        
    }
}
