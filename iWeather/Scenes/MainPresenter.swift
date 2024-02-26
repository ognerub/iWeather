import Foundation
import UIKit

protocol MainPresenterProtocol {
    var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol? { get set }
    func viewDidLoad()
    func startFetchGroup()
}

final class MainPresenter: MainPresenterProtocol {
    
    private let forcastService = ForcastService.shared
    private var forcastServiceObserver: NSObjectProtocol?
    private var mainViewController: MainViewControllerProtocol?
    
    var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    
    func viewDidLoad() {
        mainViewController = MainViewController()
        startFetchGroup()
    }
    
    func startFetchGroup() {
        uiBlockingProgressHUD?.showCustom()
        forcastService.fetch(searchArray: forcastService.searchArray) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                return
            case .failure:
                self.mainViewController?.showNetWorkErrorForImagesListVC() {
                    self.startFetchGroup()
                }
            }
        }
    }
}
