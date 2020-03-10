//
//  SQLinkedList.swift
//  SQCache
//
//  Created by Jeppt petter on 2020/3/10.
//  Copyright © 2020 Jeppt petter. All rights reserved.
//

import Foundation

// 双链表类
final class DoublyLinkedList<KeyType:Hashable, ValueType> {
    
    // 节点类
    final class Node {
        
        var value: (key: KeyType, obj: ValueType)
        
        var prev: Node?
        var next: Node?
        
        var cost: UInt = 0
        var time: TimeInterval?
        
        init(key: KeyType, value: ValueType) {
            self.value = (key,value)
        }
    }
    
    var totalCost: UInt = 0
    var totalCount: UInt = 0
    
    private var head: Node?
    private(set) var tail: Node?
    
    // MARK: 操作
    // 添加一个新节点
    func add(node: Node) {
        
        totalCost += node.cost
        totalCount += 1
        
        if let head = head {
            node.next = head
            self.head?.prev = node
            self.head = node
        } else {
            head = node
            tail = node
        }

    }
    
    // 移除已存在node
    func remove(node:Node) {
        
        totalCost -= node.cost
        totalCount -= 1
        
        if let nodeNext = node.next {
            nodeNext.prev = node.prev
        }
        
        if let nodePrev = node.prev {
            nodePrev.next = node.next
        }
        
        if node === head {
            head = node.next
        }
        
        if node === tail {
            tail = node.prev
        }
        
    }
    
    // 存在的node移动到头部
    func moveToHead(_ node: Node) {
        
        if node === head { return }
        
        if node === tail {
            self.tail = node.prev
            self.tail?.next = nil
        } else {
            node.next?.prev = node.prev
            node.prev?.next = node.next
        }
        
        node.next = head
        node.prev = nil
        self.head?.prev = node
        self.head = node
        
    }
    
    // 移除尾部
    func removeTail() -> Node? {
        guard let tail = self.tail else { return nil }

        totalCost -= tail.cost
        totalCount -= 1
        
        if tail === head {
            self.head = nil
            self.tail = nil
        } else {
            self.tail = tail.prev
            self.tail?.next = nil
        }
        return tail
        
    }
    
    // 移除所有
    func removeAll() {
        
        totalCost = 0
        totalCount = 0
        head = nil
        tail = nil
        
    }
    
    
}
