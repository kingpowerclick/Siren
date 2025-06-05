//
//  VersionCheckingStrategy.swift
//  Siren
//
//  Created by Thanut Sajjakulnukit on 30/5/2568 BE.
//

public protocol VersionCheckingStrategy
{
    func evaluateUpdate(
        currentInstalledVersion: String,
        currentAppStoreVersion: String?,
        mandatoryUpdateVersion: String,
        minimumSuggestedVersion: String,
        userPreviouslySkippedVersion: String?,
        appStoreDataModel: AppStoreDataModel?,
        completion handler: ((Result<UpdateResults, KnownError>) -> Void)?)
}


public struct DefaultVersionCheckingStrategy: VersionCheckingStrategy
{
    public static var `default`: DefaultVersionCheckingStrategy = .init()
    
    public func evaluateUpdate(
        currentInstalledVersion: String,
        currentAppStoreVersion: String?,
        mandatoryUpdateVersion: String,
        minimumSuggestedVersion: String,
        userPreviouslySkippedVersion: String?,
        appStoreDataModel: AppStoreDataModel?,
        completion handler: ((Result<UpdateResults, KnownError>) -> Void)? = nil)
    {
        if currentInstalledVersion.isVersionOlder(than: mandatoryUpdateVersion)
        {
            // forceUpdate
            handler?(
                .success(
                    UpdateResults(
                        alertType: .force,
                        model: appStoreDataModel)))
        }
        else if currentInstalledVersion.isVersionOlder(than: minimumSuggestedVersion)
        {
            if userPreviouslySkippedVersion == nil
                || userPreviouslySkippedVersion != minimumSuggestedVersion
            {
                // softUpdate
                handler?(
                    .success(
                        UpdateResults(
                            alertType: .soft,
                            model: appStoreDataModel)))
            }
            else
            {
                // do-nothing
                handler?(.failure(.noUpdateAvailable))
            }
        }
        else
        {
            // do-nothing
            handler?(.failure(.noUpdateAvailable))
        }
    }
}

public struct AppStoreVersionCheckingStrategy: VersionCheckingStrategy
{
    public static var `default`: AppStoreVersionCheckingStrategy = .init()
    
    public func evaluateUpdate(
        currentInstalledVersion: String,
        currentAppStoreVersion: String?,
        mandatoryUpdateVersion: String,
        minimumSuggestedVersion: String,
        userPreviouslySkippedVersion: String?,
        appStoreDataModel: AppStoreDataModel?,
        completion handler: ((Result<UpdateResults, KnownError>) -> Void)? = nil)
    {
        guard let currentAppStoreVersion = currentAppStoreVersion else
        {
            return
        }
        
        if currentInstalledVersion.isVersionOlder(than: mandatoryUpdateVersion)
        {
            if currentAppStoreVersion.isVersionOlder(than: mandatoryUpdateVersion)
            {
                // maintenance
                handler?(
                    .success(
                        UpdateResults(
                            alertType: .maintenance,
                            model: appStoreDataModel)))
            }
            else
            {
                // forceUpdate
                handler?(
                    .success(
                        UpdateResults(
                            alertType: .force,
                            model: appStoreDataModel)))
            }
        }
        else if currentInstalledVersion.isVersionOlder(than: minimumSuggestedVersion)
                    && currentInstalledVersion.isVersionOlder(than: currentAppStoreVersion)
        {
            if userPreviouslySkippedVersion == nil
                || userPreviouslySkippedVersion != minimumSuggestedVersion
            {
                // softUpdate
                handler?(
                    .success(
                        UpdateResults(
                            alertType: .soft,
                            model: appStoreDataModel)))
            }
            else
            {
                // do-nothing
                handler?(.failure(.noUpdateAvailable))
            }
        }
        else
        {
            // do-nothing
            handler?(.failure(.noUpdateAvailable))
        }
    }
}
