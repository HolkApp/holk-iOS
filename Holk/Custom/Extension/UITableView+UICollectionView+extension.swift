//
//  UITableView+UICollectionView+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-08.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(ofType type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>(ofType type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
    }
}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(ofType type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueHeaderFooterView<T: UICollectionReusableView>(type: T.Type, of kind: String, indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
