//
//  VersionCheckingType.swift
//  Siren
//
//  Created by Thanut Sajjakulnukit on 20/5/2568 BE.
//

/// An enum that defines how Siren should interpret version update rules.
///
/// Use VersionCheckingStrategy to configure whether the app should prompt users
/// for a mandatory update, an optional update, both, or simply check the App Store version.
///
/// - Note: This configuration is passed to Siren.shared.checkVersionUpdate(...) to determine the appropriate
///         user-facing alert behavior.
///
/// - Cases:
///   - mandatoryUpdateOnly(minimumRequiredVersion: String): Forces the user to update if their current app version is below the minimum required version.
///   - optionalUpdateOnly(recommendedVersion: String): Suggests an update if the user’s current app version is below the recommended version.
///   - bothMandatoryAndOptional(minimumRequiredVersion: String, recommendedVersion: String): Presents a forced update if the app is below the minimum required version; otherwise, shows a soft prompt if below the recommended version.
///   - newAppStoreUpdateOnly: Performs a version check and shows a soft update alert if the installed version is older than the App Store version.
public enum VersionCheckingType
{
    /// Forces the user to update if their current app version is below the minimum required version.
    case mandatoryUpdateOnly(minimumRequiredVersion: String)
    /// Suggests an update if the user’s current app version is below the recommended version.
    case optionalUpdateOnly(recommededVersion: String)
    /// Presents a forced update if the app is below the minimum required version; otherwise, shows a soft prompt if below the recommended version.
    case bothMandatoryAndOptional(minimumRequiredVersion: String, recommededVersion: String)
    /// Check if the App Store version is newer than the currently installed version.
    case newAppStoreUpdateOnly
}
