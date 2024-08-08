//
//  PaymentAgreement.swift
//  goSellSDK
//
//  Created by Osama Rabie on 08/08/2024.
//

import Foundation
// MARK: - PaymentAgreement
@objcMembers public class PaymentAgreement: NSObject, Codable {
    var contract: Contract?
       var id: String?
       var metadata: Metadata?
       var totalPaymentsCount: Int?
       var traceID, type: String?

       enum CodingKeys: String, CodingKey {
           case contract, id, metadata
           case totalPaymentsCount = "total_payments_count"
           case traceID = "trace_id"
           case type
       }

       init(contract: Contract?, id: String?, metadata: Metadata?, totalPaymentsCount: Int?, traceID: String?, type: String?) {
           self.contract = contract
           self.id = id
           self.metadata = metadata
           self.totalPaymentsCount = totalPaymentsCount
           self.traceID = traceID
           self.type = type
       }
   }

   // MARK: PaymentAgreement convenience initializers and mutators

   extension PaymentAgreement {
       convenience init(data: Data) throws {
           let me = try newJSONDecoder().decode(PaymentAgreement.self, from: data)
           self.init(contract: me.contract, id: me.id, metadata: me.metadata, totalPaymentsCount: me.totalPaymentsCount, traceID: me.traceID, type: me.type)
       }

       convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
           guard let data = json.data(using: encoding) else {
               throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
           }
           try self.init(data: data)
       }

       convenience init(fromURL url: URL) throws {
           try self.init(data: try Data(contentsOf: url))
       }

       func with(
           contract: Contract?? = nil,
           id: String?? = nil,
           metadata: Metadata?? = nil,
           totalPaymentsCount: Int?? = nil,
           traceID: String?? = nil,
           type: String?? = nil
       ) -> PaymentAgreement {
           return PaymentAgreement(
               contract: contract ?? self.contract,
               id: id ?? self.id,
               metadata: metadata ?? self.metadata,
               totalPaymentsCount: totalPaymentsCount ?? self.totalPaymentsCount,
               traceID: traceID ?? self.traceID,
               type: type ?? self.type
           )
       }

       func jsonData() throws -> Data {
           return try newJSONEncoder().encode(self)
       }

       func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
           return String(data: try self.jsonData(), encoding: encoding)
       }
   }

   // MARK: - Contract
   @objcMembers class Contract: NSObject, Codable {
       var customerID, id, type: String?

       enum CodingKeys: String, CodingKey {
           case customerID = "customer_id"
           case id, type
       }

       init(customerID: String?, id: String?, type: String?) {
           self.customerID = customerID
           self.id = id
           self.type = type
       }
   }

   // MARK: Contract convenience initializers and mutators

   extension Contract {
       convenience init(data: Data) throws {
           let me = try newJSONDecoder().decode(Contract.self, from: data)
           self.init(customerID: me.customerID, id: me.id, type: me.type)
       }

       convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
           guard let data = json.data(using: encoding) else {
               throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
           }
           try self.init(data: data)
       }

       convenience init(fromURL url: URL) throws {
           try self.init(data: try Data(contentsOf: url))
       }

       func with(
           customerID: String?? = nil,
           id: String?? = nil,
           type: String?? = nil
       ) -> Contract {
           return Contract(
               customerID: customerID ?? self.customerID,
               id: id ?? self.id,
               type: type ?? self.type
           )
       }

       func jsonData() throws -> Data {
           return try newJSONEncoder().encode(self)
       }

       func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
           return String(data: try self.jsonData(), encoding: encoding)
       }
   }

   // MARK: - Helper functions for creating encoders and decoders

   func newJSONDecoder() -> JSONDecoder {
       let decoder = JSONDecoder()
       if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
           decoder.dateDecodingStrategy = .iso8601
       }
       return decoder
   }

   func newJSONEncoder() -> JSONEncoder {
       let encoder = JSONEncoder()
       if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
           encoder.dateEncodingStrategy = .iso8601
       }
       return encoder
   }
