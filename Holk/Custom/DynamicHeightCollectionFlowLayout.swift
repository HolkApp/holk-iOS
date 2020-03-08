//
//  DynamicHeightCollectionFlowLayout.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-03.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class DynamicHeightCollectionFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)
        layoutAttributesObjects?
            .filter { $0.representedElementCategory == .cell }
            .forEach({ layoutAttributes in
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                    layoutAttributes.frame = layoutAttributes.frame.offsetBy(dx: 0, dy: sectionInset.top - layoutAttributes.frame.minY)
                }
        })

        return layoutAttributesObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView, let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }

        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }

}
