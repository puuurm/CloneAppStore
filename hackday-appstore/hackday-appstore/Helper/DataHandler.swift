//
//  DataHandler.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

enum AppStatus: String {
    case neverInstalled
    case installed
    case deleted
    case needUpdate
}

// MARK: check app status
protocol AppStatusInDeviceCheckable {

    // 단위 테스트
    var appListInDevice: InstalledAppInfo { get set }

}

extension AppStatusInDeviceCheckable {
    func getAppStatusDescription(app: App) -> String {
        let appStatus = checkAppStatus(app: app)
        switch appStatus {
        case .neverInstalled: return app.isFreeApp() ? "받기" : "USD \((app.info?.priceInfo?.appPrice())!)"
        case .installed: return "열기"
        case .deleted: return ""
        case .needUpdate: return "업데이트"
        }
    }

    fileprivate func checkAppStatus(app: App) -> AppStatus {
        let checkableApp = convertCheckableApp(app: app)

        if let appInDevice = getInstallApp(checkableApp: checkableApp) {
            return appInDevice.needUpdate(lastedApp: checkableApp) == true ? .needUpdate : .installed
        }

        return isDeletedApp(checkableApp: checkableApp) ? .deleted : .neverInstalled
    }

    private func convertCheckableApp(app: App) -> InstalledApp {
        return InstalledApp(appId: app.appId, version: app.info?.versionInfo?.version, lastUpdateDate: nil)
    }

    private func getInstallApp(checkableApp: InstalledApp) -> InstalledApp? {
        if let index = appListInDevice.installedApp?.index(of: checkableApp) {
            return appListInDevice.installedApp?[index]
        }

        return nil
    }

    private func isDeletedApp(checkableApp: InstalledApp) -> Bool {
        return appListInDevice.deletedApp?.index(of: checkableApp) != nil
    }
}
// MARK: Recommended / New recommended app list section in app tab of app store
protocol RecommendedAppListExtractable: AppStatusInDeviceCheckable {
    var allAppList: Apps { get set }
    var appTapConfiguration: AppTapConfiguration { get set }
}

extension RecommendedAppListExtractable {
    func extractRecommendedAppSectionInfo() -> [(recommendedAppInfo: RecommendedApp , app: App)]? {

        var recommendedInfoList = [(recommendedAppInfo: RecommendedApp , app: App)]()

        if let recommendedApps = appTapConfiguration.recommendedApps {
            for recommendedApp in recommendedApps {
                let appListToNeedUpdate = allAppList.appInfo?.filter({ (app: App) -> Bool in
                    return recommendedApp.appId == app.appId
                })

                recommendedInfoList.append(((recommendedAppInfo: recommendedApp, app: appListToNeedUpdate![0])))
            }
        }

        return recommendedInfoList
    }

    func extractNewRecommendedAppSectionInfo() -> [(app: App, status: String)]? {

        if let newRecommededApps = appTapConfiguration.newRecommendedApps {
            let newRecommendedAppSectionInfo = newRecommededApps.apps?.map{ (recommendedApp: NewRecommendedApp) -> (App, String) in

                let convertedApp = App(appId: recommendedApp.appId, info: nil, resource: nil)
                if let appIndex = allAppList.appInfo?.index(of: convertedApp) {
                    let app = allAppList.appInfo![appIndex]
                    return (app, self.getAppStatusDescription(app: app))
                }

                return (App(), "")
            }

            return newRecommendedAppSectionInfo
        }

        return nil
    }
}
// MARK: Ranked app list in app tab of app store, by category
protocol RankedAppListExtractable: AppStatusInDeviceCheckable {
    var allAppList: Apps {get set}
}

extension RankedAppListExtractable {
    func extractRankedAppList(category: Category?, extractFreeApp: Bool) -> [(app: App, status: String)]? {
        let appInfoList = allAppList.appInfo
        let extractApps = extractFreeApp == true ? appInfoList?.filter { $0.isFreeApp() } : appInfoList?.filter { !$0.isFreeApp() }
        return extractApps?.sorted().map { ($0, self.getAppStatusDescription(app: $0)) }
    }
}

