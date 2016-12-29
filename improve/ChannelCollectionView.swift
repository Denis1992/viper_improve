//
//  ChannelCollectionView.swift
//  improve
//
//  Created by Denis Bezrukov on 02.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit


// MARK: - Initialization -

class ChannelCollectionView:ASViewController {
    
    var output:ChannelViewOutput?
    var collectionNode: ASCollectionNode {
        return self.node as! ASCollectionNode
    }
    
    let layoutInspector = MosaicCollectionViewLayoutInspector()
    
    init() {
        
        let flowLayout = MosaicCollectionViewLayout()
        super.init(node: ASCollectionNode(collectionViewLayout: flowLayout))
        flowLayout.delegate = self
        
        collectionNode.view.registerSupplementaryNodeOfKind(UICollectionElementKindSectionHeader)
        title = "НОВОСТИ"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        collectionNode.delegate = self
        collectionNode.dataSource = self
        
        collectionNode.view.layoutInspector = layoutInspector

 
    }
}

// MARK: - ASCollectionDataSource, UITableViewDataSource -

extension ChannelCollectionView: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var rows:Int = 0
        output?.requireRows(&rows, ForSection:section)
        return rows
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        var sections:Int = 0
        output?.requireSections(&sections)
        return sections
    }
    
    func collectionView(collectionView: ASCollectionView, nodeBlockForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        var object:ItemModel = ItemModel()
        output?.requireObject(&object, ForIndexPath:indexPath)
        
        let cellNodeBlock = { () -> ASCellNode in
            let node = ChannelCollectionItemNode.init(WithDate: object.dateText ?? "",
                                                      AndTitle: object.title ?? "",
                                                      AndText:  object.info ?? "")
            return node
        }
        return cellNodeBlock
    }
    
    func collectionView(collectionView: ASCollectionView, nodeForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        guard kind == UICollectionElementKindSectionHeader else { return ASCellNode() }
        var title:String = ""
        output?.requireTitleForHeader(&title, InSection: indexPath.section)
        
        let textAttributes = [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline),
                              NSForegroundColorAttributeName: UIColor.grayColor()]
        let textInsets = UIEdgeInsetsMake(11.0, 5.0, 11.0, 5.0)
        let node = ASTextCellNode(attributes: textAttributes, insets: textInsets)
        node.text = title
        return node
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        output?.selectItem(AtIndexPath: indexPath)
    }
}


extension ChannelCollectionView: MosaicCollectionViewLayoutDelegate {
    
    func collectionView(HeightForNodeAtIndexPath indexPath: NSIndexPath) -> CGFloat? {
        
        guard let node = self.collectionNode.view.nodeForItemAtIndexPath(indexPath) else { return nil }
        return CGRectGetHeight(node.frame)
    }
    
}


extension ChannelCollectionView: ChannelViewInput {
    
    func actionDataUpdated(updates:DataUpdates?) {
        guard let updates = updates else { return }

        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.collectionNode.view.performBatchAnimated(
                true,
                updates: {
                    for set in updates.sections.delete { self?.collectionNode.view.deleteSections(set) }
                    for set in updates.sections.insert { self?.collectionNode.view.insertSections(set) }
                    if updates.rows.delete.count > 0 {
                        self?.collectionNode.view.deleteItemsAtIndexPaths(updates.rows.delete) }
                    if updates.rows.insert.count > 0 {
                        self?.collectionNode.view.insertItemsAtIndexPaths(updates.rows.insert) }
                    if updates.rows.reload.count > 0 {
                        self?.collectionNode.view.reloadItemsAtIndexPaths(updates.rows.reload) }
                },
                completion: { (flag) in
                    
            })
            
        }
    }
}


   
