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
        
        return true
    }
}
