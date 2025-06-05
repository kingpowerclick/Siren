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
        minimumRequiredVersion: String,
        recommendedVersion: String,
        storedSkippedVersion: String?,
        appStoreDataModel: AppStoreDataModel?,
        completion handler: ((Result<UpdateResults, KnownError>) -> Void)?)
}


public struct DefaultVersionCheckingStrategy: VersionCheckingStrategy
{
    public static var `default`: DefaultVersionCheckingStrategy = .init()
    
    public func evaluateUpdate(
        currentInstalledVersion: String,
        currentAppStoreVersion: String?,
        minimumRequiredVersion: String,
        recommendedVersion: String,
        storedSkippedVersion: String?,
        appStoreDataModel: AppStoreDataModel?,
        completion handler: ((Result<UpdateResults, KnownError>) -> Void)? = nil)
    {
        if currentInstalledVersion.isVersionOlder(than: minimumRequiredVersion)
        {
            // forceUpdate
            handler?(
                .success(
                    UpdateResults(
                        alertType: .force,
                        model: appStoreDataModel)))
        }
        else if currentInstalledVersion.isVersionOlder(than: recommendedVersion)
        {
            if storedSkippedVersion == nil
                || storedSkippedVersion != recommendedVersion
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
        minimumRequiredVersion: String,
        recommendedVersion: String,
        storedSkippedVersion: String?,
        appStoreDataModel: AppStoreDataModel?,
        completion handler: ((Result<UpdateResults, KnownError>) -> Void)? = nil)
    {
        guard let currentAppStoreVersion = currentAppStoreVersion else
        {
            return
        }
        
        if currentInstalledVersion.isVersionOlder(than: minimumRequiredVersion)
        {
            if currentAppStoreVersion.isVersionOlder(than: minimumRequiredVersion)
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
        else if currentInstalledVersion.isVersionOlder(than: recommendedVersion)
                    && currentInstalledVersion.isVersionOlder(than: currentAppStoreVersion)
        {
            if storedSkippedVersion == nil
                || storedSkippedVersion != recommendedVersion
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
