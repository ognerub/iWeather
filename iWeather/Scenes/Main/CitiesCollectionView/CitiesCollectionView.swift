import UIKit

final class CitiesCollectionView: UICollectionView {
    
    weak var mainViewControllerDelegate: MainViewControllerCollectionProtocol?
    
    init(frame: CGRect, layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        collectionConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func collectionConfiguration() {
        backgroundColor = .clear
        dataSource = self
        delegate = self
        register(CitiesCollectionViewCell.self, forCellWithReuseIdentifier: CitiesCollectionViewCell.cellReuseIdentifier)
    }
}

// MARK: - Collection FlowLayout
extension CitiesCollectionView: UICollectionViewDelegateFlowLayout {
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
extension CitiesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainViewControllerDelegate?.updateUI(with: indexPath.row)
    }
}

// MARK: - Collection DataSource
extension CitiesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainViewControllerDelegate?.showArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CitiesCollectionViewCell.cellReuseIdentifier,
            for: indexPath) as? CitiesCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        guard let delegate = mainViewControllerDelegate else { return cell }
        let currentWeatherResponse = delegate.showArray[indexPath.row]
        let temp = String(currentWeatherResponse.fact.temp)
        let name: String = delegate.getName(from: currentWeatherResponse)
        let image = delegate.getImageFor(currentWeatherResponse: currentWeatherResponse, largeSize: false)
        let color = Asset.Colors.customLightPurple.color
        let backgroundImage = delegate.getConditionAndImage(for: currentWeatherResponse).1
        cell.configureCell(
            nameLabel: name + " " + temp + "°C",
            image: image,
            backgroundColor: color,
            backgroundImage: backgroundImage
        )
        return cell
    }
}
