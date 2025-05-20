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
    
    /// The last date that an alert was presented to the user.
    private var alertPresentationDate: Date? = UserDefaults.alertPresentationDate
    
    /// The App Store's unique identifier for an app.
    private var appID: Int?
    
    /// The completion handler used to return the results or errors returned by Siren.
    private var resultsHandler: ResultsHandler?
    
    private var softUpdateFrequency: Rules.UpdatePromptFrequency = .daily
    
    private var versionCheckingStrategy: VersionCheckingStrategy = .newAppStoreUpdateOnly
}

// MARK: - Public API Interface

public extension Siren
{
    /// This method executes the Siren version checking and alert presentation flow.
    ///
    /// - Parameters:
    ///   - updateConfiguration: qwerty.
    ///   - softUpdateVersion: qwerty.
    ///   - handler: Returns the metadata around a successful version check and interaction with the update modal or it returns nil.
    func checkVersionUpdate(
        _ versionCheckingStrategy: VersionCheckingStrategy = .newAppStoreUpdateOnly,
        softUpdateFrequency: Rules.UpdatePromptFrequency = .daily,
        completion handler: ResultsHandler? = nil)
    {
        resultsHandler = handler
        
        self.versionCheckingStrategy = versionCheckingStrategy
        self.softUpdateFrequency = softUpdateFrequency
        
        startVersionCheckFlow()
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
}

// MARK: - Version Check and Alert Presentation Flow

private extension Siren
{
    /// Initiates the version checking flow.
    func startVersionCheckFlow()
    {
        alertPresentationDate = UserDefaults.alertPresentationDate
        
        Task
        {
            await performVersionCheck()
        }
    }
    
    /// Initiatives the version check request.
    func performVersionCheck() async
    {
        do
        {
            let apiModel = try await apiManager.performVersionCheckRequest()
            
            
            await MainActor.run {
                self.validate(apiModel: apiModel) }
            
        }
        catch (let error as KnownError)
        {
            self.resultsHandler?(.failure(error))
        }
        catch
        {
            // Do nothing. Silences exhaustive error.
        }
    }
    
    /// Validates the parsed and mapped iTunes Lookup Model
    /// to guarantee all the relevant data was returned before
    /// attempting to present an alert.
    ///
    /// - Parameter apiModel: The iTunes Lookup Model.
    func validate(apiModel: APIModel)
    {
        // Check if the latest version is compatible with current device's version of iOS.
        guard DataParser.isUpdateCompatibleWithDeviceOS(for: apiModel) else
        {
            resultsHandler?(.failure(.appStoreOSVersionUnsupported))
            return
        }
        
        // Check and store the App ID .
        guard let results = apiModel.results.first,
              let appID = apiModel.results.first?.appID else
        {
            resultsHandler?(.failure(.appStoreAppIDFailure))
            return
        }
        self.appID = appID
        
        // Check and store the current App Store version.
        guard let currentAppStoreVersion = apiModel.results.first?.version else
        {
            resultsHandler?(.failure(.appStoreVersionArrayFailure))
            return
        }
        
        // Check the release date of the current version.
        guard let currentVersionReleaseDate = apiModel.results.first?.currentVersionReleaseDate else
        {
            resultsHandler?(.failure(.currentVersionReleaseDate))
            return
        }
        
        let model = Model(
            appID: appID,
            currentVersionReleaseDate: currentVersionReleaseDate,
            minimumOSVersion: results.minimumOSVersion,
            releaseNotes: results.releaseNotes,
            version: results.version)
        
        switch versionCheckingStrategy
        {
            case let .mandatoryUpdateOnly(minimumRequiredVersion):
                if DataParser.isVersionOlder(currentAppStoreVersion, than: minimumRequiredVersion)
                {
                    UserDefaults.alertPresentationDate = Date()
                    
                    resultsHandler?(
                        .success(
                            UpdateResults(
                                alertType: .maintenance,
                                model: model)))
                }
                else if DataParser.isVersionOlder(currentInstalledVersion, than: minimumRequiredVersion)
                {
                    UserDefaults.alertPresentationDate = Date()
                    
                    resultsHandler?(
                        .success(
                            UpdateResults(
                                alertType: .force,
                                model: model)))
                }
                else
                {
                    resultsHandler?(.failure(.noUpdateAvailable))
                }
                
            case let .optionalUpdateOnly(recommededVersion):
                if DataParser.isVersionOlder(currentInstalledVersion, than: recommededVersion)
                    && DataParser.isVersionOlder(currentInstalledVersion, than: currentAppStoreVersion)
                {
                    guard let alertPresentationDate = alertPresentationDate else
                    {
                        UserDefaults.alertPresentationDate = Date()
                        
                        resultsHandler?(
                            .success(
                                UpdateResults(
                                    alertType: .soft,
                                    model: model)))
                        
                        return
                    }
                    
                    if Date.days(since: alertPresentationDate) >= softUpdateFrequency.days
                    {
                        UserDefaults.alertPresentationDate = Date()
                        
                        resultsHandler?(
                            .success(
                                UpdateResults(
                                    alertType: .soft,
                                    model: model)))
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
                
            case let .bothMandatoryAndOptional(minimumRequiredVersion, recommededVersion):
                if DataParser.isVersionOlder(currentAppStoreVersion, than: minimumRequiredVersion)
                {
                    UserDefaults.alertPresentationDate = Date()
                    
                    resultsHandler?(
                        .success(
                            UpdateResults(
                                alertType: .maintenance,
                                model: model)))
                }
                else if DataParser.isVersionOlder(currentInstalledVersion, than: minimumRequiredVersion)
                {
                    UserDefaults.alertPresentationDate = Date()
                    
                    resultsHandler?(
                        .success(
                            UpdateResults(
                                alertType: .force,
                                model: model)))
                }
                else if DataParser.isVersionOlder(currentInstalledVersion, than: recommededVersion)
                            && DataParser.isVersionOlder(currentInstalledVersion, than: currentAppStoreVersion)
                {
                    guard let alertPresentationDate = alertPresentationDate else
                    {
                        UserDefaults.alertPresentationDate = Date()
                        
                        resultsHandler?(
                            .success(
                                UpdateResults(
                                    alertType: .soft,
                                    model: model)))
                        
                        return
                    }
                    
                    if Date.days(since: alertPresentationDate) >= softUpdateFrequency.days
                    {
                        UserDefaults.alertPresentationDate = Date()
                        
                        resultsHandler?(
                            .success(
                                UpdateResults(
                                    alertType: .soft,
                                    model: model)))
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
                
            case .newAppStoreUpdateOnly:
                if DataParser.isVersionOlder(currentInstalledVersion, than: currentAppStoreVersion)
                {
                    resultsHandler?(.success(
                        UpdateResults(
                            alertType: .soft,
                            model: model)))
                }
                else
                {
                    resultsHandler?(.failure(.noUpdateAvailable))
                }
        }
    }
}
