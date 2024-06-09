import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow()
        
        let tabBarController = setupTabBar()
        window?.rootViewController = tabBarController
        
        window?.makeKeyAndVisible()

        return true
    }

    func setupTabBar() -> UITabBarController {
        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )

        let tabBarController = TabBarController()
        tabBarController.servicesAssembly = servicesAssembly
        return tabBarController
    }
}
