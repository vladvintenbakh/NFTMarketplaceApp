//
//  UserModel.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 20.05.24.
//

import UIKit

final class UserModel {

    let defaults = UserDefaults.standard

    func getUsers() -> [User] {
        if let sortType = defaults.string(forKey: "SortType") {
            switch sortType {
            case "byName":
                return sortUsersByName()
            case "byRating":
                return sortUsersByRating()
            default:
                return UserModel.mockUsersStatisticDB
            }
        }
        return UserModel.mockUsersStatisticDB
    }

    func sortUsersByName() -> [User] {
        defaults.set("byName", forKey: "SortType")
        let sortedUsersList = UserModel.mockUsersStatisticDB.sorted {
            $0.username < $1.username
        }
        return sortedUsersList
    }

    func sortUsersByRating() -> [User] {
        defaults.set("byRating", forKey: "SortType")
        let sortedUsersList = UserModel.mockUsersStatisticDB.sorted {
            $0.rating < $1.rating
        }
        return sortedUsersList
    }
}

extension UserModel {
    static let mockUsersStatisticDB = [
        User(rating: "1", username: "Alex", nftNum: "112", avatar: UIImage(named: "ImageAlex")!),
        User(rating: "2", username: "Bill", nftNum: "98", avatar: UIImage(named: "noImage")!),
        User(rating: "3", username: "Alla", nftNum: "72", avatar: UIImage(named: "noImage")!),
        User(rating: "4", username: "Mads", nftNum: "71", avatar: UIImage(named: "ImageMads")!),
        User(rating: "5", username: "Timothèe", nftNum: "51", avatar: UIImage(named: "ImageTimon")!),
        User(rating: "6", username: "Lea", nftNum: "23", avatar: UIImage(named: "ImageLea")!),
        User(rating: "7", username: "Eric", nftNum: "11", avatar: UIImage(named: "ImageEric")!),
        User(rating: "8", username: "Serhio", nftNum: "0", avatar: UIImage(named: "noImage")!),
    ]
}
