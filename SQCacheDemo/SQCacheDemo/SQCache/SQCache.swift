//
//  SQCache.swift
//  SQCache
//
//  Created by Jeppt petter on 2020/3/7.
//  Copyright © 2020 Jeppt petter. All rights reserved.
//

import Foundation

class SQCache {
    //
    private(set) var name: String?
    
    let memoryCache = SQMemoryCache<String, Any>()
    
    
    // MARK: Init
    private init() {}
    
    init?(path: String) {

        if path.isEmpty { return nil }
        // 创建SQDiskCache实例 失败nil
        let name = (path as NSString).lastPathComponent
        // 创建SQMemoryCache实例 失败nil
        
        self.name = name
    }
    
    convenience init?(name: String) {
        if name.isEmpty { return nil }
        let cacheFolder = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                              .userDomainMask,
                                                              true).first!
        let path = (cacheFolder as NSString).appendingPathComponent(name)
        self.init(path: path)
    }
    
    // MARK: Access Methods
    func object(forKey key: String) -> Any? {
        return memoryCache.object(forKey: key)
    }
    
    func setObject(_ obj:Any ,forKey key: String ,with cost: UInt = 0) {
        memoryCache.setObject(obj, forKey: key, withCost: cost)
    }
    
    func containsObject(for key: String) -> Bool {
        return memoryCache.containsObjectFor(Key: key)
    }
    
    func removeObject(forKey key: String) {
        memoryCache.removeObject(forKey: key)
    }
    
    func removeAllObjects() {
        memoryCache.removeAllObjects()
    }
    
    
}

//extension SQCache: CustomStringConvertible {
//
//    var description: String {
//
//
//    }
//
//}
