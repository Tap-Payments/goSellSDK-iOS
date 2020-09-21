//
//  SessionAppearance.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	UIKit.UIColor.UIColor
import class	UIKit.UIControl.UIControl
import class	UIKit.UIFont.UIFont
import struct	UIKit.UIGeometry.UIEdgeInsets

/// Session appearance protocol.
@objc public protocol SessionAppearance: class, NSObjectProtocol {
	
	// MARK: - Common
	
	/// SDK appearance mode. If not implemented it will be treated as `default`.
	///
	/// - Parameter session: Target session.
	/// - Returns: SDKAppearanceMode
	@objc(appearanceModeForSession:) optional func appearanceMode(for session: SessionProtocol) -> SDKAppearanceMode
	
	/// Defines if success/failure popup appears after the transaction finishes.
	/// Default is `true`.
	///
	/// - Parameter session: Target session.
	/// - Returns: Bool
	@objc(sessionShouldShowStatusPopup:)optional func sessionShouldShowStatusPopup(_ session: SessionProtocol) -> Bool
	
    
    // MARK: - Light Dark Mode
       
       /// Light/Dark mode for the checkout screen
       ///
       /// - Parameters:
       ///   - session: Target session.
       /// - Returns: The selected mode
       @objc(darkLightModeForSession:) optional func darkLightMode(for session: SessionProtocol) -> SDKLightDarkMode
    
    
	// MARK: - Background
	
	/// Background color for payment screen.
	///
	/// - Parameters:
	///   - session: Target session.
	/// - Returns: UIColor
	@objc(backgroundColorForSession:) optional func backgroundColor(for session: SessionProtocol) -> UIColor?
    
    
    
    
	
	/// Content background color for payment screen.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(contentBackgroundColorForSession:) optional func contentBackgroundColor(for session: SessionProtocol) -> UIColor?
	
	/// Background blur style for payment screen.
	///
	/// - Parameters:
	///   - session: Target session.
	/// - Returns: TapBlurEffectStyle
	@objc(backgroundBlurEffectStyleForSession:) optional func backgroundBlurEffectStyle(for session: SessionProtocol) -> TapBlurStyle
	
	/// Background blur *"radius"* progress in range [0, 1]. If you return 0 here, blur will be hidden.
	///
	/// - Parameters:
	///   - session: Target session.
	/// - Returns: CGFloat
	@available(iOS 10.0, *) @objc(backgroundBlurProgressForSession:) optional func backgroundBlurProgress(for session: SessionProtocol) -> CGFloat
	
	// MARK: - Header
	
	/// Font for the header text.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc(headerFontForSession:) optional func headerFont(for session: SessionProtocol) -> UIFont
	
	/// Color for the header text.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(headerTextColorForSession:) optional func headerTextColor(for session: SessionProtocol) -> UIColor?
	
	/// Background color for the header.
	///
	/// In windowed mode this color will be applied immediately, but in fullscreen mode only when there is content *under* the header.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(headerBackgroundColorForSession:) optional func headerBackgroundColor(for session: SessionProtocol) -> UIColor?
	
	/// Header cancel button font.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc(headerCancelButtonFontForSession:) optional func headerCancelButtonFont(for session: SessionProtocol) -> UIFont
	
	/// Header cancel button text color.
	///
	/// - Parameters:
	///   - state: Control state. Either `normal` or `highlighted`.
	///   - session: Target session.
	/// - Returns: UIColor
	@objc(headerCancelButtonTextColorForState:session:) optional func headerCancelButtonTextColor(for state: UIControl.State, session: SessionProtocol) -> UIColor?
	
	// MARK: - Card Input Fields
	
	/// Card input fields font.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc(cardInputFieldsFontForSession:) optional func cardInputFieldsFont(for session: SessionProtocol) -> UIFont
	
	/// Card input fields text color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputFieldsTextColorForSession:) optional func cardInputFieldsTextColor(for session: SessionProtocol) -> UIColor?
	
	/// Card input fields placeholder color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputFieldsPlaceholderColorForSession:) optional func cardInputFieldsPlaceholderColor(for session: SessionProtocol) -> UIColor?
	
	/// Card input fields invalid text color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputFieldsInvalidTextColorForSession:) optional func cardInputFieldsInvalidTextColor(for session: SessionProtocol) -> UIColor?
	
	// MARK: Card Input Description
	
	/// Card input fields description font.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc(cardInputDescriptionFontForSession:) optional func cardInputDescriptionFont(for session: SessionProtocol) -> UIFont
	
	/// Card input fields description text color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputDescriptionTextColorForSession:) optional func cardInputDescriptionTextColor(for session: SessionProtocol) -> UIColor?
	
	/// Card input save card switch off tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputSaveCardSwitchOffTintColorForSession:) optional func cardInputSaveCardSwitchOffTintColor(for session: SessionProtocol) -> UIColor?
	
	/// Card input save card switch on tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputSaveCardSwitchOnTintColorForSession:) optional func cardInputSaveCardSwitchOnTintColor(for session: SessionProtocol) -> UIColor?
	
	/// Card input save card switch thumb tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputSaveCardSwitchThumbTintColorForSession:) optional func cardInputSaveCardSwitchThumbTintColor(for session: SessionProtocol) -> UIColor?
	
	/// Card input scan icon frame tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputScanIconFrameTintColorForSession:) optional func cardInputScanIconFrameTintColor(for session: SessionProtocol) -> UIColor?
	
	/// Card input scan icon tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc(cardInputScanIconTintColorForSession:) optional func cardInputScanIconTintColor(for session: SessionProtocol) -> UIColor?
	
	// MARK: Pay/Save Button
	
	/// Pay/Save button background color for the given `state`.
	///
	/// - Parameters:
	///   - state: Control state.
	///   - session: Target session.
	/// - Returns: UIColor
	@objc(tapButtonBackgroundColorForState:session:) optional func tapButtonBackgroundColor(for state: UIControl.State, session: SessionProtocol) -> UIColor?
	
	/// Pay/Save button font.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc(tapButtonFontForSession:) optional func tapButtonFont(for session: SessionProtocol) -> UIFont
	
	/// Pay/Save button text color for the given `state`.
	///
	/// - Parameters:
	///   - state: Control state.
	///   - session: Target session.
	/// - Returns: UIColor
	@objc(tapButtonTextColorForState:session:) optional func tapButtonTextColor(for state: UIControl.State, session: SessionProtocol) -> UIColor?
	
	/// Pay/Save button corner radius.
	///
	/// - Parameter session: Target session.
	/// - Returns: CGFloat
	@objc(tapButtonCornerRadiusForSession:) optional func tapButtonCornerRadius(for session: SessionProtocol) -> CGFloat
	
	/// Defines if loader is visible on Pay/Save button.
	///
	/// - Parameter session: Target session.
	/// - Returns: Bool
	@objc(isLoaderVisibleOnTapButttonForSession:) optional func isLoaderVisibleOnTapButtton(for session: SessionProtocol) -> Bool
	
	/// Defines if security icon is visible on Pay/Save button.
	///
	/// - Parameter session: Target session.
	/// - Returns: Bool
	@objc(isSecurityIconVisibleOnTapButtonForSession:) optional func isSecurityIconVisibleOnTapButton(for session: SessionProtocol) -> Bool
	
	/// Pay/Save button insets on payment/card saving screen from the edges (left, right and bottom) of the screen and content.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIEdgeInsets
	@objc(tapButtonInsetsForSession:) optional func tapButtonInsets(for session: SessionProtocol) -> UIEdgeInsets
	
	/// Pay/Save button height on payment/card saving screen.
	///
	/// - Parameter session: Target session.
	/// - Returns: CGFloat
	@objc(tapButtonHeightForSession:) optional func tapButtonHeight(for session: SessionProtocol) -> CGFloat
}
