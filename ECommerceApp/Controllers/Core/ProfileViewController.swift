import UIKit

class ProfileViewController: UIViewController {

    var coordinator: ProfileCoordinatorProtocol?
    var model: ProfileViewModel!

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = Theme.Color.textFieldBackgroundColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Theme.CornerRadius.small
        textField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()

    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = Theme.Color.textFieldBackgroundColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = Theme.CornerRadius.small
        textField.attributedPlaceholder = NSAttributedString(
            string: "Surname",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return textField
    }()

    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Theme.Color.textFieldBackgroundColor
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Theme.CornerRadius.small
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "Your message"
        textView.textColor = Theme.Color.gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.tintColor = Theme.Color.white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = Theme.Color.black
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Theme.CornerRadius.extraLarge
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapToSubmit), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = Theme.Color.white
        return activityIndicatorView
    }()

    private lazy var successView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.Color.secondaryBlack
        view.isHidden = true
        return view
    }()

    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message delivered"
        label.textColor = Theme.Color.white
        label.font = Theme.AppFont.productInfo
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        model = ProfileViewModel()
        subscribeToModel()
        configureNavigationBar()
        addUIElements()
        configureTextFields()
        configureConstraints()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
    }

    @objc private func didTapToSubmit() {
        model.submitForm()
    }

    @objc private func didTapToDismiss() {
        view.endEditing(true)
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    private func showSuccessView() {
        successView.isHidden = false
    }

    private func hideSuccessView() {
        successView.isHidden = true
    }
}

// MARK: - ConfigureNavigationBar
extension ProfileViewController {
    private func configureNavigationBar() {
        navigationItem.title = "Contact Us"
    }
}

extension ProfileViewController: UITextViewDelegate, UITextFieldDelegate {
    func configureTextFields() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        messageTextView.delegate = self

        nameTextField.addTarget(self, action: #selector(didChangeName), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(didChangeSurname), for: .editingChanged)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
        if textView.textColor == Theme.Color.gray {
            textView.textColor = Theme.Color.label
            textView.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if textView.text.isEmpty {
            textView.text = "Your message"
            textView.textColor = Theme.Color.gray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        model.setMessage(text: messageTextView.text)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 30), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension ProfileViewController {
    @objc private func didChangeName() {
        model.setName(text: nameTextField.text ?? "")
    }

    @objc private func didChangeSurname() {
        model.setSurname(text: surnameTextField.text ?? "")
    }

    func clearTextFields() {
        nameTextField.text = ""
        surnameTextField.text = ""
        messageTextView.text = "Your message"
        messageTextView.textColor = Theme.Color.gray
    }
}

// MARK: - SubscribeToModel
extension ProfileViewController {
    private func subscribeToModel() {

        model.isFormValid.bind { [weak self] isFormValid in
            if isFormValid ?? false {
                self?.submitButton.isEnabled = true
            } else {
                self?.submitButton.isEnabled = false
            }
        }

        model.isVisibleSuccessView.bind { [weak self] isVisible in
            if isVisible ?? false {
                self?.showSuccessView()
            } else {
                self?.hideSuccessView()
            }
        }

        model.isLoading.bind { [weak self] isLoading in
            if isLoading == true {
                self?.clearTextFields()
                self?.submitButton.isEnabled = false
                self?.submitButton.setTitle("", for: .normal)
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.submitButton.isEnabled = true
                self?.activityIndicatorView.stopAnimating()
                self?.submitButton.setTitle("Submit", for: .normal)
            }
        }
    }
}

// MARK: - Constraints
extension ProfileViewController {
    private func addUIElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(surnameTextField)
        scrollView.addSubview(messageTextView)
        scrollView.addSubview(submitButton)
        submitButton.addSubview(activityIndicatorView)
        scrollView.addSubview(successView)
        successView.addSubview(successLabel)
    }

    private func configureConstraints() {
        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        let nameTextFieldConstraints = [
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]

        let surnameTextFieldConstraints = [
            surnameTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            surnameTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            surnameTextField.heightAnchor.constraint(equalToConstant: 50)
        ]

        let messageTextViewViewConstraints = [
            messageTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            messageTextView.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 20),
            messageTextView.heightAnchor.constraint(equalToConstant: 150)
        ]

        let submitButtonConstraints = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ]

        let activityIndicatorViewConstraints = [
            activityIndicatorView.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor)
        ]

        let successViewConstraints = [
            successView.heightAnchor.constraint(equalToConstant: 60),
            successView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            successView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            successView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor)
        ]

        let successLabelConstraints = [
            successLabel.centerYAnchor.constraint(equalTo: successView.centerYAnchor),
            successLabel.leadingAnchor.constraint(equalTo: successView.leadingAnchor, constant: 20)
        ]

        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(nameTextFieldConstraints)
        NSLayoutConstraint.activate(surnameTextFieldConstraints)
        NSLayoutConstraint.activate(messageTextViewViewConstraints)
        NSLayoutConstraint.activate(submitButtonConstraints)
        NSLayoutConstraint.activate(activityIndicatorViewConstraints)
        NSLayoutConstraint.activate(successViewConstraints)
        NSLayoutConstraint.activate(successLabelConstraints)
    }
}
