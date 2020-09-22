//
//  DataManagerWithFilteredData.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol DataManagerWithFilteredData: ClassProtocol {
    
    associatedtype DataModel: Filterable
    
    var filterQuery: String? { get set }
    
    var allData: [DataModel] { get }
    var filteredData: [DataModel] { get set }
}

internal extension DataManagerWithFilteredData {
    
    func setFilter(_ query: String?) {
        
        self.filterQuery = query
        
        if let nonnullQuery = query, !nonnullQuery.isEmpty {
        
            self.filteredData = self.allData.filter { $0.matchesFilter(nonnullQuery) }
        }
        else {
            
            self.filteredData = self.allData
        }
    }
}
