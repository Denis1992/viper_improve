//
//  RequestService.swift
//  improve
//
//  Created by Denis Bezrukov on 20.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SWXMLHash


protocol RequestServiceInput {
    func request(target:RequestApi)
}

protocol RequestServiceOutput: class {
    func receive<T>(Objects objects:[T])
    func error(Error error: NSError)
}

class RequestService<T> {
    weak var output:RequestServiceOutput?
    var functionConvertFromData: ((data:NSData, target:RequestApi) throws -> T)?
}

extension RequestService:RequestServiceInput {
    func request(target:RequestApi) {
        self.requestSignal(target).on(
            failed: { (error) in
                debugPrint(error)
            },
            next: { [weak self] responseObject in
                self?.output?.receive(Objects: [responseObject])
        }).start()
    }
}

private extension RequestService {
    func requestSignal(target:RequestApi) -> SignalProducer<T, NSError> {
        return SignalProducer<T, NSError> { [unowned self] sink, disposable in
            RequestManager.request(
                Target:target,
                Success:{ data in
                    guard let mapper = self.functionConvertFromData else {
                        sink.sendFailed(NSError.init(domain: "RequestService", code: 0, userInfo: [:]))
                        return
                    }
                    do {
                        let responseObject = try mapper(data: data, target: target)
                        sink.sendNext(responseObject)
                        sink.sendCompleted()

                    } catch let error as NSError {
                        sink.sendFailed(error)
                    }
                },
                Failure:{ error in
                    sink.sendFailed(error)
                }
            )
        }
    }
}

extension RequestService {
    func convertFromXML (data: NSData, target:RequestApi) throws -> ResponseObject {
        let channelURL = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
        let xml = SWXMLHash.parse(data)
        guard xml["rss"].all.count == 1 else {
            throw NSError(domain:"improve", code:0, userInfo:[NSLocalizedDescriptionKey:"Не содержит файла RSS"])
        }
        let channel = xml["rss"]["channel"]
        guard channel.all.count == 1 else {
            throw NSError(domain:"improve", code:0, userInfo:[NSLocalizedDescriptionKey:"RSS каналы отсутствуют, либо представлено более одного RSS канала"])
        }
        guard let channelObject = channel.channelObject(channelURL) else {
            throw NSError(domain:"improve", code:0, userInfo:[NSLocalizedDescriptionKey:"RSS канал не содержит необходимые данные"])
        }
        return (channelObject, channel.itemObjects(ChannelURL:channelURL))
    }
}


// MARK: - XMLIndexer -

extension XMLIndexer {
    
    func channelObject(channelURL:String) -> ChannelModel? {
        
        guard let link = value("link") else { return nil }
        return ChannelModel(
            ChannelURL:channelURL,
            Info:value("description"),
            Link:link,
            Title:value("title"))
    }
    
    func itemObjects(ChannelURL channelURL:String) -> [ItemModel] {
        
        var items:[ItemModel] = []
        for x in 0..<self["item"].all.count {
            items += [self["item"][x].itemObject(ChannelURL:channelURL)]
        }
        return items
    }
    
    func itemObject(ChannelURL channelURL:String) -> ItemModel {
        
        return ItemModel(
            ChannelURL:channelURL,
            Date:value("pubDate")?.date,
            Info:value("description"),
            Link:value("link"),
            Title:value("title"))
    }
    
    func value(key:String) -> String? {
        
        return self[key].element?.text
    }
}

// MARK: - String -

extension String {
    
    var date:NSDate? {
        get {
            do {
                let detector = try NSDataDetector(types:NSTextCheckingType.Date.rawValue)
                let matches = detector.matchesInString(self, options:[], range:NSMakeRange(0, characters.count))
                return matches.count > 0 ? matches[0].date : nil
            } catch {
                return nil
            }
        }
    }
}
