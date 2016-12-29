//
//  ChannelPresenter.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

class ChannelPresenter {
    
    var interactor:ChannelInteractorInput?
    var router:ChannelRouterInput?
    weak var view:ChannelViewInput?
}


extension ChannelPresenter: ChannelViewOutput {
    
    func requireObject(inout object:ItemModel, ForIndexPath indexPath:NSIndexPath) {
        
        interactor?.requireObject(&object, ForIndexPath:indexPath)
    }
    
    func requireRows(inout rows:Int, ForSection section:Int) {
        
        interactor?.requireRows(&rows, ForSection:section)
    }
    
    func requireSections(inout sections: Int) {
        
        interactor?.requireSections(&sections)
    }
    
    func requireTitleForHeader(inout title:String, InSection section:Int) {
        
        interactor?.requireTitleForHeader(&title, InSection: section)
    }
        
    func selectItem(AtIndexPath indexPath: NSIndexPath) {
        
        interactor?.selectItem(AtIndexPath: indexPath)
    }
}

extension ChannelPresenter: ChannelInteractorOutput {
    
    func actionDataUpdated(updates:DataUpdates?) {
        
        view?.actionDataUpdated(updates)
    }
    func openInfo(WithUrl url:NSURL) {
        
        router?.openInfo(WithUrl: url)
    }
    func openInfo(WithObject object:ItemModel) {
        
        router?.openInfo(WithObject: object)
    }
}




