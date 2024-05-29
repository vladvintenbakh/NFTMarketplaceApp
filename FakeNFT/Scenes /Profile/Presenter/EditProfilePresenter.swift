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

final class EditProfilePresenter: EditProfilePresenterProtocol {

    // MARK: - ViewController
    weak var view: EditProfileViewProtocol?
 
    // MARK: - Other Properties
    var data: ProfileMockModel?

    var newName: String?
    var newDescription: String?
    var newWebSite: String?
    var avatar: String?

    // MARK: - Private methods
    private func getDataFromStorage() {
        let data = MockDataStorage.mockData
        self.data = data
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
        storage.updateDataAfterEditing(newData: newData)
    }

    // MARK: - Public methods
    func viewDidLoad() {
        getDataFromStorage()
        setDescription()
        setWebsite()
        setPhoto()
        setName()
    }

    func setName() {
        guard let newName else { return }
        view?.updateName(newName)
    }

    func setDescription() {
        guard let newDescription else { return }
        view?.updateDescription(newDescription)
    }

    func setWebsite() {
        guard let newWebSite else { return }
        view?.updateWebsite(newWebSite)
    }

    func setPhoto() {
        guard let avatar else { return }
        view?.updatePhoto(avatar)
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
        NotificationCenter.default.post(name: Notification.Name("updateUI"), object: nil)
        view?.dismiss(animated: true, completion: nil)
    }
}
