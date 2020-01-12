//
//  KeyboardEventObserver.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol KeyboardEventHandler {
    func willShow(context: KeyboardContext)
    func willHide(context: KeyboardContext)
}

final class KeyboardEventObserver {
    private let handlers: [KeyboardEventHandler]
    
    convenience init(handler: KeyboardEventHandler) {
        self.init(handlers: [handler])
    }
    
    init(handlers: [KeyboardEventHandler]) {
        self.handlers = handlers
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func willShowKeyboard(_ notification: Notification) {
        if let keyboardContext = KeyboardContext(notification: notification) {
            for handler in handlers {
                handler.willShow(context: keyboardContext)
            }
        }
    }
    
    @objc private func willHideKeyboard(_ notification: Notification) {
        if let keyboardContext = KeyboardContext(notification: notification) {
            for handler in handlers {
                handler.willHide(context: keyboardContext)
            }
        }
    }
}

