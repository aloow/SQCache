//
//  SQCacheDemoTests.swift
//  SQCacheDemoTests
//
//  Created by Jeppt petter on 2020/3/10.
//  Copyright © 2020 Jeppt petter. All rights reserved.
//

import XCTest
@testable import SQCacheDemo

class SQCacheTests: XCTestCase {

    var sqCache: SQCache? = SQCache(name: "test")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sqCache = nil
        super.tearDown()
        
    }
    // 1. setobject removeobject removeall
    func testSetRemoveObject() {
        // 1.given

        // MARK: set object
        // when
        for i in 1...100 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        // then
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 100,"正确")

        // when
        for i in 101...120 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        // then
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 120,"正确")

        // MARK: remove object
        for i in 81...120 {
            sqCache?.removeObject(forKey: "\(i)")
        }

        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 80,"正确")

        for i in 41...80 {
            sqCache?.removeObject(forKey: "\(i)")
        }
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 40,"正确")

        sqCache?.removeAllObjects()
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 0,"正确")
        for i in 1...100 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        
        // MARK: containobject
        XCTAssertEqual(sqCache?.containsObject(for: "\(39)"), true,"正确")
        XCTAssertEqual(sqCache?.containsObject(for: "\(25)"), true,"正确")
        XCTAssertEqual(sqCache?.containsObject(for: "\(125)"), false,"正确")
        XCTAssertEqual(sqCache?.containsObject(for: "\(165)"), false,"正确")

        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 100,"正确")

        // MARK: 添加相同key
        for i in 11...20 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        XCTAssertNil(sqCache?.object(forKey: "\(2522)"), "不为nil")
        XCTAssertNotNil(sqCache?.object(forKey: "\(11)"))
        
        // MARK: remove all
        sqCache?.removeAllObjects()
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 0,"正确")

    }
    //
    func testRemove() {
        
        for i in 1...100 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        // then
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 100,"正确")
        for i in 1...100 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        // then
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 100,"正确")
        
        for i in 1...100 {
            sqCache?.removeObject(forKey: "\(i)")
        }
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 0,"正确")
        
    }
    
    // 3. 缓存控制方法: 总数量
    func testCount() {
        // give
        sqCache?.memoryCache.countLimit = 80
        for i in 1...80 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        // then
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 80,"正确")
        
        for i in 81...122 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 80,"正确")
        
        sqCache?.memoryCache.countLimit = UInt.max
        for i in 201...220 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 100,"正确")
        
        // end
        sqCache?.removeAllObjects()
        XCTAssertEqual(sqCache?.memoryCache.totalCount(), 0,"正确")
        
        for i in 1...80 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        sqCache?.memoryCache.trim(ToCount: 30)
        
    }

    // 4. 缓存控制方法: 总大小
    func testCost() {
        // give
        sqCache?.memoryCache.costLimit = 100
        // when
        for i in 1...30 {
            sqCache?.setObject("\(i)", forKey: "\(i)", with: 5)
        }
        sqCache?.setObject("100", forKey: "100", with: 5)
        // then
        sleep(1)
        XCTAssertEqual(sqCache?.memoryCache.totalCost(), 100,"正确")

        // when
        for i in 21...30 {
            sqCache?.removeObject(forKey: "\(i)")
        }

        
        // then
        sleep(1)
        XCTAssertEqual(sqCache?.memoryCache.totalCost(), 50,"正确")

        sqCache?.removeAllObjects()
        // then
        sleep(1)
        XCTAssertEqual(sqCache?.memoryCache.totalCost(), 0,"正确")

        for i in 1...30 {
            sqCache?.setObject("\(i)", forKey: "\(i)", with: 5)
        }
        sqCache?.memoryCache.trim(ToCost: 30)
        
    }
    
    //  5. 缓存控制方法: 时间
    func testAge() {
        
        // give
        sqCache?.memoryCache.ageLimit = 5
        // when
        for i in 1...30 {
            sqCache?.setObject("\(i)", forKey: "\(i)")
        }
        sleep(6)
        sqCache?.memoryCache.trim(Toage: 5)
        
        
    }
    
}
