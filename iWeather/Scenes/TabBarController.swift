import UIKit

final class TabBarController: UITabBarController {
    private let mainTabBarItem = UITabBarItem(
        title: "Main",
        image: UIImage(systemName: "photo.on.rectangle.angled"),
        tag: 0
    )
    private let searchTabBarItem = UITabBarItem(
        title: "Search",
        image: UIImage(systemName: "magnifyingglass"),
        tag: 1
    )
    private let mapTabBarItem = UITabBarItem(
        title: "Map",
        image: UIImage(systemName: "magnifyingglass"),
        tag: 2
    )
    private let settingsTabBarItem = UITabBarItem(
        title: "Settings",
        image: UIImage(systemName: "magnifyingglass"),
        tag: 3
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainViewController = UINavigationController(
            rootViewController:
                MainViewController()
            )
        mainViewController.tabBarItem = mainTabBarItem
        
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = searchTabBarItem
        
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = mapTabBarItem
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = settingsTabBarItem
        
        viewControllers = [
            mainViewController,
            searchViewController,
            mapViewController,
            settingsViewController
        ]
        selectedIndex = 0
        
        view.backgroundColor = UIColor.clear
        tabBar.backgroundColor = UIColor.clear
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.gray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
}
