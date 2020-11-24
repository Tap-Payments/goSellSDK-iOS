Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform              = :ios
    goSellSDK.ios.deployment_target = '11.0'
	goSellSDK.swift_versions        = ['4.0', '4.2', '5.0']
    goSellSDK.name                  = 'goSellSDK'
    goSellSDK.summary               = 'goSell SDK for iOS'
    goSellSDK.requires_arc          = true
    goSellSDK.version               = '2.2.38'
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
		core.dependency 'TapSwiftFixes/Threading'
		core.dependency 'TapVisualEffectViewV2'
		core.dependency 'SwiftyRSA'
		
	end
	
	goSellSDK.subspec 'ErrorReporting' do |errorReporting|
		
		errorReporting.source_files			= 'goSellSDK/ErrorReporting/**/*.{swift}'
		errorReporting.pod_target_xcconfig	= { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) GOSELLSDK_ERROR_REPORTING_AVAILABLE' }
		
		errorReporting.dependency	'goSellSDK/Core'
		errorReporting.dependency	'TapErrorReportingV2'
		
	end


goSellSDK.subspec 'GoSellAppClip' do |goSellAppClip|
		
		goSellAppClip.source_files			= 'goSellSDK/Core/**/*.{swift}'
		goSellAppClip.ios.resource_bundle	= { 'goSellSDKResources' => ['goSellSDK/Core/UI/Internal/Resources/*.{xcassets,storyboard,xib,json}', 'goSellSDK/Core/UI/Internal/Resources/Localization/*.lproj'] }
		goSellAppClip.dependency 'EditableTextInsetsTextFieldV2'
		goSellAppClip.dependency 'TapAdditionsKitV2'
		goSellAppClip.dependency 'TapApplicationV2'
		goSellAppClip.dependency 'TapBundleLocalization'
		goSellAppClip.dependency 'TapCardValidator'
		goSellAppClip.dependency 'TapEditableViewV2'
		goSellAppClip.dependency 'TapFontsKitV2'
		goSellAppClip.dependency 'TapGLKitV2'
		goSellAppClip.dependency 'TapKeychain'
		goSellAppClip.dependency 'TapNetworkManagerV2'
		goSellAppClip.dependency 'TapNibViewV2'				
		goSellAppClip.dependency 'TapResponderChainInputViewV2'
		goSellAppClip.dependency 'TapSearchViewV2'
		goSellAppClip.dependency 'TapVisualEffectViewV2'
		goSellAppClip.dependency 'SwiftyRSA'
	end
end
