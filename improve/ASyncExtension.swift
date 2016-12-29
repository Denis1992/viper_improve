//
//  ASyncExtension.swift
//  improve
//
//  Created by Denis Bezrukov on 02.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import AsyncDisplayKit


extension ASTextNode {
    
    convenience init(WithAttributedText attributedText:NSAttributedString) {
        self.init()
        self.layerBacked = true
        self.attributedText = attributedText
    }
}

extension ASDisplayNode {
    
    var spacer:ASLayoutSpec {
        let layout = ASLayoutSpec()
        layout.flexGrow = true
        return layout
    }
}
