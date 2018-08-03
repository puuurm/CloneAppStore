//
//  ApiCenterTest.swift
//  hackday-appstoreTests
//
//  Created by yangpc on 2018. 5. 16..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import XCTest
@testable import hackday_appstore

class ApiCenterTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testApiApp() {
        do {
            try ApiCenter.requestInfo(PlistFileName.appFile, success: { (model: Apps?) in
                if let apps = model {
                    print(apps)
                }
            }, failure: {
                print("error")
            })
        } catch {
            print(error)
        }
    }

    func testApiAppTabConfig() {

        do {
            try ApiCenter.requestInfo(
                PlistFileName.AppTapConfiguration,
                success: { (model: AppTapConfiguration?) in
                    print(model!)
            }, failure: nil)
        } catch {
            print(error)
        }

    }

    func testApiCategory() {

        do {
            try ApiCenter.requestInfo(PlistFileName.category, success: { (model: Categories?) in
                print(model!)
            }, failure: {
            })
        } catch {
            print(error)
        }

    }

    func testApiInstalledApp() {

        do {
            try ApiCenter.requestInfo(.installedApp, success: { (model: InstalledAppInfo?) in
                print(model!)
            }, failure: {
            })
        } catch {
            print(error)
        }

    }


}
