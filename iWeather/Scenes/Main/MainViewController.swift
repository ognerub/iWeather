import UIKit

protocol MainViewControllerCollectionProtocol: AnyObject {
    var showArray: [WeatherResponse] { get }
    var currentWeatherResponse: WeatherResponse? { get }
    func updateUI(with: Int)
    func getName(from currentWeatherResponse: WeatherResponse) -> String
    func getImageFor(currentWeatherResponse: WeatherResponse?, largeSize: Bool) -> UIImage
    func getConditionAndImage(for currentWeatherResponse: WeatherResponse) -> (String, UIColor)
    func showContent(_ value: Bool)
}

final class MainViewController: UIViewController {
    // MARK: Properties
    var currentWeatherResponse: WeatherResponse?
    
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
    
    private lazy var profileButton: UIButton = {
        let frame = CGRect(x: 25, y: 50, width: 34, height: 34)
        let button = UIButton(frame: frame)
        button.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        button.setImage(Asset.Assets.Buttons.iconsProfile.image, for: .normal)
        button.backgroundColor = .clear
        button.isIncreasedHitAreaEnabled = true
        return button
    }()
    
    private lazy var burgerButton: UIButton = {
        let frame = CGRect(x: view.frame.width - 34 - 25, y: 50, width: 34, height: 34)
        let button = UIButton(frame: frame)
        button.addTarget(self, action: #selector(didTapBurger), for: .touchUpInside)
        button.setImage(Asset.Assets.Buttons.iconsBurger.image, for: .normal)
        button.backgroundColor = .clear
        button.isIncreasedHitAreaEnabled = true
        return button
    }()
    
    private lazy var citiesCollectionView: CitiesCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 380, width: view.frame.width, height: 275)
        let collection = CitiesCollectionView(frame: frame, layout: layout)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.text = "Today"
        label.font = UIFont.init(name: "Poppins-Medium", size: 20)
        label.textAlignment = .left
        label.frame = CGRect(x: 25, y: 655, width: 200, height: 30)
        return label
    }()
    
    private lazy var hoursCollectionView: HoursCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 655, width: view.frame.width, height: 152)
        let collection = HoursCollectionView(frame: frame, layout: layout)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private var isContentLoaded: Bool?
    private var lastContentCount: Int?
    
    private lazy var stubView: UIView = {
        let stub = UIView()
        stub.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        stub.backgroundColor = Asset.Colors.customPurple.color
        return stub
    }()
    
    private lazy var stubImageView: UIImageView = {
        let image = Asset.Assets.info.image
        let stub = UIImageView(image: image)
        stub.frame = CGRect(x: view.frame.width/2 - 100, y: view.frame.height/2 - 100, width: 200, height: 200)
        stub.backgroundColor = Asset.Colors.customPurple.color
        return stub
    }()
    
    
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        isContentLoaded = false
        propertiesSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.customPurple.color
        navigationController?.isNavigationBarHidden = true
        self.constraintsConfiguration()
        addObserverUsingNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.startFetchGroup()
    }
    
    func showContent(_ value: Bool) {
        guard let isContentLoaded = isContentLoaded else { return }
        if value && !isContentLoaded {
            stubImageView.removeFromSuperview()
            stubView.removeFromSuperview()
        } else {
            view.addSubview(stubView)
            stubView.addSubview(stubImageView)
        }
    }
    
    private func propertiesSetup() {
        alertPresenter = AlertPresenterImpl(viewController: self)
        uiBlockingProgressHUD = UIBlockingProgressHUD(viewController: self)
        presenter = MainPresenter()
        presenter?.uiBlockingProgressHUD = uiBlockingProgressHUD
        presenter?.alert = alertPresenter
        presenter?.mainViewControllerDelegate = self
        citiesCollectionView.mainViewControllerDelegate = self
        hoursCollectionView.mainViewControllerDelegate = self
    }
    
    @objc
    private func didTapProfile() {
        print("profileButton")
    }
    
    @objc
    private func didTapBurger() {
        print("profileBurger")
    }
}

// MARK: - Configuration
private extension MainViewController {
    
    func addObserverUsingNotificationCenter() {
        forcastServiceObserver = NotificationCenter.default.addObserver(
            forName: ForcastService.SearchResultDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.showArray = self.forcastService.fetchedArray
            self.lastContentCount = self.showArray.count
            self.presenter?.uiBlockingProgressHUD?.dismissCustom()
            self.updateUI(with: 0)
            self.scrollView.setContentOffset(CGPoint(x: 0, y: -44), animated: true)
        }
    }
    
    func constraintsConfiguration() {
        if lastContentCount != showArray.count {
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubview(mainItem)
            mainItem.addSubview(profileButton)
            mainItem.addSubview(burgerButton)
            contentView.addSubview(citiesCollectionView)
            contentView.addSubview(todayLabel)
            contentView.addSubview(hoursCollectionView)
            view.addSubview(stubView)
        } else {
            isContentLoaded = true
        }
    }
}

// MARK: - MainViewControllerCollectionProtocol
extension MainViewController: MainViewControllerCollectionProtocol {
    func updateUI(with itemNumber: Int) {
        /// Main item update
        mainItemDelegate = mainItem
        if showArray.count > 0 {
            currentWeatherResponse = showArray[itemNumber]
        }
        guard let currentWeatherResponse = currentWeatherResponse else { return }
        let image = getImageFor(currentWeatherResponse: currentWeatherResponse, largeSize: true)
        let name = getName(from: currentWeatherResponse)
        let temp = String(currentWeatherResponse.fact.temp)
        let condition = getConditionAndImage(for: currentWeatherResponse)
        let conditionString = condition.0
        let color = condition.1
        let date = currentWeatherResponse.nowDt.dateFromISO8601String()
        let stringDate = date.formatted
        let separator = " "
        let stringComponents = stringDate.components(separatedBy: separator)
        let dateComponent = stringComponents[0]
        let mounthComponent = stringComponents[1].capitalized
        let dayComponent = stringComponents [2].uppercased()
        
        let dateString = dateComponent + separator + mounthComponent + separator + dayComponent
        
        let array = currentWeatherResponse.forecasts.flatMap {
            return $0.hours
        }
        let tempArray: [Int] = array.compactMap {
            return $0.temp
        }
        let minTemp = String(tempArray.min() ?? 0)
        let maxTemp = String(tempArray.max() ?? 0)
        let space = " "
        let degrees = "°C"
        let divider = "/"
        let tempString = minTemp + degrees + divider + maxTemp + degrees
        mainItemDelegate?.configureItemWith(
            name: name,
            temp: temp + degrees,
            info: dateString + space + tempString,
            condition: conditionString,
            image: image,
            backgroundImage: UIImage(),
            backgroundColor: color
        )
        animatedAdd(of: mainItem)
        downloadImageFor(imageView: mainItem.backgroundImageView, with: itemNumber)
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
        hoursCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func downloadImageFor(imageView: UIImageView, with number: Int) {
        let icon = showArray[number].fact.icon
        let string = NetworkConstants.standart.imageBase + icon + NetworkConstants.standart.imageExt
        guard let url = URL(string: string)
        else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(),
            options: [
                .processor(SVGImgProcessor())
            ]
        ) { result in
            switch result {
            case .success(_):
                imageView.contentMode = .scaleAspectFill
            case .failure(_):
                imageView.image = UIImage(systemName: "nosign") ?? UIImage()
            }
            
        }
    }
    
    func getConditionAndImage(for currentWeatherResponse: WeatherResponse) -> (String, UIColor) {
        let condition = currentWeatherResponse.fact.condition
        var color = UIColor()
        switch condition {
        case Condition.cloudy.rawValue,
            Condition.partlyCloudy.rawValue,
            Condition.overcast.rawValue:
            color = UIColor.lightText
        case Condition.lightRain.rawValue,
            Condition.rain.rawValue,
            Condition.heavyRain.rawValue,
            Condition.showers.rawValue:
            color = UIColor.blue
        case Condition.wetSnow.rawValue,
            Condition.lightSnow.rawValue,
            Condition.snow.rawValue,
            Condition.snowShowers.rawValue:
            color = UIColor.lightGray
        case Condition.hail.rawValue,
            Condition.thunderstorm.rawValue,
            Condition.thumderstormWithRain.rawValue,
            Condition.thunderstormWithHail.rawValue:
            color = UIColor.gray
        default:
            color = Asset.Colors.customLightPurple.color
        }
        return (condition, color)
    }
    
    func getName(from currentWeatherResponse: WeatherResponse) -> String {
        let name = currentWeatherResponse.geoObject.locality.name
        let separator = "округ "
        let stringComponents = name.components(separatedBy: separator)
        var onlyName = stringComponents[0]
        if stringComponents.count > 0 {
            onlyName = stringComponents[stringComponents.count-1]
        }
        return onlyName
    }
    
    func getImageFor(currentWeatherResponse: WeatherResponse?, largeSize: Bool) -> UIImage {
        guard let currentWeatherResponse = currentWeatherResponse else { return UIImage() }
        let onlyName = getName(from: currentWeatherResponse).lowercased()
        switch onlyName {
        case CityName.moscow.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.moscow.image : Asset.Assets.Cities.Small.moscowSmall.image
        case CityName.saintPetersburg.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.saintPetersburg.image : Asset.Assets.Cities.Small.saintPetersburgSmall.image
        case CityName.novosibirsk.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.novosibirsk.image : Asset.Assets.Cities.Small.novosibirskSmall.image
        case CityName.ekaterinburg.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.ekaterinburg.image : Asset.Assets.Cities.Small.ekaterinburgSmall.image
        case CityName.samara.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.samara.image : Asset.Assets.Cities.Small.samaraSmall.image
        case CityName.omsk.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.omsk.image : Asset.Assets.Cities.Small.omskSmall.image
        case CityName.kazan.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.kazan.image : Asset.Assets.Cities.Small.kazanSmall.image
        case CityName.rostovOnDon.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.rostovOnDon.image : Asset.Assets.Cities.Small.rostovOnDon.image
        case CityName.murmansk.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.murmansk.image : Asset.Assets.Cities.Small.murmanskSmall.image
        case CityName.nizhniyNovgorod.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.nizhniyNovgorod.image : Asset.Assets.Cities.Small.nizhniyNovgorodSmall.image
        case CityName.chelyabinsk.rawValue:
            return largeSize ? Asset.Assets.Cities.Large.chelyabinsk.image : Asset.Assets.Cities.Small.chelyabinskSmall.image
        default:
            return UIImage()
        }
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

