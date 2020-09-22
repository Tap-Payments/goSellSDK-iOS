//
//  AsyncResponseViewController.swift
//  goSellSDK
//
//  Created by Osama Rabie on 11/02/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
import struct   TapAdditionsKitV2.TypeAlias
import class    TapVisualEffectViewV2.TapVisualEffectView

internal final class AsyncResponseViewController: SeparateWindowViewController {
    
    
    @IBOutlet weak var headerVieq: TapNavigationView!
    private var chargeProtocol:ChargeProtocol?
    private var paymentOption:PaymentOption?
    private static var storage: AsyncResponseViewController?
    
    @IBOutlet private weak var contentViewTopOffsetConstraint: NSLayoutConstraint?
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var acknolwedgementLabel: UILabel!
    @IBOutlet weak var orderCodeTitleLabel: UILabel!
    @IBOutlet weak var codeReferenceLabel: UILabel!
    @IBOutlet weak var codeExpirationLabel: UILabel!
    @IBOutlet weak var hintFooterLabel: UILabel!
    @IBOutlet weak var blurView: TapVisualEffectView!
    
    @IBOutlet weak var closeButton: TapButton!{
        
        didSet {
            
            if let nonnullPayButton = self.closeButton {
                
                Process.shared.buttonHandlerInterface.setButton(nonnullPayButton)
            }
        }
    }
    @IBOutlet weak var storeLinkLabel: UILabel!
    
    @IBOutlet var asyncResponseLabels: [UILabel]!
    
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return Theme.current.commonStyle.statusBar[.fullscreen].uiStatusBarStyle
    }
    
    
    // MARK: Methods
    
    internal static func show(with topOffset: CGFloat = 0.0, with chargeProtocol: ChargeProtocol, for paymentOption:PaymentOption) {
        
        let controller = self.createAndSetupController()
        controller.chargeProtocol = chargeProtocol
        controller.paymentOption = paymentOption
        controller.showExternally(topOffset: topOffset)
    }
    
    
    private static func createAndSetupController() -> AsyncResponseViewController {
        
        KnownStaticallyDestroyableTypes.add(AsyncResponseViewController.self)
        let controller = self.shared
        controller.modalPresentationStyle = .custom
        return controller
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        headerVieq.dataSource = self
        headerVieq.closeButtonContainerView?.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    internal func setupUI()
    {
        self.closeButton?.setLocalizedText(.btn_async_title)
        self.closeButton?.themeStyle = Theme.current.buttonStyles.first(where: { $0.type == .async })!
        self.updateLabels()
        self.closeButton?.isEnabled = true
        self.closeButton?.delegate = self
        headerVieq.setStyle(Theme.current.navigationBarStyle)
        blurView.style = Theme.current.commonStyle.blurStyle[Process.shared.appearance].style
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ThemeManager.shared.resetCurrentThemeToDefault()
        setupUI()
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// MARK: - InstantiatableFromStoryboard
extension AsyncResponseViewController: InstantiatableFromStoryboard {
    
    internal static var hostingStoryboard: UIStoryboard {
        
        return .goSellSDKPayment
    }
}

// MARK: - Singleton
extension AsyncResponseViewController: Singleton {
    
    internal static var shared: AsyncResponseViewController {
        
        if let nonnullStorage = self.storage {
            
            return nonnullStorage
        }
        
        let instance = AsyncResponseViewController.instantiate()
        
        self.storage = instance
        
        return instance
    }
}
extension AsyncResponseViewController: PopupPresentationSupport {
    
    internal var presentationAnimationAnimatingConstraint: NSLayoutConstraint? {
        
        return self.contentViewTopOffsetConstraint
    }
    
    internal var viewToLayout: UIView {
        
        return self.view
    }
}


extension AsyncResponseViewController: DelayedDestroyable {
    
    internal static var hasAliveInstance: Bool {
        
        return self.storage != nil
    }
    
    internal static func destroyInstance(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
        
        if let nonnullStorage = self.storage {
            
            nonnullStorage.hide(animated: true,async: true) {
                
                self.storage = nil
                KnownStaticallyDestroyableTypes.delayedDestroyableInstanceDestroyed()
                completion?()
            }
        }
        else {
            
            completion?()
        }
    }
}



extension AsyncResponseViewController:TapButtonDelegate
{
    var canBeHighlighted: Bool {
        return true
    }
    
    func buttonTouchUpInside() {
        if let nonNullCharge:ChargeProtocol = Process.shared.dataManagerInterface.currentChargeOrAuthorize
        {
            Process.shared.dataManagerInterface.currentChargeOrAuthorize?.status = ChargeStatus.captured
            //AsyncResponseViewController.destroyInstance()
            Process.shared.closePayment(with: .successfulCharge(nonNullCharge as! Charge), fadeAnimation: false, force: false, completion: nil)
        }
    }
    
    func securityButtonTouchUpInside() {}
    
    func disabledButtonTouchUpInside() {}
    
    
}


extension AsyncResponseViewController:TapNavigationViewDataSource
{
    func navigationViewIconPlaceholder(for navigationView: TapNavigationView) -> Image? {
        nil
    }
    
    func navigationViewIcon(for navigationView: TapNavigationView) -> Image? {
        if let imageURL =  self.paymentOption?.imageURL {
            
            return .remote(imageURL)
        }
        else {
            
            return nil
        }
    }
    
    func navigationViewTitle(for navigationView: TapNavigationView) -> String? {
        if let paymentName =  self.paymentOption?.title {
            
            return paymentName
        }
        else {
            
            return ""
        }
    }
    
    func navigationViewCanGoBack(_ navigationView: TapNavigationView) -> Bool {
        false
    }
    
}
