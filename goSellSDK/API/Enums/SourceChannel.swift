//
//  SourceChannel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal enum SourceChannel: String, Codable {
    
    case callCentre     = "CALL_CENTRE"
    case internet       = "INTERNET"
    case mailOrder      = "MAIL_ORDER"
    case moto           = "MOTO"
    case telephoneOrder = "TELEPHONE_ORDER"
    case voiceResponse  = "VOICE_RESPONSE"
}
