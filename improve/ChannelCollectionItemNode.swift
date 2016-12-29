//
//  ChannelCollectionItemNode.swift
//  improve
//
//  Created by Denis Bezrukov on 02.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import AsyncDisplayKit


class ChannelCollectionItemNode: ASCellNode {
    
    
    var nodeDate:ASTextNode!
    var nodeText:ASTextNode!
    var nodeTitle:ASTextNode!
    
    convenience init(WithDate date: String, AndTitle title: String, AndText text:String) {
        
        self.init()
        self.borderWidth = 0.5
        self.borderColor = UIColor.grayColor().CGColor
        
        nodeDate  = ASTextNode(WithAttributedText: NSAttributedString.attributedBoldText(date))
        nodeTitle = ASTextNode(WithAttributedText: NSAttributedString.attributedBoldText(title))
        nodeText  = ASTextNode(WithAttributedText: NSAttributedString.attributedText(text))
        
        addSubnode(nodeDate)
        addSubnode(nodeText)
        addSubnode(nodeTitle)
        
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let layoutDate = ASStackLayoutSpec(
            direction: .Horizontal,
            spacing: 0,
            justifyContent: .Start,
            alignItems: .Center,
            children: [self.spacer, nodeDate])
        
        let layoutVertical = ASStackLayoutSpec(
            direction: .Vertical,
            spacing: 5,
            justifyContent: .Start,
            alignItems: .Stretch,
            children: [layoutDate, nodeTitle, nodeText])
        
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), child: layoutVertical)
    }

}
