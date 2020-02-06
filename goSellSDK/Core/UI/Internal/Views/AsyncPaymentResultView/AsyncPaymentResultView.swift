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
    @IBOutlet weak var acknolwedgementLabel: UILabel!
    @IBOutlet weak var orderCodeTitleLabel: UILabel!
    @IBOutlet weak var codeReferenceLabel: UILabel!
    @IBOutlet weak var codeExpirationLabel: UILabel!
    @IBOutlet weak var hintFooterLabel: UILabel!
    @IBOutlet weak var closeButton: TapButton!
    @IBOutlet weak var storeLinkLabel: UILabel!
    
     internal override class var bundle: Bundle {
		   
		   return .goSellSDKResources
	   }

    override init(frame: CGRect) {

        super.init(frame: frame)
        self.closeButton?.setLocalizedText(.btn_async_title)
        self.closeButton?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == .async })!
        self.updateLabels()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override internal func setup() {
        super.setup()
    }
    
     private func updateLabels() {
        
        paymentStatusLabel.setLocalizedText(.async_status_text)
        orderCodeTitleLabel.setLocalizedText(.async_pay_order_code_text)
        
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
                dateFormatter.dateFormat = "dd/MM/yyyy @ HH:mmm aaa"
                codeExpirationLabel.text = String(format: LocalizationManager.shared.localizedString(for: .async_pay_code_expire_text), dateFormatter.string(from: expirationDate ?? currentDate))
            }else
            {
                codeExpirationLabel.text = ""
            }
            
            
            if let order = nonNullCharge.transactionDetails.order
            {
                codeReferenceLabel.text = order.reference
            }else
            {
                codeReferenceLabel.text = ""
            }
            
        }
        
        
        
        
        
           /*guard let nonnullLabel = self.descriptionLabel, self.phoneNumber.tap_length > 0 else { return }
           
           let numberString = "\u{202A}\(self.phoneNumber)\u{202C}"
           
           let descriptionText = String(format: LocalizationManager.shared.localizedString(for: .otp_guide_text), numberString)
           
           let themeSettings = Theme.current.otpScreenStyle
           
           let descriptionAttributes = themeSettings.descriptionText.asStringAttributes
           
           let attributedDescriptionText = NSMutableAttributedString(string: descriptionText, attributes: descriptionAttributes)
           
           if let range = attributedDescriptionText.string.tap_nsRange(of: numberString) {
               
               let numberAttributes = themeSettings.descriptionNumber.asStringAttributes
               
               let attributedMaskedNumberText = NSAttributedString(string: numberString, attributes: numberAttributes)
               
               attributedDescriptionText.replaceCharacters(in: range, with: attributedMaskedNumberText)
           }
           
           nonnullLabel.attributedText = NSAttributedString(attributedString: attributedDescriptionText)*/
       }
}
