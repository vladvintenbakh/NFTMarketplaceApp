import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
        
        let tabBarController = TabBarController()
        tabBarController.servicesAssembly = servicesAssembly
        
        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let userModel = UserModel.shared
        
        // Получение пользователей с текущей сортировкой
        _ = userModel.getUsers()
        
        // Сортировка по имени
        _ = userModel.sortUsersByName()
        
        // Сортировка по рейтингу
        _ = userModel.sortUsersByRating()
        
        userModel.changeSortOrder(to: "byName")
        userModel.changeSortOrder(to: "byRating")
        
        return true
    }
}
