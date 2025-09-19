//
//  SignInViewTest.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-19.
//

import XCTest

final class SignInViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["test-ui"]  //identifier for testing
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testSignInFlow() {
        let emailTextField = app.textFields["emailTF"]
        let passwordSecureField = app.secureTextFields["passwordTF"]
        let signInButton = app.buttons["signInBTN"]

        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2))
        XCTAssertTrue(passwordSecureField.waitForExistence(timeout: 2))
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2))

        emailTextField.tap()
        emailTextField.typeText("test@test.com")

        passwordSecureField.tap()
        passwordSecureField.typeText("password123")

        signInButton.tap()

        let loginAlert = app.alerts["Login"]
        XCTAssertTrue(loginAlert.waitForExistence(timeout: 2))
    }
}
