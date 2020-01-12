import UIKit

final class HolkLoadingSpinner: UIView {
    private enum AnimationState {
        case starting
        case stopping
        case stopped
        
        mutating func start() {
            self = .starting
        }
        
        mutating func stop() {
            if self == .stopped { return }
            self = .stopping
        }
        
        mutating func didStop() {
            self = .stopped
        }
    }
    
    private var state: AnimationState = .stopped {
        didSet {
            guard state != oldValue else {
                return
            }
            switch state {
            case .starting:
                beginAnimation()
                startRepeatingAnimation()
            case .stopping:
                endAnimation()
            case .stopped:
                break
            }
        }
    }
    private var shouldBeAnimating = false {
        didSet {
            guard shouldBeAnimating != oldValue else {
                return
            }
            if shouldBeAnimating {
                state.start()
            } else {
                state.stop()
            }
        }
    }
    
    // MARK: - Animation
    private enum AnimationKey: String {
        case rotation
        case opacity
    }
    
    let indicatorView = UIImageView().then { imageView in
        imageView.image = UIImage.fontAwesomeIcon(name: .spinner, style: .regular, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.heightAnchor.constraint(equalTo: heightAnchor),
            indicatorView.widthAnchor.constraint(equalTo: widthAnchor)
            ])
    }
}

extension HolkLoadingSpinner {
    /// Starts the animation of the progress indicator.
    func startAnimating() {
        #if DEBUG
            dispatchPrecondition(condition: .onQueue(.main))
        #endif
        DispatchQueue.main.async {
            self.shouldBeAnimating = true
        }
    }
    
    /// Stops the animation of the progress indicator.
    func stopAnimating() {
        #if DEBUG
            dispatchPrecondition(condition: .onQueue(.main))
        #endif
        DispatchQueue.main.async {
            self.shouldBeAnimating = false
        }
    }
    
    private func beginAnimation() {
        let duration = 0.5
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.repeatCount = 1
        opacityAnimation.duration = duration
        opacityAnimation.isRemovedOnCompletion = false
        indicatorView.layer.add(opacityAnimation, forKey: AnimationKey.opacity.rawValue)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.repeatCount = 1
        rotationAnimation.duration = duration
        rotationAnimation.isRemovedOnCompletion = false
        indicatorView.layer.add(rotationAnimation, forKey: AnimationKey.rotation.rawValue)
    }
    
    private func startRepeatingAnimation() {
        let duration = 1.0
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.repeatCount = .greatestFiniteMagnitude
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        indicatorView.layer.add(animation, forKey: AnimationKey.rotation.rawValue)
    }
    
    private func endAnimation() {
        let duration = 0.5
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.repeatCount = 1
        opacityAnimation.duration = duration
        opacityAnimation.isRemovedOnCompletion = false
        indicatorView.layer.add(opacityAnimation, forKey: AnimationKey.opacity.rawValue)
    }
}
