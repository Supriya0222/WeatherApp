//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import XCTest
@testable import WeatherApp
import CoreLocation

final class WeatherAppTests: XCTestCase {
    var viewModel: WeatherViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetRegionName() {

        let location = CLLocation(latitude: 51.50998, longitude: -0.1337)
        viewModel?.getRegion(location, completion: { result in
            XCTAssertEqual(result, "London")

        })
    }
    
    func testForDate() {
        let timestamp: Double = 1702241530
        let result = DateUtility.formatDateFromTimestamp(timestamp: timestamp)
        
        XCTAssertEqual(result, "2023/12/11\u{00a0}00.52")

    }


}
