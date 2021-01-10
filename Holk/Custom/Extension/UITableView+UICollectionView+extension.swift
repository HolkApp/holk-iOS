//
//  UITableView+UICollectionView+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-08.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        self.register(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
    }

    func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    func registerReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, of kind: String) {
        self.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identifier)
    }

    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, of kind: String, indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
