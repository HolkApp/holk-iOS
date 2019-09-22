import UIKit

class FontLoader {
    static func loadFont(_ name: String) {
        guard
            let fontURL = URL.fontURL(for: name),
            let data = try? Data(contentsOf: fontURL),
            let provider = CGDataProvider(data: data as CFData),
            let font = CGFont(provider)
            else { return }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            guard let nsError = error?.takeUnretainedValue() as AnyObject as? NSError else { return }
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}

extension URL {
    static func fontURL(for fontName: String) -> URL? {
        let bundle = Bundle(for: FontLoader.self)

        if let fontURL = bundle.url(forResource: fontName, withExtension: "otf") {
            return fontURL
        }

        return nil
    }
}
