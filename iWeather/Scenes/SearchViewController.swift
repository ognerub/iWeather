import UIKit

class SearchViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.frame = CGRect(x: view.frame.width/2-100, y: 30, width: 200, height: 100)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(label)
    }
}

