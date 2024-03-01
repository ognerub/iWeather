import Foundation
import UIKit

protocol MainPresenterProtocol: AnyObject {
    var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol? { get set }
    var alert: AlertPresenterProtocol? { get set }
}

final class MainPresenter: MainPresenterProtocol {
    
    weak var mainViewControllerDelegate: MainViewControllerCollectionProtocol?
    
    private let forcastService = ForcastService.shared
    private var forcastServiceObserver: NSObjectProtocol?
    
    var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    var alert: AlertPresenterProtocol?
    
    private var alertShown: Bool = false
    
    func startFetchGroup() {
        uiBlockingProgressHUD?.showCustom()
        forcastService.fetch(searchArray: forcastService.searchArray) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.mainViewControllerDelegate?.showContent(true)
            case .failure:
                self.mainViewControllerDelegate?.showContent(false)
                let model = self.createAlertModel {
                    self.startFetchGroup()
                    self.alertShown = false
                }
                if !self.alertShown {
                    self.alertShown = true
                    self.alert?.show(with: model)
                }
            }
        }
    }
    
    func createAlertModel(with completion: @escaping () -> Void) -> AlertModel{
        let model = AlertModel(
            title: "Что-то пошло не так(",
            message: "Попробовать еще раз?",
            firstButton: "Повторить",
            secondButton: "Не надо",
            firstCompletion: completion,
            secondCompletion: { self.alertShown = false })
        return model
    }
}
