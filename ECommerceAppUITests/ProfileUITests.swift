import XCTest

final class ProfileUITests: XCTestCase {

    func testContactUsForm() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["profile_tabBarItem"].tap()

        let nameTextField = app.textFields["name_text_field"]
        XCTAssertTrue(nameTextField.exists, "The name text field should be displayed on the profile screen.")

        nameTextField.tap()
        nameTextField.typeText("Name")

        let surnameTextField = app.textFields["surname_text_field"]
        XCTAssertTrue(surnameTextField.exists, "The surname text field should be displayed on the profile screen.")

        surnameTextField.tap()
        surnameTextField.typeText("Surname")

        let messageTextView = app.textViews["message_text_view"]
        XCTAssertTrue(messageTextView.exists, "The message text view should be displayed on the profile screen.")

        messageTextView.tap()
        messageTextView.typeText("Hello World!")

        app.buttons["submit_button"].tap()
        Thread.sleep(forTimeInterval: 1)

        let successMessageLabel = app.staticTexts["success_label"]
        XCTAssertTrue(
            successMessageLabel.exists,
            "The success message label should be displayed after submitting the contact form."
        )
    }
}
