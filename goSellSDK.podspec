Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform = :ios
    goSellSDK.ios.deployment_target = '8.0'
    goSellSDK.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
    goSellSDK.name = 'goSellSDK'
    goSellSDK.summary = 'goSell SDK for iOS'
    goSellSDK.requires_arc = true
    goSellSDK.version = '1.1'
    goSellSDK.license = { :type => 'MIT', :file => 'LICENSE' }
    goSellSDK.author = { 'Tap Payments' => 'hello@tap.company' }
    goSellSDK.homepage = 'https://github.com/Tap-Payments/goSellSDK-iOS'
    goSellSDK.source = { :git => 'https://github.com/Tap-Payments/goSellSDK-iOS.git', :tag => goSellSDK.version.to_s }
    goSellSDK.source_files = 'goSellSDK/**/*.{swift}'
    goSellSDK.vendored_frameworks = 'goSellSDK/Crypter/goSellCrypto.swift'
    goSellSDK.ios.resource_bundle = { 'goSellSDKResources' => 'goSellSDK/Resources/*.{xcassets,storyboard,xib}' }
    
    goSellSDK.dependency 'EditableTextInsetsTextField'
    goSellSDK.dependency 'TapAdditionsKit/Foundation/Bundle'
    goSellSDK.dependency 'TapAdditionsKit/SwiftStandartLibrary/OptionSet'
    goSellSDK.dependency 'TapAdditionsKit/SwiftStandartLibrary/String'
    goSellSDK.dependency 'TapAdditionsKit/UIKit/UIView'
    goSellSDK.dependency 'TapApplication'
    goSellSDK.dependency 'TapEditableView'
    goSellSDK.dependency 'TapGLKit/TapActivityIndicatorView'
    goSellSDK.dependency 'TapNetworkManager'
    goSellSDK.dependency 'TapNibView'
    goSellSDK.dependency 'TapSwiftFixes/Threading'
    goSellSDK.dependency 'TapVisualEffectView'
    
end
