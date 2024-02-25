import UIKit

final class MainViewController: UIViewController {
    
    private let imagesListService = ForcastService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    private var found: WeatherResponse? {
        didSet {
            print( "Print from Found")
        }
    }
    
    private var foundArray: [WeatherResponse] = [] {
        didSet {
            foundArray.forEach { found in
                print( "Print from arrayFound. Country: \(found.geoObject.country) Province: \(found.geoObject.province) Locality: \(found.geoObject.locality) Disctrict: \(found.geoObject.district) Lan: \(found.info.lat) Lon: \(found.info.lon) Temp: \(found.fact.temp)")
            }
            
        }
    }
    
    let searchArray: [String] = [
        NetworkConstants.standart.moscow,
        NetworkConstants.standart.saintPetersburg,
        //        NetworkConstants.standart.novosibirsk,
        //        NetworkConstants.standart.ekaterinburg,
        //        NetworkConstants.standart.nizhniyNovgorod,
        //        NetworkConstants.standart.samara,
        //        NetworkConstants.standart.omsk,
        //        NetworkConstants.standart.kazan,
        //        NetworkConstants.standart.chelyabinsk,
        //        NetworkConstants.standart.rostovOnDon,
        NetworkConstants.standart.murmansk
    ]
    
    override func loadView() {
        super.loadView()
        alertPresenter = AlertPresenterImpl(viewController: self)
        uiBlockingProgressHUD = UIBlockingProgressHUD(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ForcastService.SearchResultDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.found = self.imagesListService.found
        }
        
        startFetch()
    }
    
    private func startFetch() {
        var fetchedArray: [WeatherResponse] = []
        let group = DispatchGroup()
        uiBlockingProgressHUD?.showCustom()
        for searchText in searchArray {
            imagesListService.fetchPhotosUsing(searchText: searchText, group: group) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let item):
                    fetchedArray.append(item)
                    return
                case .failure:
                    self.showNetWorkErrorForImagesListVC() {
                        self.startFetch()
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.uiBlockingProgressHUD?.dismissCustom()
            self.foundArray = fetchedArray.sorted(by: {
                $0.geoObject.locality.name > $1.geoObject.locality.name
            })
        }
    }
    
    func showNetWorkErrorForImagesListVC(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let model = AlertModel(
                title: "Что-то пошло не так(",
                message: "Попробовать еще раз?",
                firstButton: "Повторить",
                secondButton: "Не надо",
                firstCompletion: completion,
                secondCompletion: {})
            self.alertPresenter?.show(with: model)
        }
    }
}

