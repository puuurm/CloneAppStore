//
//  Category.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import Foundation

struct Categories: Decodable {
    private(set) var categoryInfo: [Category]?
}

struct Category: Decodable, Comparable {

    var categoryId: String?
    var categoryName: String?
    var rank: String?

    static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.categoryId! == rhs.categoryId!
    }

    static func <(lhs: Category, rhs: Category) -> Bool {
        return Int(lhs.rank!)! < Int(rhs.rank!)!
    }

}
