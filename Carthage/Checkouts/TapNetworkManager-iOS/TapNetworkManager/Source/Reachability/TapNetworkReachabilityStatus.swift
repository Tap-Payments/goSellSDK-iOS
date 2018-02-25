//
//  TapNetworkReachabilityStatus.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

public enum TapNetworkReachabilityStatus {

    case unknown
    case unreachable
    case reachable(TapNetworkConnectionType)
}

public enum TapNetworkConnectionType {

    case cellular
    case wifi
}

extension TapNetworkReachabilityStatus: Equatable {

    public static func == (lhs: TapNetworkReachabilityStatus, rhs: TapNetworkReachabilityStatus) -> Bool {

        switch (lhs, rhs) {

        case (.unknown, .unknown):

            return true

        case (.unreachable, .unreachable):

            return true

        case let (.reachable(lhsConnectionType), .reachable(rhsConnectionType)):

            return lhsConnectionType == rhsConnectionType

        default:

            return false
        }
    }
}
