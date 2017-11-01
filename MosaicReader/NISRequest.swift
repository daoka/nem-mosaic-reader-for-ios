//
//  NISRequest.swift
//  MosaicReader
//
//  Created by Kazuya Okada on 2017/11/01.
//  Copyright © 2017年 appirits. All rights reserved.
//

import Foundation
import APIKit

final class DecoadableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }
    
    func parse(data: Data) throws -> Any {
        return data
    }
}

protocol NISRequest: Request {
    
}

extension NISRequest {
    var baseURL: URL {
        return URL(string: "http://alice3.nem.ninja:7890")!
    }
}

extension NISRequest where Response: Decodable {
    var dataParser: DataParser {
        return DecoadableDataParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data  = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

final class  NISAPI {
    private init() {}
    
    struct OwnedMosaic: NISRequest {
        typealias Response = OwnedMosaicData
        
        let method: HTTPMethod = .get
        let path: String = "/account/mosaic/owned"
        var parameters: Any? {
            return ["address": address]
        }
        let address: String
    }
}
