//
//  ThemeManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Theme manager class.
internal final class ThemeManager {

	// MARK: - Internal -
	// MARK: Properties
	
	internal var currentTheme: Theme
	
	internal var originalCurrentTheme: Theme {
		
		return getCorrectTheme()
	}
	
	// MARK: Methods
	
	internal func resetCurrentThemeToDefault() {
		self.currentTheme = getCorrectTheme()
	}
    
    
    internal func getCorrectTheme() -> Theme
    {
        var selectedTheme:Theme = self.themes.first { $0.isDefault }!
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                selectedTheme = self.themes.first { $0.dark }!
            }
        }
        return selectedTheme
    }
	
	// MARK: - Private -
	
	private struct Constants {
		
		fileprivate static let themesFileName 		= "themes"
		fileprivate static let themesFileExtension	= "json"
		
		//@available(*, unavailable) private init() { }
	}
	
	// MARK: Properties
	
	private static var storage: ThemeManager?
	
	private var themes: [Theme] = []
	
	// MARK: Methods
	
	private init() {
        
		KnownStaticallyDestroyableTypes.add(ThemeManager.self)
		
		self.themes 		= ThemeManager.loadThemes()
        
        var selectedTheme:Theme = self.themes.first { $0.isDefault }!
        
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                selectedTheme = self.themes.first { $0.dark }!
            }
        }
        
        self.currentTheme	= selectedTheme
	}
	
	private static func loadThemes() -> [Theme] {
		
		guard let jsonURL = Bundle.goSellSDKResources.url(forResource: Constants.themesFileName, withExtension: Constants.themesFileExtension) else {
			
			fatalError("goSell SDK initialization failed. No themes resource file.")
		}
		
		guard let data = try? Data(contentsOf: jsonURL) else {
			
			fatalError("goSell SDK initialization failed. Failed to load themes resource file.")
		}
		
		let decoder = JSONDecoder()
		var themesContainer: ThemesContainer
		
		do {
		
			themesContainer = try decoder.decode(ThemesContainer.self, from: data)
		}
		catch let error {
			
			fatalError("goSell SDK initialization failed. Failed to map themes resource file (\(error))")
		}
		
		return themesContainer.themes
	}
}

// MARK: - Singleton
extension ThemeManager: Singleton {
	
	internal static var shared: ThemeManager {
		
		if let nonnullStorage = self.storage {
			
			return nonnullStorage
		}
		
		let manager = ThemeManager()
		self.storage = manager
		
		return manager
	}
}

// MARK: - StaticlyDestroyable
extension ThemeManager: StaticlyDestroyable {
	
	internal static var hasAliveInstance: Bool {
		
		return self.storage != nil
	}
}

// MARK: - ImmediatelyDestroyable
extension ThemeManager: ImmediatelyDestroyable {
	
	internal static func destroyInstance() {
		
		self.storage = nil
	}
}
