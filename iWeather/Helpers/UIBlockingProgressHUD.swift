import UIKit

protocol UIBlockingProgressHUDProtocol: AnyObject {
    func showCustom()
    func dismissCustom()
}

final class UIBlockingProgressHUD: UIBlockingProgressHUDProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    private var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    private var customView: UIView?

    func showCustom() {
        window?.isUserInteractionEnabled = false
        self.customView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        guard let customView = customView,
              let viewController = viewController
        else { return }
        customView.backgroundColor = .clear
        viewController.view.addSubview(customView)
        customView.center = viewController.view.center
        let activity = UIActivityIndicatorView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: customView.frame.width,
                height: customView.frame.height
            )
        )
        activity.startAnimating()
        activity.color = .init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .white : .black
        }
        customView.addSubview(activity)
    }

    func dismissCustom() {
        window?.isUserInteractionEnabled = true
        customView?.removeFromSuperview()
    }
}
