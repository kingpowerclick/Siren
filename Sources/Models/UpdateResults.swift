//
//  UpdateResults.swift
//  Siren
//
//  Created by Arthur Sabintsev on 12/1/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

/// The relevant metadata returned from Siren upon completing a successful version check.
public struct UpdateResults
{
    /// The recommended alert behavior based on version check results.
    public var alertType: Rules.AlertType = .none

    /// The Swift-mapped and unwrapped API model, if a successful version check was performed.
    public let model: Model
    
}
