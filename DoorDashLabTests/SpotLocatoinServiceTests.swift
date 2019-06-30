//
//  SpotLocatoinServiceTests.swift
//  DoorDashLabTests
//
//  Created by aarthur on 6/30/19.
//  Copyright © 2019 Gigabit LLC. All rights reserved.
//

import XCTest
@testable import DoorDashLab

class SpotLocatoinServiceTests: XCTestCase {
    let spotService = SpotLocatoinService()
    
    func testSpotServiceIsSuspended() {
        spotService.suspend()
        XCTAssertTrue(spotService.isSuspended)
    }

    func testSpotServiceNotSuspended() {
        spotService.resume()
        XCTAssertFalse(spotService.isSuspended)
    }
}
