//
//  EditProfileViewController.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 14.05.2024.
//

import UIKit

protocol EditProfileViewProtocol: AnyObject {
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func updateDescription(_ description: String)
    func updateWebsite(_ webSite: String)
    func updatePhoto(_ photoName: String)
    func updateName(_ name: String)
}

final class EditProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        let paddingLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftView = paddingLeftView
        textField.leftViewMode = .always
        textField.font = UIFont.bodyRegular
        textField.backgroundColor = UIColor.segmentInactive
        textField.layer.cornerRadius = 12
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.delegate = self
        return textField
    } ()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.font = UIFont.bodyRegular
        textView.backgroundColor = UIColor.segmentInactive
        textView.layer.cornerRadius = 12
        textView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        textView.delegate = self
        return textView
    } ()
    private lazy var webSiteTextField: UITextField = {
        let siteField = UITextField()
        siteField.backgroundColor = UIColor.segmentInactive
        siteField.layer.cornerRadius = 12
        let paddingLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: siteField.frame.height))
        siteField.leftView = paddingLeftView
        siteField.leftViewMode = .always
        siteField.delegate = self
        siteField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return siteField
    } ()
    private lazy var loadNewPhoto: UILabel = {
        let label = UILabel()
        label.text = "Загрузить изображение"
        label.font = UIFont.bodyRegular
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 45).isActive = true
        label.isHidden = true
        return label
    } ()
    private lazy var photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.round(squareSize: 70)
        return imageView
    }()

    // MARK: - Presenter
    var presenter: EditProfilePresenterProtocol

    // MARK: - Init
    init(presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupLayout()
    }

    // MARK: - IB Actions
    @objc private func closeButtonTapped(sender: UIButton) {
        presenter.closeButtonTapped()
    }

    @objc private func clearTextButtonTapped(sender: UIButton) {
        nameTextField.text = ""
    }

    @objc private func changePhotoButtonTapped(sender: UIButton) {
        print("Why don't you like Hoakin?")
        loadNewPhoto.isHidden = false
    }

    // MARK: - Public methods
    func updateName(_ name: String) {
        nameTextField.text = name
    }

    func updateDescription(_ description: String) {
        descriptionTextView.text = description
    }

    func updateWebsite(_ webSite: String) {
        webSiteTextField.text = webSite
    }

    func updatePhoto(_ photoName: String) {
        photoImage.image = UIImage(named: photoName)
    }

    // MARK: - Private methods
    private func setupLayout() {
        view.backgroundColor = UIColor.backgroundActive
        setupNavigation()
        setupContentStack()
    }

    private func setupNavigation() {
        let closeImage = UIImage(named: "plus")
        let colorImage = closeImage?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: colorImage, landscapeImagePhone: nil, style: .done, target: self, action: #selector(closeButtonTapped))
    }

    private func setupContentStack() {
        let photoView = photoView()

        let nameStack = nameStack()
        let descriptionStack = descriptionStack()
        let siteStack = siteStack()

        let stack = UIStackView(arrangedSubviews: [nameStack, descriptionStack, siteStack, UIView()])
        stack.axis = .vertical
        stack.spacing = 24

        view.addSubViews([photoView, loadNewPhoto, stack])

        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 70),
            photoView.widthAnchor.constraint(equalToConstant: 70),

            loadNewPhoto.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 4),
            loadNewPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 63),
            loadNewPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -63),

            stack.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    private func photoView() -> UIView {
        let photoView = UIView()
        photoView.addSubViews([photoImage])
        photoImage.constraintCenters(to: photoView)

        let changePhotoButton: UIButton = {
            let button = UIButton()
            button.setTitle("Сменить фото", for: .normal)
            button.addTarget(self, action: #selector(changePhotoButtonTapped), for: .touchUpInside)
            let color = UIColor.yaBlackLight.withAlphaComponent(0.6)
            button.backgroundColor = color
            button.titleLabel?.font = UIFont.caption3
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .center
            button.round(squareSize: 70)
            return button
        } ()

        photoView.addSubViews([changePhotoButton])

        NSLayoutConstraint.activate([
            changePhotoButton.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            changePhotoButton.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 70)
        ])

        return photoView
    }

    private func nameStack() -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.text = "Имя"
        nameLabel.font = UIFont.headline3

        let rightPaddingView = UIView()
        let clearTextFieldButton: UIButton = {
            let button = UIButton(type: .custom)
            let imageColor = UIColor.yaDarkGray
            let image = UIImage(systemName: "xmark.circle.fill")?.withTintColor(imageColor).withRenderingMode(.alwaysOriginal)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(clearTextButtonTapped), for: .touchUpInside)
            return button
        }()

        lazy var clearTextStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.addArrangedSubview(clearTextFieldButton)
            stack.addArrangedSubview(rightPaddingView)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.widthAnchor.constraint(equalToConstant: 28).isActive = true
            return stack
        }()

        nameTextField.rightView = clearTextStack
        nameTextField.rightViewMode = .whileEditing

        let stack = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        stack.axis = .vertical
        stack.spacing = 8

        return stack
    }

    private func descriptionStack() -> UIStackView {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Описание"
        descriptionLabel.font = UIFont.headline3

        let stack = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        stack.axis = .vertical
        stack.spacing = 8

        return stack
    }

    private func siteStack() -> UIStackView {
        let siteStack = UILabel()
        siteStack.text = "Сайт"
        siteStack.font = UIFont.headline3

        let stack = UIStackView(arrangedSubviews: [siteStack, webSiteTextField])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            switch textField {
            case nameTextField: presenter.passNewName(text)
            case webSiteTextField: presenter.passWebSite(text)
            default: print("Ooops")
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.passNewDescription(textView.text)
    }
}

// MARK: - EditProfileViewProtocol
extension EditProfileViewController: EditProfileViewProtocol {

}
