import UIKit

protocol MainViewControllerProtocol {
    func showNetWorkErrorForImagesListVC(completion: @escaping () -> Void)
    func getFetched(array: [WeatherResponse])
}

final class MainViewController: UIViewController {
    
    private var alertPresenter: AlertPresenterProtocol?
    private var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    private var presenter: MainPresenter?
    
    private var foundArray: [WeatherResponse] = [] {
        didSet {
            foundArray.forEach { found in
                print( "Print from arrayFound. Country: \(found.geoObject.country) Province: \(found.geoObject.province) Locality: \(found.geoObject.locality) Disctrict: \(found.geoObject.district) Lan: \(found.info.lat) Lon: \(found.info.lon) Temp: \(found.fact.temp)")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        alertPresenter = AlertPresenterImpl(viewController: self)
        uiBlockingProgressHUD = UIBlockingProgressHUD(viewController: self)
        presenter = MainPresenter()
        presenter?.uiBlockingProgressHUD = uiBlockingProgressHUD
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        presenter?.addObserverUsingNotificationCenter()
        presenter?.viewDidLoad()
    }
    
    func getFetched(array: [WeatherResponse]) {
        foundArray = array
    }
}

// MARK: - Alert
extension MainViewController: MainViewControllerProtocol {
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

