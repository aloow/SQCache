//
//  SQMemoryCache.swift
//  SQCache
//
//  Created by Jeppt petter on 2020/3/10.
//  Copyright © 2020 Jeppt petter. All rights reserved.
//

import Foundation
import UIKit

final class SQMemoryCache<Key: Hashable, Value> {
    
    typealias Node = DoublyLinkedList<Key, Value>.Node
    
    var countLimit: UInt = UInt.max
    var costLimit: UInt = UInt.max
    var ageLimit: TimeInterval = Double.greatestFiniteMagnitude
    var autoTrimInterval: TimeInterval = 5.0
    
    private(set) var lock: pthread_mutex_t = pthread_mutex_t()
    let queue = DispatchQueue.global(qos: .background)
    
    // 字典
    private var dict = [Key: Node]()
    private var lru = DoublyLinkedList<Key, Value>()
    
    init() {

        pthread_mutex_init(&lock, nil)
//        queue = DispatchQueue.init(label: "com.aloow.cache.memory")

    }
    
    // MARK:
    func setObject(_ obj: Value, forKey key: Key,
                   withCost cost:UInt = 0) {
        
        pthread_mutex_lock(&lock)
        defer {
            pthread_mutex_unlock(&lock)
        }
        let now = CACurrentMediaTime()
        
        // 判断Key是否已经存储过
        if let node = dict[key] {
            lru.totalCost -= node.cost
            lru.totalCost += cost
            node.cost = cost
            node.time = now
            lru.moveToHead(node)
        } else {
            let node = Node(key: key, value: obj)
            node.cost = cost
            node.time = now
            lru.add(node: node)
            dict[key] = node
        }
        /// 判断Cost、Count是否超出限制
        if lru.totalCost > costLimit {
            queue.async {
                self.trimToCost(self.costLimit)
            }
        }
        
        if lru.totalCount > countLimit {
            
            if let node = lru.removeTail() {
                dict.removeValue(forKey: node.value.key)
                
//                if lru.releaseAsynchronously {
//                    let queue = lru.releaseOnMainThread ? DispatchQueue.main :
//                        DispatchQueue.global(qos: .background)
//                    queue.async {
//                        _ = node.cost
//                    }
//                } else if lru.releaseOnMainThread && (pthread_main_np() == 0) {
//                    DispatchQueue.main.async {
//                        _ = node.cost
//                    }
//                }
                
            }
            
        }
        
    }
    
    func object(forKey key: Key) -> Value? {
        pthread_mutex_lock(&lock)
        guard let node = dict[key] else {
            pthread_mutex_unlock(&lock)
            return nil
        }
        lru.moveToHead(node)
        pthread_mutex_unlock(&lock)
        return node.value.obj
    }
    
    func removeObject(forKey key: Key) {
        pthread_mutex_lock(&lock)
        if let node = dict.removeValue(forKey: key) {
            lru.remove(node: node)
        }
        pthread_mutex_unlock(&lock)
    }
    
    func removeAllObjects() {
        pthread_mutex_lock(&lock)
        dict.removeAll()
        lru.removeAll()
        pthread_mutex_unlock(&lock)
    }
    
    func containsObjectFor(Key key:Key) -> Bool {
        pthread_mutex_lock(&lock)
        let flag = (dict[key] != nil) ? true : false
        pthread_mutex_unlock(&lock)
        return flag
    }
    
    // MARK: 清理Cache
    func trim(ToCount count:UInt) {
        guard count != 0 else {
            removeAllObjects()
            return
        }
        trimToCount(count)
        
    }
    
    func trim(ToCost cost:UInt) {
        trimToCost(cost)
    }
    
    func trim(Toage age:TimeInterval) {
        trimToage(age)
    }
    
    // MARK: private methods
    private func trimToCost(_ costLimit:UInt) {
        
        var finish = false
        pthread_mutex_lock(&lock)
        if costLimit == 0 {
            lru.removeAll()
            dict.removeAll()
            finish = true
        } else if lru.totalCost <= costLimit{
            finish = true
        }
        pthread_mutex_unlock(&lock)
        guard !finish else { return }
        
        var holder = Array<AnyObject?>()
        while !finish {
            if pthread_mutex_trylock(&lock) == 0 {
                if lru.totalCost > costLimit {
                    let node = lru.removeTail()
                    dict.removeValue(forKey: node!.value.key)
                    if node != nil { holder.append(node) }
                } else {
                    finish = true
                }
                pthread_mutex_unlock(&lock)
            } else {
                usleep(10 * 1000) //10 ms
            }
        }
        
//        if !holder.isEmpty {
//            let queue = lru.releaseOnMainThread ? DispatchQueue.main :
//                DispatchQueue.global(qos: .background)
//            queue.async {
//                _ = holder.count // release in queue
//            }
//        }
        
    }
    
    private func trimToCount(_ countLimit:UInt) {
        
        var finish = false
        pthread_mutex_lock(&lock)
        if countLimit == 0 {
            lru.removeAll()
            dict.removeAll()
            finish = true
        } else if lru.totalCount <= countLimit{
            finish = true
        }
        pthread_mutex_unlock(&lock)
        if finish { return }
        
        var holder = Array<AnyObject?>()
        while !finish {
            if pthread_mutex_trylock(&lock) == 0 {
                if lru.totalCount > countLimit {
                    let node = lru.removeTail()
                    dict.removeValue(forKey: node!.value.key)
                    if node != nil { holder.append(node) }
                } else {
                    finish = true
                }
                pthread_mutex_unlock(&lock)
            } else {
                usleep(10 * 1000) //10 ms
            }
        }
        
//        if !holder.isEmpty {
//            let queue = lru.releaseOnMainThread ? DispatchQueue.main :
//                DispatchQueue.global(qos: .background)
//            queue.async {
//                _ = holder.count // release in queue
//            }
//        }
        
    }
    
    private func trimToage(_ ageLimit:TimeInterval) {
        
        var finish = false
        let now = CACurrentMediaTime()
        
        pthread_mutex_lock(&lock)
        
        if ageLimit <= 0 {
            lru.removeAll()
            finish = true
        } else if let tail = lru.tail,
            (now - tail.time!) <= ageLimit {
            finish = true
        }
        pthread_mutex_unlock(&lock)
        if finish { return }
        
        var holder = Array<AnyObject?>()
        while !finish {
            if pthread_mutex_trylock(&lock) == 0 {
                if let tail = lru.tail,
                (now - tail.time!) > ageLimit {
                    let node = lru.removeTail()
                    dict.removeValue(forKey: node!.value.key)
                    if node != nil { holder.append(node) }
                } else {
                    finish = true
                }
                pthread_mutex_unlock(&lock)
            } else {
                usleep(10 * 1000) //10 ms
            }
        }
        
//        guard holder.isEmpty else { return }
//        let queue = lru.releaseOnMainThread ? DispatchQueue.main :
//            DispatchQueue.global(qos: .background)
//        queue.async {
//            _ = holder.count // release in queue
//        }
        
    }
    
    // MARK: Access Methods
    // 优化的地方：写、读操作都是串行，考虑只有读用并行，写存在串行
    func totalCount() -> UInt {
        pthread_mutex_lock(&lock)
        let totalCount = lru.totalCount
        pthread_mutex_unlock(&lock)
        return totalCount
    }
    
    func totalCost() -> UInt {
        pthread_mutex_lock(&lock)
        let totalCost = lru.totalCost
        pthread_mutex_unlock(&lock)
        return totalCost
    }
    
}

