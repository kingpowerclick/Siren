//
//  Rules.swift
//  Siren
//
//  Created by Sabintsev, Arthur on 11/18/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// Alert Presentation Rules for Siren.
public struct Rules
{
    /// The type of alert that should be presented.
    let alertType: AlertType

    /// The frequency in which a the user is prompted to update the app
    /// once a new version is available in the App Store and if they have not updated yet.
    let frequency: UpdatePromptFrequency

    /// Initializes the alert presentation rules.
    ///
    /// - Parameters:
    ///   - frequency: How often a user should be prompted to update the app once a new version is available in the App Store.
    ///   - alertType: The type of alert that should be presented.
    public init(
        promptFrequency frequency: UpdatePromptFrequency,
        forAlertType alertType: AlertType)
    {
        self.frequency = frequency
        self.alertType = alertType
    }
}

// Rules-related Constants
public extension Rules
{
    /// Determines the type of alert to present after a successful version check has been performed.
    enum AlertType
    {
        /// Forces the user to update your app.
        case force
        /// Presents the user with option to update app now or to skip this version.
        case soft
        /// Presents the user with option to update the app now, at next launch, or to skip this version all together (3 button alert).
        case maintenance
        /// Doesn't present the alert.
        case none
    }

    /// Determines the frequency in which the user is prompted to update the app
    /// once a new version is available in the App Store and if they have not updated yet.
    enum UpdatePromptFrequency
    {
        /// Version check performed every time the app is launched.
        case immediately
        /// Version check performed once a day.
        case daily
        /// Version check performed once a week.
        case weekly
        
        case custom(day: UInt)
        
        var days: UInt
        {
            switch self
            {
                case .immediately:
                    return 0
                case .daily:
                    return 1
                case .weekly:
                    return 7
                case let .custom(day):
                    return day
            }
        }
    }
}
