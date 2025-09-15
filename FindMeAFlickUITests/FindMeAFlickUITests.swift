//
//  FindMeAFlickUITests.swift
//  FindMeAFlickUITests
//
//  Created by P10 on 15/09/25.
//
import XCTest
final class FavoriteMoviesUITests: XCTestCase {
    func testOpenApp_andOpenDetails() {
        let app = XCUIApplication()
        app.launch()
        // Wait for table, tap first cell
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()
        // check detail title exists
        let addButton = app.buttons["Add to Favorites"]
        XCTAssertTrue(addButton.exists || app.buttons["Remove Favorite"].exists)
    }
}
