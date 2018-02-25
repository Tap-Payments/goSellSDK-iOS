//
//  TapReachabilityManager.swift
//  TapNetworkManager
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct Darwin.POSIX.netinet.`in`.sockaddr_in
import var Darwin.POSIX.sys.socket.AF_INET
import struct Darwin.POSIX.sys.socket.sockaddr
import struct Darwin.POSIX.sys.types.sa_family_t
import class Dispatch.DispatchQueue
import class SystemConfiguration.SCNetworkReachability.SCNetworkReachability
import struct SystemConfiguration.SCNetworkReachability.SCNetworkReachabilityContext
import func SystemConfiguration.SCNetworkReachability.SCNetworkReachabilityCreateWithAddress
import func SystemConfiguration.SCNetworkReachability.SCNetworkReachabilityCreateWithName
import struct SystemConfiguration.SCNetworkReachability.SCNetworkReachabilityFlags
import func SystemConfiguration.SCNetworkReachability.SCNetworkReachabilityGetFlags
import func SystemConfiguration.SCNetworkReachability.SCNetworkReachabilitySetCallback
import func SystemConfiguration.SCNetworkReachability.SCNetworkReachabilitySetDispatchQueue

/// Network Reachability Manager class.
public class TapReachabilityManager {

    // MARK: - Public -

    public typealias TapNetworkReachabilityCallback = (TapNetworkReachabilityStatus) -> Void

    // MARK: Properties

    public var isReachable: Bool {

        return self.isReachableOnCellular || self.isReachableOnWiFi
    }

    public var isReachableOnCellular: Bool {

        return self.networkReachabilityStatus == .reachable(.cellular)
    }

    public var isReachableOnWiFi: Bool {

        return self.networkReachabilityStatus == .reachable(.wifi)
    }

    public var networkReachabilityStatus: TapNetworkReachabilityStatus {

        guard let flags = self.flags else { return .unknown }

        return self.networkReachabilityStatusForFlags(flags)
    }

    public var listenerQueue: DispatchQueue = DispatchQueue.main

    // MARK: Methods

    public convenience init?(host: String) {

        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }
        self.init(reachability: reachability)
    }

    public convenience init?() {

        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)

        guard let reachability = withUnsafePointer(to: &address, { pointer in

            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {

                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }

        }) else {

            return nil
        }

        self.init(reachability: reachability)
    }

    @discardableResult public func addListener(_ listener: @escaping TapNetworkReachabilityCallback) -> Int {

        let id = self.nextID
        self.listeners[id] = listener

        return id
    }

    public func removeListener(_ listenerID: Int) {

        self.listeners.removeValue(forKey: listenerID)
    }

    deinit {

        self.stopListening()
    }

    @discardableResult public func startListening() -> Bool {

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()

        let callbackEnabled = SCNetworkReachabilitySetCallback(self.reachability, { (_, flags, info) in

                let reachability = Unmanaged<TapReachabilityManager>.fromOpaque(info!).takeUnretainedValue()
                reachability.notifyListener(flags)
        },
            &context
        )

        let queueEnabled = SCNetworkReachabilitySetDispatchQueue(self.reachability, self.listenerQueue)

        self.listenerQueue.async {

            self.previousFlags = SCNetworkReachabilityFlags()
            self.notifyListener(self.flags ?? SCNetworkReachabilityFlags())
        }

        return callbackEnabled && queueEnabled
    }

    public func stopListening() {

        SCNetworkReachabilitySetCallback(self.reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(self.reachability, nil)
    }

    // MARK: - Internal -
    // MARK: Methods

    internal func notifyListener(_ flags: SCNetworkReachabilityFlags) {

        guard self.previousFlags != flags else { return }

        self.previousFlags = flags

        let status = self.networkReachabilityStatusForFlags(flags)

        for listener in self.listeners.values {

            listener(status)
        }
    }

    internal func networkReachabilityStatusForFlags(_ flags: SCNetworkReachabilityFlags) -> TapNetworkReachabilityStatus {

        guard self.isNetworkReachable(with: flags) else { return .unreachable }

        var networkStatus: TapNetworkReachabilityStatus = .reachable(.wifi)

        if flags.contains(.isWWAN) {

            networkStatus = .reachable(.cellular)
        }

        return networkStatus
    }

    internal func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)

        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }

    // MARK: - Private -
    // MARK: Properties

    private var flags: SCNetworkReachabilityFlags? {

        var flags = SCNetworkReachabilityFlags()

        if SCNetworkReachabilityGetFlags(self.reachability, &flags) {

            return flags
        }

        return nil
    }

    private let reachability: SCNetworkReachability
    private var previousFlags: SCNetworkReachabilityFlags

    private var listeners: [Int: TapNetworkReachabilityCallback] = [:]

    private var nextID: Int {

        let ids = self.listeners.map { $0.key }
        for id in 1... {

            if ids.index(of: id) == nil {

                return id
            }
        }

        fatalError("This piece of code should never be executed.")
    }

    // MARK: Methods

    private init(reachability: SCNetworkReachability) {

        self.reachability = reachability
        self.previousFlags = SCNetworkReachabilityFlags()
    }
}
