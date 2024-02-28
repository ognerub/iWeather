import UIKit

protocol MainViewControllerCollectionProtocol: AnyObject {
    var showArray: [WeatherResponse] { get }
    var currentCity: WeatherResponse? { get }
    func updateUI(with: Int)
}

final class MainViewController: UIViewController {
    // MARK: Properties
    var currentCity: WeatherResponse?
    
    var showArray: [WeatherResponse] = []
    
    weak var mainItemDelegate: MainItemProtocol?
    
    private let forcastService = ForcastService.shared
    private var forcastServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    private var presenter: MainPresenter?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentSize
        scroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: -44, width: contentSize.width, height: contentSize.height)
        return view
    }()
    
    private lazy var contentSize: CGSize = CGSize(width: view.frame.width, height: Double(
        mainItem.frame.height +
        citiesCollectionView.frame.height +
        hoursCollectionView.frame.height))
    
    private lazy var mainItem: MainItemView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 380)
        let view = MainItemView(frame: frame)
        return view
    }()
    
    private lazy var citiesCollectionView: CitiesCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 380, width: view.frame.width, height: 275)
        let collection = CitiesCollectionView(frame: frame, layout: layout)
        return collection
    }()
    
    private lazy var hoursCollectionView: HoursCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 655, width: view.frame.width, height: 152)
        let collection = HoursCollectionView(frame: frame, layout: layout)
        return collection
    }()
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        propertiesSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.customPurple.color
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
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
        citiesCollectionView.mainViewControllerDelegate = self
        hoursCollectionView.mainViewControllerDelegate = self
    }
}

// MARK: - Configuration
private extension MainViewController {
    func constraintsConfiguration() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainItem)
        contentView.addSubview(citiesCollectionView)
        contentView.addSubview(hoursCollectionView)
    }
    
    func addObserverUsingNotificationCenter() {
        forcastServiceObserver = NotificationCenter.default.addObserver(
            forName: ForcastService.SearchResultDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.showArray = self.forcastService.fetchedArray
            self.presenter?.uiBlockingProgressHUD?.dismissCustom()
            self.updateUI(with: 0)
        }
    }
}

// MARK: - MainViewControllerCollectionProtocol
extension MainViewController: MainViewControllerCollectionProtocol {
    func updateUI(with itemNumber: Int) {
        /// Main item update
        mainItemDelegate = mainItem
        if showArray.count > 0 {
            currentCity = showArray[itemNumber]
        }
        guard let currentCity = currentCity else { return }
        let temp = String(currentCity.fact.temp)
        let name = currentCity.geoObject.locality.name
        mainItemDelegate?.configureItem(with: name + " " + temp + "°C")
        animatedAdd(of: mainItem)
        /// Cities collection view update
        let filteredArray = forcastService.fetchedArray.filter( { $0.geoObject.locality.name
            != showArray[itemNumber].geoObject.locality.name } )
        showArray = filteredArray
        citiesCollectionView.performBatchUpdates( {
            citiesCollectionView.reloadSections(IndexSet(integer: 0))
        })
        /// Hours collection view update
        hoursCollectionView.performBatchUpdates( {
            hoursCollectionView.reloadSections(IndexSet(integer: 0))
        })
    }
    
    private func animatedAdd(of item: UIView) {
        UIView.transition(with: view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            item.removeFromSuperview()
        }, completion: nil)
        UIView.transition(with: view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.contentView.addSubview(item)
        }, completion: nil)
    }
}

