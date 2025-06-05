//
//  String+IsVersionOlder.swift
//  Siren
//
//  Created by Thanut Sajjakulnukit on 29/5/2568 BE.
//

import Foundation

public extension String
{
    func isVersionOlder(than comparingVersion: String) -> Bool
    {
        return compare(comparingVersion, options: .numeric) == .orderedAscending
    }
}

public extension Optional where Wrapped == String
{
    func isVersionOlder(than compairingVersion: String?) -> Bool
    {
        guard let currentInstalledVersion = self,
              let compairingVersion = compairingVersion,
              currentInstalledVersion.compare(compairingVersion, options: .numeric) == .orderedAscending else
        {
            return false
        }
        
        return true
    }
}
