//
//  DatabaseManager.swift
//  improve
//
//  Created by Denis Bezrukov on 12.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

// MARK: - Initialization -

class DatabaseManager {

    private static let calendar = NSCalendar.currentCalendar()
    private static let instance = DatabaseManager.init()
    
    static let collectionTitleChannels      = "Channels"
    static let extensionTitleChannels       = "Channels"
    static let extensionTitleItems          = "Items"
    static let extensionTitleItemsExtended  = "ItemsExtended"
    static let groupTitleChannelDefault     = "ChannelsDefault"
    static let groupTitleChannelManual      = "ChannelsManual"
    
    private let database:YapDatabase = {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let directory = paths.count > 0 ? paths[0] as String : NSTemporaryDirectory() as String
        let url = NSURL.init(string: directory)?.URLByAppendingPathComponent("db.sqlite")
        return YapDatabase.init(path:url!.path!)
    }()
    private var databaseConnectionRead:YapDatabaseConnection!
    private var databaseConnectionWrite:YapDatabaseConnection!
}

extension DatabaseManager {
    
    class func prepare() {
        
        DatabaseManager.instance.databaseConnectionRead  = connection
        DatabaseManager.instance.databaseConnectionWrite = connection
        DatabaseManager.instance.database.registerExtension(
            DatabaseManager.extensionChannels(),
            withName:DatabaseManager.extensionTitleChannels)
        DatabaseManager.instance.database.registerExtension(
            DatabaseManager.extensionItems(),
            withName:DatabaseManager.extensionTitleItems)
        DatabaseManager.instance.database.registerExtension(
            DatabaseManager.extensionItemsExtended(),
            withName:DatabaseManager.extensionTitleItemsExtended)
    }
}

// MARK: - Public Methods -

extension DatabaseManager {
    
    class var connection:YapDatabaseConnection {
        get {
            let connection = DatabaseManager.instance.database.newConnection()
            connection.metadataCacheEnabled = false
            connection.objectCacheEnabled = true
            connection.objectCacheLimit = 0
            return connection
        }
    }
    
    class func requestWriteAsync(ResponseObjects objects:[ResponseObject], @autoclosure(escaping) Completion completionBlock:() -> Void) {
        
        DatabaseManager.instance.databaseConnectionWrite.asyncReadWriteWithBlock({ (transaction) in
            for object in objects {
                transaction.setObject(object.channel, forKey:object.channel.key, inCollection:DatabaseManager.collectionTitleChannels)
                transaction.removeAllObjectsInCollection(object.channel.key)
                for item in object.items {
                    transaction.setObject(item, forKey:item.key, inCollection:object.channel.key)
                }
            }
        }) { completionBlock() }
    }
}

extension DatabaseManager {
    
    private class func extensionChannels() -> YapDatabaseView {
        
        let grouping:YapDatabaseViewGrouping = YapDatabaseViewGrouping.withKeyBlock { (transaction, collection, key) -> String? in
            guard collection == collectionTitleChannels else { return nil }
            if (key as NSString).rangeOfString("kaspersky", options:.CaseInsensitiveSearch).location != NSNotFound {
                return groupTitleChannelDefault
            } else {
                return groupTitleChannelManual
            }
        }
        let sorting:YapDatabaseViewSorting = YapDatabaseViewSorting.withObjectBlock { (transaction, group, collection1, key1, object1, collection2, key2, object2) -> NSComparisonResult in
            guard let channel1 = object1 as? ChannelModel else { return .OrderedSame }
            guard let channel2 = object2 as? ChannelModel else { return .OrderedSame }
            guard let date1 = channel1.date else { return .OrderedSame }
            guard let date2 = channel2.date else { return .OrderedSame }
            return date2.compare(date1)
        }
        let options:YapDatabaseViewOptions = YapDatabaseViewOptions.init()
        options.isPersistent = true
        return YapDatabaseView.init(grouping:grouping, sorting:sorting, versionTag:"1", options:options)
    }
    
    private class func extensionItems() -> YapDatabaseView {
        
        let grouping:YapDatabaseViewGrouping = YapDatabaseViewGrouping.withKeyBlock { (transaction, collection, key) -> String? in
            if collection == collectionTitleChannels { return nil }
            return collection
        }
        let sorting:YapDatabaseViewSorting = YapDatabaseViewSorting.withObjectBlock { (transaction, group, collection1, key1, object1, collection2, key2, object2) -> NSComparisonResult in
            guard let item1 = object1 as? ItemModel else { return .OrderedSame }
            guard let item2 = object2 as? ItemModel else { return .OrderedSame }
            guard let date1 = item1.date else { return .OrderedSame }
            guard let date2 = item2.date else { return .OrderedSame }
            return date2.compare(date1)
        }
        let options:YapDatabaseViewOptions = YapDatabaseViewOptions.init()
        options.isPersistent = true
        return YapDatabaseView.init(grouping:grouping, sorting:sorting, versionTag:"1", options:options)
    }
    
    private class func extensionItemsExtended() -> YapDatabaseExtension {
        
        let grouping:YapDatabaseViewGrouping = YapDatabaseViewGrouping.withObjectBlock { (transaction, collection, key, object) -> String? in
            if collection == collectionTitleChannels { return nil }
            guard let item = object as? ItemModel else { return nil }
            guard let date = item.date else { return nil }
            let components = DatabaseManager.calendar.components(
                [NSCalendarUnit.Month, NSCalendarUnit.Year],
                fromDate:date)
            let month = components.month < 10 ? "0\(components.month)" : "\(components.month)"
            return collection + "+\(components.year)\(month)"
        }
        let sorting:YapDatabaseViewSorting = YapDatabaseViewSorting.withObjectBlock { (transaction, group, collection1, key1, object1, collection2, key2, object2) -> NSComparisonResult in
            guard let item1 = object1 as? ItemModel else { return .OrderedSame }
            guard let item2 = object2 as? ItemModel else { return .OrderedSame }
            guard let date1 = item1.date else { return .OrderedSame }
            guard let date2 = item2.date else { return .OrderedSame }
            return date2.compare(date1)
        }
        let options:YapDatabaseViewOptions = YapDatabaseViewOptions.init()
        options.isPersistent = true
        return YapDatabaseView.init(grouping:grouping, sorting:sorting, versionTag:"1", options:options)
    }
}
