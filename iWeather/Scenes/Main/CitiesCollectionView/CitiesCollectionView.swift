import UIKit
import Kingfisher

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
        let color = delegate.getConditionAndImage(for: currentWeatherResponse).1
        cell.configureCell(
            nameLabel: name + " " + temp + "°C",
            image: image,
            backgroundColor: color,
            backgroundImage: UIImage()
        )
        let icon = currentWeatherResponse.fact.icon
        downloadImageFor(imageView: cell.backgroundImageView, at: indexPath, icon: icon)
        guard let phenomIcon = currentWeatherResponse.fact.phenomIcon else { return cell }
        downloadImageFor(imageView: cell.phenomImageView, at: indexPath, icon: phenomIcon)
        return cell
    }
    
    private func downloadImageFor(imageView: UIImageView, at indexPath: IndexPath, icon: String) {
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
}
