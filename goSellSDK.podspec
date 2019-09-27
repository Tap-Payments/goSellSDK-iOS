CardIODynamicDependencyVersion					= '>= 5.4.1'	unless defined? CardIODynamicDependencyVersion
EditableTextInsetsTextFieldDependencyVersion	= '>= 1.0.6'	unless defined? EditableTextInsetsTextFieldDependencyVersion
TapAdditionsKitDependencyVersion				= '>= 1.3.3'	unless defined? TapAdditionsKitDependencyVersion
TapApplicationDependencyVersion					= '>= 1.0.7'	unless defined? TapApplicationDependencyVersion
TapBundleLocalizationDependencyVersion			= '>= 1.0.3'	unless defined? TapBundleLocalizationDependencyVersion
TapCardValidatorDependencyVersion				= '>= 1.2.6'	unless defined? TapCardValidatorDependencyVersion
TapEditableViewDependencyVersion				= '>= 1.0.5'	unless defined? TapEditableViewDependencyVersion
TapErrorReportingDependencyVersion				= '>= 1.0.3'	unless defined?	TapErrorReportingDependencyVersion
TapFontsKitDependencyVersion					= '>= 1.0.6'	unless defined? TapFontsKitDependencyVersion
TapGLKitDependencyVersion						= '>= 1.1.1'	unless defined? TapGLKitDependencyVersion
TapKeychainDependencyVersion					= '>= 1.0.5'	unless defined? TapKeychainDependencyVersion
TapNetworkManagerDependencyVersion				= '>= 1.2.6'	unless defined? TapNetworkManagerDependencyVersion
TapNibViewDependencyVersion						= '>= 1.0.4'	unless defined? TapNibViewDependencyVersion
TapResponderChainInputViewDependencyVersion		= '>= 1.1.4'	unless defined? TapResponderChainInputViewDependencyVersion
TapSearchViewDependencyVersion					= '>= 1.0.4'	unless defined? TapSearchViewDependencyVersion
TapSwiftFixesDependencyVersion					= '>= 1.0.9'	unless defined? TapSwiftFixesDependencyVersion
TapVisualEffectViewDependencyVersion			= '>= 1.1.2'	unless defined? TapVisualEffectViewDependencyVersion

Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform              = :ios
    goSellSDK.ios.deployment_target = '8.0'
	goSellSDK.swift_versions        = ['4.0', '4.2', '5.0']
    goSellSDK.name                  = 'goSellSDK'
    goSellSDK.summary               = 'goSell SDK for iOS'
    goSellSDK.requires_arc          = true
    goSellSDK.version               = '2.2.6'
    goSellSDK.license               = { :type => 'MIT', :file => 'LICENSE' }
    goSellSDK.author                = { 'Tap Payments' => 'hello@tap.company' }
    goSellSDK.homepage              = 'https://github.com/Tap-Payments/goSellSDK-iOS'
    goSellSDK.source                = { :git => 'https://github.com/Tap-Payments/goSellSDK-iOS.git', :tag => goSellSDK.version.to_s }
	goSellSDK.default_subspec		= 'Core'
	
	goSellSDK.subspec 'Core' do |core|
		
		core.source_files			= 'goSellSDK/Core/**/*.{swift}'
		core.ios.resource_bundle	= { 'goSellSDKResources' => ['goSellSDK/Core/UI/Internal/Resources/*.{xcassets,storyboard,xib,json}', 'goSellSDK/Core/UI/Internal/Resources/Localization/*.lproj'] }
		
		core.dependency 'CardIODynamic',												CardIODynamicDependencyVersion
		core.dependency 'EditableTextInsetsTextField',									EditableTextInsetsTextFieldDependencyVersion
		core.dependency 'TapAdditionsKit/Foundation/Bundle',							TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/Foundation/Date',								TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/Foundation/Locale',							TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/Foundation/URL',								TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Bool',					TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Comparable',				TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Decodable',				TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Dictionary',				TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Encodable',				TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/KeyedDecodingContainer',	TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/OptionSet',				TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/String',					TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/Tap/TypeAlias',								TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/NSLayoutConstraint',						TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIEdgeInsets',							TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIButton',								TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIImageView',							TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UILabel',								TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UINavigationController',					TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIResponder',							TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIScreen',								TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UITableView',							TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIView',									TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIView/AnimationOptions',				TapAdditionsKitDependencyVersion
		core.dependency 'TapAdditionsKit/UIKit/UIView/KeyframeAnimationOptions',		TapAdditionsKitDependencyVersion
		core.dependency 'TapApplication',												TapApplicationDependencyVersion
		core.dependency	'TapBundleLocalization',										TapBundleLocalizationDependencyVersion
		core.dependency 'TapCardValidator',												TapCardValidatorDependencyVersion
		core.dependency 'TapEditableView',												TapEditableViewDependencyVersion
		core.dependency 'TapFontsKit',													TapFontsKitDependencyVersion
		core.dependency 'TapGLKit/LinearGradientView',									TapGLKitDependencyVersion
		core.dependency 'TapGLKit/TapActivityIndicatorView',							TapGLKitDependencyVersion
		core.dependency 'TapKeychain',													TapKeychainDependencyVersion
		core.dependency 'TapNetworkManager/Core',										TapNetworkManagerDependencyVersion
		core.dependency 'TapNetworkManager/ImageLoading',								TapNetworkManagerDependencyVersion
		core.dependency 'TapNibView',													TapNibViewDependencyVersion
		core.dependency 'TapResponderChainInputView',									TapResponderChainInputViewDependencyVersion
		core.dependency 'TapSearchView',												TapSearchViewDependencyVersion
		core.dependency 'TapSwiftFixes/Threading',										TapSwiftFixesDependencyVersion
		core.dependency 'TapVisualEffectView',											TapVisualEffectViewDependencyVersion
		
	end
	
	goSellSDK.subspec 'ErrorReporting' do |errorReporting|
		
		errorReporting.source_files			= 'goSellSDK/ErrorReporting/**/*.{swift}'
		errorReporting.pod_target_xcconfig	= { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) GOSELLSDK_ERROR_REPORTING_AVAILABLE' }
		
		errorReporting.dependency	'goSellSDK/Core'
		errorReporting.dependency	'TapErrorReporting',	TapErrorReportingDependencyVersion
		
	end
end
