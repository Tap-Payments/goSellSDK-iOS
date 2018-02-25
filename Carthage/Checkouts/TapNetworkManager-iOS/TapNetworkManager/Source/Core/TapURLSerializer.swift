//
//  TapURLSerializer.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class Foundation.NSNull.NSNull
import struct Foundation.NSURL.URLComponents
import struct Foundation.NSURL.URLQueryItem

/// TapURLSerializer class.
internal class TapURLSerializer {

    // MARK: - Internal -
    // MARK: Properties

    /// Shared instance.
    internal static let shared = TapURLSerializer()

    // MARK: - Private -
    // MARK: Methods

    private init() {}
}

extension TapURLSerializer: TapEncoder {

    internal typealias EncodedType = String

    internal func encode(_ data: Any) throws -> String {

        guard let model = data as? TapURLModel else {

            throw TapNetworkError.serializationError(.wrongData)
        }

        switch model {

        case .dictionary(let params):

            guard var urlComponents = URLComponents(string: "url") else {

                throw TapNetworkError.internalError
            }

            urlComponents.queryItems = self.queryItems(from: params)

            guard let query = urlComponents.percentEncodedQuery else {

                throw TapNetworkError.serializationError(.wrongData)
            }

            return "?" + query

        case .array(let params):

            let urlEncodedParams = params.flatMap { $0.description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) }
            guard params.count == urlEncodedParams.count else {

                throw TapNetworkError.serializationError(.wrongData)
            }

            return urlEncodedParams.joined(separator: "/")
        }
    }

    private func queryItems(from params: [String: Any]) -> [URLQueryItem] {

        var result: [URLQueryItem] = []
        for (key, value) in params {

            result += self.queryItems(for: key, value: value)
        }

        return result.sorted { $0.name < $1.name }
    }

    private func queryItems(for key: String, value: Any?) -> [URLQueryItem] {

        var result: [URLQueryItem] = []

        if let dict = value as? [String: Any] {

            for (nestedKey, nestedValue) in dict {

                result += self.queryItems(for: "\(key)[\(nestedKey)]", value: nestedValue)
            }
        } else if let arr = value as? [Any] {

            let arrKey = "\(key)[]"
            for nestedValue in arr {

                result += self.queryItems(for: arrKey, value: nestedValue)
            }
        } else if value is NSNull {

            result.append(URLQueryItem(name: key, value: nil))
        } else if let v = value {

            result.append(URLQueryItem(name: key, value: "\(v)"))
        } else {

            result.append(URLQueryItem(name: key, value: nil))
        }

        return result
    }
}

extension TapURLSerializer: TapDecoder {

    internal typealias DecodedType = [String: Any]

    internal func decode(_ data: Any) throws -> [String: Any] {

        guard let urlString = data as? String else {

            throw TapNetworkError.serializationError(.wrongData)
        }

        guard let urlComponents = URLComponents(string: urlString) else {

            throw TapNetworkError.serializationError(.wrongData)
        }

        var result: [String: Any] = [:]
        if let queryParams = urlComponents.queryItems {

            for param in queryParams {

                result[param.name] = param.value ?? NSNull()
            }
        }

        return result
    }
}
