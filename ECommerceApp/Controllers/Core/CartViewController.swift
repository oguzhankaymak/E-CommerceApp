import UIKit

class CartViewController: UIViewController {

    var coordinator: CartCoordinatorProtocol?
    var model: CartViewModel!

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Theme.Color.backgroundColor
        tableView.separatorInset = .zero
        return tableView
    }()

    private lazy var cartInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.Color.antiFlashWhite.cgColor
        return view
    }()

    private lazy var totalPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total"
        label.font = Theme.AppFont.productCardPrice
        label.textColor = Theme.Color.gray
        return label
    }()

    private lazy var totalPriceValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productInfo
        label.text = model.totalPrice.value
        return label
    }()

    private lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.backgroundColor = Theme.Color.black
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(Theme.Color.white, for: .normal)
        button.addTarget(self, action: #selector(checkoutButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var emptyDataView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        return view
    }()

    private lazy var emptyDataIconView: UIImageView = {
        let image = UIImage(
            systemName: "cart.badge.plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)
        )?.withTintColor(Theme.Color.lightGrey, renderingMode: .alwaysOriginal)

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var emptyDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.AppFont.productInfo
        label.text = "Your cart is empty"
        label.textColor = Theme.Color.lightGrey
        return label
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .white
        return activityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        model = CartViewModel()
        configureNavigationBar()
        addUIElements()
        configureTableView()
        configureConstraints()
        subscribeToModel()
        updateUIBasedOnCart()
    }

    @objc private func checkoutButtonDidTap() {
        model.checkout()
    }
}

// MARK: - SubscribeToModel
extension CartViewController {
    private func subscribeToModel() {
        model.cartData.bind { [weak self] _ in
            self?.tableView.reloadData()
            self?.updateUIBasedOnCart()
        }

        model.totalPrice.bind { [weak self] totalPrice in
            guard let totalPrice = totalPrice else { return }
            self?.totalPriceValueLabel.text = totalPrice
        }

        model.warning.bind { [weak self] warning in
            guard let warning = warning else { return }

            if warning.warningType == "clearCart" {
                self?.showWarningMessage(
                    title: warning.title,
                    message: warning.message) {
                        self?.model.forceClearCart()
                    } handlerCancel: {
                        return
                    }
            }
        }

        model.isLoading.bind { [weak self] isLoading in
            if isLoading == true {
                self?.checkoutButton.isEnabled = false
                self?.checkoutButton.setTitle("", for: .normal)
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.checkoutButton.isEnabled = true
                self?.activityIndicatorView.stopAnimating()
                self?.checkoutButton.setTitle("Checkout", for: .normal)
            }
        }

        model.onComplete = {
            self.coordinator?.goToSuccess()
        }
    }
}

// MARK: - ConfigureNavigationBar
extension CartViewController {
    private func configureNavigationBar() {
        navigationItem.title = "Cart"

        let trashImage = UIImage(
            systemName: "trash.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )?.withTintColor(.red, renderingMode: .alwaysOriginal)

        let trashButton = UIButton(type: .custom)
        trashButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        trashButton.setImage(trashImage, for: .normal)
        trashButton.addTarget(self, action: #selector(clearCart), for: .touchUpInside)

        let rightBarButtonItem = UIBarButtonItem(customView: trashButton)
        rightBarButtonItem.customView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        rightBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 32).isActive = true

        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc private func clearCart() {
        model.clearCart()
    }
}

// MARK: - ConfigureTableView
extension CartViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(CartProductTableViewCell.self, forCellReuseIdentifier: CartProductTableViewCell.identifier)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cartData.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartProductTableViewCell.identifier,
            for: indexPath
        ) as? CartProductTableViewCell,
            let cartData = model.cartData.value
        else {
            return UITableViewCell()
        }

        let currentCartProduct = cartData[indexPath.row]

        cell.configure(cartProduct: currentCartProduct)
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            guard let cartData = model.cartData.value else { return }
            model.removeProductFromCart(cartProduct: cartData[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension CartViewController: CartProductTableViewCellDelegate {
    func didTapPlusButton(cartProduct: CartProduct) {
        model.addProductToCart(cartProduct: cartProduct)
    }

    func didTapMinusButton(cartProduct: CartProduct) {
        model.decreaseProductQuantityInCart(cartProduct: cartProduct)
    }
}

// MARK: - ConfigureConstraints
extension CartViewController {

    private func updateUIBasedOnCart() {

        if let data = model.cartData.value {
            if data.isEmpty {
                navigationItem.rightBarButtonItem?.isHidden = true
                cartInfoView.isHidden = true
                emptyDataView.addSubview(emptyDataIconView)
                emptyDataView.addSubview(emptyDataLabel)

                NSLayoutConstraint.activate([
                    emptyDataIconView.centerYAnchor.constraint(equalTo: emptyDataView.centerYAnchor, constant: -20),
                    emptyDataIconView.centerXAnchor.constraint(equalTo: emptyDataView.centerXAnchor),
                    emptyDataLabel.topAnchor.constraint(equalTo: emptyDataIconView.bottomAnchor, constant: 20),
                    emptyDataLabel.centerXAnchor.constraint(equalTo: emptyDataView.centerXAnchor)
                ])

                tableView.backgroundView = emptyDataView
            } else {
                navigationItem.rightBarButtonItem?.isHidden = false
                cartInfoView.isHidden = false
                tableView.backgroundView = nil
            }
        }
    }

    private func addUIElements() {
        view.addSubview(tableView)
        view.addSubview(cartInfoView)
        cartInfoView.addSubview(totalPriceTitleLabel)
        cartInfoView.addSubview(totalPriceValueLabel)
        cartInfoView.addSubview(checkoutButton)
        checkoutButton.addSubview(activityIndicatorView)
    }

    private func configureConstraints() {

        let cartInfoViewConstraints = [
            cartInfoView.heightAnchor.constraint(equalToConstant: 60),
            cartInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cartInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cartInfoView.topAnchor)
        ]

        let totalPriceTitleLabelConstraints = [
            totalPriceTitleLabel.leadingAnchor.constraint(equalTo: cartInfoView.leadingAnchor, constant: 40),
            totalPriceTitleLabel.centerYAnchor.constraint(equalTo: cartInfoView.centerYAnchor, constant: -10)
        ]

        let totalPriceValueLabelConstraints = [
            totalPriceValueLabel.leadingAnchor.constraint(equalTo: totalPriceTitleLabel.leadingAnchor),
            totalPriceValueLabel.topAnchor.constraint(equalTo: totalPriceTitleLabel.bottomAnchor, constant: 4)
        ]

        let checkoutButtonConstraints = [
            checkoutButton.centerYAnchor.constraint(equalTo: cartInfoView.centerYAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: cartInfoView.centerXAnchor, constant: 10),
            checkoutButton.trailingAnchor.constraint(equalTo: cartInfoView.trailingAnchor, constant: -20),
            checkoutButton.heightAnchor.constraint(equalToConstant: 35)
        ]

        let activityIndicatorViewConstraints = [
            activityIndicatorView.centerXAnchor.constraint(equalTo: checkoutButton.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: checkoutButton.centerYAnchor)
        ]

        NSLayoutConstraint.activate(cartInfoViewConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
        NSLayoutConstraint.activate(totalPriceTitleLabelConstraints)
        NSLayoutConstraint.activate(totalPriceValueLabelConstraints)
        NSLayoutConstraint.activate(checkoutButtonConstraints)
        NSLayoutConstraint.activate(activityIndicatorViewConstraints)
    }
}
