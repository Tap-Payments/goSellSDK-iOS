//
//  TapAlertController.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	TapAdditionsKitV2.SeparateWindowRootViewController
import struct	TapAdditionsKitV2.TypeAlias
import struct	TapBundleLocalization.LocalizationKey
import class	UIKit.UIAlertController.UIAlertAction
import class	UIKit.UIAlertController.UIAlertController
import enum		UIKit.UIApplication.UIStatusBarStyle

internal final class TapAlertController: UIAlertController {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal override var preferredStatusBarStyle: UIStatusBarStyle {
		
		return .lightContent
	}
	
	internal override var modalPresentationCapturesStatusBarAppearance: Bool {
		
		get {
			
			return true
		}
		set {
			
			super.modalPresentationCapturesStatusBarAppearance = true
		}
	}
	
	// MARK: Methods
	//Added override to the func header to fix the init issues - Floward tech Team
	internal convenience init(titleKey: LocalizationKey?, messageKey: LocalizationKey?, preferredStyle: Style, override: Bool = true) {
		
		self.init(titleKey: titleKey, messageKey: messageKey, [], preferredStyle: preferredStyle)
	}
	
	internal convenience init(titleKey: LocalizationKey?, messageKey: LocalizationKey?, _ messageArguments: CVarArg..., preferredStyle: Style) {
		
		self.init(title: nil, message: nil, preferredStyle: preferredStyle)
		
		self.setLocalizedText(for: .title, key: titleKey)
		
		if messageArguments.count > 0 {
			
			self.setLocalizedText(for: .message, key: messageKey, arguments: messageArguments)
		}
		else {
			
			self.setLocalizedText(for: .message, key: messageKey)
		}
	}
	
	@available(*, unavailable)
	internal override func addAction(_ action: UIAlertAction) {}
	
	internal func addAction(_ action: Action) {
		
		super.addAction(action)
	}
	
	internal func show() {
		
		let appearanceClosure: TypeAlias.GenericViewControllerClosure<SeparateWindowRootViewController> = { [unowned self] rootController in
			
			let supportedOrientations	= InterfaceOrientationManager.shared.supportedInterfaceOrientations(for: rootController)
			let canAutorotate			= InterfaceOrientationManager.shared.viewControllerShouldAutorotate(rootController)
			let preferredOrientation	= InterfaceOrientationManager.shared.preferredInterfaceOrientationForPresentation(of: rootController)
			
			rootController.canAutorotate					= canAutorotate
			rootController.allowedInterfaceOrientations		= supportedOrientations
			rootController.preferredInterfaceOrientation	= preferredOrientation
			
			rootController.present(self, animated: true, completion: nil)
		}
		
		DispatchQueue.main.async {
			
			self.tap_showOnSeparateWindow(below: .tap_statusBar, using: appearanceClosure)
		}
	}
	
	internal func hide(_ completion: TypeAlias.ArgumentlessClosure? = nil) {
		
		DispatchQueue.main.async {
			
			self.tap_dismissFromSeparateWindow(true, completion: completion)
		}
	}
}

// MARK: - Localizable
extension TapAlertController: Localizable {
	
	internal typealias LocalizableElement = LocalizationElement
	
	internal enum LocalizationElement {
		
		case title
		case message
	}
	
	internal func setLocalized(text: String?, for element: LocalizationElement) {
		
		switch element {
			
		case .title:	self.title 		= text
		case .message: 	self.message	= text
			
		}
	}
}

/// - MARK: TapAlertController.Action
internal extension TapAlertController {
	
	class Action: UIAlertAction {
		
		internal convenience init(titleKey: LocalizationKey?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
			
			var titleText: String? = nil
			if let nonnullTitle = titleKey {
				
				titleText = LocalizationManager.shared.localizedString(for: nonnullTitle)
			}
			
			self.init(title: titleText, style: style, handler: handler)
		}
	}
}
