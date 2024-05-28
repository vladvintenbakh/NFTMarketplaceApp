//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 27.05.2024.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    func getImageName() -> String 
    func getDescription() -> String
    func getWebSite() -> String 
    func getName() -> String
    func sendDataToStorage()
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

    // MARK: - Init
    init(view: EditProfileViewProtocol?) {
        self.view = view
        getDataFromStorage()
    }

    // MARK: - Private methods
    private func getDataFromStorage() {
        let data = MockDataStorage.mockData
        self.data = data
        newName = data.name
        newDescription = data.description
        newWebSite = data.website
    }

    // MARK: - Public methods
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

    func sendDataToStorage() {
        let newData = EditedDataModel(name: newName,
                                      description: newDescription,
                                      website: newWebSite)
        let storage = MockDataStorage()
        storage.updateDataAfterEditing(newData: newData)
    }

    func getName() -> String {
        guard let name = data?.name else { return ""}
        return name
    }

    func getImageName() -> String {
        guard let imageName = data?.avatar else { return ""}
        return imageName
    }

    func getDescription() -> String {
        guard let description = data?.description else { return ""}
        return description
    }

    func getWebSite() -> String {
        guard let webSite = data?.website else { return ""}
        return webSite
    }
}
