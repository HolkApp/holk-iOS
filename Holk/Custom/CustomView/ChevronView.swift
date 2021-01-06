import UIKit

enum ChevronDirection {
    case right
    case left
    case up
    case down
}

class ChevronView: UIImageView {
    var direction: ChevronDirection = .right {
        didSet {
            update()
        }
    }

    init() {
        super.init(frame: .zero)

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
}

extension ChevronView {
    func setup() {
        contentMode = .scaleAspectFit

        update()
    }

    func update() {
        switch direction {
        case .up:
            image = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate)
        case .down:
            image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        case .left:
            image = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        case .right:
            image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
