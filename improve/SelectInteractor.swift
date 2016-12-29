//
//  SelectInteractor.swift
//  improve
//
//  Created by Denis Bezrukov on 19.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol SelectInteractorInput:class {
    func actionAddChannel()
    func actionRequestInitial()
    func requireObject(inout object:ChannelModel, ForIndexPath indexPath:NSIndexPath)
    func requireRows(inout rows:Int, ForSection section:Int)
    func requireSections(inout sections:Int)
    func selectChannel(AtIndexPath indexPath:NSIndexPath)
    func addCustomNews(Url url:String)
}

protocol SelectInteractorOutput:class {
    
    func actionDataUpdated(updates:DataUpdates?)
    func actionRequestCompleted()
    func openDetail(WithChannel channel:ChannelModel, AndExtended extended: Bool)
    func showAlert(WithAlertController controller:UIViewController, Animated animated:Bool, Completion completionBlock:() -> Void)
}

class SelectInteractor {
    
    var dataService:DataServiceInput?
    var requestResponseObjectService: RequestServiceInput?
    
    weak var output:SelectInteractorOutput?
}

extension SelectInteractor:SelectInteractorInput {
    
    func actionRequestInitial() {
        
        var sections:Int = 0
        dataService?.requireSections(&sections)
        if sections == 0 {
            requestResponseObjectService?.request(RequestApi.CorporateNews)
            requestResponseObjectService?.request(RequestApi.TechnicalNews)
        }
    }
    
    func addCustomNews(Url url: String) {
        requestResponseObjectService?.request(RequestApi.CustomNews(url: url))
    }
    
    func requireObject(inout object:ChannelModel, ForIndexPath indexPath:NSIndexPath) {
        
        dataService?.requireObject(&object, ForIndexPath:indexPath)
    }
    
    func requireRows(inout rows:Int, ForSection section:Int) {
        
        dataService?.requireRows(&rows, ForSection:section)
    }
    
    func requireSections(inout sections:Int) {
        
        dataService?.requireSections(&sections)
    }
    
    func selectChannel(AtIndexPath indexPath:NSIndexPath) {
        var object:ChannelModel = ChannelModel()
        self.requireObject(&object, ForIndexPath: indexPath)
        
        let controller = UIAlertController(
            title:"Внимание",
            message:"Выберите тип контроллера",
            preferredStyle:.Alert)
        let extendedAction = UIAlertAction(title: "Table", style: .Default) { [weak self] (action) in
            self?.output?.openDetail(WithChannel: object, AndExtended: true)
        }
        let normalAction = UIAlertAction(title: "Collection", style: .Default) { [weak self] (action) in
            self?.output?.openDetail(WithChannel: object, AndExtended: false)
        }

        let actionCancel = UIAlertAction(title:"Отмена", style:.Cancel, handler: nil)
        controller.addAction(normalAction)
        controller.addAction(extendedAction)
        controller.addAction(actionCancel)
        self.output?.showAlert(WithAlertController: controller, Animated: true) {
            
        }

    }
    func actionAddChannel() {
        let controller = UIAlertController(
            title:"Добавить RSS канал",
            message:"Введите адрес желаемого RSS канала",
            preferredStyle:.Alert)
        controller.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Адрес RSS канала"
            let channels = [
                "http://www.aif.ru/rss/politics.php",
                "https://lenta.ru/rss"]
            textField.text = channels[Int(arc4random_uniform(UInt32(channels.count)))]
        }
        weak var controllerWeak:UIAlertController? = controller
        let actionAdd = UIAlertAction(title:"Добавить", style:.Default) { [weak self] (action) in
            guard let textFields = controllerWeak?.textFields else { return }
            guard textFields.count > 0 else { return }
            let textField = textFields[0]
            guard let channelUrl = textField.text else { return }
            self?.addCustomNews(Url: channelUrl)
        }
        let actionCancel = UIAlertAction(title:"Отмена", style:.Cancel, handler:nil)
        controller.addAction(actionAdd)
        controller.addAction(actionCancel)
        self.output?.showAlert(WithAlertController: controller, Animated: true) {
            
        }
    }
}





extension SelectInteractor:DataServiceOutput {
    
    func actionDataUpdated(updates:DataUpdates?) {
        
        output?.actionDataUpdated(updates)
    }
}


extension SelectInteractor:RequestServiceOutput {
    
    func receive<T>(Objects objects:[T]) {
        dataService?.writeObjectsAsync(objects)
    }
    
    func error(Error error:NSError) {
        debugPrint(error)
    }
}
