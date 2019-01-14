//
//  CreateAuthorizeRequest.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal class CreateAuthorizeRequest: CreateChargeRequest {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let authorizeAction: AuthorizeAction
    
    // MARK: Methods
    
    /// Initializes authorize request.
    ///
    /// - Parameters:
    ///   - amount: Charge amount.
    ///   - currency: Charge currency.
    ///   - customer: Customer.
    ///   - fee: Extra fees amount.
    ///   - order: Order.
    ///   - redirect: Redirect.
    ///   - post: Post.
    ///   - source: Source.
    ///   - descriptionText: Description text.
    ///   - metadata: Metadata.
    ///   - reference: Reference.
    ///   - shouldSaveCard: Defines if the card should be saved.
    ///   - statementDescriptor: Statement descriptor.
    ///   - requires3DSecure: Defines if 3D secure is required.
    ///   - receipt: Receipt settings.
    ///   - authorizeAction: Authorize action.
    internal init(amount: Decimal, currency: Currency, customer: Customer, fee: Decimal, order: Order, redirect: TrackingURL, post: TrackingURL?, source: SourceRequest, descriptionText: String?, metadata: [String: String]?, reference: Reference?, shouldSaveCard: Bool, statementDescriptor: String?, requires3DSecure: Bool?, receipt: Receipt?, authorizeAction: AuthorizeAction) {
        
        self.authorizeAction = authorizeAction
        
        super.init(amount:              amount,
                   currency:            currency,
                   customer:            customer,
                   fee:                 fee,
                   order:               order,
                   redirect:            redirect,
                   post:                post,
                   source:              source,
                   descriptionText:     descriptionText,
                   metadata:            metadata,
                   reference:           reference,
                   shouldSaveCard:      shouldSaveCard,
                   statementDescriptor: statementDescriptor,
                   requires3DSecure:    requires3DSecure,
                   receipt:             receipt)
    }
    
    internal override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.authorizeAction, forKey: .authorizeAction)
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case authorizeAction = "auto"
    }
}
