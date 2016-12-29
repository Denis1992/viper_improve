//
//  MosaicCollectionViewLayout.swift
//  improve
//
//  Created by Denis Bezrukov on 02.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class MosaicCollectionViewLayoutInspector:NSObject, ASCollectionViewLayoutInspecting {
    
    let sizeMin:CGSize = {
        
        let width = floor((UIScreen.mainScreen().bounds.size.width - 15.0) / 2.0)
        return CGSizeMake(width, 0.0)
    }()
    
    let sizeMax:CGSize = {
        
        let width = floor((UIScreen.mainScreen().bounds.size.width - 15.0) / 2.0)
        return CGSizeMake(width, CGFloat.max)
    }()
    
    let sizeHeader: CGSize = {
        return CGSize.init(width: UIScreen.mainScreen().bounds.size.width, height: 45)
    }()
    
    func collectionView(collectionView: ASCollectionView, constrainedSizeForNodeAtIndexPath indexPath: NSIndexPath) -> ASSizeRange {
        
        return ASSizeRangeMake(sizeMin, sizeMax)
    }
    func collectionView(collectionView: ASCollectionView!, constrainedSizeForSupplementaryNodeOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> ASSizeRange {
        
        guard let layout = collectionView.collectionViewLayout as? MosaicCollectionViewLayout else {
            return ASSizeRangeMake(CGSizeZero, CGSizeZero)
        }
        let size = CGSizeMake(layout.contentWidth, layout.headerHeight)
        return ASSizeRangeMake(size, size)
    }
    
    func collectionView(collectionView: ASCollectionView!, numberOfSectionsForSupplementaryNodeOfKind kind: String!) -> UInt {
        
        if kind == UICollectionElementKindSectionHeader {
            
            guard let delegate = collectionView.asyncDataSource else { return 0 }
            return UInt(delegate.numberOfSectionsInCollectionView?(collectionView) ?? 0)
        }
        
        return 0
    }
    
    func collectionView(collectionView: ASCollectionView!, supplementaryNodesOfKind kind: String!, inSection section: UInt) -> UInt {
        
        if kind == UICollectionElementKindSectionHeader {
            
            return 1
        }
        
        return 0
    }
}

protocol MosaicCollectionViewLayoutDelegate {
    
    func collectionView(HeightForNodeAtIndexPath indexPath: NSIndexPath) -> CGFloat?
    
}

class MosaicCollectionViewLayout: UICollectionViewLayout {
    var delegate:MosaicCollectionViewLayoutDelegate!
    
    var numberOfColumns = 2
    var cellPadding: CGFloat  = 5.0
    var headerHeight: CGFloat = 40.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    private var headerAttributes = [UICollectionViewLayoutAttributes]()
    private var insets:UIEdgeInsets {
        get {
            return collectionView!.contentInset
        }
        set {}
    }
    
    private var contentHeight:CGFloat  = 0.0
    private var contentWidth: CGFloat {
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override func prepareLayout() {
        
        guard self.collectionView?.numberOfSections() != 0 else { return }
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
            
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            for section in 0 ..< collectionView!.numberOfSections() {
                column = 0
                guard collectionView!.numberOfItemsInSection(section) != 0 else { return }
                let attributes  = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath:NSIndexPath.init(forItem: 0, inSection: section))
                attributes.frame = CGRectMake(insets.left, yOffset.maxElement()!, contentWidth, headerHeight)
                headerAttributes.append(attributes)
                cache.append(attributes)
                yOffset = [CGFloat](count: numberOfColumns, repeatedValue: yOffset.maxElement()! + headerHeight)
                var rowAttributes = [UICollectionViewLayoutAttributes]()
                for item in 0 ..< collectionView!.numberOfItemsInSection(section) {
                    
                    let indexPath = NSIndexPath(forItem: item, inSection: section)
                    guard let heightNode = delegate.collectionView(HeightForNodeAtIndexPath: indexPath) else {
                        
                        fatalError("prepareLayout mosaic node not found")
                        continue
                    }
                    let height = cellPadding + heightNode + cellPadding
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    rowAttributes.append(attributes)
                    
                    contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                    yOffset[column] = yOffset[column] + height
                    

                    if column >= (numberOfColumns - 1) {
                        column = 0
                    } else {
                        column += 1
                    }
                }
                itemAttributes.append(rowAttributes)
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes  in cache {
            if CGRectIntersectsRect(attributes.frame, rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard elementKind == UICollectionElementKindSectionHeader else { return nil }
        return headerAttributes[indexPath.section]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard indexPath.section < itemAttributes.count else { return  nil }
        guard indexPath.row     < itemAttributes[indexPath.section].count else { return nil }
        return itemAttributes[indexPath.section][indexPath.row]
    }
}

