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

    func isNeedToShowOnboarding() {
        if UserDefaults.standard.object(forKey: "onboardingButtonTapped") == nil {
            window?.rootViewController = OnboardingVC()
        } else {
            let servicesAssembly = ServicesAssembly(
                networkClient: DefaultNetworkClient(),
                nftStorage: NftStorageImpl()
            )

            let tabBarController = TabBarController()
            tabBarController.servicesAssembly = servicesAssembly
            window?.rootViewController = tabBarController
        }
    }
}
