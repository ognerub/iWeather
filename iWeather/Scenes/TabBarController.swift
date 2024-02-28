import UIKit

final class TabBarController: UITabBarController {
    private let mainTabBarItem = UITabBarItem(
        title: "",
        image: Asset.Assets.TabBarItems.iconsMain.image,
        tag: 0
    )
    private let searchTabBarItem = UITabBarItem(
        title: "",
        image: Asset.Assets.TabBarItems.iconsSearch.image,
        tag: 1
    )
    private let mapTabBarItem = UITabBarItem(
        title: "",
        image: Asset.Assets.TabBarItems.iconsMap.image,
        tag: 2
    )
    private let settingsTabBarItem = UITabBarItem(
        title: "",
        image: Asset.Assets.TabBarItems.iconsSettings.image,
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
        tabBar.backgroundColor = Asset.Colors.customLightPurple.color
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Asset.Colors.customLightPurple.color
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
}
