//
//  HeaderStickyTabUITests.swift
//  HeaderStickyTabUITests
//
//  Created by nico on 01.07.20.
//  Copyright © 2020 nico. All rights reserved.
//

import XCTest

class HeaderStickyTabUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScrollAndPaging() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Open"]/*[[".buttons[\"Open\"].staticTexts[\"Open\"]",".staticTexts[\"Open\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.staticTexts["Full Name"].isHittable)
        
        app/*@START_MENU_TOKEN@*/.buttons["Second"]/*[[".segmentedControls.buttons[\"Second\"]",".buttons[\"Second\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["First"]/*[[".segmentedControls.buttons[\"First\"]",".buttons[\"First\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Row 8"]/*[[".scrollViews.tables",".cells.staticTexts[\"Row 8\"]",".staticTexts[\"Row 8\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.swipeUp()
        
        XCTAssertFalse(app.staticTexts["Full Name"].isHittable)
        
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Row 25"]/*[[".scrollViews.tables",".cells.staticTexts[\"Row 25\"]",".staticTexts[\"Row 25\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.swipeLeft()
        app.buttons["First"].tap()
        app.tables.staticTexts["Row 13"].swipeDown()
        XCTAssertTrue(app.staticTexts["Full Name"].isHittable)
    }
}
