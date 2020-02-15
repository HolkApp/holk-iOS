import UIKit

extension String {
    /// Get a FontAwesome icon string with the given icon name.
    ///
    /// - parameter name: The preferred icon name.
    /// - returns: A string that will appear as icon with FontAwesome.
    static func fontAwesomeIcon(name: FontAwesome) -> String {
        let toIndex = name.unicode.index(name.unicode.startIndex, offsetBy: 1)
        return String(name.unicode[name.unicode.startIndex..<toIndex])
    }

    /// Get a FontAwesome icon string with the given CSS icon code. Icon code can be found here: http://fontawesome.io/icons/
    ///
    /// - parameter code: The preferred icon name.
    /// - returns: A string that will appear as icon with FontAwesome.
    static func fontAwesomeIcon(code: String) -> String? {
        guard let name = self.fontAwesome(code: code) else {
            return nil
        }

        return self.fontAwesomeIcon(name: name)
    }

    /// Get a FontAwesome icon with the given CSS icon code. Icon code can be found here: http://fontawesome.io/icons/
    ///
    /// - parameter code: The preferred icon name.
    /// - returns: An internal corresponding FontAwesome code.
    static func fontAwesome(code: String) -> FontAwesome? {
        return FontAwesome(rawValue: code)
    }
}

extension UIImage {

    /// Get a FontAwesome image with the given icon name, text color, size and an optional background color.
    ///
    /// - parameter name: The preferred icon name.
    /// - parameter style: The font style. Either .solid, .regular or .brands.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: A string that will appear as icon with FontAwesome
    static func fontAwesomeIcon(name: FontAwesome, style: FontAwesomeStyle, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear) -> UIImage {

        // Prevent application crash when passing size where width or height is set equal to or less than zero, by clipping width and height to a minimum of 1 pixel.
        var size = size
        if size.width <= 0 { size.width = 1 }
        if size.height <= 0 { size.height = 1 }

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center

        let fontSize = min(size.width / FontAwesomeConfig.fontAspectRatio, size.height)

        // stroke width expects a whole number percentage of the font size
        let strokeWidth: CGFloat = fontSize == 0 ? 0 : (-100 * borderWidth / fontSize)

        let attributedString = NSAttributedString(string: String.fontAwesomeIcon(name: name), attributes: [
            .font: UIFont.fontAwesome(ofSize: fontSize, style: style),
            .foregroundColor: textColor,
            .backgroundColor: backgroundColor,
            .paragraphStyle: paragraph,
            .strokeWidth: strokeWidth,
            .strokeColor: borderColor
            ])

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) / 2, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /// Get a FontAwesome image with the given icon css code, text color, size and an optional background color.
    ///
    /// - parameter code: The preferred icon css code.
    /// - parameter style: The font style. Either .solid, .regular or .brands.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: A string that will appear as icon with FontAwesome
    static func fontAwesomeIcon(code: String, style: FontAwesomeStyle, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear) -> UIImage? {
        guard let name = String.fontAwesome(code: code) else { return nil }
        return fontAwesomeIcon(name: name, style: style, textColor: textColor, size: size, backgroundColor: backgroundColor, borderWidth: borderWidth, borderColor: borderColor)
    }
}
