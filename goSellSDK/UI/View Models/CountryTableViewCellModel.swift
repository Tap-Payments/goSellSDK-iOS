//
//  CountryTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage

internal class CountryTableViewCellModel: TableViewCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let country: Country
    
    internal weak var cell: CountryTableViewCell?
    
    internal var displayText: String {
        
        return self.country.displayInTheListValue
    }
    
    internal var checkmarkImage: UIImage {
        
        return Theme.current.settings.generalImages.checkmarkImage
    }
    
    internal var isSelected = false {
        
        didSet {
            
            self.updateCell(animated: true)
        }
    }
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal init(indexPath: IndexPath, country: Country) {
        
        self.country = country
        super.init(indexPath: indexPath)
    }
}

// MARK: - Filterable
extension CountryTableViewCellModel: Filterable {
    
    internal func matchesFilter(_ filterText: String) -> Bool {
        
        return self.country.isoCode.containsIgnoringCase(filterText) || self.country.displayInTheListValue.containsIgnoringCase(filterText)
    }
}

// MARK: - SingleCellModel
extension CountryTableViewCellModel: SingleCellModel {}
