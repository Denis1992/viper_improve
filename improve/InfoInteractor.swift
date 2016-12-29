//
//  InfoInteractor.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

class InfoInteractor {
    
    weak var output:InfoInteractorOutput?
    var itemObject: ItemModel?
}


extension InfoInteractor: InfoInteractorInput {
    
    func requestItem() {
        
        guard itemObject != nil else { return }
        output?.recieve(WithItem: itemObject!)
    }
    
    func openInBrowser() {
        guard let link = itemObject?.link else { return }
        guard let url = NSURL(string:link) else { return }
        output?.openInBrowser(WithUrl: url)
        
    }
}

