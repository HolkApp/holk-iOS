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
    private let shapeLayer = CAShapeLayer()
    private var radius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / (2 * CGFloat.pi)
    }
    
    private var dashLength: CGFloat {
       bounds.size.width / CGFloat(totalSteps)
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
        barPath.move(to: CGPoint(x: bounds.minX + dashLength / 8, y: bounds.midY))
        barPath.addLine(to: CGPoint(x: bounds.maxX + dashLength / 8, y: bounds.midY))
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
    
    var totalSteps: Int {
        didSet {
            progressLayer.lineDashPattern = progressLayerDashPattern
        }
    }
    var currentStep: Int {
        didSet {
            progressLayer.lineDashPattern = progressLayerDashPattern
            progressLayer.strokeColor =
                progressLayerDashPattern == nil ? UIColor.clear.cgColor : progressTintColor?.cgColor
        }
    }
    
    var trackTintColor: UIColor? = .red {
        didSet {
            trackLayer.strokeColor = trackTintColor?.cgColor
        }
    }
    
    var progressTintColor: UIColor? = .black {
        didSet {
            progressLayer.strokeColor = progressTintColor?.cgColor
        }
    }
    
    private(set) var style: Style = .spinner
    
    convenience init() {
        self.init(totalSteps: 1, frame: .zero)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    func update(_ style: Style, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.style = style
        switch style {
        case .spinner:
            toSpinnerAnimation(animated: animated, completion: completion)
        case .bar:
            toBarAnimation(animated: animated, completion: completion)
        }
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            spinnerLoading()
        } else {
            endLoading()
        }
    }
    
    private func spinnerLoading() {
        guard style == .spinner else { return }
        
        posesAnimate()
    }
    
    private func endLoading() {
        layer.removeAnimation(forKey: "transform.rotation")
        trackLayer.removeAnimation(forKey: "strokeEnd")
    }
    
    private func toBarAnimation(animated: Bool, completion: (() -> Void)? = nil) {
        endLoading()
        trackLayer.path = barPath.cgPath
        progressLayer.path = barPath.cgPath
        trackLayer.lineDashPattern = trackLayerDashPartterm
        progressLayer.lineDashPattern = progressLayerDashPattern

        CATransaction.setCompletionBlock {
            self.progressLayer.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }

        if animated {
            let trackAnimation = CABasicAnimation(keyPath: "path")
            trackAnimation.fromValue = spinnerPath.cgPath
            trackAnimation.toValue = barPath.cgPath

            let progressAnimation = CABasicAnimation(keyPath: "path")
            progressAnimation.fromValue = spinnerPath.cgPath
            progressAnimation.toValue = barPath.cgPath

            trackLayer.add(trackAnimation, forKey: nil)
            progressLayer.add(progressAnimation, forKey: nil)
            layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
        }
    }
    
    private func toSpinnerAnimation(animated: Bool, completion: (() -> Void)? = nil) {
        endLoading()
        progressLayer.isHidden = true
        trackLayer.path = spinnerPath.cgPath
        progressLayer.path = spinnerPath.cgPath
        trackLayer.lineDashPattern = nil
        progressLayer.lineDashPattern = nil

        CATransaction.setCompletionBlock {
            self.spinnerLoading()
            completion?()
        }

        if animated {
            let trackAnimation = CABasicAnimation(keyPath: "path")
            trackAnimation.fromValue = barPath.cgPath
            trackAnimation.toValue = spinnerPath.cgPath

            let progressAnimation = CABasicAnimation(keyPath: "path")
            progressAnimation.fromValue = barPath.cgPath
            progressAnimation.toValue = spinnerPath.cgPath

            trackLayer.add(trackAnimation, forKey: nil)
            progressLayer.add(progressAnimation, forKey: nil)
        }
    }
    
    private func setup() {
        trackLayer.lineWidth = 5
        trackLayer.lineCap = .round
        trackLayer.strokeColor = trackTintColor?.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
        progressLayer.strokeColor = progressLayerDashPattern == nil ? UIColor.clear.cgColor : progressTintColor?.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        
        let fromPath: UIBezierPath
        switch style {
        case .spinner:
            fromPath = spinnerPath
            trackLayer.lineDashPattern = nil
            progressLayer.lineDashPattern = nil
            progressLayer.isHidden = true
        case .bar:
            fromPath = barPath
            trackLayer.lineDashPattern = trackLayerDashPartterm
            progressLayer.lineDashPattern = progressLayerDashPattern
            progressLayer.isHidden = false
        }
        trackLayer.path = fromPath.cgPath
        progressLayer.path = fromPath.cgPath
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
}


extension HolkProgressBarView {
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    static var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }
    
    private func posesAnimate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = HolkProgressBarView.poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animate(trackLayer, keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animate(layer, keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
    }
    
    private func animate(_ layer: CALayer, keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}
