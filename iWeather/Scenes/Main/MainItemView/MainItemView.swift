import UIKit

protocol MainItemProtocol: AnyObject {
    func configureItem(with text: String)
}

final class MainItemView: UIView, MainItemProtocol {
    
    private lazy var background: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
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
    
    func configureItem(with text: String) {
        self.nameLabel.text = text
    }
    
    private func configureConstraints() {
        addSubview(background)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.heightAnchor.constraint(equalToConstant: 380),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        background.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10)
        ])
    }
}
