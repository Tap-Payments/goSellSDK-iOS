//
//  AsyncPaymentResultView.swift
//  goSellSDK
//
//  Created by Osama Rabie on 06/02/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//
import class    TapNibViewV2.TapNibView
import UIKit

class AsyncPaymentResultView: TapNibView {
    
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var acknolwedgementLabel: UILabel!
    @IBOutlet weak var orderCodeTitleLabel: UILabel!
    @IBOutlet weak var codeReferenceLabel: UILabel!
    @IBOutlet weak var codeExpirationLabel: UILabel!
    @IBOutlet weak var hintFooterLabel: UILabel!
    @IBOutlet weak var closeButton: TapButton!{
        
        didSet {
            
            if let nonnullPayButton = self.closeButton {
                
                Process.shared.buttonHandlerInterface.setButton(nonnullPayButton)
            }
        }
    }
    
    
    @IBOutlet weak var storeLinkLabel: UILabel!
    
    @IBOutlet var asyncResponseLabels: [UILabel]!
    
    internal override class var bundle: Bundle {
		   
		   return .goSellSDKResources
	   }

    override init(frame: CGRect) {

        super.init(frame: frame)
        setupUI()
    }
    
    
    func setupUI()
    {
        self.closeButton?.setLocalizedText(.btn_async_title)
        self.closeButton?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == .async })!
        self.updateLabels()
        self.closeButton?.isEnabled = true
        self.closeButton?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ThemeManager.shared.resetCurrentThemeToDefault()
        setupUI()
        
    }
    
    
    override internal func setup() {
        super.setup()
    }
    
     private func updateLabels() {
        
        self.asyncResponseLabels?.forEach { $0.textColor = UIColor(tap_hex: "535353")?.loadCompatibleDarkModeColor(forColorNamed: "AsyncLabelColors") }
        
        paymentStatusLabel.setLocalizedText(.async_status_text)
        orderCodeTitleLabel.setLocalizedText(.async_pay_order_code_text)
        hintFooterLabel.setLocalizedText(.async_pay_hint_footer_text)
        
        if let nonNullCharge:ChargeProtocol = Process.shared.dataManagerInterface.currentChargeOrAuthorize
        {
            var acknolwedgeMentString:String = ""
            var channelString:String = ""
            
            if let nonNullPhone:PhoneNumber = nonNullCharge.customer.phoneNumber
            {
                acknolwedgeMentString = LocalizationManager.shared.localizedString(for: .async_pay_sms_text)
                channelString = nonNullPhone.phoneNumber
            }else
            {
                acknolwedgeMentString = LocalizationManager.shared.localizedString(for: .async_pay_email_text)
                channelString = nonNullCharge.customer.emailAddress?.value ?? ""
            }
            acknolwedgementLabel.text = String(format: "%@\n%@\n%@", acknolwedgeMentString,channelString,LocalizationManager.shared.localizedString(for: .async_pay_reference_text))
            
            if let expiration = nonNullCharge.transactionDetails.expiry
            {
                let currentDate:Date = Date()
                let calendar = NSCalendar.current
                var expirationDateComponent:Calendar.Component = .minute
                
                if expiration.type.lowercased() == "seconds"
                {
                    expirationDateComponent = .second
                }else if expiration.type.lowercased() == "hours"
                {
                    expirationDateComponent = .hour
                }else if expiration.type.lowercased() == "days"
                {
                    expirationDateComponent = .day
                }
                let expirationDate = calendar.date(byAdding: expirationDateComponent, value: expiration.period, to: currentDate)
                let dateFormatter:DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy @ HH:mm aaa"
                codeExpirationLabel.text = String(format: LocalizationManager.shared.localizedString(for: .async_pay_code_expire_text), dateFormatter.string(from: expirationDate ?? currentDate))
            }else
            {
                codeExpirationLabel.text = ""
            }
            
            
            if let order = nonNullCharge.transactionDetails.order
            {
                codeReferenceLabel.text = order.reference
                storeLinkLabel.text = order.storeUrl
            }else
            {
                codeReferenceLabel.text = ""
            }
            
        }
        
        
        self.closeButton?.isEnabled = true
        self.closeButton?.setup()
    }
    
    @IBAction func openMerchantUrlClicked(_ sender: Any) {
        if let nonNullCharge:ChargeProtocol = Process.shared.dataManagerInterface.currentChargeOrAuthorize
        {
            if let order = nonNullCharge.transactionDetails.order
            {
                if let url = URL(string: order.storeUrl) {
                    if #available(iOS 10.0, *) {
                        if UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.open(url, options:[:], completionHandler: nil)
                        }
                    } else {
                        // Fallback on earlier versions
                        if UIApplication.shared.canOpenURL(url) {
                           UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }
    }
}


extension AsyncPaymentResultView:TapButtonDelegate
{
    var canBeHighlighted: Bool {
        return true
    }
    
    func buttonTouchUpInside() {
        if let nonNullCharge:ChargeProtocol = Process.shared.dataManagerInterface.currentChargeOrAuthorize
        {
           // let charge: = Charge(identifier: "", apiVersion: nonNullCharge.apiVersion, amount: nonNullCharge.amount, currency: nonNullCharge.currency, customer: nonNullCharge.customer, isLiveMode: nonNullCharge.isLiveMode, cardSaved: nonNullCharge.cardSaved, object: nonNullCharge.object, authentication: nonNullCharge.authentication, redirect: nonNullCharge.redirect, post: nonNullCharge.post, card: nonNullCharge.card, source: nonNullCharge.source, destinations: nonNullCharge.destinations, status: nonNullCharge.status, requires3DSecure: nonNullCharge.requires3DSecure, transactionDetails: nonNullCharge.transactionDetails, descriptionText: nonNullCharge.descriptionText, metadata: nonNullCharge.metadata, reference: nonNullCharge.reference, receiptSettings: nonNullCharge.receiptSettings, acquirer: nonNullCharge.acquirer, response: nonNullCharge.response, statementDescriptor: nonNullCharge.statementDescriptor)
            Process.shared.dataManagerInterface.currentChargeOrAuthorize?.status = ChargeStatus.captured
            Process.shared.closePayment(with: .successfulCharge(nonNullCharge as! Charge), fadeAnimation: false, force: false, completion: nil)
        }
    }
    
    func securityButtonTouchUpInside() {}
    
    func disabledButtonTouchUpInside() {}
    
    
}
