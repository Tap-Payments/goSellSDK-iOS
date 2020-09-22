//
//  SetupApplePayViewControllerDelegate.swift
//  goSellSDK
//
//  Created by Osama Rabie on 09/01/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//


import protocol TapAdditionsKitV2.ClassProtocol

internal protocol SetupApplePayViewControllerDelegate: ClassProtocol {
    /**
	Method to get notified when the user wants to setup his apple pay
	- Parameter controller: The current visible setup apple view controller
	*/
    func setupApplePayViewControllerSetpButtonTouchUpInside(_ controller: SetupApplePayViewController)
	/**
	Method to get notified when the user wants to cancel setup his apple pay
	- Parameter controller: The current visible setup apple view controller
	*/
    func setupApplePayViewControllerDidCancel(_ controller: SetupApplePayViewController)
}


