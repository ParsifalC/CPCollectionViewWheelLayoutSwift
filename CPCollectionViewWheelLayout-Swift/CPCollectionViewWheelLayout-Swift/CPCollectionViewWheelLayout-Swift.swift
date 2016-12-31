//
//  CPCollectionViewWheelLayout-Swift.swift
//  CPCollectionViewWheelLayout-Swift
//
//  Created by Parsifal on 2016/12/30.
//  Copyright © 2016年 Parsifal. All rights reserved.
//

import UIKit

class CPCollectionViewWheelLayout: UICollectionViewLayout {
    
    // MARK: - Private Properties
    var cellSize = CGSize.init(width: 50.0, height: 50.0)
    var cellCount = 0
    var invisibleCellCount = 0.0
    var radius = 200.0
    var angular = 20.0 //每个cell的角度间隔
    var fadeAway = true
    var maxContentHeight = 0.0
    open var contentHeigthPadding = 0.0
    
    // MARK: - Open Methods
    override func prepare() {
        cellCount = collectionView!.numberOfItems(inSection: 0)
        if cellCount > 0 {
            invisibleCellCount = Double(collectionView!.contentOffset.y/cellSize.height)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let viewSize = collectionView?.bounds.size
        let contentOffset = collectionView?.contentOffset
        let visibleCellIndex = Double(indexPath.item)-invisibleCellCount
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attributes.size = cellSize
        attributes.isHidden = true
        let angle = angular/90.0*Double(visibleCellIndex)*M_PI_2
        let angleOffset = asin(Double(cellSize.width)/radius)
        var translation = CGAffineTransform.identity
        
        attributes.center = CGPoint.init(x: cellSize.width/2.0,
                                         y: (contentOffset?.y)!+(viewSize?.height)!-cellSize.height/2)
        
        if (angle <= (M_PI_2+2.0*angleOffset+angular/90.0)) && (angle >= -angleOffset) {
            attributes.isHidden = false
            translation = CGAffineTransform.init(translationX: CGFloat(sin(angle)*radius),
                                                 y: -(CGFloat(cos(angle)*radius)+cellSize.height/2.0))
        }
        
        attributes.transform = translation
        attributes.alpha = CGFloat(fadeAway ? (1.0-fabs(angle-M_PI_4)) : 1.0)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var mutableAttributes = [UICollectionViewLayoutAttributes]()
        for index in 0..<cellCount {
            let attributes = layoutAttributesForItem(at: IndexPath(item: index, section: 0))
            if rect.contains((attributes?.frame)!) || rect.intersects((attributes?.frame)!) {
                mutableAttributes.append(attributes!)
            }
        }
        return mutableAttributes
    }

    override var collectionViewContentSize: CGSize {
        let viewSize = collectionView?.bounds.size
        let visibleCellCount = CGFloat(90.0/angular+1.0)
        return CGSize.init(width: viewSize!.width,
                           height: (viewSize?.height)!+(CGFloat(cellCount)-visibleCellCount)*(cellSize.height)+CGFloat(contentHeigthPadding))
    }
    
}
