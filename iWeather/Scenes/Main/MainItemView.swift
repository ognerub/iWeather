import UIKit

protocol MainItemProtocol: AnyObject {
    func configureItemWith(
        name: String,
        temp: String,
        info: String,
        condition: String,
        image: UIImage,
        backgroundImage: UIImage,
        backgroundColor: UIColor
    )
}

final class MainItemView: UIView, MainItemProtocol {
    
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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Poppins-SemiBold", size: 28)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Poppins-SemiBold", size: 36)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Poppins-Regular", size: 13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "Poppins-Regular", size: 21)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureItemWith(
        name: String,
        temp: String,
        info: String,
        condition: String,
        image: UIImage,
        backgroundImage: UIImage,
        backgroundColor: UIColor
    ) {
        self.nameLabel.text = name
        self.tempLabel.text = temp
        self.infoLabel.text = info
        self.conditionLabel.text = condition
        self.imageView.image = image
        self.backgroundImageView.image = backgroundImage
        self.background.backgroundColor = backgroundColor
    }
    
    private func configureConstraints() {
        addSubview(background)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        background.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 60),
            backgroundImageView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 60),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        background.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: background.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: background.trailingAnchor)
        ])
        background.addSubview(labelsStackView)
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: background.topAnchor, constant: 120),
            labelsStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 25),
            labelsStackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -25)
        ])
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(tempLabel)
        
        background.addSubview(infoLabelsStackView)
        NSLayoutConstraint.activate([
            infoLabelsStackView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 7),
            infoLabelsStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 25),
            infoLabelsStackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -25)
        ])
        infoLabelsStackView.addArrangedSubview(infoLabel)
        infoLabelsStackView.addArrangedSubview(conditionLabel)
    }
}
