//
//  OTPTimerDataManager.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import func TapSwiftFixes.performOnMainThread

internal class OTPTimerDataManager {
    
    // MARK: - Internal -
    
    internal typealias TickClosure = (OTPTimerState) -> Void
    
    // MARK: Methods
    
    internal init() {
        
        self.remainingAttemptsCount = self.attemptsCount
        self.remainingTime = self.resendInterval
    }
    
    internal func startTimer(force: Bool = true, tickClosure: TickClosure) {
        
        if !force && (self.timer?.isValid ?? false) {
            
            return
        }
        
        self.invalidateTimer()
        
        self.remainingAttemptsCount -= 1
        self.remainingTime = self.resendInterval
        
        if self.remainingAttemptsCount < 0 {
            
            tickClosure(.attemptsFinished)
            return
        }
        else {
            
            self.startTimer(tickClosure)
            tickClosure(.ticking(self.remainingTime))
        }
    }
    
    internal func invalidateTimer() {
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let tickDuration: TimeInterval = 1.0
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private let attemptsCount = SettingsDataManager.shared.settings?.internalSettings.otpResendAttempts ?? InternalSDKSettings.default.otpResendAttempts
    private let resendInterval = SettingsDataManager.shared.settings?.internalSettings.otpResendInterval ?? InternalSDKSettings.default.otpResendInterval
    
    private var remainingAttemptsCount: Int
    private var remainingTime: TimeInterval
    
    private var timer: Timer?
    
    // MARK: Methods
    
    private func startTimer(_ updateClosure: TickClosure) {
        
        let timer = Timer.scheduledTimer(timeInterval: Constants.tickDuration,
                                         target: self,
                                         selector: #selector(timerTicked(_:)),
                                         userInfo: updateClosure,
                                         repeats: true)
        
        RunLoop.main.add(timer, forMode: .commonModes)
        
        self.timer = timer
    }
    
    @objc private func timerTicked(_ sender: Timer) {
        
        guard let tickClosure = sender.userInfo as? TickClosure else { return }
        
        self.remainingTime -= 1.0
        if self.remainingTime < 0.0 {
            
            self.invalidateTimer()
            
            let state: OTPTimerState = self.remainingAttemptsCount > 0 ? .notTicking : .attemptsFinished
            self.dispatchTickClosureOnMainThread(tickClosure, with: state)
        }
        else {
            
            let state: OTPTimerState = .ticking(self.remainingTime)
            self.dispatchTickClosureOnMainThread(tickClosure, with: state)
        }
    }
    
    private func dispatchTickClosureOnMainThread(_ closure: @escaping TickClosure, with state: OTPTimerState) {
        
        performOnMainThread {
            
            closure(state)
        }
    }
}
