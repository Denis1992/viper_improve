//
//  DataService.swift
//  improve
//
//  Created by Denis Bezrukov on 19.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import YapDatabase

private typealias DataChanges   = (sections:[YapDatabaseViewSectionChange], rows:[YapDatabaseViewRowChange])
typealias DataUpdates           = (sections:DataUpdatesSections, rows:DataUpdatesRows)
typealias DataUpdatesRows       = (delete:[NSIndexPath], insert:[NSIndexPath], reload:[NSIndexPath])
typealias DataUpdatesSections   = (delete:[NSIndexSet], insert:[NSIndexSet])

protocol DataServiceOutput:class {
    
    func actionDataUpdated(updates:DataUpdates?)
}

protocol DataServiceInput:class {

    func requireObject<T>(inout object:T, ForIndexPath indxexPath:NSIndexPath)
    func requireRows(inout rows:Int, ForSection section:Int)
    func requireSections(inout sections:Int)
    func requireGroup(inout group:String, ForSection section:Int)
    func writeObjectsAsync<T>(objects:[T])
}


class DataService {
    
    weak var output:DataServiceOutput?
    
    private let databaseConnectionLongLive:YapDatabaseConnection    = DatabaseManager.connection
    private let databaseConnectionWrite:YapDatabaseConnection       = DatabaseManager.connection
    private let databaseMappings:YapDatabaseViewMappings
    
    init (Mappings mappings:YapDatabaseViewMappings) {

        databaseMappings = mappings
        databaseConnectionLongLive.permittedTransactions = [.YDB_SyncReadTransaction, .YDB_MainThreadOnly]
        databaseConnectionLongLive.beginLongLivedReadTransaction()
        databaseConnectionLongLive.objectCacheLimit = mappings.numberOfItemsInAllGroups()
        databaseConnectionLongLive.readWithBlock { [weak self] (transaction) in
            self?.databaseMappings.updateWithTransaction(transaction)
        }
//        dispatch_sync(dispatch_get_main_queue()) { [weak databaseMappings, weak databaseConnectionLongLive] in
//            databaseConnectionLongLive?.readWithBlock { (transaction) in
//                databaseMappings?.updateWithTransaction(transaction)
//            }
//        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(notification), name:YapDatabaseModifiedNotification, object: nil)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:YapDatabaseModifiedNotification, object:nil)
    }
}

private extension DataService {
    
    @objc func notification() {
        
        let notifications:[NSNotification] = databaseConnectionLongLive.beginLongLivedReadTransaction()
        guard let ext = databaseConnectionLongLive.ext(databaseMappings.view) as? YapDatabaseViewConnection else { return }
        var sectionChanges:NSArray?, rowChanges:NSArray?
        ext.getSectionChanges(&sectionChanges, rowChanges:&rowChanges, forNotifications:notifications, withMappings:databaseMappings)
        let changes:DataChanges = (((sectionChanges as? [YapDatabaseViewSectionChange]) ?? []), (rowChanges as? [YapDatabaseViewRowChange]) ?? [])
        guard changes.rows.count > 0 || changes.sections.count > 0 else { return }
        output?.actionDataUpdated(updates(changes))
    }
    
    func updates(changes:DataChanges) -> DataUpdates {
        
        var rowsDelete:[NSIndexPath] = []
        var rowsInsert:[NSIndexPath] = []
        var rowsReload:[NSIndexPath] = []
        for change in changes.rows {
            switch change.type {
            case .Delete:   rowsDelete  += [change.indexPath]
            case .Insert:   rowsInsert  += [change.newIndexPath]
            case .Update:   rowsReload  += [change.indexPath]
            case .Move:     rowsDelete  += [change.indexPath]
                            rowsInsert  += [change.newIndexPath]
            }
        }
        var sectionsDelete:[NSIndexSet] = []
        var sectionsInsert:[NSIndexSet] = []
        for change in changes.sections {
            switch change.type {
            case .Delete:   sectionsDelete += [NSIndexSet.init(index:Int(change.index))]
            case .Insert:   sectionsInsert += [NSIndexSet.init(index:Int(change.index))]
            default:        break
            }
        }
        return ((sectionsDelete, sectionsInsert), (rowsDelete, rowsInsert, rowsReload))
    }
}

extension DataService:DataServiceInput {
    
    func requireObject<T>(inout object:T, ForIndexPath indexPath:NSIndexPath) {
        
        databaseConnectionLongLive.readWithBlock { [weak databaseMappings] (transaction) in
            guard let mappings = databaseMappings else { return }
            guard let ext = transaction.ext(mappings.view) as? YapDatabaseViewTransaction else { return }
            guard let validObject = ext.objectAtIndexPath(indexPath, withMappings:mappings) as? T else { return }
            object = validObject
        }
    }
    
    func requireRows(inout rows:Int, ForSection section:Int) {
        
        rows = Int(databaseMappings.numberOfItemsInSection(UInt(section)))
    }
    
    func requireSections(inout sections:Int) {
        
        sections = Int(databaseMappings.numberOfSections())
    }
    
    func requireGroup(inout group:String, ForSection section:Int) {
        
        group = databaseMappings.groupForSection(UInt(section))
    }
    
    func writeObjectsAsync<T>(objects: [T]) {
        
        if T.self == ResponseObject.self {
            DatabaseManager.requestWriteAsync(ResponseObjects: objects as Any as! [ResponseObject], Completion: {
                ///
            }())
        }
    }
}
