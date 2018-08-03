//
//  AppTabConfiguration.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct AppTapConfiguration: Decodable {
    var recommendedApps: [RecommendedApp]?
    var favoriteCategories: [String]?
    var newRecommendedApps: NewRecommendedAppInfo?
}

struct RecommendedApp: Decodable {
    var appId: String?
    var subTitle: String?
    var description: String?
    var bgImg: String?
}

struct NewRecommendedAppInfo: Decodable {
    var apps: [NewRecommendedApp]?
}

struct NewRecommendedApp: Decodable, Equatable {
    var appId: String?
    var description: String?

    static func == (lhs: NewRecommendedApp, rhs: NewRecommendedApp) -> Bool {
        return lhs.appId! == rhs.appId!
    }
}
