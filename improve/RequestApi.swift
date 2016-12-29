//
//  RequestApi.swift
//  improve
//
//  Created by Denis Bezrukov on 12.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Moya

// MARK: - Initialization -

enum RequestApi {
    
    case CorporateNews
    case TechnicalNews
    case CustomNews(url:String?)
}

// MARK: - TargetType -

extension RequestApi:TargetType {
    
    var baseURL:NSURL {
        switch self {
        case .CorporateNews, .TechnicalNews:
            return NSURL(string:"http://www.kaspersky.ru/rss")!
        case .CustomNews(let url):
            guard let url = url else { return NSURL() }
            return NSURL(string:url) ?? NSURL()
        }
    }
    
    var path:String {
        switch self {
        case .CorporateNews:    return "/corpnews/"
        case .TechnicalNews:    return "/technews/"
        default:                return ""
        }
    }
    
    var method: Moya.Method {
        return .GET
    }
    
    var parameters:[String: AnyObject]? {
        return nil
    }
    
    var multipartBody:[MultipartFormData]? {
        return nil
    }
    
    var sampleData:NSData {
        return "<rss version=\"2.0\"></rss>".UTF8EncodedData
    }
}

// MARK: - String -

private extension String {
    
    var UTF8EncodedData:NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
