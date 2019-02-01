//
//  SessionAppearance.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGFloat
import class	UIKit.UIColor.UIColor
import class	UIKit.UIControl.UIControl
import class	UIKit.UIFont.UIFont

@objc public protocol SessionAppearance: class, NSObjectProtocol {
	
	// MARK: - Common
	
	/// SDK appearance mode. If not implemented it will be treated as `default`.
	///
	/// - Parameter session: Target session.
	/// - Returns: SDKAppearanceMode
	@objc optional func appearanceMode(for session: SessionProtocol) -> SDKAppearanceMode
	
	/// Defines if success/failure popup appears after the transaction finishes.
	/// Default is `true`.
	///
	/// - Parameter session: Target session.
	/// - Returns: Bool
	@objc optional func sessionShouldShowStatusPopup(_ session: SessionProtocol) -> Bool
	
	// MARK: - Card Input Fields
	
	/// Card input fields font.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc optional func cardInputFieldsFont(for session: SessionProtocol) -> UIFont
	
	/// Card input fields text color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputFieldsTextColor(for session: SessionProtocol) -> UIColor
	
	/// Card input fields placeholder color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputFieldsPlaceholderColor(for session: SessionProtocol) -> UIColor
	
	/// Card input fields invalid text color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputFieldsInvalidTextColor(for session: SessionProtocol) -> UIColor
	
	// MARK: Card Input Description
	
	/// Card input fields description font.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc optional func cardInputDescriptionFont(for session: SessionProtocol) -> UIFont
	
	/// Card input fields description text color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputDescriptionTextColor(for session: SessionProtocol) -> UIColor
	
	/// Card input save card switch off tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputSaveCardSwitchOffTintColor(for session: SessionProtocol) -> UIColor
	
	/// Card input save card switch on tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputSaveCardSwitchOnTintColor(for session: SessionProtocol) -> UIColor
	
	/// Card input save card switch thumb tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputSaveCardSwitchThumbTintColor(for session: SessionProtocol) -> UIColor
	
	/// Card input scan icon frame tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputScanIconFrameTintColor(for session: SessionProtocol) -> UIColor
	
	/// Card input scan icon tint color.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIColor
	@objc optional func cardInputScanIconTintColor(for session: SessionProtocol) -> UIColor
	
	// MARK: Pay/Save Button
	
	/// Pay/Save button background color for the given `state`.
	///
	/// - Parameters:
	///   - state: Control state.
	///   - session: Target session.
	/// - Returns: UIColor
	@objc optional func tapButtonBackgroundColor(for state: UIControl.State, for session: SessionProtocol) -> UIColor?
	
	/// Pay/Save button font.
	///
	/// - Parameter session: Target session.
	/// - Returns: UIFont
	@objc optional func tapButtonFont(for session: SessionProtocol) -> UIFont
	
	/// Pay/Save button text color for the given `state`.
	///
	/// - Parameters:
	///   - state: Control state.
	///   - session: Target session.
	/// - Returns: UIColor
	@objc optional func tapButtonTextColor(for state: UIControl.State, for session: SessionProtocol) -> UIColor?
	
	/// Pay/Save button corner radius.
	///
	/// - Parameter session: Target session.
	/// - Returns: CGFloat
	@objc optional func tapButtonCornerRadius(for session: SessionProtocol) -> CGFloat
	
	/// Defines if loader is visible on Pay/Save button.
	///
	/// - Parameter session: Target session.
	/// - Returns: Bool
	@objc optional func isLoaderVisibleOnTapButtton(for session: SessionProtocol) -> Bool
	
	/// Defines if security icon is visible on Pay/Save button.
	///
	/// - Parameter session: Target session.
	/// - Returns: Bool
	@objc optional func isSecurityIconVisibleOnTapButton(for session: SessionProtocol) -> Bool
}
