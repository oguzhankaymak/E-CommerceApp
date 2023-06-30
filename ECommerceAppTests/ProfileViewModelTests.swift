import XCTest
@testable import ECommerceApp

final class ProfileViewModelTests: XCTestCase {

    var viewModel: ProfileViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ProfileViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testSetName() {
        let testName = "Oğuzhan"

        viewModel.name.bind { name in
            XCTAssertEqual(name, testName, "The name property should be updated correctly")

            guard let isFormValid = self.viewModel.isFormValid.value else {
                return XCTFail("isFormValid value was nil")
            }

            XCTAssertFalse(isFormValid, "isFormValid should be false because other fields are empty")
        }

        viewModel.setName(text: testName)
    }

    func testSetSurname() {
        let testSurname = "Kaymak"

        viewModel.surname.bind { surname in
            XCTAssertEqual(surname, testSurname, "The surname property should be updated correctly")

            guard let isFormValid = self.viewModel.isFormValid.value else {
                return XCTFail("isFormValid value was nil")
            }

            XCTAssertFalse(isFormValid, "isFormValid should be false because other fields are empty")
        }

        viewModel.setSurname(text: testSurname)
    }

    func testSetMessage() {
        let testMessage = "Hello, World!"

        viewModel.message.bind { message in
            XCTAssertEqual(message, testMessage, "The message property should be updated correctly")

            guard let isFormValid = self.viewModel.isFormValid.value else {
                return XCTFail("isFormValid value was nil")
            }

            XCTAssertFalse(isFormValid, "isFormValid should be false when the message field is not empty")
        }

        viewModel.setMessage(text: testMessage)

    }

    func testValidForm() {
        let testName = "Oğuzhan"
        let testSurname = "Kaymak"
        let testMessage = "Hello, World!"

        viewModel.isFormValid.bind { isFormValid in
            guard let isFormValid = isFormValid else {
                return XCTFail("isFormValid value was nil")
            }

            XCTAssertTrue(
                isFormValid,
                "isFormValid should be true when all the text fields have a length greater than 2"
            )
        }

        viewModel.setName(text: testName)
        viewModel.setSurname(text: testSurname)
        viewModel.setMessage(text: testMessage)
    }

}
