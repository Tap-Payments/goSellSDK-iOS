//
//  OTPTimerState.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal enum OTPTimerState {
    
    case ticking(TimeInterval)
    case notTicking
    case attemptsFinished
}
