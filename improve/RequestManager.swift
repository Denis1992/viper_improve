//
//  RequestManager.swift
//  improve
//
//  Created by Denis Bezrukov on 12.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Alamofire
import ReactiveCocoa
import Moya
import SWXMLHash

// MARK: - Initialization -

typealias ResponseObject = (channel:ChannelModel, items:[ItemModel])

class RequestManager {
    
    private static let provider = MoyaProvider(
        endpointClosure: { (target:RequestApi) -> Endpoint<RequestApi> in
            return Endpoint(
                URL:target.baseURL.URLByAppendingPathComponent(target.path).absoluteString,
                sampleResponseClosure:{.NetworkResponse(200, target.sampleData)},
                method:target.method,
                parameters:target.parameters,
                parameterEncoding:.URL,
                httpHeaderFields:nil)
        },
        requestClosure: { (endpoint:Endpoint<RequestApi>, requestResultClosure) in
            let request = endpoint.urlRequest
            requestResultClosure(.Success(request))
        },
        stubClosure: { (target) -> StubBehavior in
            return StubBehavior.Never
        },
        manager:Manager(configuration:NSURLSessionConfiguration.defaultSessionConfiguration()),
        plugins:[],
        trackInflights:false)
    
}
// MARK: - Public Methods -

//extension RequestManager {
//    
//    static func request(Target target:RequestApi) -> SignalProducer<Bool, NSError> {
//        
//        return SignalProducer<Bool, NSError> { sink, disposable in
//            signalRequest(Target:target)
//                .on(failed: { (error) in
//                    sink.sendFailed(error)
//                    }, next: { (object) in
//                        DatabaseManager.requestWriteAsync(
//                            ResponseObjects:[object],
//                            Completion:sink.sendCompleted())
//                }).start()
//        }
//    }
//
//    static func update() -> SignalProducer<Bool, NSError> {
//        
//        return SignalProducer<Bool, NSError> { sink, disposable in
//            signalRequest(Target:.CorporateNews)
//                .combineLatestWith(signalRequest(Target:.TechnicalNews))
//                .on(failed: { (error) in
//                    sink.sendFailed(error)
//                    }, next: { (object1, object2) in
//                        DatabaseManager.requestWriteAsync(
//                            ResponseObjects:[object1, object2],
//                            Completion:sink.sendCompleted())
//                }).start()
//        }
//    }
//}

extension RequestManager {
    
    static func request(Target target:RequestApi, Success successCallback:((NSData) -> Void)?, Failure failureCallback:((NSError) -> Void)?) {
        provider.request(target) { (result) in
            switch result {
            case let .Success(response):
                do {
                    try response.filterSuccessfulStatusCodes()
                    guard let callback = successCallback else { return }
                    callback(response.data)
                } catch let error as NSError {
                    guard let callback = failureCallback else { return }
                    callback(error)
                }
            case let .Failure(error):
                guard let callback = failureCallback else { return }
                if case .Underlying(let responseError) = error {
                    callback(responseError)
                }
            }
        }
    }
}

