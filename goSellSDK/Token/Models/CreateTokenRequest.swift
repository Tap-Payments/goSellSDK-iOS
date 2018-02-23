//
//  CreateTokenRequest.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

// MARK: - CreateTokenRequest -

/// Create token request model.
@objcMembers public class CreateTokenRequest: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Card used to make the charge.
    public var card: CreateTokenCard
    
    // MARK: Methods
    
    /// Initializes the request with the given card.
    ///
    /// - Parameter card: Card.
    public init(card: CreateTokenCard) {
        
        self.card = card
        super.init()
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case card
    }
}

// MARK: - CreateTokenCard -

/// Card model for token creation.
@objcMembers public class CreateTokenCard: NSObject, Encodable {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Card number.
    public var number: String {
        
        get {
            
            return self.secureData.number
        }
        set {
            
            self.secureData.number = newValue
        }
    }
    
    /// Card expiration month.
    public var expirationMonth: Int {
        
        get {
            
            return Int(self.secureData.expirationMonth) ?? 0
        }
        set {
            
            self.secureData.expirationMonth = String(format: "%02d", newValue)
        }
    }
    
    /// Card expiration year.
    public var expirationYear: Int {
        
        get {
            
            return Int(self.secureData.expirationYear) ?? 0
        }
        set {
            
            self.secureData.expirationYear = String(format: "%02d", newValue % 100)
        }
    }
    
    /// Card security code.
    public var cvc: String {
        
        get {
            
            return self.secureData.cvc
        }
        set {
            
            self.secureData.cvc = newValue
        }
    }
    
    /// Cardholder name.
    public var cardholderName: String? {
        
        get {
            
            return self.secureData.cardholderName
        }
        set {
            
            self.secureData.cardholderName = newValue
        }
    }
    
    /// City/District/Suburb/Town/Village.
    public var addressCity: String?
    
    /// Billing address country, if provided when creating card.
    public var addressCountry: String?
    
    /// Address line 1 (Street address/PO Box/Company name).
    public var addressLine1: String?
    
    /// Address line 2 (Apartment/Suite/Unit/Building).
    public var addressLine2: String?
    
    /// State/County/Province/Region.
    public var addressState: String?
    
    /// Zip or postal code.
    public var addressZip: Int?
    
    // MARK: Methods
    
    /// Initializes the card with number and expiration date.
    ///
    /// - Parameters:
    ///   - number: Card number.
    ///   - expirationMonth: Card expiration month.
    ///   - expirationYear: Card expiration year.
    ///   - cvc: Card security code.
    public convenience init(number: String, expirationMonth: Int, expirationYear: Int, cvc: String) {
        
        self.init(number: number,
                  expirationMonth: expirationMonth,
                  expirationYear: expirationYear,
                  cvc: cvc,
                  name: nil,
                  city: nil,
                  country: nil,
                  addressLine1: nil,
                  addressLine2: nil,
                  addressState: nil,
                  addressZip: 0)
    }
    
    /// Initializes the card with number, expiration date, cvc code, cardholder name, city, country, address line 1, address line 2, address state, address zip.
    ///
    /// - Parameters:
    ///   - number: Card number.
    ///   - expirationMonth: Card expiration month.
    ///   - expirationYear: Card expiration year.
    ///   - cvc: Card CVC code.
    ///   - name: Cardholder name.
    ///   - city: Card address city.
    ///   - country: Card address country.
    ///   - addressLine1: Card address line 1.
    ///   - addressLine2: Card address line 2.
    ///   - addressState: Card address state.
    ///   - addressZip: Card address zip code.
    public init(number: String, expirationMonth: Int, expirationYear: Int, cvc: String, name: String?, city: String?, country: String?, addressLine1: String?, addressLine2: String?, addressState: String?, addressZip: Int) {
        
        self.secureData = CardSecureData(number: number,
                                         expirationMonth: expirationMonth,
                                         expirationYear: expirationYear,
                                         cvc: cvc,
                                         cardholderName: name)
        
        self.addressCity = city
        self.addressCountry = country
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.addressState = addressState
        
        if addressZip > 0 {
            
            self.addressZip = addressZip
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(try self.secureData.secureEncoded(), forKey: .secureData)
        try container.encode(self.addressCity, forKey: .addressCity)
        try container.encode(self.addressCountry, forKey: .addressCountry)
        try container.encode(self.addressState, forKey: .addressState)
        try container.encode(self.addressLine1, forKey: .addressLine1)
        try container.encode(self.addressLine2, forKey: .addressLine2)
        try container.encode(self.addressZip, forKey: .addressZip)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case secureData = "crypted_data"
        case addressCity = "address_city"
        case addressCountry = "address_country"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case addressState = "address_state"
        case addressZip = "address_zip"
    }
    
    private struct CardSecureData: SecureEncodable {
        
        fileprivate var number: String = ""
        fileprivate var expirationMonth: String = ""
        fileprivate var expirationYear: String = ""
        fileprivate var cvc: String = ""
        fileprivate var cardholderName: String?
        
        fileprivate init(number: String, expirationMonth: Int, expirationYear: Int, cvc: String, cardholderName: String?) {
            
            self.number = number
            self.expirationMonth = String(format: "%02d", expirationMonth)
            self.expirationYear = String(format: "%02d", expirationYear % 100)
            self.cvc = cvc
            self.cardholderName = cardholderName
        }
        
        private enum CodingKeys: String, CodingKey {
            
            case number
            case expirationMonth = "exp_month"
            case expirationYear = "exp_year"
            case cvc
            case cardholderName = "name"
        }
    }
    
    // MARK: Properties
    
    private var secureData: CardSecureData
}
