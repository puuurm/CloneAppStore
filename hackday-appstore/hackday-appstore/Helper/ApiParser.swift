//
//  ApiParser.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct ApiParser<Model: Decodable> {

    static func jsonParse(json: JsonResponse) -> Model? {
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Model.self, from: data)
    }
}
