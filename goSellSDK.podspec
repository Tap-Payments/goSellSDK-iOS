Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform              = :ios
    goSellSDK.ios.deployment_target = '11.0'
	goSellSDK.swift_versions        = ['4.0', '4.2', '5.0']
    goSellSDK.name                  = 'goSellSDK'
    goSellSDK.summary               = 'goSell SDK for iOS'
    goSellSDK.requires_arc          = true
    goSellSDK.version               = '2.3.3'
    goSellSDK.license               = { :type => 'MIT', :file => 'LICENSE' }
    goSellSDK.author                = { 'Tap Payments' => 'hello@tap.company' }
    goSellSDK.homepage              = 'https://github.com/Tap-Payments/goSellSDK-iOS'
    goSellSDK.source                = { :git => 'https://github.com/Tap-Payments/goSellSDK-iOS.git', :tag => goSellSDK.version.to_s }


    goSellSDK.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
    goSellSDK.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

	goSellSDK.default_subspec		= 'Core'
	
	goSellSDK.subspec 'Core' do |core|
		
		core.source_files			= 'goSellSDK/Core/**/*.{swift}'
		core.ios.resource_bundle	= { 'goSellSDKResources' => ['goSellSDK/Core/UI/Internal/Resources/*.{xcassets,storyboard,xib,json}', 'goSellSDK/Core/UI/Internal/Resources/Localization/*.lproj'] }
		
		core.dependency 'CardIODynamic'
		core.dependency 'EditableTextInsetsTextFieldV2'
		core.dependency 'TapAdditionsKitV2'
		core.dependency 'TapApplicationV2'
		core.dependency	'TapBundleLocalization'
		core.dependency 'TapCardValidator'
		core.dependency 'TapEditableViewV2'
		core.dependency 'TapFontsKitV2'
		core.dependency 'TapGLKitV2'
		core.dependency 'TapKeychain'
		core.dependency 'TapNetworkManagerV2'
		core.dependency 'TapNibViewV2'				
		core.dependency 'TapResponderChainInputViewV2'
		core.dependency 'TapSearchViewV2'
		core.dependency 'TapVisualEffectViewV2'
		core.dependency 'SwiftyRSA'
		
	end
	
	goSellSDK.subspec 'ErrorReporting' do |errorReporting|
		
		errorReporting.source_files			= 'goSellSDK/ErrorReporting/**/*.{swift}'
		errorReporting.pod_target_xcconfig	= { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) GOSELLSDK_ERROR_REPORTING_AVAILABLE' }
		
		errorReporting.dependency	'goSellSDK/Core'
		errorReporting.dependency	'TapErrorReportingV2'
		
	end


	goSellSDK.subspec 'AppClip' do |appClip|
		
		appClip.source_files			= 'goSellSDK/Core/**/*.{swift}'
		appClip.ios.resource_bundle	= { 'goSellSDKResources' => ['goSellSDK/Core/UI/Internal/Resources/*.{xcassets,storyboard,xib,json}', 'goSellSDK/Core/UI/Internal/Resources/Localization/*.lproj'] }
		appClip.ios.deployment_target = '14.0'
		appClip.dependency 'EditableTextInsetsTextFieldV2'
		appClip.dependency 'TapAdditionsKitV2'
		appClip.dependency 'TapApplicationV2'
		appClip.dependency 'TapBundleLocalization'
		appClip.dependency 'TapCardValidator'
		appClip.dependency 'TapEditableViewV2'
		appClip.dependency 'TapFontsKitV2'
		appClip.dependency 'TapGLKitV2'
		appClip.dependency 'TapKeychain'
		appClip.dependency 'TapNetworkManagerV2'
		appClip.dependency 'TapNibViewV2'				
		appClip.dependency 'TapResponderChainInputViewV2'
		appClip.dependency 'TapSearchViewV2'
		appClip.dependency 'TapVisualEffectViewV2'
		appClip.dependency 'SwiftyRSA'
		
	end
end
