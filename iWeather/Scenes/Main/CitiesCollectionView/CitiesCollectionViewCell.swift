import UIKit

final class CitiesCollectionViewCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = "feedbacksCell"
    
    private lazy var background: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = Asset.Colors.customLightPurple.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var phenomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Poppins-SemiBold", size: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(
        nameLabel: String,
        image: UIImage,
        backgroundColor: UIColor,
        backgroundImage: UIImage
    ) {
        self.nameLabel.text = nameLabel
        self.imageView.image = image
        self.background.backgroundColor = backgroundColor
        self.backgroundImageView.image = backgroundImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - Configure constraints
    private func configureConstraints() {
        addSubview(background)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        background.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 30),
            backgroundImageView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 60),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        background.addSubview(phenomImageView)
        NSLayoutConstraint.activate([
            phenomImageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 30),
            phenomImageView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            phenomImageView.widthAnchor.constraint(equalToConstant: 60),
            phenomImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        background.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: background.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: background.trailingAnchor)
        ])
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
