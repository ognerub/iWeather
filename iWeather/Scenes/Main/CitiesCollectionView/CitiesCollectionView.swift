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
        let temp = String(mainViewControllerDelegate?.showArray[indexPath.row].fact.temp ?? 0)
        let name: String = mainViewControllerDelegate?.showArray[indexPath.row].geoObject.locality.name ?? ""
        cell.configureCell(
            nameLabel: name + " " + temp + "°C"
        )
        return cell
    }
}
