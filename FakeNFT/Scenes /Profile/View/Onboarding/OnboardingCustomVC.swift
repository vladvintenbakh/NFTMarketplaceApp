//
//  OnboardingCustomVC.swift
//  Tracker
//
//  Created by Kirill Sklyarov on 04.04.2024.
//

import UIKit

final class OnboardingCustomVC: UIViewController {

    // MARK: - UI Properties
    private lazy var image = UIImageView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline1
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    } ()
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    } ()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Что внутри?", for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.backgroundColor = UIColor.yaBlackLight
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(onboardingButtonTapped2), for: .touchUpInside)
        return button
    } ()
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        let image = UIImage(named: "close")?.withTintColor(UIColor.textOnPrimary, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(onboardingButtonTapped2), for: .touchUpInside)
        return button
    } ()

    // MARK: - Other Properties
    let userDefaults = UserDefaults.standard

    // MARK: - Init
    init(image: String, titleText: String, subTitleText: String,  isButtonHidden: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.image.image = UIImage(named: image)
        self.titleLabel.text = titleText
        self.subTitleLabel.text = subTitleText
        self.doneButton.isHidden = isButtonHidden
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradient(view: image)
    }

    // MARK: - IB Actions
    @objc private func onboardingButtonTapped2(_ sender: UIButton) {
        userDefaults.set(true, forKey: "onboardingButtonTapped")

        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )

        let tabBarController = TabBarController()
        tabBarController.servicesAssembly = servicesAssembly
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }

    // MARK: - Private methods
    private func setupUI() {

        view.addSubViews([image, closeButton, titleLabel, subTitleLabel, doneButton])

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),

            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])

    }

    private func setGradient(view: UIImageView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        let colors: [CGColor] = [
            UIColor.yaBlackLight.withAlphaComponent(1).cgColor,
            UIColor.yaBlackLight.withAlphaComponent(0).cgColor
        ]
        gradientLayer.colors = colors

        view.layer.addSublayer(gradientLayer)
    }
}
