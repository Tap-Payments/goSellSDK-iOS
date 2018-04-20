//
//  Source.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Source model.
internal class Source: Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// A payment source to be charged, such as a credit card.
    /// If you also pass a customer ID, the source must be the ID of a source belonging to the customer (e.g., a saved card).
    /// Otherwise, if you do not pass a customer ID, the source you provide must can be a token or card id or source id.
    /// Default source id's (KNET - src_kw.knet, Visa/MasterCard - src_visamastercard)
    internal private(set) var identifier: String?
    
    /// The type of payment source.
    internal private(set) var object: String?
    
    /// The last 4 digits of the card.
    internal private(set) var lastFourDigits: String?
    
    /// Two digit number representing the card's expiration month.
    internal private(set) var expirationMonth: Int?
    
    /// Two or four digit number representing the card's expiration year.
    internal private(set) var expirationYear: Int?
    
    // MARK: Methods
    
    /// Initializes the source with token identifier.
    ///
    /// - Parameter tokenIdentifier: Token identifier.
    internal convenience init(tokenIdentifier: String) {
        
        self.init(identifier: tokenIdentifier)
    }
    
    /// Initializes the source with static identifier.
    ///
    /// - Parameter staticIdentifier: Static identifier.
    internal convenience init(staticIdentifier: SourceIdentifier) {
        
        self.init(identifier: staticIdentifier.stringValue)
    }
    
    /// Initializes the source with card number, expiration month, expiration year and CVC code.
    ///
    /// - Parameters:
    ///   - cardNumber: Card number.
    ///   - expirationMonth: Expiration month.
    ///   - expirationYear: Expiration year.
    ///   - cvc: CVC code.
    internal convenience init(cardNumber: String, expirationMonth: Int, expirationYear: Int, cvc: String) {
        
        self.init(cardNumber: cardNumber,
                  expirationMonth: expirationMonth,
                  expirationYear: expirationYear,
                  cvc: cvc,
                  cardholderName: nil,
                  addressCity: nil,
                  addressCountry: nil,
                  addressState: nil,
                  addressLine1: nil,
                  addressLine2: nil,
                  addressZip: 0)
    }
    
    /// Initializes the source with full card data.
    ///
    /// - Parameters:
    ///   - cardNumber: Card number.
    ///   - expirationMonth: Expiration month.
    ///   - expirationYear: Expiration year.
    ///   - cvc: CVC code.
    ///   - cardholderName: Cardholder name.
    ///   - addressCity: Address city.
    ///   - addressCountry: Address country.
    ///   - addressState: Address state.
    ///   - addressLine1: Address line 1.
    ///   - addressLine2: Address line 2.
    ///   - addressZip: Address zip code.
    internal init(cardNumber: String, expirationMonth: Int, expirationYear: Int, cvc: String, cardholderName: String?, addressCity: String?, addressCountry: String?, addressState: String?, addressLine1: String?, addressLine2: String?, addressZip: Int) {
        
        self.object = "card"
        
        self.number = cardNumber
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvc = cvc
        self.cardholderName = cardholderName
        self.addressCity = addressCity
        self.addressCountry = addressCountry
        self.addressState = addressState
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        
        if addressZip > 0 {
            
            self.addressZip = addressZip
        }
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case object = "object"
        case expirationMonth = "exp_month"
        case expirationYear = "exp_year"
        case lastFourDigits = "last4"
        
        case number = "number"
        case cvc = "cvc"
        case cardholderName = "name"
        case addressCity = "address_city"
        case addressCountry = "address_country"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case addressState = "address_state"
        case addressZip = "address_zip"
    }
    
    // MARK: Properties
    
    /// Card number, as a string without any separators.
    private var number: String?
    
    /// Card security code.
    private var cvc: String?
    
    /// Cardholder name.
    private var cardholderName: String?
    
    /// City/District/Suburb/Town/Village.
    private var addressCity: String?
    
    /// Billing address country, if provided when creating card.
    private var addressCountry: String?
    
    /// Address line 1 (Street address/PO Box/Company name).
    private var addressLine1: String?
    
    /// Address line 2 (Apartment/Suite/Unit/Building).
    private var addressLine2: String?
    
    /// State/County/Province/Region.
    private var addressState: String?
    
    /// Zip or postal code.
    private var addressZip: Int?
    
    // MARK: Methods
    
    private init(identifier: String) {
        
        self.identifier = identifier
    }
    
    @available(*, unavailable) private init() {
        
        fatalError("This class cannot be instantiated without parameters.")
    }
}

// MARK: - CustomStringConvertible
extension Source: CustomStringConvertible {
    
    /// Pretty printed description of the Source object.
    internal var description: String {
        
        let lines: [String] = [
            
            "Source",
            "identifier:       \(self.identifier?.description ?? "nil")",
            "object:           \(self.object?.description ?? "nil")",
            "expiration month: \(self.expirationMonth?.description ?? "nil")",
            "expiration year:  \(self.expirationYear?.description ?? "nil")",
            "last 4 digits:    \(self.lastFourDigits?.description ?? "nil")"
        ]
        
        return "\n" + lines.joined(separator: "\n\t")
    }
}
