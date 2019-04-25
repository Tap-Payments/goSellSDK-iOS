Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform              = :ios
    goSellSDK.ios.deployment_target = '8.0'
	goSellSDK.swift_versions        = ['4.2', '5.0']
    goSellSDK.name                  = 'goSellSDK'
    goSellSDK.summary               = 'goSell SDK for iOS'
    goSellSDK.requires_arc          = true
    goSellSDK.version               = '2.2.3'
    goSellSDK.license               = { :type => 'MIT', :file => 'LICENSE' }
    goSellSDK.author                = { 'Tap Payments' => 'hello@tap.company' }
    goSellSDK.homepage              = 'https://github.com/Tap-Payments/goSellSDK-iOS'
    goSellSDK.source                = { :git => 'https://github.com/Tap-Payments/goSellSDK-iOS.git', :tag => goSellSDK.version.to_s }
	goSellSDK.default_subspec		= 'Core'
	
	goSellSDK.subspec 'Core' do |core|
		
		core.source_files			= 'goSellSDK/Core/**/*.{swift}'
		core.ios.resource_bundle	= { 'goSellSDKResources' => ['goSellSDK/Core/UI/Internal/Resources/*.{xcassets,storyboard,xib,json}', 'goSellSDK/Core/UI/Internal/Resources/Localization/*.lproj'] }
		
		core.dependency 'CardIODynamic'
		core.dependency 'EditableTextInsetsTextField'
		core.dependency 'TapAdditionsKit/Foundation/Bundle'
		core.dependency 'TapAdditionsKit/Foundation/Date'
		core.dependency 'TapAdditionsKit/Foundation/Locale'
		core.dependency 'TapAdditionsKit/Foundation/URL'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Bool'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Comparable'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Decodable'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Dictionary'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/Encodable'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/KeyedDecodingContainer'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/OptionSet'
		core.dependency 'TapAdditionsKit/SwiftStandartLibrary/String'
		core.dependency 'TapAdditionsKit/Tap/TypeAlias'
		core.dependency 'TapAdditionsKit/UIKit/NSLayoutConstraint'
		core.dependency 'TapAdditionsKit/UIKit/UIEdgeInsets'
		core.dependency 'TapAdditionsKit/UIKit/UIButton'
		core.dependency 'TapAdditionsKit/UIKit/UIImageView'
		core.dependency 'TapAdditionsKit/UIKit/UILabel'
		core.dependency 'TapAdditionsKit/UIKit/UINavigationController'
		core.dependency 'TapAdditionsKit/UIKit/UIResponder'
		core.dependency 'TapAdditionsKit/UIKit/UIScreen'
		core.dependency 'TapAdditionsKit/UIKit/UITableView'
		core.dependency 'TapAdditionsKit/UIKit/UIView'
		core.dependency 'TapAdditionsKit/UIKit/UIView/AnimationOptions'
		core.dependency 'TapAdditionsKit/UIKit/UIView/KeyframeAnimationOptions'
		core.dependency 'TapApplication'
		core.dependency	'TapBundleLocalization'
		core.dependency 'TapCardValidator'
		core.dependency 'TapEditableView'
		core.dependency 'TapFontsKit'
		core.dependency 'TapGLKit/LinearGradientView'
		core.dependency 'TapGLKit/TapActivityIndicatorView'
		core.dependency 'TapKeychain'
		core.dependency 'TapNetworkManager/Core'
		core.dependency 'TapNetworkManager/ImageLoading'
		core.dependency 'TapNibView'
		core.dependency 'TapResponderChainInputView'
		core.dependency 'TapSearchView'
		core.dependency 'TapSwiftFixes/Threading'
		core.dependency 'TapVisualEffectView'
		
	end
	
	goSellSDK.subspec 'ErrorReporting' do |errorReporting|
		
		errorReporting.source_files			= 'goSellSDK/ErrorReporting/**/*.{swift}'
		errorReporting.pod_target_xcconfig	= { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) GOSELLSDK_ERROR_REPORTING_AVAILABLE' }
		
		errorReporting.dependency	'goSellSDK/Core'
		errorReporting.dependency	'TapErrorReporting'
		
	end
end
