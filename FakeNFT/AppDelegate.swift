/*import UIKit
 
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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}*/
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow()
        isNeedToShowOnboarding()
        window?.makeKeyAndVisible()

        return true
    }

    private func isNeedToShowOnboarding() {
        if UserDefaults.standard.object(forKey: ConstantsCatalog.onboardingKey) == nil {
            window?.rootViewController = setupTabBar()
        } else {
            let tabBarController = setupTabBar()
            window?.rootViewController = tabBarController
        }
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
 
