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

    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.backgroundColor = Theme.Color.black
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(Theme.Color.white, for: .normal)
        button.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        return button
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
    }

    @objc private func completeButtonDidTap() {
        print("completeButtonDidTap")
    }
}

// MARK: - SubscribeToModel
extension CartViewController {
    private func subscribeToModel() {
        model.productsInCartData.bind { [weak self] _ in
            self?.tableView.reloadData()
        }

        model.totalPrice.bind { [weak self] totalPrice in
            guard let totalPrice = totalPrice else { return }
            self?.totalPriceValueLabel.text = totalPrice
        }
    }
}

// MARK: - ConfigureNavigationBar
extension CartViewController {
    private func configureNavigationBar() {
        navigationItem.title = "Cart"
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
        return model.productsInCartData.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartProductTableViewCell.identifier,
            for: indexPath
        ) as? CartProductTableViewCell,
            let cartData = model.productsInCartData.value
        else {
            return UITableViewCell()
        }

        let currentCartProduct = cartData[indexPath.row]

        cell.configure(
            image: currentCartProduct.thumbnail,
            title: currentCartProduct.title,
            description: currentCartProduct.description,
            price: currentCartProduct.price,
            quantity: currentCartProduct.quantity
        )

        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension CartViewController: CartProductTableViewCellDelegate {
    func didTapPlusButton() {
        print("didTapPlusButton")
    }

    func didTapMinusButton() {
        print("didTapMinusButton")
    }
}

// MARK: - ConfigureConstraints
extension CartViewController {

    private func addUIElements() {
        view.addSubview(tableView)
        view.addSubview(cartInfoView)
        cartInfoView.addSubview(totalPriceTitleLabel)
        cartInfoView.addSubview(totalPriceValueLabel)
        cartInfoView.addSubview(completeButton)
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

        let completeButtonConstraints = [
            completeButton.centerYAnchor.constraint(equalTo: cartInfoView.centerYAnchor),
            completeButton.leadingAnchor.constraint(equalTo: cartInfoView.centerXAnchor, constant: 10),
            completeButton.trailingAnchor.constraint(equalTo: cartInfoView.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 35)
        ]

        NSLayoutConstraint.activate(cartInfoViewConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
        NSLayoutConstraint.activate(totalPriceTitleLabelConstraints)
        NSLayoutConstraint.activate(totalPriceValueLabelConstraints)
        NSLayoutConstraint.activate(completeButtonConstraints)

    }
}
