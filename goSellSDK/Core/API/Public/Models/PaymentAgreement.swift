//
//  PaymentAgreement.swift
//  goSellSDK
//
//  Created by Osama Rabie on 08/08/2024.
//

import Foundation
// MARK: - PaymentAgreement

// MARK: - PaymentAgreement
@objcMembers public class PaymentAgreement: NSObject, Codable {
    var id, type, traceID: String?
    var totalPaymentsCount: Int?
    var contract: Contract?

    enum CodingKeys: String, CodingKey {
        case id, type
        case traceID = "trace_id"
        case totalPaymentsCount = "total_payments_count"
        case contract
    }

    init(id: String?, type: String?, traceID: String?, totalPaymentsCount: Int?, contract: Contract?) {
        self.id = id
        self.type = type
        self.traceID = traceID
        self.totalPaymentsCount = totalPaymentsCount
        self.contract = contract
    }
}

// MARK: PaymentAgreement convenience initializers and mutators

extension PaymentAgreement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(PaymentAgreement.self, from: data)
        self.init(id: me.id, type: me.type, traceID: me.traceID, totalPaymentsCount: me.totalPaymentsCount, contract: me.contract)
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
        id: String?? = nil,
        type: String?? = nil,
        traceID: String?? = nil,
        totalPaymentsCount: Int?? = nil,
        contract: Contract?? = nil
    ) -> PaymentAgreement {
        return PaymentAgreement(
            id: id ?? self.id,
            type: type ?? self.type,
            traceID: traceID ?? self.traceID,
            totalPaymentsCount: totalPaymentsCount ?? self.totalPaymentsCount,
            contract: contract ?? self.contract
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
    var id, customerID, type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case type
    }

    init(id: String?, customerID: String?, type: String?) {
        self.id = id
        self.customerID = customerID
        self.type = type
    }
}

// MARK: Contract convenience initializers and mutators

extension Contract {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Contract.self, from: data)
        self.init(id: me.id, customerID: me.customerID, type: me.type)
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
        id: String?? = nil,
        customerID: String?? = nil,
        type: String?? = nil
    ) -> Contract {
        return Contract(
            id: id ?? self.id,
            customerID: customerID ?? self.customerID,
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
