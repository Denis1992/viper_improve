//
//  ChannelInteractor.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation


class ChannelInteractor {

    weak var output:ChannelInteractorOutput?
    var dataService:DataServiceInput?
}


extension ChannelInteractor: ChannelInteractorInput {
    
    func requireObject(inout object:ItemModel, ForIndexPath indexPath:NSIndexPath) {
        
        dataService?.requireObject(&object, ForIndexPath:indexPath)
    }
    
    func requireRows(inout rows:Int, ForSection section:Int) {
        
        dataService?.requireRows(&rows, ForSection:section)
    }
    
    func requireSections(inout sections:Int) {
        
        dataService?.requireSections(&sections)
    }
    
    func requireTitleForHeader(inout title:String, InSection section:Int) {
        
        var group:String = ""
        dataService?.requireGroup(&group, ForSection: section)
        let date = (group as NSString).substringWithRange(NSMakeRange(group.characters.count - 6, 6))
        let year = (date as NSString).substringWithRange(NSMakeRange(0, 4))
        let month = (date as NSString).substringWithRange(NSMakeRange(4, 2))
        title = "Год: \(year), Месяц: \(month)"
    }

    
    func selectItem(AtIndexPath indexPath: NSIndexPath) {
        
        var itemObject = ItemModel()
        self.requireObject(&itemObject, ForIndexPath: indexPath)
        output?.openInfo(WithObject: itemObject)
        
    }
}

extension ChannelInteractor:DataServiceOutput {
    
    func actionDataUpdated(updates:DataUpdates?) {
        
        output?.actionDataUpdated(updates)
    }
}
