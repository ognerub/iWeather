import UIKit

protocol MainViewControllerCollectionProtocol: AnyObject {
    var showArray: [WeatherResponse] { get }
    func updateUI(with: Int)
}

final class MainViewController: UIViewController {
    
    var showArray: [WeatherResponse] = []
    
    weak var mainItemDelegate: MainItemProtocol?
    
    private let forcastService = ForcastService.shared
    private var forcastServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    private var presenter: MainPresenter?
    
    private lazy var mainItem: MainItem = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 380)
        let view = MainItem(frame: frame)
        return view
    }()
    
    private lazy var collectionView: CollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 380, width: view.frame.width, height: 275)
        let collection = CollectionView(frame: frame, layout: layout)
        return collection
    }()
    
    override func loadView() {
        super.loadView()
        propertiesSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraintsConfiguration()
        presenter?.viewDidLoad()
        addObserverUsingNotificationCenter()
    }
    
    private func propertiesSetup() {
        alertPresenter = AlertPresenterImpl(viewController: self)
        uiBlockingProgressHUD = UIBlockingProgressHUD(viewController: self)
        presenter = MainPresenter()
        presenter?.uiBlockingProgressHUD = uiBlockingProgressHUD
        presenter?.alert = alertPresenter
        collectionView.mainViewControllerDelegate = self
    }
}

// MARK: - Configuration
private extension MainViewController {
    func constraintsConfiguration() {
        view.addSubview(mainItem)
        view.addSubview(collectionView)
    }
    
    func addObserverUsingNotificationCenter() {
        forcastServiceObserver = NotificationCenter.default.addObserver(
            forName: ForcastService.SearchResultDidChangeNotification,
            object: nil,
            queue: .main
        ) { notification in
            self.showArray = self.forcastService.fetchedArray
            self.presenter?.uiBlockingProgressHUD?.dismissCustom()
            self.updateUI(with: 0)
        }
    }
}

extension MainViewController: MainViewControllerCollectionProtocol {
    func updateUI(with number: Int) {
        /// main item update
        self.mainItemDelegate = self.mainItem
        let temp = String(self.showArray[number].fact.temp ?? 0)
        let name = self.showArray[number].geoObject.locality.name
        self.mainItemDelegate?.configureItem(with: name + " " + temp + "°C")
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.mainItem.removeFromSuperview()
        }, completion: nil)
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.mainItem)
        }, completion: nil)
        /// collection view update
        let filteredArray = self.forcastService.fetchedArray.filter( { $0.geoObject.locality.name
            != self.showArray[number].geoObject.locality.name } )
        self.showArray = filteredArray
        self.collectionView.performBatchUpdates( {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        })
    }
}

