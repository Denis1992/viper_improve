//
//  SelectPresenter.swift
//  improve
//
//  Created by Denis Bezrukov on 19.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

class SelectPresenter {
    
    var interactor:SelectInteractorInput?
    var router:SelectRouterInput?
    weak var view:SelectViewInput?
}

extension SelectPresenter:SelectViewOutput {
    
    func actionAddChannel() {
        
        interactor?.actionAddChannel()
    }
    
    func actionViewLoaded() {
        
        interactor?.actionRequestInitial()
    }
    
    func selectChannel(AtIndexPath indexPath:NSIndexPath) {
        
        interactor?.selectChannel(AtIndexPath: indexPath)
    }
    
    func requireObject(inout object:ChannelModel, ForIndexPath indexPath:NSIndexPath) {
    
        interactor?.requireObject(&object, ForIndexPath:indexPath)
    }
    
    func requireRows(inout rows:Int, ForSection section:Int) {
        
        interactor?.requireRows(&rows, ForSection:section)
    }
    
    func requireSections(inout sections: Int) {
        
        interactor?.requireSections(&sections)
    }
}

extension SelectPresenter:SelectInteractorOutput {
    
    func actionDataUpdated(updates:DataUpdates?) {
        
        view?.actionDataUpdated(updates)
    }

    func actionRequestCompleted() {
        
        //
    }
    func openDetail(WithChannel channel:ChannelModel, AndExtended extended: Bool) {
        
        router?.openDetail(WithChannel: channel, AndExtended: extended)
    }
    
    func showAlert(WithAlertController controller:UIViewController, Animated animated:Bool, Completion completionBlock:() -> Void) {
        
        router?.showAlert(WithAlertController: controller, Animated: animated, Completion: completionBlock)
    }
}


