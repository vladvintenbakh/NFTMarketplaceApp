import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!
    
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
        
        let profilePresenter = ProfilePresenter()
        let profileView = ProfileMainVC(presenter: profilePresenter)
        let profileMainVC = UINavigationController(rootViewController: profileView)
        profileMainVC.tabBarItem = profileTabBarItem
        
        let catalogMainVC = CatalogMainVC()
        catalogMainVC.tabBarItem = catalogTabBarItem
        
        let cartMainVC = CartMainVC()
        cartMainVC.tabBarItem = cartTabBarItem
        
        let statisticsMainVC = StatisticsMainVC()
        statisticsMainVC.tabBarItem = statisticsTabBarItem

        viewControllers = [profileMainVC, catalogMainVC, cartMainVC, statisticsMainVC]

        view.backgroundColor = .systemBackground
    }
}
