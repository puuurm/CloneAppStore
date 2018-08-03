//
//  ApiCenter.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 15..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

typealias JsonResponse = String

struct ApiCenter<Model: Decodable> {

    typealias AfterSuccess = ((Model?) -> Void)
    typealias AfterFailure = (() -> Void)
    
    static func requestInfo(_ plistFileName: PlistFileName, success: AfterSuccess?, failure: AfterFailure?) throws {
        guard let dictionaty = getDictionaryFromPlist(fileName: plistFileName.rawValue) else { return }
        let json = makeJson(dictionary: dictionaty)
        if json.count > 0,
            let model: Model = ApiParser<Model>.jsonParse(json: json) {
            success?(model)
        } else {
            failure?()
        }
    }

    static private func getDictionaryFromPlist(fileName: String) -> [String : AnyObject]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
                return nil
        }
        return dict
    }

    static private func makeJson(dictionary: [String : AnyObject]) -> JsonResponse {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            return ""
        } catch {
            return ""
        }
    }

    
}

enum PlistFileName: String {
    case appFile = "App"
    case AppTapConfiguration = "AppTapConfiguration"
    case category = "Category"
    case installedApp = "InstalledApp"
}
