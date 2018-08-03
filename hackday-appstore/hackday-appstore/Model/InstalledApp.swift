//
//  InstalledApp.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct InstalledAppInfo: Decodable {
    private(set) var installedApp: [InstalledApp]?
    private(set) var deletedApp: [InstalledApp]?
}

struct InstalledApp: Decodable, Equatable {

    var appId: String?
    var version: String?
    var lastUpdateDate: String?

    func needUpdate(lastedApp: InstalledApp) -> Bool {
        return version! < lastedApp.version!
    }

    static func ==(lhs: InstalledApp, rhs: InstalledApp) -> Bool {
        return lhs.appId! == rhs.appId!
    }
}
