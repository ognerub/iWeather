import Foundation
import UIKit

protocol MainPresenterProtocol {
    var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol? { get set }
    func viewDidLoad()
    func startFetchGroup()
    func addObserverUsingNotificationCenter()
}

final class MainPresenter: MainPresenterProtocol {
    
    private let imagesListService = ForcastService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var mainViewController: MainViewControllerProtocol?
    var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    
    let searchArray: [String] = [
        NetworkConstants.standart.moscow,
        NetworkConstants.standart.saintPetersburg,
        NetworkConstants.standart.novosibirsk,
        NetworkConstants.standart.ekaterinburg,
        NetworkConstants.standart.nizhniyNovgorod,
        NetworkConstants.standart.samara,
        NetworkConstants.standart.omsk,
        NetworkConstants.standart.kazan,
        NetworkConstants.standart.chelyabinsk,
        NetworkConstants.standart.rostovOnDon,
        NetworkConstants.standart.murmansk
    ]
    
    func viewDidLoad() {
        mainViewController = MainViewController()
        startFetchGroup()
    }
    
    func startFetchGroup() {
        uiBlockingProgressHUD?.showCustom()
        var fetchedArray: [WeatherResponse] = []
        let group = DispatchGroup()
        for searchText in searchArray {
            imagesListService.fetch(group: group, searchText: searchText) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let item):
                    fetchedArray.append(item)
                    return
                case .failure:
                    self.mainViewController?.showNetWorkErrorForImagesListVC() {
                        self.startFetchGroup()
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let arrayToReorder = self.createArrayToReorder()
            fetchedArray = fetchedArray.reorder(by: arrayToReorder)
            self.uiBlockingProgressHUD?.dismissCustom()
            self.mainViewController?.getFetched(array: fetchedArray)
        }
    }
    
    func addObserverUsingNotificationCenter() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ForcastService.SearchResultDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            //self.imagesListService.found
            print("notify")
        }
    }
    
    private func createArrayToReorder() -> [Double] {
        var orderArray: [Double] = []
        searchArray.forEach({
            let separator = ";"
            let stringComponents = $0.components(separatedBy: separator)
            let lat = Double(stringComponents[0])
            orderArray.append(lat ?? 0.0)
        })
        return orderArray
    }
    
}
