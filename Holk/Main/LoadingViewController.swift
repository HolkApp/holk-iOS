import Foundation
import UIKit

final class LoadingViewController: UIViewController {
    private struct Constants {
        static let loadingSpinnerSize: CGFloat = 48
    }

    private let loadingSpinner = HolkProgressBarView()
    private let textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(resumeLoadingAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseLoadingAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)

        loadingSpinner.update(.spinner)
        loadingSpinner.trackTintColor = Color.placeHolder
        loadingSpinner.spinnerRadius = Constants.loadingSpinnerSize / 2

        view.backgroundColor = .white
        view.addSubview(loadingSpinner)
        view.addSubview(textLabel)
        
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.text = "One moment, please"
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            loadingSpinner.widthAnchor.constraint(equalToConstant: Constants.loadingSpinnerSize),
            loadingSpinner.heightAnchor.constraint(equalToConstant: Constants.loadingSpinnerSize),
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            textLabel.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor, constant: 20),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func pauseLoadingAnimation() {
        loadingSpinner.setLoading(false)
    }

    @objc private func resumeLoadingAnimation() {
        loadingSpinner.setLoading(true)
    }
}
