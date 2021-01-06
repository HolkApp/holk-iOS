import UIKit
import Kingfisher

extension UIImageView {

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }
}
