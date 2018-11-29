Pod::Spec.new do |goSellSDK|
    
    goSellSDK.platform				= :ios
    goSellSDK.ios.deployment_target	= '8.0'
    goSellSDK.swift_version			= '4.2'
    goSellSDK.name					= 'goSellSDK'
    goSellSDK.summary				= 'goSell SDK for iOS'
    goSellSDK.requires_arc			= true
    goSellSDK.version				= '1.1.5'
    goSellSDK.license				= { :type => 'MIT', :file => 'LICENSE' }
    goSellSDK.author				= { 'Tap Payments' => 'hello@tap.company' }
    goSellSDK.homepage				= 'https://github.com/Tap-Payments/goSellSDK-iOS'
    goSellSDK.source				= { :git => 'https://github.com/Tap-Payments/goSellSDK-iOS.git', :tag => goSellSDK.version.to_s }
    goSellSDK.default_subspecs		= 'BIN', 'Charge', 'Token', 'Card', 'Customers'
    
    goSellSDK.subspec 'Core' do |core|
    
        core.dependency 'TapNetworkManager', '1.2.2'
        core.source_files = 'goSellSDK/Core/**/*.swift'
    
    end
    
    goSellSDK.subspec 'BIN' do |bin|
    
        bin.dependency 'goSellSDK/Core'
        bin.source_files = 'goSellSDK/BIN/**/*.swift'
    
    end
    
    goSellSDK.subspec 'Charge' do |charge|
        
        charge.dependency 'goSellSDK/Core'
        charge.source_files = 'goSellSDK/Charge/**/*.swift'
        
    end
    
    goSellSDK.subspec 'Card' do |card|
    
        card.dependency 'goSellSDK/Core'
        card.source_files = 'goSellSDK/Card/**/*.swift'
    
    end
    
    goSellSDK.subspec 'Crypter' do |crypter|
    
        crypter.dependency 'goSellSDK/Core'
        crypter.source_files = 'goSellSDK/Crypter/**/*.swift'
    
    end
    
    goSellSDK.subspec 'Customers' do |customers|
    
        customers.dependency 'goSellSDK/Core'
        customers.source_files = 'goSellSDK/Customers/**/*.swift'
    
    end
    
    goSellSDK.subspec 'Token' do |token|
        
        token.dependency 'goSellSDK/Core'
        token.dependency 'goSellSDK/Crypter'
        
        token.source_files = 'goSellSDK/Token/**/*.swift'
        
    end
    
end
