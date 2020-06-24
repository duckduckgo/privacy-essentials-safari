//
//  TempUnprotectedSitesDataServiceUserDefaultsTests.swift
//  UnitTests
//
//  Copyright © 2019 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import XCTest

@testable import TrackerBlocking

class TempUnprotectedSitesDataServiceUserDefaultsTests: XCTestCase {
    
    let testGroupName = "test"
    
    override func setUp() {
        UserDefaults(suiteName: testGroupName)?.removePersistentDomain(forName: testGroupName)
    }

    func testWhenInitializedThenEtagIsNil() {
        let userDefaults = TempUnprotectedSitesDataServiceUserDefaults(userDefaults: UserDefaults(suiteName: testGroupName)!)
        XCTAssertNil(userDefaults.etag)
    }
    
    func testWhenEtagIsSetThenItIsPersisted() {
        let userDefaults = TempUnprotectedSitesDataServiceUserDefaults(userDefaults: UserDefaults(suiteName: testGroupName)!)
        let etag = "abcd"
        userDefaults.etag = etag
        XCTAssertEqual(etag, userDefaults.etag)
    }
}
