//
//  SignUpViewTest.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-19.
//


import XCTest

final class SignupViewUITest: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["test-ui"]  
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testSignupFlow() {
        let emailTextField = app.textFields["emailTF"]
        let passwordField = app.secureTextFields["passwordTF"]
        let signUpButton = app.buttons["signupBTN"]

        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2))
        XCTAssertTrue(passwordField.waitForExistence(timeout: 2))
        XCTAssertTrue(signUpButton.waitForExistence(timeout: 2))

        emailTextField.tap()
        emailTextField.typeText("test@test.com")

        passwordField.tap()
        passwordField.typeText("password123")

        signUpButton.tap()


        let alert = app.alerts["Login"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
    }
}
