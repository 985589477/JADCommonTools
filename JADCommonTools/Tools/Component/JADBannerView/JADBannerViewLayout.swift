//
//  JADBannerViewLayout.swift
//  JADTransfer
//
//  Created by iOS on 2019/9/16.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

class JADBannerViewLayout: UICollectionViewLayout {
    var itemSize: CGSize = CGSize.zero {
        didSet {
            self.itemOffSet = self.itemSize.width
        }
    }
    var minimumColumnSpacing: CGFloat = 0.0
    var viewSize: CGFloat = 0.0
    
    
    private var itemOffSet: CGFloat = 0.0
    private var itemArray = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        itemArray.removeAll()
        if viewSize == 0.0 {
            viewSize = self.collectionView?.frame.width ?? 0
        }
        let cellCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        for i in 0 ..< cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attribute = self.layoutAttributesForItem(at: indexPath)
            itemArray.append(attribute!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let x = self.itemSize.width * CGFloat(indexPath.row) + self.minimumColumnSpacing * CGFloat(indexPath.row)
        attribute.frame = CGRect(x: x, y: 0, width: self.itemSize.width, height: self.itemSize.height)
        let attCY = self.collectionView?.contentOffset.x ?? 0 + viewSize / 2
        let attributesY = itemOffSet * CGFloat(indexPath.row) + itemOffSet / 2
        attribute.zIndex = Int(-abs(attributesY - attCY))
        return attribute
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.equalTo(self.collectionView!.bounds)
    }
    
    override var collectionViewContentSize: CGSize {
        let cellCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        return CGSize(width: CGFloat(cellCount) * itemOffSet + CGFloat(cellCount - 1) * self.minimumColumnSpacing, height: self.collectionView!.frame.height)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var index = (proposedContentOffset.x + self.minimumColumnSpacing + viewSize / 2 - itemOffSet / 2) / itemOffSet
        index = CGFloat(roundf(Float(index)))
        var contentOffSet = proposedContentOffset
        contentOffSet.x = itemOffSet * index + self.minimumColumnSpacing * index + itemOffSet / 2 - viewSize / 2
        return contentOffSet
    }
    
}
