//
//  KeyboardEventContext.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

struct KeyboardContext {
    let frame: CGRect
    let duration: TimeInterval
    let curve: UIView.AnimationCurve
    
    init?(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int
            else { return nil }
        
        self.frame = value.cgRectValue
        self.duration = duration
        self.curve = UIView.AnimationCurve(rawValue: curve) ?? .linear
    }
}
