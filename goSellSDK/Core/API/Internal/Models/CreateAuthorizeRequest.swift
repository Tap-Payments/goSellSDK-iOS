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
    ///   - selectedAmount: Charge amount that is selected by the user..
    ///   - currency: Charge currency.
    ///   - selectedCurrency: Charge currency that is selected by the user.
    ///   - customer: Customer.
	///   - merchant: Merchant.
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
	internal init(
				  amount:				Decimal,
				  selectedAmount:		Decimal,
				  currency:				Currency,
				  selectedCurrency:		Currency,
				  customer:				Customer,
				  merchant:				Merchant?,
				  fee:					Decimal,
				  order:				Order,
				  redirect:				TrackingURL,
				  post:					TrackingURL?,
				  source:				SourceRequest,
				  destinationGroup:		DestinationGroup?,
				  descriptionText:		String?,
				  metadata:				Metadata?,
				  reference:			Reference?,
				  shouldSaveCard:		Bool,
				  statementDescriptor:	String?,
				  requires3DSecure:		Bool?,
				  receipt:				Receipt?,
				  authorizeAction:		AuthorizeAction) {
        
        self.authorizeAction = authorizeAction
        
        super.init(
				   amount:              amount,
				   selectedAmount:      selectedAmount,
                   currency:            currency,
                   selectedCurrency:    selectedCurrency,
				   customer:            customer,
				   merchant:			merchant,
                   fee:                 fee,
                   order:               order,
                   redirect:            redirect,
                   post:                post,
                   source:              source,
				   destinationGroup:	destinationGroup,
                   descriptionText:     descriptionText,
                   metadata:            metadata,
                   reference:           reference,
                   shouldSaveCard:      shouldSaveCard,
                   statementDescriptor: statementDescriptor,
                   requires3DSecure:    requires3DSecure,
                   receipt:             receipt,
                   topup: nil)
    }
	
	/// Encodes the contents of the receiver.
	///
	/// - Parameter encoder: Encoder.
	/// - Throws: EncodingError
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
