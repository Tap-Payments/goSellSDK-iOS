//
//  DataManagerWithFilteredData.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol DataManagerWithFilteredData: ClassProtocol {
    
    associatedtype DataModel: Filterable
    
    var filterQuery: String? { get set }
    
    var allData: [DataModel] { get }
    var filteredData: [DataModel] { get set }
}

internal extension DataManagerWithFilteredData {
    
    internal func setFilter(_ query: String?) {
        
        self.filterQuery = query
        
        if let nonnullQuery = query, !nonnullQuery.isEmpty {
        
            self.filteredData = self.allData.filter { $0.matchesFilter(nonnullQuery) }
        }
        else {
            
            self.filteredData = self.allData
        }
    }
}
