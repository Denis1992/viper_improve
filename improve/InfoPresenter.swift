//
//  InfoPresenter.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation


class InfoPresenter {
    var interactor:InfoInteractorInput?
    var router:InfoRouterInput?
    weak var view:InfoViewInput?
}

extension InfoPresenter: InfoViewOutput {
    
    func actionViewDidLoad() {
        
        interactor?.requestItem()
    }
    func openInBrowser() {
        
        interactor?.openInBrowser()
    }
}

extension InfoPresenter: InfoInteractorOutput {
    
    func recieve(WithItem item:ItemModel) {
        
        view?.recieve(WithItem: item)
    }
    
    func openInBrowser(WithUrl url: NSURL) {
        
        router?.openInBrowser(WithUrl: url)
    }
}
