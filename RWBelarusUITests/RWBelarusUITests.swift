//
//  RWBelarusUITests.swift
//  RWBelarusUITests
//
//  Created by Vadzim Mikalayeu on 12/5/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import XCTest

class RWBelarusUITests: XCTestCase {

    override func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let app = XCUIApplication()
        app.staticTexts["FROM"].tap()
        
        let searchByStationOrRouteSearchField = app.navigationBars["RWBelarus.SearchAutocompleteView"].searchFields["Search by station or route"]
        searchByStationOrRouteSearchField.tap()
        searchByStationOrRouteSearchField.typeText("lida")
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["LIDA"]/*[[".cells.staticTexts[\"LIDA\"]",".staticTexts[\"LIDA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["TO"].tap()
        searchByStationOrRouteSearchField.typeText("Minsk")
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["g. Minsk, Belarus"]/*[[".cells.staticTexts[\"g. Minsk, Belarus\"]",".staticTexts[\"g. Minsk, Belarus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["tomorrow"].press(forDuration: 0.5)
        
        snapshot("0Launch")
        
        app.buttons["SEARCH TRAINS"].press(forDuration: 0.5)
        sleep(2)

        tablesQuery.cells.tables.cells.containing(.staticText, identifier: "79").staticTexts["5.03 BYN"].tap()
        
        snapshot("1Launch")
        
        app.navigationBars["RWBelarus.CarriageSchemeView"].buttons["Cancel"].press(forDuration: 0.5)
        
        tablesQuery.cells.containing(.staticText, identifier: "08:18").staticTexts["till 08.12, everyday"].press(forDuration: 0.5)
        sleep(2)
        snapshot("2Launch")
        
        app.tabBars.children(matching: .button).element(boundBy: 1).tap()
        app.staticTexts["STATION"].tap()
        app.navigationBars["RWBelarus.SearchAutocompleteView"].searchFields["Search by station or route"].typeText("lida")
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["LIDA"]/*[[".cells.staticTexts[\"LIDA\"]",".staticTexts[\"LIDA\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("3Launch")
        sleep(2)
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .button)["all days"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["12"]/*[[".cells.staticTexts[\"12\"]",".staticTexts[\"12\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Done"].tap()
        
        snapshot("4Launch")
        app.buttons["Done"].press(forDuration: 1)
        app.buttons["SCHEDULE"].press(forDuration: 2)
        sleep(2)
        snapshot("5Launch")
        tablesQuery.staticTexts["Departure: 03:35"].press(forDuration: 1)
        
    }

}
