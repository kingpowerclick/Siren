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
    
    /// Holds the parsed App Store metadata from a successful version check.
    var appStoreDataModel: AppStoreDataModel?
    
    /// Storing a version that the user wants to skip updating.
    private var userPreviouslySkippedVersion: String? = UserDefaults.userPreviouslySkippedVersion
    
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
        mandatoryUpdateVersion: String = "0.0.0",
        minimumSuggestedVersion: String = "0.0.0",
        strategy: VersionCheckingStrategy = DefaultVersionCheckingStrategy.default,
        completion handler: ResultsHandler? = nil)
    {
        resultsHandler = handler
        
        userPreviouslySkippedVersion = UserDefaults.userPreviouslySkippedVersion
        
        guard let currentInstalledVersion = currentInstalledVersion else
        {
            return
        }
        
        Task
        {
            let result = await fetchAppStoreVersionData()
            
            await MainActor.run {
                var appStoreDataModel: AppStoreDataModel?
                switch result
                {
                    case let .success(dataModel):
                        appStoreDataModel = dataModel
                        
                    case let .failure(error):
                        guard case .appStoreDataRetrievalEmptyResults = error else
                        {
                            resultsHandler?(.failure(error))
                            return
                        }
                }
                
                strategy
                    .evaluateUpdate(
                        currentInstalledVersion: currentInstalledVersion,
                        currentAppStoreVersion: appStoreDataModel?.version,
                        mandatoryUpdateVersion: mandatoryUpdateVersion,
                        minimumSuggestedVersion: minimumSuggestedVersion,
                        userPreviouslySkippedVersion: userPreviouslySkippedVersion,
                        appStoreDataModel: appStoreDataModel,
                        completion: handler)
            }
        }
    }
    
    /// Launches the AppStore in two situations when the user clicked the `Update` button in the UIAlertController modal.
    ///
    /// This function is marked `public` as a convenience for those developers who decide to build a custom alert modal
    /// instead of using Siren's prebuilt update alert.
    @MainActor
    func launchAppStore()
    {
        guard let appID = appID,
              let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else
        {
            resultsHandler?(.failure(.malformedURL))
            
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /// Begins the version checking and update evaluation process.
    ///
    /// This method retrieves the previously skipped version (if any) from `UserDefaults`,
    func markAsSkippedVersion(softVersionToSkip: String)
    {
        UserDefaults.userPreviouslySkippedVersion = softVersionToSkip
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
            let result = try await apiManager.performVersionCheckRequest()
            
            let apiDataModel: APIModel?
            
            switch result
            {
                case let .success(apiModel):
                    apiDataModel = apiModel
                case let .failure(error):
                    apiDataModel = nil
                    return .failure(error)
            }
            
            
            // Check if the latest version is compatible with current device's version of iOS.
            guard DataParser.isUpdateCompatibleWithDeviceOS(for: apiDataModel) else
            {
                return .failure(.appStoreOSVersionUnsupported)
            }
            
            // Check and store the App ID .
            guard let results = apiDataModel?.results.first,
                  let appID = apiDataModel?.results.first?.appID else
            {
                return .failure(.appStoreAppIDFailure)
            }
            self.appID = appID
            
            // Check the release date of the current version.
            guard let currentVersionReleaseDate = apiDataModel?.results.first?.currentVersionReleaseDate else
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
}
