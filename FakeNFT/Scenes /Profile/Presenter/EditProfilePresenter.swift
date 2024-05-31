//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func closeButtonTapped()
    func passNewDescription(_ newDesc: String)
    func passNewName(_ newName: String)
    func passWebSite(_ newWebSite: String) 
}

final class EditProfilePresenter {

    // MARK: - ViewController
    weak var view: EditProfileViewProtocol?

    // MARK: - Private Properties
    private let notification = NotificationCenter.default

    private var newName: String?
    private var newDescription: String?
    private var newWebSite: String?
    private var avatar: String?

    // MARK: - Private methods
    private func getDataFromStorage() {
        guard let data = ProfileStorage.profile else { print("Oops"); return }
        newName = data.name
        newDescription = data.description
        newWebSite = data.website
        avatar = data.avatar
    }

    private func sendDataToStorage() {
        let newData = EditedDataModel(name: newName,
                                      description: newDescription,
                                      website: newWebSite)
        let storage = MockDataStorage()
//        storage.updateDataAfterEditing(newData: newData)
    }

    private func setWebsite() {
        guard let newWebSite else { return }
        view?.updateWebsite(newWebSite)
    }

    private func setPhoto() {
        guard let avatar,
              let imageURL = URL(string: avatar) else { return }
        view?.updatePhoto(imageURL)
    }

    private func setName() {
        guard let newName else { return }
        view?.updateName(newName)
    }

}

// MARK: - EditProfilePresenterProtocol
extension EditProfilePresenter: EditProfilePresenterProtocol {

    func viewDidLoad() {
        getDataFromStorage()
        setDescription()
        setWebsite()
        setPhoto()
        setName()
    }

    func setDescription() {
        guard let newDescription else { return }
        view?.updateDescription(newDescription)
    }

    func passNewDescription(_ newDesc: String) {
        self.newDescription = newDesc
    }

    func passNewName(_ newName: String) {
        self.newName = newName
    }

    func passWebSite(_ newWebSite: String) {
        self.newWebSite = newWebSite
    }

    func closeButtonTapped() {
        sendDataToStorage()
        notification.post(name: .profileDidChange, object: nil)
        view?.dismiss(animated: true, completion: nil)
    }
}
