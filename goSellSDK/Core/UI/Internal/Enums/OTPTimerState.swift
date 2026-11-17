//
//  OTPTimerState.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal enum OTPTimerState {
    
    case ticking(TimeInterval)
    case notTicking
    case attemptsFinished
}
