Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform = :ios
    goSellSDK.ios.deployment_target = '8.0'
    goSellSDK.swift_version = '4.1'
    goSellSDK.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
    goSellSDK.name = 'goSellSDK'
    goSellSDK.summary = 'goSell SDK for iOS'
    goSellSDK.requires_arc = true
    goSellSDK.version = '1.0.4'
    goSellSDK.license = { :type => 'MIT', :file => 'LICENSE' }
    goSellSDK.author = { 'Tap Payments' => 'hello@tap.company' }
    goSellSDK.homepage = 'https://github.com/Tap-Payments/goSellSDK-iOS'
    goSellSDK.source = { :git => 'https://github.com/Tap-Payments/goSellSDK-iOS.git', :tag => goSellSDK.version.to_s }
    goSellSDK.default_subspecs = 'Charge', 'Token'
    
    goSellSDK.subspec 'Core' do |core|
    
        core.dependency 'TapNetworkManager'
        core.source_files = 'goSellSDK/Core/**/*.swift'
    
    end
    
    goSellSDK.subspec 'Charge' do |charge|
        
        charge.dependency 'goSellSDK/Core'
        charge.source_files = 'goSellSDK/Charge/**/*.swift'
        
    end
    
    goSellSDK.subspec 'Crypter' do |crypter|
    
        crypter.dependency 'goSellSDK/Core'
        crypter.source_files = 'goSellSDK/Crypter/**/*.swift'
    
    end
    
    goSellSDK.subspec 'Token' do |token|
        
        token.dependency 'goSellSDK/Core'
        token.dependency 'goSellSDK/Crypter'
        
        token.source_files = 'goSellSDK/Token/**/*.swift'
        
    end
    
end
