import UIKit

final class HoursCollectionView: UICollectionView {
    
    weak var mainViewControllerDelegate: MainViewControllerCollectionProtocol?
    
    private var currentHour: Int?
    
    init(frame: CGRect, layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        collectionConfiguration()
        setCurrentHour()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HoursCollectionView {
    func setCurrentHour() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        currentHour = Int(formatter.string(from: Date()))
    }
    
    func collectionConfiguration() {
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(HoursCollectionViewCell.self, forCellWithReuseIdentifier: HoursCollectionViewCell.cellReuseIdentifier)
    }
}

// MARK: - Collection FlowLayout
extension HoursCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 76, height: 116)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 36, left: 25, bottom: 0, right: 25)
    }
}

// MARK: - Collection DataSource
extension HoursCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems: Int = mainViewControllerDelegate?.currentCity?.forecasts.flatMap { return $0.hours }.count ?? 0
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HoursCollectionViewCell.cellReuseIdentifier,
            for: indexPath) as? HoursCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let labels = createLabels(using: indexPath)
        let hour = labels.0
        let temp = labels.1
        
        cell.configureCell(
            nameLabel: hour + " " + temp
        )
        return cell
    }
    
    private func createLabels(using indexPath: IndexPath) -> (String, String) {
        let hoursArray: [Hour] = mainViewControllerDelegate?.currentCity?.forecasts.flatMap {
            return $0.hours
        } ?? []
        let intArray: [Int] = hoursArray.compactMap {
            return Int($0.hour)
        }
        let startArray: [Int] = intArray.filter {
            return $0 >= (currentHour ?? 0)
        }
        let endArray: [Int] = intArray.filter {
            return $0 < (currentHour ?? 0)
        }
        let orderArray = startArray + endArray
        let orderNumber = orderArray[indexPath.row]
        var hour = hoursArray[orderNumber].hour + ":00"
        if indexPath.row == 0 {
            hour = "Now"
        }
        let temp = String(hoursArray[orderNumber].temp) + "°C"
        return (hour, temp)
    }
}
