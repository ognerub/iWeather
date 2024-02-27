import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func showNetWorkErrorForImagesListVC(completion: @escaping () -> Void)
}

final class MainViewController: UIViewController {
    
    private let forcastService = ForcastService.shared
    private var forcastServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var uiBlockingProgressHUD: UIBlockingProgressHUDProtocol?
    private var presenter: MainPresenter?
    
    weak var delegate: MainItemProtocol?
    
    private var showArray: [WeatherResponse] = [
        WeatherResponse(
            nowDt: "",
            info: Info(
                n: false,
                geoid: 0,
                url: "",
                lat: 0.0,
                lon: 0.0,
                tzinfo: Tzinfo(
                    name: "",
                    abbr: "",
                    dst: false,
                    offset: 0)),
            geoObject: GeoObject(
                district: District(id: 0, name: ""),
                locality: Locality(id: 0, name: ""),
                province: Province(id: 0, name: ""),
                country: Country(id: 0, name: "")),
            yesterday: Yesterday(temp: 0),
            fact: Fact(
                temp: 0,
                icon: "",
                condition: "",
                phenomIcon: "",
                phenomCondition: ""),
            forecasts: [
                Forecast(
                    date: "",
                    parts: Parts(
                        day: Day(tempMin: 0, tempAvg: 0, tempMax: 0, icon: "", condition: ""),
                        night: Night(tempMin: 0, tempAvg: 0, tempMax: 0, icon: "", condition: "")),
                    hours: [
                        Hour(
                            hour: "",
                            hourTs: 0,
                            temp: 0,
                            icon: "",
                            condition: "")
                    ])
            ]
        )
    ]
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var background: MainItem = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 380)
        let view = MainItem(frame: frame)
        return view
    }()
    
    override func loadView() {
        super.loadView()
        alertPresenter = AlertPresenterImpl(viewController: self)
        uiBlockingProgressHUD = UIBlockingProgressHUD(viewController: self)
        presenter = MainPresenter()
        presenter?.uiBlockingProgressHUD = uiBlockingProgressHUD
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraintsConfiguration()
        collectionConfiguration()
        presenter?.viewDidLoad()
        addObserverUsingNotificationCenter()
    }
}

// MARK: - Configuration
private extension MainViewController {
    func constraintsConfiguration() {
        view.addSubview(background)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 410),
            collectionView.heightAnchor.constraint(equalToConstant: 215),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func collectionConfiguration() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellReuseIdentifier)
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
            self.updateMainItem(with: 0)
        }
    }
    
    private func updateMainItem(
        with number: Int) {
            /// main item update
            self.delegate = self.background
            self.delegate?.configureItem(with: self.showArray[number].geoObject.locality.name)
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.background.removeFromSuperview()
            }, completion: nil)
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(self.background)
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

// MARK: - Collection FlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 172, height: 215)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
}

// MARK: - Collection Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateMainItem(with: indexPath.row)
    }
}

// MARK: - Collection DataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.cellReuseIdentifier,
            for: indexPath) as? CollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let name: String = showArray[indexPath.row].geoObject.locality.name
        cell.configureCell(
            nameLabel: name
        )
        return cell
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

