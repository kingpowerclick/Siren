//
//  DataParser.swift
//  Siren
//
//  Created by Arthur Sabintsev on 11/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// Version parsing functions for Siren.
struct DataParser
{
    /// Checks to see if the compairingVersion is newer than the current installed version.
    ///
    /// - Parameters:
    ///   - currentInstalledVersion: The installed version of the app.
    ///   - compairingVersion: The App Store version of the app.
    /// - Returns: `true` if the App Store version is newer. Otherwise, `false`.
    static func isVersionOlder(
        _ currentInstalledVersion: String?,
        than compairingVersion: String?) -> Bool
    {
        guard let currentInstalledVersion = currentInstalledVersion,
              let compairingVersion = compairingVersion,
              (currentInstalledVersion.compare(compairingVersion, options: .numeric) == .orderedAscending) else
        {
            return false
        }
        
        return true
    }
    
    /// Validates that the latest version in the App Store is compatible with the device's current version of iOS.
    ///
    /// - Parameter model: The iTunes Lookup Model.
    /// - Returns: `true` if the latest version is compatible with the device's current version of iOS. Otherwise, `false`.
    static func isUpdateCompatibleWithDeviceOS(for model: APIModel) -> Bool
    {
        guard let requiredOSVersion = model.results.first?.minimumOSVersion else
        {
            return false
        }
        
        let systemVersion = UIDevice.current.systemVersion
        
        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending
                || systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame else
        {
            return false
        }
        
        return true
    }
}
