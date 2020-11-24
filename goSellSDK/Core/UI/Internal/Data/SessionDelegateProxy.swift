//
//  SessionDelegateProxy.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func TapSwiftFixesV2.synchronized

internal class SessionDelegateProxy: NSObject, SessionDelegate {
	
	// MARK: - Internal -
	// MARK: Properties
	
	internal weak var originalDelegate: SessionDelegate? {
		
		didSet {
			
			self.add(self.originalDelegate, removing: oldValue)
		}
	}
	
	internal weak var middlemanDelegate: SessionDelegate? {
		
		didSet {
			
			self.add(self.middlemanDelegate, removing: oldValue)
		}
	}
	
	// MARK: Methods
	
	internal func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.paymentSucceed?(charge, on: targetSession) }
		}
	}
    
    
    internal func applePaymentTokenizationEnded(_ charge: String, on session: SessionProtocol) {
        
        let targetSession = self.targetSession(for: session)
        
        self.removeNilDelegatesAndSynchronized { theDelegates in
            
            theDelegates.forEach { $0.applePaymentSucceed?(charge, on: targetSession)}
        }
    }
    
    internal func applePaymentCanceled(on session: SessionProtocol) {
        let targetSession = self.targetSession(for: session)
        
        self.removeNilDelegatesAndSynchronized { theDelegates in
            
            theDelegates.forEach { $0.applePaymentCanceled?(on: targetSession)}
        }
    }
    
    
    internal func applePaymentTokenizationSucceeded(_ token: Token, on session: SessionProtocol)
    {
        let targetSession = self.targetSession(for: session)
        
        self.removeNilDelegatesAndSynchronized { theDelegates in
            
            theDelegates.forEach { $0.applePaymentTokenizationSucceeded?(token, on: targetSession)}
        }
    }
    
    internal func applePaymentTokenizationFailed(_ error: String, on session: SessionProtocol) {
        let targetSession = self.targetSession(for: session)
               
               self.removeNilDelegatesAndSynchronized { theDelegates in
                   
                   theDelegates.forEach { $0.applePaymentTokenizationFailed?(error, on: targetSession)}
               }
    }
    
    
    
	
	internal func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.authorizationSucceed?(authorize, on: targetSession)}
		}
	}
	
	internal func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.paymentFailed?(with: charge, error: error, on: targetSession) }
		}
	}
	
	internal func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.authorizationFailed?(with: authorize, error: error, on: targetSession) }
		}
	}
	
	internal func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.cardSaved?(cardVerification, on: targetSession) }
		}
	}
	
	internal func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.cardSavingFailed?(with: cardVerification, error: error, on: targetSession) }
		}
	}
	
	internal func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.cardTokenized?(token, on: targetSession, customerRequestedToSaveTheCard: saveCard) }
		}
	}
	
	internal func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.cardTokenizationFailed?(with: error, on: targetSession) }
		}
	}
	
	internal func sessionIsStarting(_ session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.sessionIsStarting?(targetSession) }
		}
	}
	
	internal func sessionHasStarted(_ session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.sessionHasStarted?(targetSession) }
		}
	}
	
	internal func sessionHasFailedToStart(_ session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.sessionHasFailedToStart?(targetSession) }
		}
	}
	
	internal func sessionCancelled(_ session: SessionProtocol) {
		
		let targetSession = self.targetSession(for: session)
		
		self.removeNilDelegatesAndSynchronized { theDelegates in
			
			theDelegates.forEach { $0.sessionCancelled?(targetSession) }
		}
	}
	
	// MARK: - Private -
	// MARK: Properties
	
	private lazy var delegates: [WeaklyWrapped<SessionDelegate>] = []
	
	// MARK: Methods
	
	private func add(_ newDelegate: SessionDelegate?, removing oldDelegate: SessionDelegate?) {
		
		synchronized(self.delegates) {
			
			if let nonnullOld = oldDelegate, let index = self.delegates.firstIndex(where: { $0.object === nonnullOld }) {
				
				self.delegates.remove(at: index)
			}
			
			if let nonnullNew = newDelegate, self.delegates.firstIndex(where: { $0.object === nonnullNew }) == nil {
				
				self.delegates.append(WeaklyWrapped(nonnullNew))
			}
		}
	}
	
	private func removeNilDelegatesAndSynchronized(_ closure: ([SessionDelegate]) -> Void) {
		
		synchronized(self.delegates) {
			
			self.delegates.removeAll { $0.object == nil }
			
			let remaining = self.delegates.compactMap { $0.object }
			closure(remaining)
		}
	}
	
	private func targetSession(for session: SessionProtocol) -> SessionProtocol {
		
		if let internalSession = session as? InternalSessionProtocol {
			
			return internalSession.externalSession
		}
		else {
			
			return session
		}
	}
}
