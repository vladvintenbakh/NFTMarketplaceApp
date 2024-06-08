import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly! {
        didSet {
            setupViewControllers()
        }
    }
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
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
        
        let profileMainVC = ProfileMainVC()
        profileMainVC.tabBarItem = profileTabBarItem
        
        let catalogMainVC = CatalogMainVC()
        catalogMainVC.tabBarItem = catalogTabBarItem
        
        let cartMainVC = CartMainVC()
        cartMainVC.tabBarItem = cartTabBarItem
        
        let userModel = UserModelTest()
        let statisticPresenter = StatisticPresenter(for: userModel, servicesAssembly: servicesAssembly)
        let statisticVC = UINavigationController(
            rootViewController: StatisticsMainVC(
                presenter: statisticPresenter
            ))
        
        statisticVC.tabBarItem = statisticsTabBarItem

        viewControllers = [profileMainVC, catalogMainVC, cartMainVC, statisticVC]
    }
}
