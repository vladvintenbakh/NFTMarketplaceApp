import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly! {
        didSet {
            setupViewControllers()
        }
    }
    
    private let profileTabBarItem = UITabBarItem(
        title: SGen.profile,
        image: UIImage(named: "ProfileTabBarItem"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "CatalogTabBarItem"),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "CartTabBarItem"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "StatisticsTabBarItem"),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    private func setupViewControllers() {
        guard servicesAssembly != nil else { return }
        
        let presenter = ProfilePresenter()
        let profileView = ProfileMainVC(presenter: presenter)
        let profileViewNavController = UINavigationController(rootViewController: profileView)
        let navigationService = NavigationManager(navigation: profileViewNavController, rootVC: profileView)
        presenter.view = profileView
        presenter.navigation = navigationService
        profileViewNavController.tabBarItem = profileTabBarItem

        let catalogMainVC = CatalogMainVC()
        catalogMainVC.tabBarItem = catalogTabBarItem
        
        let cartNavigationVC = UINavigationController(rootViewController: cartEntryPoint())
        cartNavigationVC.tabBarItem = cartTabBarItem
        
        let userModel = UserModel()
        let statisticPresenter = StatisticPresenter(for: userModel, servicesAssembly: servicesAssembly)
        let statisticVC = UINavigationController(
            rootViewController: StatisticsMainVC(
                presenter: statisticPresenter
            ))
        viewControllers = [profileViewNavController, catalogMainVC, cartNavigationVC, statisticsMainVC]
    }
    
    private func cartEntryPoint() -> CartMainVC {
        let cartNetworkService = CartNetworkService(client: DefaultNetworkClient())
        let cartMainPresenter = CartMainPresenter(cartNetworkService: cartNetworkService)

        return CartMainVC(presenter: cartMainPresenter)
    }
}
