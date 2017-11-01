//
//  OwnedMosaic.swift
//  MosaicReader
//
//  Created by Kazuya Okada on 2017/11/01.
//  Copyright © 2017年 appirits. All rights reserved.
//

import Foundation

struct OwnedMosaicData: Codable {
    var data: [OwnedMosaic]!
}

struct OwnedMosaic: Codable {
    var mosaicId: MosaicInfo
    var quantity: Int
}

struct MosaicInfo: Codable {
    var namespaceId: String
    var name: String
    
    func displayMosaicInfo() -> String {
        return namespaceId + ":" + name
    }
}
