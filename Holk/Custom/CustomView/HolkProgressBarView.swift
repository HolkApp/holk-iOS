import UIKit

class HolkProgressBarView: UIView {
    enum Style {
        case bar
        case spinner
    }
    
    private var trackViews = [UIView]()
    private var progressView = [UIView]()
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private var radius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / (2 * CGFloat.pi)
    }
    
    private var dashLength: CGFloat {
       2 * radius * CGFloat.pi / CGFloat(totalSteps)
    }
    
    private var spinnerPath: UIBezierPath {
        UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: radius,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi,
            clockwise: false
        )
    }

    private var barPath: UIBezierPath {
        let barPath = UIBezierPath()
        barPath.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        barPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        return barPath
    }
    
    private var trackLayerDashPartterm: [NSNumber] {
        [NSNumber(value: Double(dashLength * 3 / 4)), NSNumber(value: Double(dashLength / 4))]
    }
    
    private var progressLayerDashPattern: [NSNumber]? {
        guard currentStep != 0 else { return nil }
        var dashParttern = [NSNumber]()
        for i in 1 ... currentStep {
            dashParttern.append(NSNumber(value: Double(dashLength * 3 / 4)))
            if i != currentStep {
                dashParttern.append(NSNumber(value: Double(dashLength / 4)))
            } else {
                dashParttern.append(NSNumber(value: Double(dashLength * CGFloat(totalSteps - i) + dashLength / 4)))
            }
        }
        return dashParttern
    }
    
    var totalSteps: Int
    var currentStep: Int {
        didSet {
            progressLayer.lineDashPattern = progressLayerDashPattern
            progressLayer.strokeColor =
                progressLayerDashPattern == nil ? UIColor.clear.cgColor : progressTintColor?.cgColor
        }
    }
    var style: Style = .spinner
    var trackTintColor: UIColor? = .red {
        didSet {
            trackLayer.strokeColor = trackTintColor?.cgColor
        }
    }
    
    var progressTintColor: UIColor? = .black {
        didSet {
            progressLayer.strokeColor =
                progressLayerDashPattern == nil ? UIColor.clear.cgColor : progressTintColor?.cgColor
        }
    }
    
    init(totalSteps: Int, currentStep: Int = 0, frame: CGRect) {
        self.totalSteps = totalSteps
        self.currentStep = currentStep
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ style: Style, animated: Bool = true) {
        self.style = style
        switch style {
        case .spinner:
            toSpinnerAnimation(animated: animated)
        case .bar:
            toBarAnimation(animated: animated)
        }
    }
    
    func spinnerLoading() {
        guard style == .spinner else { return }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.repeatCount = .greatestFiniteMagnitude
        animation.duration = 1.0
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "rotation")
    }
    
    func endLoading() {
        layer.removeAnimation(forKey: "rotation")
    }
    
    private func toBarAnimation(animated: Bool) {
        endLoading()
        trackLayer.path = barPath.cgPath
        progressLayer.path = barPath.cgPath

        let trackAnimation = CABasicAnimation(keyPath: "path")
        trackAnimation.fromValue = spinnerPath.cgPath
        trackAnimation.toValue = barPath.cgPath

        let progressAnimation = CABasicAnimation(keyPath: "path")
        progressAnimation.fromValue = spinnerPath.cgPath
        progressAnimation.toValue = barPath.cgPath
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)

        trackLayer.add(trackAnimation, forKey: nil)
        progressLayer.add(progressAnimation, forKey: nil)
        
        layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))

        CATransaction.commit()
        CATransaction.setCompletionBlock {
            self.progressLayer.isHidden = false
        }
    }
    
    private func toSpinnerAnimation(animated: Bool) {
        endLoading()
        trackLayer.path = spinnerPath.cgPath
        progressLayer.path = spinnerPath.cgPath

        let trackAnimation = CABasicAnimation(keyPath: "path")
        trackAnimation.fromValue = barPath.cgPath
        trackAnimation.toValue = spinnerPath.cgPath

        let progressAnimation = CABasicAnimation(keyPath: "path")
        progressAnimation.fromValue = barPath.cgPath
        progressAnimation.toValue = spinnerPath.cgPath
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)

        trackLayer.add(trackAnimation, forKey: nil)
        progressLayer.add(progressAnimation, forKey: nil)
        
        layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))

        CATransaction.commit()
        CATransaction.setCompletionBlock {
            self.progressLayer.isHidden = true
            self.currentStep += 1
            self.spinnerLoading()
        }
    }
    
    private func setup() {
        trackLayer.lineWidth = 5
        trackLayer.lineCap = .round
        trackLayer.strokeColor = trackTintColor?.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
        // TODO: Simplify this
        progressLayer.strokeColor = progressLayerDashPattern == nil ? UIColor.clear.cgColor : progressTintColor?.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        
        let fromPath: UIBezierPath
        switch style {
        case .spinner:
            fromPath = spinnerPath
            trackLayer.lineDashPattern = trackLayerDashPartterm
            progressLayer.lineDashPattern = progressLayerDashPattern
            progressLayer.isHidden = true
            layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
        case .bar:
            fromPath = barPath
            progressLayer.isHidden = false
        }
        trackLayer.path = fromPath.cgPath
        progressLayer.path = fromPath.cgPath
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
}
