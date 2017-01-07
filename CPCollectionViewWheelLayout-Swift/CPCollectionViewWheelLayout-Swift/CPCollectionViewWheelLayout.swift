//
//  CPCollectionViewWheelLayout.swift
//  CPCollectionViewWheelLayout-Swift
//
//  Created by Parsifal on 2016/12/30.
//  Copyright © 2016年 Parsifal. All rights reserved.
//

import UIKit

enum CPWheelLayoutType:Int {
    case leftBottom = 0
    case rightBottom
    case leftTop
    case rightTop
    case leftCenter
    case rightCenter
    case topCenter
    case bottomCenter
}

struct CPWheelLayoutConfiguration {
    var _cellSize:CGSize
    var _radius:Double
    var _angular:Double
    var fadeAway:Bool
    var maxContentHeight:Double
    var contentHeigthPadding:Double
    var wheelType:CPWheelLayoutType
    
    // MARK: - Initial Methods
    init(withCellSize cellSize:CGSize,
                        radius:Double,
                        angular:Double,
                        wheelType:CPWheelLayoutType,
                        fadeAway:Bool = true,
                        maxContentHeight:Double = 0.0,
                        contentHeigthPadding:Double = 0.0) {
        _cellSize = cellSize
        _radius = radius
        _angular = angular
        self.wheelType = wheelType
        self.fadeAway = fadeAway
        self.maxContentHeight = maxContentHeight
        self.contentHeigthPadding = contentHeigthPadding
    }
    
    // MARK: - Getter & Setter
    var radius:Double {
        get {
            return _radius
        }
        set {
            _radius = newValue>0 ? newValue : 200
        }
    }
    
    var angular:Double {
        get {
            return _angular
        }
        set {
            _angular = newValue>0 ? newValue : 20.0
        }
    }
    
    var cellSize:CGSize {
        get {
            return _cellSize
        }
        set {
            _cellSize = newValue.width<=0.0 || newValue.height<=0.0 ?  CGSize.init(width: 50.0, height: 50.0) : newValue
        }
    }
}

class CPCollectionViewWheelLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    var cellCount = 0
    var invisibleCellCount = 0.0
    open var configuration:CPWheelLayoutConfiguration
    
    // MARK: - Open Methods
    init(withConfiguration configuration:CPWheelLayoutConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        cellCount = collectionView!.numberOfItems(inSection: 0)
        if cellCount > 0 {
            invisibleCellCount = Double(collectionView!.contentOffset.y/configuration.cellSize.height)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let viewSize = collectionView?.bounds.size
        let cellSize = configuration.cellSize
        let angular = configuration.angular
        let radius = configuration.radius
        let fadeAway = configuration.fadeAway
        let contentOffset = collectionView?.contentOffset
        let visibleCellIndex = Double(indexPath.item)-invisibleCellCount
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attributes.size = cellSize
        attributes.isHidden = true
        var angle = angular/90.0*Double(visibleCellIndex)*M_PI_2
        let angleOffset = asin(Double(cellSize.width)/radius)
        var translation = CGAffineTransform.identity
        
        switch configuration.wheelType {
        case .leftBottom:
            attributes.center = CGPoint.init(x: cellSize.width/2.0,
                                             y: (contentOffset?.y)!+(viewSize?.height)!-cellSize.height/2)
            
            if (angle <= (M_PI_2+2.0*angleOffset+angular/90.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: CGFloat(sin(angle)*radius),
                                                     y: -(CGFloat(cos(angle)*radius)+cellSize.height/2.0))
            }
        case .rightBottom:
            attributes.center = CGPoint.init(x: (viewSize?.width)!-cellSize.width/2.0,
                                             y: (contentOffset?.y)!+(viewSize?.height)!-cellSize.height/2)
            
            if (angle <= (M_PI_2+2.0*angleOffset+angular/90.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: CGFloat(-sin(angle)*radius),
                                                     y: -(CGFloat(cos(angle)*radius)+cellSize.height/2.0))
            }
        case .leftTop:
            attributes.center = CGPoint.init(x: cellSize.width/2.0,
                                             y: (contentOffset?.y)!)
            
            if (angle <= (M_PI_2+2.0*angleOffset+angular/90.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: CGFloat(cos(angle)*radius),
                                                     y: (CGFloat(sin(angle)*radius)+cellSize.height/2.0))
            }
        case .rightTop:
            attributes.center = CGPoint.init(x: (viewSize?.width)!-cellSize.width/2.0,
                                             y: (contentOffset?.y)!)
            
            if (angle <= (M_PI_2+2.0*angleOffset+angular/90.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: CGFloat(-cos(angle)*radius),
                                                     y: (CGFloat(sin(angle)*radius)+cellSize.height/2.0))
            }
        case .leftCenter:
            attributes.center = CGPoint.init(x: cellSize.width/2.0,
                                             y: (contentOffset?.y)!+(viewSize?.height)!/2)
            angle = visibleCellIndex*angular/180*M_PI;
            
            if (angle <= (M_PI+2.0*angleOffset+angular/180.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: CGFloat(sin(angle)*radius),
                                                     y: -CGFloat(cos(angle)*radius))
            }

        case .rightCenter:
            attributes.center = CGPoint.init(x: (viewSize?.width)!-cellSize.width/2.0,
                                             y: (contentOffset?.y)!+(viewSize?.height)!/2)
            
            if (angle <= (M_PI+2.0*angleOffset+angular/180.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: -CGFloat(sin(angle)*radius),
                                                     y: -CGFloat(cos(angle)*radius))
            }
        case .topCenter:
            attributes.center = CGPoint.init(x: (viewSize?.width)!/2.0,
                                             y: (contentOffset?.y)!+cellSize.width/2)
            angle = visibleCellIndex*angular/180*M_PI;

            if (angle <= (M_PI+2.0*angleOffset+angular/180.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: -CGFloat(cos(angle)*radius),
                                                     y: (CGFloat(sin(angle)*radius)))
            }
        case .bottomCenter:
            attributes.center = CGPoint.init(x: (viewSize?.width)!/2.0,
                                             y: (contentOffset?.y)!+(viewSize?.height)!-cellSize.height/2)
            angle = visibleCellIndex*angular/180*M_PI;
            
            if (angle <= (M_PI+2.0*angleOffset+angular/180.0)) && (angle >= -angleOffset) {
                attributes.isHidden = false
                translation = CGAffineTransform.init(translationX: -CGFloat(cos(angle)*radius),
                                                     y: -CGFloat(sin(angle)*radius))
            }
        }
        
        attributes.transform = translation
        var fadeFactor:Double
        switch configuration.wheelType {
        case .bottomCenter,.topCenter,.rightCenter,.leftCenter:
            fadeFactor = 1-fabs(angle-M_PI_2)*0.5
        default:
            fadeFactor = 1-fabs(angle-M_PI_4)
        }
        attributes.alpha = CGFloat(fadeAway ? (fadeFactor) : 1.0)
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
        var visibleCellCount:CGFloat
        var contentSize:CGSize
        switch configuration.wheelType {
        case .bottomCenter,.topCenter,.rightCenter,.leftCenter:
            visibleCellCount = CGFloat(180.0/configuration.angular+1.0)
            contentSize = CGSize.init(width: viewSize!.width,
                                     height: (viewSize?.height)!+(CGFloat(cellCount)-visibleCellCount)*(configuration.cellSize.height)+CGFloat(configuration.contentHeigthPadding))
        default:
            visibleCellCount = CGFloat(90.0/configuration.angular+1.0)
            contentSize = CGSize.init(width: viewSize!.width,
                                     height: (viewSize?.height)!+(CGFloat(cellCount)-visibleCellCount)*(configuration.cellSize.height)+CGFloat(configuration.contentHeigthPadding))
        }
        
        return contentSize
    }
    
}
