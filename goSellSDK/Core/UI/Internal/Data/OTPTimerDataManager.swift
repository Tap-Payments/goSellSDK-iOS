//
//  OTPTimerDataManager.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func TapSwiftFixesV2.performOnMainThread

internal class OTPTimerDataManager {
    
    // MARK: - Internal -
    
    internal typealias TickClosure = (OTPTimerState) -> Void
	
	// MARK: Properties
	
	internal private(set) lazy var state: OTPTimerState = .ticking(self.resendInterval)
	
    // MARK: Methods
    
    internal init() {
        
        self.remainingAttemptsCount = self.attemptsCount
        self.remainingTime = self.resendInterval
    }
    
    internal func startTimer(force: Bool = true, tickClosure: @escaping TickClosure) {
        
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
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    private let attemptsCount = SettingsDataManager.shared.settings?.internalSettings.otpResendAttempts ?? InternalSDKSettings.default.otpResendAttempts
    private let resendInterval = SettingsDataManager.shared.settings?.internalSettings.otpResendInterval ?? InternalSDKSettings.default.otpResendInterval
    
    private var remainingAttemptsCount: Int
    private var remainingTime: TimeInterval
    
    private var timer: Timer?
	
	private var timerRunLoopMode: RunLoop.Mode {
		
		#if swift(>=4.2)
		
		return .common
		
		#else
		
		return .commonModes
		
		#endif
	}
    
    // MARK: Methods
    
    private func startTimer(_ updateClosure: @escaping TickClosure) {
        
        let timer = Timer.scheduledTimer(timeInterval: Constants.tickDuration,
                                         target: self,
                                         selector: #selector(timerTicked(_:)),
                                         userInfo: updateClosure,
                                         repeats: true)
        
        RunLoop.main.add(timer, forMode: self.timerRunLoopMode)
        
        self.timer = timer
    }
    
    @objc private func timerTicked(_ sender: Timer) {
        
        guard let tickClosure = sender.userInfo as? TickClosure else { return }
        
        self.remainingTime -= 1.0
        if self.remainingTime < 0.0 {
            
            self.invalidateTimer()
            
            self.state = self.remainingAttemptsCount > 0 ? .notTicking : .attemptsFinished
        }
        else {
            
            self.state = .ticking(self.remainingTime)
        }
		
		self.dispatchTickClosureOnMainThread(tickClosure)
    }
    
    private func dispatchTickClosureOnMainThread(_ closure: @escaping TickClosure) {
        
        performOnMainThread { [weak self] in
			
			guard let strongSelf = self else { return }
			
            closure(strongSelf.state)
        }
    }
}
