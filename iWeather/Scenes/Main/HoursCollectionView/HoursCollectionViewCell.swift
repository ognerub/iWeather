import UIKit

final class HoursCollectionViewCell: UICollectionViewCell {
    
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Poppins-Medium", size: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Poppins-SemiBold", size: 15)
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
        temp: String,
        hour: String
    ) {
        self.tempLabel.text = temp
        self.hourLabel.text = hour
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
            background.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        ])
        background.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            backgroundImageView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 30),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        background.addSubview(tempLabel)
        NSLayoutConstraint.activate([
            tempLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10),
            tempLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            tempLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10)
        ])
        addSubview(hourLabel)
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: background.bottomAnchor),
            hourLabel.centerXAnchor.constraint(equalTo: tempLabel.centerXAnchor)
        ])
    }
}
