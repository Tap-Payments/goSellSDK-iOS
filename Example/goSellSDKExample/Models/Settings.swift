//
//  Settings.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGBase.CGFloat
import struct	Foundation.NSLocale.Locale
import class    goSellSDK.Currency
import class    goSellSDK.Customer
import class	goSellSDK.Destination
import class	goSellSDK.goSellSDK
import enum		goSellSDK.SDKAppearanceMode
import enum     goSellSDK.SDKMode
import class    goSellSDK.Shipping
import class	goSellSDK.TapBlurStyle
import class    goSellSDK.Tax
import enum     goSellSDK.TransactionMode
import struct	UIKit.UIGeometry.UIEdgeInsets

internal final class Settings: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
	internal static let `default` = Settings(sdkLanguage:							Language(localeIdentifier: Locale.TapLocaleIdentifier.en),
											 sdkMode:								.sandbox,
											 
											 transactionMode:						.purchase,
											 isThreeDSecure:						false,
											 canSaveSameCardMultipleTimes:			true,
											 saveCardSwitchEnabledByDefault:		false,
											 currency:								try! Currency(isoCode: "kwd"),
											 customer:								nil,
											 destinations:							[],
											 shippingList:							[],
											 taxes:									[],
											 
											 appearanceMode:						.default,
											 showsStatusPopup:						true,
											 headerFont:							"Helvetica Neue",
											 headerTextColor:						.custom("#535353"),
											 headerBackgroundColor:					.custom("#f7f7f7"),
											 headerCancelFont:						"Helvetica Neue",
											 headerCancelNormalTextColor:			.custom("#535353"),
											 headerCancelHighlightedTextColor:		.black,
											 cardInputFont:							"Helvetica Neue",
											 cardInputTextColor:					.custom("#535353"),
											 cardInputInvalidTextColor:				.custom("#ee0000"),
											 cardInputPlaceholderTextColor:			.custom("#bdbdbd"),
											 cardInputDescriptionFont:				"Helvetica Neue",
											 cardInputDescriptionTextColor:			.custom("#5c5c5c"),
											 cardInputSaveCardSwitchOffTintColor:	.white,
											 cardInputSaveCardSwitchOnTintColor:	.custom("#2ace00"),
											 cardInputSaveCardSwitchThumbTintColor:	.white,
											 cardInputScanIconFrameTintColor:		.custom("#2ace00"),
											 cardInputScanIconTintColor:			nil,
											 tapButtonDisabledBackgroundColor:		nil,
											 tapButtonEnabledBackgroundColor:		nil,
											 tapButtonHighlightedBackgroundColor:	nil,
											 tapButtonFont:							"Helvetica Neue",
											 tapButtonDisabledTextColor:			nil,
											 tapButtonEnabledTextColor:				nil,
											 tapButtonHighlightedTextColor:			nil,
											 tapButtonCornerRadius:					22.0,
											 isTapButtonLoaderVisible:				true,
											 isTapButtonSecurityIconVisible:		true,
											 tapButtonHeight:						44.0,
											 tapButtonEdgeInsets:					UIEdgeInsets(tap_inset: 8.0),
											 backgroundColor:						.clear,
											 contentBackgroundColor:				.clear,
											 backgroundBlurStyle:					.extraLight,
											 backgroundBlurProgress:				1.0)
	
	// Common
	
	internal var sdkLanguage: Language
	
	// Data Source
	
	internal var sdkMode: SDKMode
	
	internal var transactionMode: TransactionMode
	
	internal var isThreeDSecure: Bool
	
	internal var canSaveSameCardMultipleTimes: Bool
	
	internal var isSaveCardSwitchToggleEnabledByDefault: Bool
	
    internal var currency: Currency
    
    internal var customer: EnvironmentCustomer?
	
	internal var destinations: [Destination]
	
	internal var shippingList: [Shipping]
	
	internal var taxes: [Tax]
	
	// Appearance: General
	
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
    
	internal init(sdkLanguage:								Language,
				  
				  sdkMode:									SDKMode,
				  transactionMode:							TransactionMode,
				  isThreeDSecure:							Bool,
				  canSaveSameCardMultipleTimes:				Bool,
				  saveCardSwitchEnabledByDefault:			Bool,
				  currency:									Currency,
				  customer:									EnvironmentCustomer?,
				  destinations:								[Destination],
				  shippingList:								[Shipping],
				  taxes:									[Tax],
				  
				  appearanceMode:							SDKAppearanceMode,
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
		
		self.sdkLanguage 							= sdkLanguage
        self.sdkMode            					= sdkMode
		
        self.transactionMode    					= transactionMode
		self.isThreeDSecure							= isThreeDSecure
		self.canSaveSameCardMultipleTimes			= canSaveSameCardMultipleTimes
		self.isSaveCardSwitchToggleEnabledByDefault	= saveCardSwitchEnabledByDefault
        self.currency           					= currency
        self.customer           					= customer
		self.destinations							= destinations
        self.shippingList       					= shippingList
        self.taxes              					= taxes
		
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
		
		case sdkLanguage							= "sdk_language"
		
		case sdkMode            					= "sdk_mode"
        case transactionMode    					= "mode"
		case isThreeDSecure							= "3d_secure"
		case canSaveSameCardMultipleTimes			= "save_same_card_multiple_times"
		case isSaveCardSwitchToggleEnabledByDefault	= "is_save_card_switch_enabled_by_default"
        case currency           					= "currency"
        case customer           					= "customer"
		case destinations							= "destinations"
        case shippingList       					= "shippingList"
        case taxes              					= "taxes"
		
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

// MARK: - Decodable
extension Settings: Decodable {
    
    internal convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let sdkLanguage								= try container.decodeIfPresent	(Language.self,				forKey: .sdkLanguage)								?? Language(localeIdentifier: goSellSDK.language)
        let sdkMode         						= try container.decodeIfPresent	(SDKMode.self,				forKey: .sdkMode)									?? Settings.default.sdkMode
		
        let transactionMode 						= try container.decode			(TransactionMode.self,		forKey: .transactionMode)
		let isThreeDSecure							= try container.decodeIfPresent	(Bool.self,					forKey: .isThreeDSecure)							?? Settings.default.isThreeDSecure
		let canSaveCardMultipleTimes				= try container.decodeIfPresent	(Bool.self,					forKey: .canSaveSameCardMultipleTimes)				?? Settings.default.canSaveSameCardMultipleTimes
		let saveCardSwitchEnabledByDefault			= try container.decodeIfPresent	(Bool.self,					forKey: .isSaveCardSwitchToggleEnabledByDefault)	?? Settings.default.isSaveCardSwitchToggleEnabledByDefault
        let currency        						= try container.decode			(Currency.self,				forKey: .currency)
        var envCustomer     						= try container.decodeIfPresent	(EnvironmentCustomer.self,	forKey: .customer)
		let destinations							= try container.decodeIfPresent ([Destination].self,		forKey: .destinations)								?? []
        let shippingList    						= try container.decode			([Shipping].self,			forKey: .shippingList)
        let taxes           						= try container.decode			([Tax].self,				forKey: .taxes)
		
		let appearanceMode							= try container.decodeIfPresent	(SDKAppearanceMode.self,	forKey: .appearanceMode)							?? Settings.default.appearanceMode
		let showsStatusPopup						= try container.decodeIfPresent	(Bool.self,					forKey: .showsStatusPopup)							?? Settings.default.showsStatusPopup
		let headerFont								= try container.decodeIfPresent	(String.self,				forKey: .headerFont)								?? Settings.default.headerFont
		let headerTextColor							= try container.decodeIfPresent	(Color.self,				forKey: .headerTextColor)							?? Settings.default.headerTextColor
		let headerBackgroundColor					= try container.decodeIfPresent	(Color.self,				forKey: .headerBackgroundColor)						?? Settings.default.headerBackgroundColor
		let headerCancelFont						= try container.decodeIfPresent	(String.self,				forKey: .headerCancelFont)							?? Settings.default.headerCancelFont
		let headerCancelNormalTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .headerCancelNormalTextColor)				?? Settings.default.headerCancelNormalTextColor
		let headerCancelHighlightedTextColor		= try container.decodeIfPresent	(Color.self,				forKey: .headerCancelHighlightedTextColor)			?? Settings.default.headerCancelHighlightedTextColor
		let cardInputFont							= try container.decodeIfPresent	(String.self,				forKey: .cardInputFont)								?? Settings.default.cardInputFont
		let cardInputTextColor						= try container.decodeIfPresent	(Color.self,				forKey: .cardInputTextColor)						?? Settings.default.cardInputTextColor
		let cardInputInvalidTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .cardInputInvalidTextColor)					?? Settings.default.cardInputInvalidTextColor
		let cardInputPlaceholderTextColor			= try container.decodeIfPresent	(Color.self,				forKey: .cardInputPlaceholderTextColor)				?? Settings.default.cardInputPlaceholderTextColor
		let cardInputDescriptionFont				= try container.decodeIfPresent	(String.self,				forKey: .cardInputDescriptionFont)					?? Settings.default.cardInputDescriptionFont
		let cardInputDescriptionTextColor			= try container.decodeIfPresent	(Color.self,				forKey: .cardInputDescriptionTextColor)				?? Settings.default.cardInputDescriptionTextColor
		let cardInputSaveCardSwitchOffTintColor		= try container.decodeIfPresent	(Color.self,				forKey: .cardInputSaveCardSwitchOffTintColor)		?? Settings.default.cardInputSaveCardSwitchOffTintColor
		let cardInputSaveCardSwitchOnTintColor		= try container.decodeIfPresent	(Color.self,				forKey: .cardInputSaveCardSwitchOnTintColor)		?? Settings.default.cardInputSaveCardSwitchOnTintColor
		let cardInputSaveCardSwitchThumbTintColor	= try container.decodeIfPresent	(Color.self,				forKey: .cardInputSaveCardSwitchThumbTintColor)		?? Settings.default.cardInputSaveCardSwitchThumbTintColor
		let cardInputScanIconFrameTintColor			= try container.decodeIfPresent	(Color.self,				forKey: .cardInputScanIconFrameTintColor)			?? Settings.default.cardInputScanIconFrameTintColor
		let cardInputScanIconTintColor				= try container.decodeIfPresent	(Color.self,				forKey: .cardInputScanIconTintColor)				?? Settings.default.cardInputScanIconTintColor
		let tapButtonDisabledBackgroundColor		= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonDisabledBackgroundColor)			?? Settings.default.tapButtonDisabledBackgroundColor
		let tapButtonEnabledBackgroundColor			= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonEnabledBackgroundColor)			?? Settings.default.tapButtonEnabledBackgroundColor
		let tapButtonHighlightedBackgroundColor		= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonHighlightedBackgroundColor)		?? Settings.default.tapButtonHighlightedBackgroundColor
		let tapButtonFont							= try container.decodeIfPresent	(String.self,				forKey: .tapButtonFont)								?? Settings.default.tapButtonFont
		let tapButtonDisabledTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonDisabledTextColor)				?? Settings.default.tapButtonDisabledTextColor
		let tapButtonEnabledTextColor				= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonEnabledTextColor)					?? Settings.default.tapButtonEnabledTextColor
		let tapButtonHighlightedTextColor			= try container.decodeIfPresent	(Color.self,				forKey: .tapButtonHighlightedTextColor)				?? Settings.default.tapButtonHighlightedTextColor
		let tapButtonCornerRadius					= try container.decodeIfPresent	(CGFloat.self,				forKey: .tapButtonCornerRadius)						?? Settings.default.tapButtonCornerRadius
		let isTapButtonLoaderVisible				= try container.decodeIfPresent	(Bool.self,					forKey: .isTapButtonLoaderVisible)					?? Settings.default.isTapButtonLoaderVisible
		let isTapButtonSecurityIconVisible			= try container.decodeIfPresent	(Bool.self,					forKey: .isTapButtonSecurityIconVisible)			?? Settings.default.isTapButtonSecurityIconVisible
		let tapButtonHeight							= try container.decodeIfPresent	(CGFloat.self,				forKey: .tapButtonHeight)							?? Settings.default.tapButtonHeight
		let tapButtonEdgeInsets						= try container.decodeIfPresent	(UIEdgeInsets.self,			forKey: .tapButtonEdgeInsets)						?? Settings.default.tapButtonEdgeInsets
		let backgroundColor							= try container.decodeIfPresent	(Color.self,				forKey: .backgroundColor)							?? Settings.default.backgroundColor
		let contentBackgroundColor					= try container.decodeIfPresent	(Color.self,				forKey: .contentBackgroundColor)					?? Settings.default.contentBackgroundColor
		let backgroundBlurStyle						= try container.decodeIfPresent	(TapBlurStyle.self,			forKey: .backgroundBlurStyle)						?? Settings.default.backgroundBlurStyle
		let backgroundBlurProgress					= try container.decodeIfPresent	(CGFloat.self,				forKey: .backgroundBlurProgress)					?? Settings.default.backgroundBlurProgress
		
        if envCustomer == nil {
            
            let customer: Customer? = try container.decodeIfPresent(Customer.self, forKey: .customer)
            if let nonnullCustomer = customer {
                
                envCustomer = EnvironmentCustomer(customer: nonnullCustomer, environment: .sandbox)
            }
        }
        
        if envCustomer == nil {
        
            if let envCustomers: [EnvironmentCustomer] = Serializer.deserialize(), envCustomers.count > 0 {
                
                envCustomer = envCustomers.first
            }
        }
        
        if envCustomer == nil {
            
            if let customers: [Customer] = Serializer.deserialize(), customers.count > 0 {
                
                envCustomer = EnvironmentCustomer(customer: customers[0], environment: .sandbox)
            }
        }
		
		self.init(sdkLanguage:								sdkLanguage,
				  sdkMode:									sdkMode,
				  
				  transactionMode:							transactionMode,
				  isThreeDSecure:							isThreeDSecure,
				  canSaveSameCardMultipleTimes:				canSaveCardMultipleTimes,
				  saveCardSwitchEnabledByDefault:			saveCardSwitchEnabledByDefault,
				  
				  currency:									currency,
				  customer:									envCustomer,
				  destinations:								destinations,
				  shippingList:								shippingList,
				  taxes:									taxes,
				  
				  appearanceMode:							appearanceMode,
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

// MARK: - Codable
extension SDKMode: Codable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        
        if let result = SDKMode(rawValue: rawValue) {
            
            self = result
        }
        else {
            
            self = Settings.default.sdkMode
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension SDKAppearanceMode: Codable {
	
	public init(from decoder: Decoder) throws {
		
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(Int.self)
		
		if let result = SDKAppearanceMode(rawValue: rawValue) {
			
			self = result
		}
		else {
			
			self = Settings.default.appearanceMode
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(self.rawValue)
	}
}
