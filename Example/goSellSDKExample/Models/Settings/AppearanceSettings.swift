//
//  AppearanceSettings.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGFloat
import enum		goSellSDK.SDKAppearanceMode
import class	goSellSDK.TapBlurStyle
import struct	UIKit.UIGeometry.UIEdgeInsets

internal struct AppearanceSettings: Encodable {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal static let `default` = AppearanceSettings(appearanceMode:							.default,
													   showsStatusPopup:						true,
													   headerFont:								"Helvetica Neue",
													   headerTextColor:							.custom("#535353"),
													   headerBackgroundColor:					.custom("#f7f7f7"),
													   headerCancelFont:						"Helvetica Neue",
													   headerCancelNormalTextColor:				.custom("#535353"),
													   headerCancelHighlightedTextColor:		.black,
													   cardInputFont:							"Helvetica Neue",
													   cardInputTextColor:						.custom("#535353"),
													   cardInputInvalidTextColor:				.custom("#ee0000"),
													   cardInputPlaceholderTextColor:			.custom("#bdbdbd"),
													   cardInputDescriptionFont:				"Helvetica Neue",
													   cardInputDescriptionTextColor:			.custom("#5c5c5c"),
													   cardInputSaveCardSwitchOffTintColor:		.none,
													   cardInputSaveCardSwitchOnTintColor:		.custom("#2ace00"),
													   cardInputSaveCardSwitchThumbTintColor:	.none,
													   cardInputScanIconFrameTintColor:			.none,
													   cardInputScanIconTintColor:				.none,
													   tapButtonDisabledBackgroundColor:		nil,
													   tapButtonEnabledBackgroundColor:			nil,
													   tapButtonHighlightedBackgroundColor:		nil,
													   tapButtonFont:							"Helvetica Neue",
													   tapButtonDisabledTextColor:				nil,
													   tapButtonEnabledTextColor:				nil,
													   tapButtonHighlightedTextColor:			nil,
													   tapButtonCornerRadius:					22.0,
													   isTapButtonLoaderVisible:				true,
													   isTapButtonSecurityIconVisible:			true,
													   tapButtonHeight:							44.0,
													   tapButtonEdgeInsets:						UIEdgeInsets(tap_inset: 8.0),
													   backgroundColor:							.clear,
													   contentBackgroundColor:					.clear,
													   backgroundBlurStyle:						.extraLight,
													   backgroundBlurProgress:					1.0)
	
	// Common
	
	internal var appearanceMode: SDKAppearanceMode
	
	internal var showsStatusPopup: Bool
	
	// Appearance: Background
	
	internal var backgroundColor: Color
	
	internal var contentBackgroundColor: Color
	
	internal var backgroundBlurStyle: TapBlurStyle
	
	internal var backgroundBlurProgress: CGFloat
	
	// Appearance: Header
	
	internal var headerFont: String
	
	internal var headerTextColor: Color
	
	internal var headerBackgroundColor: Color
	
	internal var headerCancelFont: String
	
	internal var headerCancelNormalTextColor: Color
	
	internal var headerCancelHighlightedTextColor: Color
	
	// Appearance: Card Input
	
	internal var cardInputFont: String
	
	internal var cardInputTextColor: Color
	
	internal var cardInputInvalidTextColor: Color
	
	internal var cardInputPlaceholderTextColor: Color
	
	internal var cardInputDescriptionFont: String
	
	internal var cardInputDescriptionTextColor: Color
	
	internal var cardInputSaveCardSwitchOffTintColor: Color
	
	internal var cardInputSaveCardSwitchOnTintColor: Color
	
	internal var cardInputSaveCardSwitchThumbTintColor: Color
	
	internal var cardInputScanIconFrameTintColor: Color
	
	internal var cardInputScanIconTintColor: Color?
	
	// Appearance: Tap Button
	
	internal var tapButtonDisabledBackgroundColor: Color?
	
	internal var tapButtonEnabledBackgroundColor: Color?
	
	internal var tapButtonHighlightedBackgroundColor: Color?
	
	internal var tapButtonFont: String
	
	internal var tapButtonDisabledTextColor: Color?
	
	internal var tapButtonEnabledTextColor: Color?
	
	internal var tapButtonHighlightedTextColor: Color?
	
	internal var tapButtonCornerRadius: CGFloat
	
	internal var isTapButtonLoaderVisible: Bool
	
	internal var isTapButtonSecurityIconVisible: Bool
	
	internal var tapButtonHeight: CGFloat
	
	internal var tapButtonEdgeInsets: UIEdgeInsets
	
	// MARK: Methods
	
	internal init(appearanceMode:							SDKAppearanceMode,
				  showsStatusPopup:							Bool,
				  headerFont:								String,
				  headerTextColor:							Color,
				  headerBackgroundColor:					Color,
				  headerCancelFont:							String,
				  headerCancelNormalTextColor:				Color,
				  headerCancelHighlightedTextColor:			Color,
				  cardInputFont:							String,
				  cardInputTextColor:						Color,
				  cardInputInvalidTextColor:				Color,
				  cardInputPlaceholderTextColor:			Color,
				  cardInputDescriptionFont:					String,
				  cardInputDescriptionTextColor:			Color,
				  cardInputSaveCardSwitchOffTintColor:		Color,
				  cardInputSaveCardSwitchOnTintColor:		Color,
				  cardInputSaveCardSwitchThumbTintColor:	Color,
				  cardInputScanIconFrameTintColor:			Color,
				  cardInputScanIconTintColor:				Color?,
				  tapButtonDisabledBackgroundColor:			Color?,
				  tapButtonEnabledBackgroundColor:			Color?,
				  tapButtonHighlightedBackgroundColor:		Color?,
				  tapButtonFont:							String,
				  tapButtonDisabledTextColor:				Color?,
				  tapButtonEnabledTextColor:				Color?,
				  tapButtonHighlightedTextColor:			Color?,
				  tapButtonCornerRadius:					CGFloat,
				  isTapButtonLoaderVisible:					Bool,
				  isTapButtonSecurityIconVisible:			Bool,
				  tapButtonHeight:							CGFloat,
				  tapButtonEdgeInsets:						UIEdgeInsets,
				  backgroundColor:							Color,
				  contentBackgroundColor:					Color,
				  backgroundBlurStyle:						TapBlurStyle,
				  backgroundBlurProgress:					CGFloat) {
		
		self.appearanceMode							= appearanceMode
		self.showsStatusPopup						= showsStatusPopup
		self.headerFont								= headerFont
		self.headerTextColor						= headerTextColor
		self.headerBackgroundColor					= headerBackgroundColor
		self.headerCancelFont						= headerCancelFont
		self.headerCancelNormalTextColor			= headerCancelNormalTextColor
		self.headerCancelHighlightedTextColor		= headerCancelHighlightedTextColor
		self.cardInputFont							= cardInputFont
		self.cardInputTextColor						= cardInputTextColor
		self.cardInputInvalidTextColor				= cardInputInvalidTextColor
		self.cardInputPlaceholderTextColor			= cardInputPlaceholderTextColor
		self.cardInputDescriptionFont				= cardInputDescriptionFont
		self.cardInputDescriptionTextColor			= cardInputDescriptionTextColor
		self.cardInputSaveCardSwitchOffTintColor	= cardInputSaveCardSwitchOffTintColor
		self.cardInputSaveCardSwitchOnTintColor		= cardInputSaveCardSwitchOnTintColor
		self.cardInputSaveCardSwitchThumbTintColor	= cardInputSaveCardSwitchThumbTintColor
		self.cardInputScanIconFrameTintColor		= cardInputScanIconFrameTintColor
		self.cardInputScanIconTintColor				= cardInputScanIconTintColor
		self.tapButtonDisabledBackgroundColor		= tapButtonDisabledBackgroundColor
		self.tapButtonEnabledBackgroundColor		= tapButtonEnabledBackgroundColor
		self.tapButtonHighlightedBackgroundColor	= tapButtonHighlightedBackgroundColor
		self.tapButtonFont							= tapButtonFont
		self.tapButtonDisabledTextColor				= tapButtonDisabledTextColor
		self.tapButtonEnabledTextColor				= tapButtonEnabledTextColor
		self.tapButtonHighlightedTextColor			= tapButtonHighlightedTextColor
		self.tapButtonCornerRadius					= tapButtonCornerRadius
		self.isTapButtonLoaderVisible				= isTapButtonLoaderVisible
		self.isTapButtonSecurityIconVisible			= isTapButtonSecurityIconVisible
		self.tapButtonHeight						= tapButtonHeight
		self.tapButtonEdgeInsets					= tapButtonEdgeInsets
		self.backgroundColor						= backgroundColor
		self.contentBackgroundColor					= contentBackgroundColor
		self.backgroundBlurStyle					= backgroundBlurStyle
		self.backgroundBlurProgress					= backgroundBlurProgress
	}
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case appearanceMode							= "appearance_mode"
		case showsStatusPopup						= "shows_status_popup"
		case headerFont								= "header_font"
		case headerTextColor						= "header_text_color"
		case headerBackgroundColor					= "header_background_color"
		case headerCancelFont						= "header_cancel_font"
		case headerCancelNormalTextColor			= "header_cancel_normal_text_color"
		case headerCancelHighlightedTextColor		= "header_cancel_highlighted_text_color"
		case cardInputFont							= "card_input_font"
		case cardInputTextColor						= "card_input_text_color"
		case cardInputInvalidTextColor				= "card_input_invalid_text_color"
		case cardInputPlaceholderTextColor			= "card_input_placeholder_text_color"
		case cardInputDescriptionFont				= "card_input_description_font"
		case cardInputDescriptionTextColor			= "card_input_description_text_color"
		case cardInputSaveCardSwitchOffTintColor	= "card_input_save_card_switch_off_tint_color"
		case cardInputSaveCardSwitchOnTintColor		= "card_input_save_card_switch_on_tint_color"
		case cardInputSaveCardSwitchThumbTintColor	= "card_input_save_card_switch_thumb_tint_color"
		case cardInputScanIconFrameTintColor		= "card_input_scan_icon_frame_tint_color"
		case cardInputScanIconTintColor				= "card_input_scan_icon_tint_color"
		case tapButtonDisabledBackgroundColor		= "tap_button_disabled_background_color"
		case tapButtonEnabledBackgroundColor		= "tap_button_enabled_background_color"
		case tapButtonHighlightedBackgroundColor	= "tap_button_highlighted_background_color"
		case tapButtonFont							= "tap_button_font"
		case tapButtonDisabledTextColor				= "tap_button_disabled_text_color"
		case tapButtonEnabledTextColor				= "tap_button_enabled_text_color"
		case tapButtonHighlightedTextColor			= "tap_button_highlighted_text_color"
		case tapButtonCornerRadius					= "tap_button_corner_radius"
		case isTapButtonLoaderVisible				= "tap_button_loader_visible"
		case isTapButtonSecurityIconVisible			= "tap_button_security_icon_visible"
		case tapButtonHeight						= "tap_button_height"
		case tapButtonEdgeInsets					= "tap_button_edge_insets"
		case backgroundColor						= "background_color"
		case contentBackgroundColor					= "content_background_color"
		case backgroundBlurStyle					= "background_blur_style"
		case backgroundBlurProgress					= "background_blur_progress"
	}
}

extension AppearanceSettings: Decodable {
	
	internal init(from decoder: Decoder) throws {
		
		let container								= try decoder.container(keyedBy: CodingKeys.self)
		
		let appearanceMode							= try container.decodeIfPresent	(SDKAppearanceMode.self,	forKey: .appearanceMode)							?? AppearanceSettings.default.appearanceMode
		let showsStatusPopup						= try container.decodeIfPresent	(Bool.self,					forKey: .showsStatusPopup)							?? AppearanceSettings.default.showsStatusPopup
		let headerFont								= try container.decodeIfPresent	(String.self,				forKey: .headerFont)								?? AppearanceSettings.default.headerFont
		let headerTextColor							= try container.decodeIfPresent	(Color.self,				forKey: .headerTextColor)							?? AppearanceSettings.default.headerTextColor
		let headerBackgroundColor					= try container.decodeIfPresent	(Color.self,				forKey: .headerBackgroundColor)						?? AppearanceSettings.default.headerBackgroundColor
		let headerCancelFont						= try container.decodeIfPresent	(String.self,				forKey: .headerCancelFont)							?? AppearanceSettings.default.headerCancelFont
		let headerCancelNormalTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .headerCancelNormalTextColor)				?? AppearanceSettings.default.headerCancelNormalTextColor
		let headerCancelHighlightedTextColor		= try container.decodeIfPresent	(Color.self,				forKey: .headerCancelHighlightedTextColor)			?? AppearanceSettings.default.headerCancelHighlightedTextColor
		let cardInputFont							= try container.decodeIfPresent	(String.self,				forKey: .cardInputFont)								?? AppearanceSettings.default.cardInputFont
		let cardInputTextColor						= try container.decodeIfPresent	(Color.self,				forKey: .cardInputTextColor)						?? AppearanceSettings.default.cardInputTextColor
		let cardInputInvalidTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .cardInputInvalidTextColor)					?? AppearanceSettings.default.cardInputInvalidTextColor
		let cardInputPlaceholderTextColor			= try container.decodeIfPresent	(Color.self,				forKey: .cardInputPlaceholderTextColor)				?? AppearanceSettings.default.cardInputPlaceholderTextColor
		let cardInputDescriptionFont				= try container.decodeIfPresent	(String.self,				forKey: .cardInputDescriptionFont)					?? AppearanceSettings.default.cardInputDescriptionFont
		let cardInputDescriptionTextColor			= try container.decodeIfPresent	(Color.self,				forKey: .cardInputDescriptionTextColor)				?? AppearanceSettings.default.cardInputDescriptionTextColor
		let cardInputSaveCardSwitchOffTintColor		= try container.decodeIfPresent	(Color.self,				forKey: .cardInputSaveCardSwitchOffTintColor)		?? AppearanceSettings.default.cardInputSaveCardSwitchOffTintColor
		let cardInputSaveCardSwitchOnTintColor		= try container.decodeIfPresent	(Color.self,				forKey: .cardInputSaveCardSwitchOnTintColor)		?? AppearanceSettings.default.cardInputSaveCardSwitchOnTintColor
		let cardInputSaveCardSwitchThumbTintColor	= try container.decodeIfPresent	(Color.self,				forKey: .cardInputSaveCardSwitchThumbTintColor)		?? AppearanceSettings.default.cardInputSaveCardSwitchThumbTintColor
		let cardInputScanIconFrameTintColor			= try container.decodeIfPresent	(Color.self,				forKey: .cardInputScanIconFrameTintColor)			?? AppearanceSettings.default.cardInputScanIconFrameTintColor
		let cardInputScanIconTintColor				= try container.decodeIfPresent	(Color.self,				forKey: .cardInputScanIconTintColor)				?? AppearanceSettings.default.cardInputScanIconTintColor
		let tapButtonDisabledBackgroundColor		= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonDisabledBackgroundColor)			?? AppearanceSettings.default.tapButtonDisabledBackgroundColor
		let tapButtonEnabledBackgroundColor			= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonEnabledBackgroundColor)			?? AppearanceSettings.default.tapButtonEnabledBackgroundColor
		let tapButtonHighlightedBackgroundColor		= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonHighlightedBackgroundColor)		?? AppearanceSettings.default.tapButtonHighlightedBackgroundColor
		let tapButtonFont							= try container.decodeIfPresent	(String.self,				forKey: .tapButtonFont)								?? AppearanceSettings.default.tapButtonFont
		let tapButtonDisabledTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonDisabledTextColor)				?? AppearanceSettings.default.tapButtonDisabledTextColor
		let tapButtonEnabledTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonEnabledTextColor)					?? AppearanceSettings.default.tapButtonEnabledTextColor
		let tapButtonHighlightedTextColor			= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonHighlightedTextColor)				?? AppearanceSettings.default.tapButtonHighlightedTextColor
		let tapButtonCornerRadius					= try container.decodeIfPresent	(CGFloat.self,				forKey: .tapButtonCornerRadius)						?? AppearanceSettings.default.tapButtonCornerRadius
		let isTapButtonLoaderVisible				= try container.decodeIfPresent	(Bool.self,					forKey: .isTapButtonLoaderVisible)					?? AppearanceSettings.default.isTapButtonLoaderVisible
		let isTapButtonSecurityIconVisible			= try container.decodeIfPresent	(Bool.self,					forKey: .isTapButtonSecurityIconVisible)			?? AppearanceSettings.default.isTapButtonSecurityIconVisible
		let tapButtonHeight							= try container.decodeIfPresent	(CGFloat.self,				forKey: .tapButtonHeight)							?? AppearanceSettings.default.tapButtonHeight
		let tapButtonEdgeInsets						= try container.decodeIfPresent	(UIEdgeInsets.self,			forKey: .tapButtonEdgeInsets)						?? AppearanceSettings.default.tapButtonEdgeInsets
		let backgroundColor							= try container.decodeIfPresent	(Color.self,				forKey: .backgroundColor)							?? AppearanceSettings.default.backgroundColor
		let contentBackgroundColor					= try container.decodeIfPresent	(Color.self,				forKey: .contentBackgroundColor)					?? AppearanceSettings.default.contentBackgroundColor
		let backgroundBlurStyle						= try container.decodeIfPresent	(TapBlurStyle.self,			forKey: .backgroundBlurStyle)						?? AppearanceSettings.default.backgroundBlurStyle
		let backgroundBlurProgress					= try container.decodeIfPresent	(CGFloat.self,				forKey: .backgroundBlurProgress)					?? AppearanceSettings.default.backgroundBlurProgress
		
		self.init(appearanceMode:							appearanceMode,
				  showsStatusPopup:							showsStatusPopup,
				  headerFont:								headerFont,
				  headerTextColor:							headerTextColor,
				  headerBackgroundColor:					headerBackgroundColor,
				  headerCancelFont:							headerCancelFont,
				  headerCancelNormalTextColor:				headerCancelNormalTextColor,
				  headerCancelHighlightedTextColor:			headerCancelHighlightedTextColor,
				  cardInputFont:							cardInputFont,
				  cardInputTextColor:						cardInputTextColor,
				  cardInputInvalidTextColor:				cardInputInvalidTextColor,
				  cardInputPlaceholderTextColor:			cardInputPlaceholderTextColor,
				  cardInputDescriptionFont:					cardInputDescriptionFont,
				  cardInputDescriptionTextColor:			cardInputDescriptionTextColor,
				  cardInputSaveCardSwitchOffTintColor:		cardInputSaveCardSwitchOffTintColor,
				  cardInputSaveCardSwitchOnTintColor:		cardInputSaveCardSwitchOnTintColor,
				  cardInputSaveCardSwitchThumbTintColor:	cardInputSaveCardSwitchThumbTintColor,
				  cardInputScanIconFrameTintColor:			cardInputScanIconFrameTintColor,
				  cardInputScanIconTintColor:				cardInputScanIconTintColor,
				  tapButtonDisabledBackgroundColor:			tapButtonDisabledBackgroundColor,
				  tapButtonEnabledBackgroundColor:			tapButtonEnabledBackgroundColor,
				  tapButtonHighlightedBackgroundColor:		tapButtonHighlightedBackgroundColor,
				  tapButtonFont:							tapButtonFont,
				  tapButtonDisabledTextColor:				tapButtonDisabledTextColor,
				  tapButtonEnabledTextColor:				tapButtonEnabledTextColor,
				  tapButtonHighlightedTextColor:			tapButtonHighlightedTextColor,
				  tapButtonCornerRadius:					tapButtonCornerRadius,
				  isTapButtonLoaderVisible:					isTapButtonLoaderVisible,
				  isTapButtonSecurityIconVisible:			isTapButtonSecurityIconVisible,
				  tapButtonHeight:							tapButtonHeight,
				  tapButtonEdgeInsets:						tapButtonEdgeInsets,
				  backgroundColor:							backgroundColor,
				  contentBackgroundColor:					contentBackgroundColor,
				  backgroundBlurStyle:						backgroundBlurStyle,
				  backgroundBlurProgress:					backgroundBlurProgress)
	}
}

// MARK: - SDKAppearanceMode: Codable
extension SDKAppearanceMode: Codable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(Int.self)
		
		if let result = SDKAppearanceMode(rawValue: rawValue) {
			
			self = result
		}
		else {
			
			self = AppearanceSettings.default.appearanceMode
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(self.rawValue)
	}
}
