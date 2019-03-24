//
//  Settings.swift
//  goSellSDKExample
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal final class Settings: Encodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
	internal static let `default` = Settings(global:		GlobalSettings.default,
											 dataSource:	DataSourceSettings.default,
											 appearance:	AppearanceSettings.default)
	
	internal var global: GlobalSettings
	
	internal var dataSource: DataSourceSettings
	
	internal var appearance: AppearanceSettings
	
	
    // MARK: Methods
    
	internal init(global: GlobalSettings, dataSource: DataSourceSettings, appearance: AppearanceSettings) {
		
		self.global		= global
		self.dataSource	= dataSource
		self.appearance	= appearance
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
		
		case global		= "global"
		case dataSource	= "data_source"
		case appearance	= "appearance"
	}
}

// MARK: - Decodable
extension Settings: Decodable {
    
    internal convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let global	= try container.decodeIfPresent(GlobalSettings.self,			forKey: .global)		?? Settings.default.global
		let dataSource	= try container.decodeIfPresent(DataSourceSettings.self,	forKey: .dataSource)	?? Settings.default.dataSource
		let appearance	= try container.decodeIfPresent(AppearanceSettings.self,	forKey: .appearance)	?? Settings.default.appearance
		
		self.init(global: global, dataSource: dataSource, appearance: appearance)
    }
}
