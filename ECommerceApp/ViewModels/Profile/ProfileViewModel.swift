import Foundation

final class ProfileViewModel {
    private(set) var isFormValid = Observable<Bool>()
    private(set) var isLoading = Observable<Bool>()
    private(set) var name = Observable<String>()
    private(set) var surname = Observable<String>()
    private(set) var message = Observable<String>()
    private(set) var isVisibleSuccessView = Observable<Bool>()

    init() {
        self.isFormValid.value = false
        self.isLoading.value = false
        self.name.value = ""
        self.surname.value = ""
        self.message.value = ""
        self.isVisibleSuccessView.value = false
    }

    func setName(text: String) {
        name.value = text
        checkFormValidations()
    }

    func setSurname(text: String) {
        surname.value = text
        checkFormValidations()
    }

    func setMessage(text: String) {
        message.value = text
        checkFormValidations()
    }

    func submitForm() {
        isLoading.value = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.resetForm()
            self.showSuccessView()
        })

    }

    // MARK: - Private Methods
    private func showSuccessView() {
        isVisibleSuccessView.value = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.isVisibleSuccessView.value = false
        })
    }

    private func checkFormValidations() {
        guard let isFormValidValue = isFormValid.value,
              let isLoadingValue = isLoading.value
        else { return }

        if textFieldsAreFull() && !isLoadingValue {
            if !isFormValidValue {
                isFormValid.value = true
            }
        } else {
            if isFormValidValue {
                isFormValid.value = false
            }
        }
    }

    private func textFieldsAreFull() -> Bool {
        guard let nameValue = name.value,
              let surnameValue = surname.value,
              let messageValue = message.value
        else { return true }

        return nameValue.count > 2 && surnameValue.count > 2 && messageValue.count > 2
    }

    private func resetForm() {
        isLoading.value = false
        isFormValid.value = false
        name.value = ""
        surname.value = ""
        message.value = ""
    }
}
