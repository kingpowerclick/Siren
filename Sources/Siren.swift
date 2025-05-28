//
//  Siren.swift
//  Siren
//
//  Created by Arthur Sabintsev on 1/3/15.
//  Copyright (c) 2015 Sabintsev iOS Projects. All rights reserved.
//

import UIKit

/// The Siren Class.
public final class Siren
{
    /// Return results or errors obtained from performing a version check with Siren.
    public typealias ResultsHandler = (Result<UpdateResults, KnownError>) -> Void
    
    /// The Siren singleton. The main point of entry to the Siren library.
    public static let shared = Siren()
    
    /// The manager that controls the App Store API that is
    /// used to fetch the latest version of the app.
    ///
    /// Defaults to the US App Store.
    public lazy var apiManager: APIManager = .default
    
    /// The current installed version of your app.
    lazy var currentInstalledVersion: String? = Bundle.version()
    
    /// Storing a version that the user wants to skip updating.
    private var storedSkippedVersion: String? = UserDefaults.storedSkippedVersion
    
    /// The App Store's unique identifier for an app.
    private var appID: Int?
    
    /// The completion handler used to return the results or errors returned by Siren.
    private var resultsHandler: ResultsHandler?
    
}

// MARK: - Public API Interface

public extension Siren
{
    /// This method executes the Siren version checking and alert presentation flow.
    ///
    /// - Parameters:
    ///   - versionCheckingStrategy:  A value that determines the update rules (e.g., mandatory, optional, both, or new version only). Defaults to `.newAppStoreUpdateOnly`.
    ///   - handler: Returns the metadata around a successful version check and interaction with the update modal or it returns nil.
    func checkVersionUpdate(
        _ versionCheckingType: VersionCheckingType = .newAppStoreUpdateOnly,
        isByPassAppStoreVersionCheck: Bool = true,
        completion handler: ResultsHandler? = nil)
    {
        resultsHandler = handler
        
        storedSkippedVersion = UserDefaults.storedSkippedVersion
        
        Task
        {
            let result = await fetchAppStoreVersionData()
            
            if isByPassAppStoreVersionCheck
            {
                validate(versionCheckingType: versionCheckingType)
            }
            else
            {
                switch result
                {
                    case let .success(appStoreDataModel):
                        validate(
                            versionCheckingType: versionCheckingType,
                            appStoreDataModel: appStoreDataModel)
                        
                    case let .failure(error):
                        resultsHandler?(.failure(error))
                        
                }
            }
        }
    }
    
    /// Launches the AppStore in two situations when the user clicked the `Update` button in the UIAlertController modal.
    ///
    /// This function is marked `public` as a convenience for those developers who decide to build a custom alert modal
    /// instead of using Siren's prebuilt update alert.
    func launchAppStore() async
    {
        guard let appID = appID,
              let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else
        {
            resultsHandler?(.failure(.malformedURL))
            
            return
        }
        
        await MainActor.run {
            UIApplication.shared.open(url, options: [:], completionHandler: nil) }
    }
    
    /// Begins the version checking and update evaluation process.
    ///
    /// This method retrieves the previously skipped version (if any) from `UserDefaults`,
    func markAsSkippedVersion(softVersionToSkip: String)
    {
        UserDefaults.storedSkippedVersion = softVersionToSkip
    }
}

// MARK: - Version Check and Alert Presentation Flow

private extension Siren
{
    /// Initiatives the version check request.
    func fetchAppStoreVersionData() async -> Result<AppStoreDataModel, KnownError>
    {
        do
        {
            let apiModel = try await apiManager.performVersionCheckRequest()
            
            // Check if the latest version is compatible with current device's version of iOS.
            guard DataParser.isUpdateCompatibleWithDeviceOS(for: apiModel) else
            {
                return .failure(.appStoreOSVersionUnsupported)
            }
            
            // Check and store the App ID .
            guard let results = apiModel.results.first,
                  let appID = apiModel.results.first?.appID else
            {
                return .failure(.appStoreAppIDFailure)
            }
            self.appID = appID
            
            // Check the release date of the current version.
            guard let currentVersionReleaseDate = apiModel.results.first?.currentVersionReleaseDate else
            {
                return .failure(.currentVersionReleaseDate)
            }
            
            return .success(
                AppStoreDataModel(
                    appID: appID,
                    currentVersionReleaseDate: currentVersionReleaseDate,
                    minimumOSVersion: results.minimumOSVersion,
                    releaseNotes: results.releaseNotes,
                    version: results.version))
        }
        catch
        {
            return .failure(.performVersionCheckingFailed(underlyingError: error))
        }
    }
    
    /// Validates the parsed and mapped iTunes Lookup Model
    /// to guarantee all the relevant data was returned before
    /// attempting to present an alert.
    ///
    /// - Parameter apiModel: The iTunes Lookup Model.
    func validate(
        versionCheckingType: VersionCheckingType,
        appStoreDataModel: AppStoreDataModel? = nil)
    {
        switch versionCheckingType
        {
            case let .mandatoryUpdateOnly(minimumRequiredVersion):
                if DataParser.isVersionOlder(appStoreDataModel?.version, than: minimumRequiredVersion)
                {
                    resultsHandler?(
                        .success(
                            UpdateResults(
                                alertType: .maintenance,
                                model: appStoreDataModel)))
                }
                else if DataParser.isVersionOlder(currentInstalledVersion, than: minimumRequiredVersion)
                {
                    resultsHandler?(
                        .success(
                            UpdateResults(
                                alertType: .force,
                                model: appStoreDataModel)))
                }
                else
                {
                    resultsHandler?(.failure(.noUpdateAvailable))
                }
                
            case let .optionalUpdateOnly(recommendedVersion):
                if DataParser.isVersionOlder(currentInstalledVersion, than: recommendedVersion)
                    && DataParser.isVersionOlder(currentInstalledVersion, than: appStoreDataModel?.version)
                {
                    guard let storedSkippedVersion = storedSkippedVersion else
                    {
                        resultsHandler?(
                            .success(
                                UpdateResults(
                                    alertType: .soft,
                                    model: appStoreDataModel)))
                        
                        return
                    }
                    
                    if storedSkippedVersion != recommendedVersion
                    {
                        UserDefaults.alertPresentationDate = Date()
                        
                        resultsHandler?(
                            .success(
                                UpdateResults(
                                    alertType: .soft,
                                    model: appStoreDataModel)))
                    }
                    else
                    {
                        resultsHandler?(.failure(.recentlyPrompted))
                    }
                }
                else
                {
                    resultsHandler?(.failure(.noUpdateAvailable))
                }
                
            case let .bothMandatoryAndOptional(minimumRequiredVersion, recommendedVersion):
                if DataParser.isVersionOlder(currentInstalledVersion, than: minimumRequiredVersion)
                {
                    resultsHandler?(
                        .success(
                            UpdateResults(
                                alertType: .force,
                                model: appStoreDataModel)))
                }
                else if DataParser.isVersionOlder(currentInstalledVersion, than: recommendedVersion)
                {
                    if storedSkippedVersion == nil
                        || storedSkippedVersion != recommendedVersion
                    {
                        resultsHandler?(
                            .success(
                                UpdateResults(
                                    alertType: .soft,
                                    model: appStoreDataModel)))
                    }
                    else
                    {
                        resultsHandler?(.failure(.noUpdateAvailable))
                    }
                }
                else
                {
                    resultsHandler?(.failure(.noUpdateAvailable))
                }
                
            case .newAppStoreUpdateOnly:
                if DataParser.isVersionOlder(currentInstalledVersion, than: appStoreDataModel?.version)
                {
                    resultsHandler?(.success(
                        UpdateResults(
                            alertType: .soft,
                            model: appStoreDataModel)))
                }
                else
                {
                    resultsHandler?(.failure(.noUpdateAvailable))
                }
        }
    }
    
    // MARK: - For Further implimentation with checking AppStore version
    
    private func crossCheckAppStoreStrategy(
        currentAppStoreVersion: String,
        minimumRequiredVersion: String,
        recommendedVersion: String)
    {

        if DataParser.isVersionOlder(currentInstalledVersion, than: minimumRequiredVersion)
        {
            if DataParser.isVersionOlder(currentAppStoreVersion, than: minimumRequiredVersion)
            {
                // maintenance
            }
            else
            {
                // forceUpdate
            }
        }
        else if DataParser.isVersionOlder(currentInstalledVersion, than: recommendedVersion)
                    && DataParser.isVersionOlder(currentInstalledVersion, than: currentAppStoreVersion)
        {
            guard let storedSkippedVersion = storedSkippedVersion,
                storedSkippedVersion != recommendedVersion else
            {
                return
            }
            
            // softUpdate
        }
        else
        {
            // do-nothing
        }
    }
    
}
