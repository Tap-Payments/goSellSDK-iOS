//
//  TapNetworkRequestOperation.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Network request operation class.
public class TapNetworkRequestOperation {

    // MARK: - Public -
    // MARK: Properties

    /// HTTP method.
    public var httpMethod: TapHTTPMethod

    /// Request path.
    public var path: String

    /// Additional request headers.
    public var additionalHeaders: [String: String]

    /// URL model.
    public var urlModel: TapURLModel?

    /// Body model
    public var bodyModel: TapBodyModel?

    /// Expected response type.
    public var responseType: TapSerializationType

    /// Initialiazier.
    ///
    /// - Parameters:
    ///   - path: Relative to network manager's base URL request path.
    ///   - method: HTTP method.
    ///   - headers: Request headers.
    ///   - urlModel: URL model (if present).
    ///   - bodyModel: Request body model.
    ///   - responseType: Expected response type.
    public init(path: String, method: TapHTTPMethod = .GET, headers: [String: String]? = nil, urlModel: TapURLModel? = nil, bodyModel: TapBodyModel? = nil, responseType: TapSerializationType = .json) {

        self.httpMethod = method
        self.path = path
        self.additionalHeaders = headers ?? [:]
        self.urlModel = urlModel
        self.bodyModel = bodyModel
        self.responseType = responseType
    }
}
