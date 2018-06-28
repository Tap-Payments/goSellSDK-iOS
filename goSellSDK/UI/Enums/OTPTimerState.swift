//
//  OTPTimerState.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum OTPTimerState {
    
    case ticking(TimeInterval)
    case notTicking
    case attemptsFinished
}
