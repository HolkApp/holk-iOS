//
//  KeyboardEventFloatingViewHandler.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class KeyboardEventFloatingViewHandler: KeyboardEventHandler {
    
    private let floatingView: UIView
    private let view: UIView
    private var bottomConstraint: NSLayoutConstraint
    private let floatingButtonBottomMargin: CGFloat
    
    // bottomConstraint needs to have a positive constant
    public init(floatingView: UIView, view: UIView, bottomConstraint: NSLayoutConstraint) {
        self.floatingView = floatingView
        self.view = view
        assert(floatingView.superview === view)
        
        self.bottomConstraint = bottomConstraint
        floatingButtonBottomMargin = bottomConstraint.constant
        
        floatingView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(floatingView: UIView, view: UIView, bottomMargin: CGFloat = 20) {
        let fallbackBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: floatingView.bottomAnchor, constant: bottomMargin)
        self.init(floatingView: floatingView, view: view, bottomConstraint: fallbackBottomConstraint)
    }
    
    public func willShow(context: KeyboardContext) {
        // Convert view frame to window coordinates which is the coordinate system of the keyboard frame.
        let viewFrame = view.convert(view.frame, to: nil)
        
        let inset = context.frame.height
        let offset = context.frame.maxY - viewFrame.maxY
        
        bottomConstraint.constant = inset - offset
        
        UIView.animate(withDuration: context.duration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    public func willHide(context: KeyboardContext) {
        bottomConstraint.constant = floatingButtonBottomMargin
        
        UIView.animate(withDuration: context.duration, animations: {
            self.view.layoutIfNeeded()
        })
    }

}
