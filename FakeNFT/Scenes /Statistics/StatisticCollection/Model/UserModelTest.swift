//
//  UserModel.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 20.05.24.
//

import UIKit

final class UserModelTest {
    private var usersDB: [User] = [] {
        didSet {
        }
    }
    
    private let defaults = UserDefaults.standard
    
    enum SortType: String {
        case byName
        case byRating
    }
    
    private let sortTypeKey = "SortType"
    
    func saveUsers(users: [UserData]) {
        usersDB = users.map {
            convert(userData: $0)
        }
    }
    
    func getUsers() -> [User] {
        guard let sortTypeString = defaults.string(forKey: sortTypeKey),
              let sortType = SortType(rawValue: sortTypeString) else {
            return usersDB
        }
        
        switch sortType {
        case .byName:
            return sortUsersByName()
        case .byRating:
            return sortUsersByRating()
        }
    }
    
    func sortUsers(by sortType: SortType) -> [User] {
        defaults.set(sortType.rawValue, forKey: sortTypeKey)
        let sortedUsersList: [User]
        
        switch sortType {
        case .byName:
            sortedUsersList = usersDB.sorted { $0.username < $1.username }
        case .byRating:
            sortedUsersList = usersDB.sorted { $0.rating > $1.rating }
        }
        
        return sortedUsersList
    }

    
    func sortUsersByName() -> [User] {
        return sortUsers(by: .byName)
    }
    
    func sortUsersByRating() -> [User] {
        return sortUsers(by: .byRating)
    }
}

extension UserModelTest {
    func convert(userData: UserData) -> User {
        guard let rating = Int(userData.rating) else {
            return User(rating: 0, username: userData.name, nfts: userData.nfts, avatar: userData.avatar, description: userData.description, website: userData.website)
        }
        
        return User(
            rating: rating,
            username: userData.name,
            nfts: userData.nfts,
            avatar: userData.avatar,
            description: userData.description,
            website: userData.website
        )
    }
}
