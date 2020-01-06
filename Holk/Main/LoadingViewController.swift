import Foundation
import UIKit

final class LoadingViewController: UIViewController {
    private let loadingSpinner = HolkLoadingSpinner()
    private let textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setup()
    }
    
    private func setup() {
        view.addSubview(loadingSpinner)
        view.addSubview(textLabel)
        
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.text = "One moment, please"
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            loadingSpinner.widthAnchor.constraint(equalToConstant: 40),
            loadingSpinner.heightAnchor.constraint(equalToConstant: 40),
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            textLabel.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor, constant: 20),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loadingSpinner.startAnimating()
    }
}
