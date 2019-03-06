//
//  ProcessMode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol ProcessMode {}
internal protocol Payment: ProcessMode {}
internal protocol CardSaving: ProcessMode {}

internal class ProcessModeClass: ProcessMode {}

internal class PaymentClass:	ProcessModeClass, Payment & ProcessMode {}
internal class CardSavingClass:	ProcessModeClass, CardSaving & ProcessMode {}
