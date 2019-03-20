//
//  _ObjCMeasurement.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Measurement class.
@objc(Measurement) public final class _ObjCMeasurement: NSObject {

    // MARK: - Public -
    // MARK: Methods
    
    /// Creates and returns an instance of area measurement.
    ///
    /// - Parameter area: Area measurement unit.
    /// - Returns: Area measurement.
    @objc public static func area(_ area: Area) -> _ObjCMeasurement {

        return self.with(.area(area))
    }
    
    /// Creates and returns an instance of duration measurement.
    ///
    /// - Parameter duration: Duration measurement unit.
    /// - Returns: Duration measurement.
    @objc public static func duration(_ duration: Duration) -> _ObjCMeasurement {

        return self.with(.duration(duration))
    }

    /// Creates and returns an instance of electric charge measurement.
    ///
    /// - Parameter electricCharge: Electric charge measurement unit.
    /// - Returns: Electric charge measurement.
    @objc public static func electricCharge(_ electricCharge: ElectricCharge) -> _ObjCMeasurement {

        return self.with(.electricCharge(electricCharge))
    }

    /// Creates and returns an instance of electric current measurement.
    ///
    /// - Parameter electricCurrent: Electric current measurement unit.
    /// - Returns: Electric current measurement.
    @objc public static func electricCurrent(_ electricCurrent: ElectricCurrent) -> _ObjCMeasurement {

        return self.with(.electricCurrent(electricCurrent))
    }

    /// Creates and returns an instance of energy measurement.
    ///
    /// - Parameter energy: Energy measurement unit.
    /// - Returns: Energy meausurement.
    @objc public static func energy(_ energy: Energy) -> _ObjCMeasurement {

        return self.with(.energy(energy))
    }

    /// Creates and returns an instance of length measurement.
    ///
    /// - Parameter length: Length measurement unit.
    /// - Returns: Length measurement.
    @objc public static func length(_ length: Length) -> _ObjCMeasurement {

        return self.with(.length(length))
    }

    /// Creates and returns an instance of mass measurement.
    ///
    /// - Parameter mass: Mass measurement unit.
    /// - Returns: Mass measurement.
    @objc public static func mass(_ mass: Mass) -> _ObjCMeasurement {

        return self.with(.mass(mass))
    }

    /// Creates and returns an instance of power measurement.
    ///
    /// - Parameter power: Power measurement unit.
    /// - Returns: Power measurement.
    @objc public static func power(_ power: Power) -> _ObjCMeasurement {

        return self.with(.power(power))
    }

    /// Creates and returns an instance of volume measurement.
    ///
    /// - Parameter volume: Volume measurement unit.
    /// - Returns: Volume measurement.
    @objc public static func volume(_ volume: Volume) -> _ObjCMeasurement {

        return self.with(.volume(volume))
    }

    /// Creates and returns an instance of unit measurement.
    ///
    /// - Returns: Units measurement.
    @objc public static func units() -> _ObjCMeasurement {

        return self.with(.units)
    }
    
    /// Checks if the receiver is equal to `object.`
    ///
    /// - Parameter object: Object to test equality with.
    /// - Returns: `true` if the receiver is equal to `object`, `false` otherwise.
    public override func isEqual(_ object: Any?) -> Bool {
        
        if let anotherObjCMeasurement = object as? _ObjCMeasurement {
            
            return self.swiftValue == anotherObjCMeasurement.swiftValue
        }
        else if let anotherMeasurement = object as? Measurement {
            
            return self.swiftValue == anotherMeasurement
        }
        else {
            
            return false
        }
    }
    
    /// Checks if 2 objects are equal.
    ///
    /// - Parameters:
    ///   - lhs: First object.
    ///   - rhs: Second object.
    /// - Returns: `true` if 2 objects are equal, `false` otherwise.
    public static func == (lhs: _ObjCMeasurement, rhs: _ObjCMeasurement) -> Bool {
        
        return lhs.isEqual(rhs)
    }
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal let swiftValue: Measurement

    // MARK: Methods
    
    private init(_ swiftValue: Measurement) {
        
        self.swiftValue = swiftValue
        super.init()
    }
    
    internal static func with(_ swiftValue: Measurement) -> _ObjCMeasurement {
        
        if let existing = self.storage.first(where: { $0.swiftValue == swiftValue }) {
            
            return existing
        }
        else {
            
            let measurement = _ObjCMeasurement(swiftValue)
            self.storage.insert(measurement)
            
            return measurement
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static var storage: Set<_ObjCMeasurement> = Set<_ObjCMeasurement>()
}
