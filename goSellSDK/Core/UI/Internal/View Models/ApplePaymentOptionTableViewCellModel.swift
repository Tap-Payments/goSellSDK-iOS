//
//  ApplePaymentOptionTableViewCellModel.swift
//  goSellSDK
//
//  Created by Osama Rabie on 07/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import Foundation
import UIKit

import TapCardVlidatorKit_iOS
import class TapNetworkManagerV2.TapImageLoader
import class UIKit.UIImage.UIImage
import enum PassKit.PKPaymentButtonType
import enum PassKit.PKPaymentButtonStyle
import class PassKit.PKPaymentAuthorizationController
import struct PassKit.PKPaymentNetwork

internal class ApplePaymentOptionTableViewCellModel: PaymentOptionTableCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var title: String {
        
        return self.paymentOption.title
    }
    
    internal var iconImageURL: URL {
        
        return self.paymentOption.imageURL
    }
    
    internal override var paymentOption: PaymentOption {
        
        return self.storedPaymentOption
    }
    
    internal private(set) var iconImage: UIImage?
    
    internal weak var cell: ApplePayTableViewCell? {
        
        didSet {
            
            self.loadImageAndUpdateCell()
        }
    }
    
    internal var arrowImage: UIImage {
		
		return Theme.current.commonStyle.icons.arrowRight
    }
    
    internal override var isReadyForPayment: Bool {
        
        return true
    }
    
    internal override var affectsPayButtonState: Bool {
        
        return false
    }
    
    internal override var initiatesPaymentOnSelection: Bool {
        
        return true
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath, paymentOption: PaymentOption) {
        
        self.storedPaymentOption = paymentOption
        
        super.init(indexPath: indexPath)
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private let storedPaymentOption: PaymentOption
    
    // MARK: Methods
    
    private func loadImageAndUpdateCell() {
        
        TapImageLoader.shared.downloadImage(from: self.iconImageURL) { [weak self] (image, _) in
            
            guard let strongSelf = self else { return }
            
            if let nonnullImage = image {
                
                strongSelf.iconImage = nonnullImage
                strongSelf.updateCell()
            }
        }
    }
    
    
    internal var applePayMappedSupportedNetworks: [PKPaymentNetwork] {
        get{
            var applePayMappedSupportedNetworks:[PKPaymentNetwork] = []
            applePayMappedSupportedNetworks.append(contentsOf: paymentOption.applePayNetworkMapper())
            return applePayMappedSupportedNetworks.removingDuplicates()
        }
    }
}

// MARK: - SingleCellModel
extension ApplePaymentOptionTableViewCellModel: SingleCellModel {
    
    func applePayButtonType() -> PKPaymentButtonType
    {
        var applPayButtonType:PKPaymentButtonType = .plain
        if #available(iOS 10.0, *) {
            applPayButtonType = .inStore
        }
        
        /*if let session = Process.shared.externalSession, let sessionDatSource = session.dataSource
        {
            if let dataSourceApplePayButtonType = sessionDatSource.applePayButtonType
            {
                applPayButtonType = dataSourceApplePayButtonType
            }
        }*/
        // First we check if we need to show setup pay
        if isApplePayNeedsSetup() {
            applPayButtonType = .setUp
        }
        return applPayButtonType
    }
    
    
    func isApplePayNeedsSetup() -> Bool {
        guard ApplePayAvailability.canMakePayments else {
            return true
        }
        
        guard ApplePayAvailability.canMakePayments(usingNetworks: self.applePayMappedSupportedNetworks) else {
            return true
        }

        return false
    }
    
    
    func applePayButtonTypeStyle() -> PKPaymentButtonStyle
    {
        // First we set the default apple pay button style
        var applPayButtonStyle:PKPaymentButtonStyle = .whiteOutline
        
        if #available(iOS 13.0, *) {
            if Process.shared.externalSession?.dataSource?.uiModeDisplay?.userInterface == .dark
            {
                applPayButtonStyle = .white
            }
       }
        
        if let session = Process.shared.externalSession, let sessionDatSource = session.dataSource
        {
            if let dataSourceApplePayStyle = sessionDatSource.applePayButtonStyle
            {
                applPayButtonStyle = dataSourceApplePayStyle
            }
        }
        
        return applPayButtonStyle
    }
}

// MARK: - Apple Pay availability

/// Whether Apple Pay can be used, looked up once per payment session off the main thread.
///
/// `canMakePayments` asks PassKit through a synchronous XPC call. It is usually quick, but when
/// PassKit is slow to answer it blocks the caller, and the payment sheet used to ask it on the main
/// thread on every Apple Pay cell update, which froze the UI. Now each answer is looked up once on a
/// background queue (started early by `prefetch()`), and a main-thread read waits for it at most
/// `maximalWait`. If PassKit hasn't answered by then, Apple Pay is treated as unavailable until it does.
internal enum ApplePayAvailability {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Whether the device supports Apple Pay with any card network.
    internal static var canMakePayments: Bool {
        
        return self.value(for: Constants.anyNetworkKey) { PKPaymentAuthorizationController.canMakePayments() }
    }
    
    // MARK: Methods
    
    /// Whether the user has a card in Wallet for one of the given networks.
    internal static func canMakePayments(usingNetworks networks: [PKPaymentNetwork]) -> Bool {
        
        let key = networks.map { $0.rawValue }.sorted().joined(separator: ",")
        return self.value(for: key) { PKPaymentAuthorizationController.canMakePayments(usingNetworks: networks) }
    }
    
    /// Forgets the previous answers and starts looking up `canMakePayments` in the background.
    /// Called when a payment session starts, so the answer is usually ready before the sheet needs it.
    internal static func prefetch() {
        
        self.lock.lock()
        self.lookups.removeAll()
        self.lock.unlock()
        
        _ = self.lookup(for: Constants.anyNetworkKey) { PKPaymentAuthorizationController.canMakePayments() }
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let anyNetworkKey = "*"
        
        /// The longest a caller waits for PassKit before treating Apple Pay as unavailable.
        fileprivate static let maximalWait: DispatchTimeInterval = .milliseconds(500)
        
        @available(*, unavailable) private init() {}
    }
    
    private final class Lookup {
        
        fileprivate let group = DispatchGroup()
        fileprivate var value: Bool?
        fileprivate var didTimeOut = false
    }
    
    // MARK: Properties
    
    private static let lock = NSLock()
    private static var lookups: [String: Lookup] = [:]
    
    // MARK: Methods
    
    private static func value(for key: String, compute: @escaping () -> Bool) -> Bool {
        
        let lookup = self.lookup(for: key, compute: compute)
        
        self.lock.lock()
        let alreadyTimedOut = lookup.didTimeOut
        self.lock.unlock()
        
        // Wait for PassKit only the first time; after a timeout, answer without waiting until it replies.
        if !alreadyTimedOut, lookup.group.wait(timeout: .now() + Constants.maximalWait) == .timedOut {
            
            self.lock.lock()
            lookup.didTimeOut = true
            self.lock.unlock()
        }
        
        self.lock.lock()
        defer { self.lock.unlock() }
        
        return lookup.value ?? false
    }
    
    private static func lookup(for key: String, compute: @escaping () -> Bool) -> Lookup {
        
        self.lock.lock()
        
        if let existing = self.lookups[key] {
            
            self.lock.unlock()
            return existing
        }
        
        let lookup = Lookup()
        lookup.group.enter()
        self.lookups[key] = lookup
        self.lock.unlock()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let value = compute()
            
            self.lock.lock()
            lookup.value = value
            self.lock.unlock()
            
            lookup.group.leave()
        }
        
        return lookup
    }
}
