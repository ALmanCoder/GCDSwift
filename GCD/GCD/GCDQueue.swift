//
//  GCDQueue.swift
//  GCD
//
//  Created by GuangHuiWu on 11/6/15.
//  Copyright © 2015 ALman. All rights reserved.
//

import UIKit


class GCDQueue: NSObject {
    
    static var mainQueue:GCDQueue?
    static var globalQueue:GCDQueue?
    static var highPriorityGlobalQueue:GCDQueue?
    static var lowPriorityGlobalQueue:GCDQueue?
    static var backGroundPriorityQueue:GCDQueue?
    
    
    var dispatchQueue:dispatch_queue_t?
    
    // 构造方法
    override init() {
        
        // UnsafePointer<Int8> -> "".cStringUsingEncoding(NSUTF8StringEncoding)
        super.init()
        self.dispatchQueue = dispatch_queue_create("".cStringUsingEncoding(NSUTF8StringEncoding), DISPATCH_QUEUE_SERIAL)
        
    }
    
    // 便利构造方法
    convenience init(serival:CBool){
        self.init()
        if serival {
            self.dispatchQueue = dispatch_queue_create("".cStringUsingEncoding(NSUTF8StringEncoding), DISPATCH_QUEUE_SERIAL)
        }
    }
    
    convenience init(concurrent:CBool){
        self.init()
        if concurrent {
            self.dispatchQueue = dispatch_queue_create("".cStringUsingEncoding(NSUTF8StringEncoding), DISPATCH_QUEUE_CONCURRENT)
        }
    }

    
    convenience init(serival:CBool ,label:String){
        self.init()
        if serival {
            self.dispatchQueue = dispatch_queue_create(label.cStringUsingEncoding(NSUTF8StringEncoding)!, DISPATCH_QUEUE_SERIAL)
        }
    }

    convenience init(concurrent:CBool ,label:String){
        self.init()
        if concurrent {
            self.dispatchQueue = dispatch_queue_create(label.cStringUsingEncoding(NSUTF8StringEncoding)!, DISPATCH_QUEUE_CONCURRENT)
        }
    }

    
    // 
    func execute(block:dispatch_block_t){
        dispatch_async(self.dispatchQueue!, block)
    }
    
    func execute(afterDelay delta:Int64 ,block:dispatch_block_t){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), self.dispatchQueue!, block)
    }
    
    func execute(afterDelaySecs delta:NSTimeInterval ,block:dispatch_block_t){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * delta)), self.dispatchQueue!, block)
    }
    
    func waitExecute(block:dispatch_block_t){
        dispatch_sync(self.dispatchQueue!, block)
    }
    
    func barrierExecute(block:dispatch_block_t){
        dispatch_barrier_async(self.dispatchQueue!, block)
    }
    
    func waitBarrierExecute(block:dispatch_block_t){
        dispatch_barrier_sync(self.dispatchQueue!, block)
    }
    
    
    // 
    func suspend(){
        dispatch_suspend(self.dispatchQueue!)
    }
    
    func resume(){
        dispatch_resume(self.dispatchQueue!)
    }
    
    func execute(inGroup group:GCDGroup ,block:dispatch_block_t){
        dispatch_group_async(group.dispatchGroup, self.dispatchQueue!, block)
    }
    
    func notify(inGroup group:GCDGroup ,block:dispatch_block_t){
        dispatch_group_notify(group.dispatchGroup, self.dispatchQueue!, block)
    }
    
    
    // 类方法
    override class func initialize() {
        
        super.initialize()
        
//        print("initialize")
        self.mainQueue = GCDQueue()
        self.mainQueue!.dispatchQueue = dispatch_get_main_queue()
        
        self.globalQueue = GCDQueue()
        self.globalQueue!.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        self.highPriorityGlobalQueue = GCDQueue()
        self.highPriorityGlobalQueue!.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        
        self.lowPriorityGlobalQueue = GCDQueue()
        self.lowPriorityGlobalQueue!.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        self.backGroundPriorityQueue = GCDQueue()
        self.backGroundPriorityQueue!.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        
    }

    
    class func main_Queue() ->GCDQueue {
        
        print("main_Queue")
        return self.mainQueue!
    }
    
    class func global_Queue() ->GCDQueue {
        return self.globalQueue!
    }
    
    class func highPriorityGlobal_Queue() ->GCDQueue {
        return self.highPriorityGlobalQueue!
    }
    
    class func lowPriorityGlobal_Queue() ->GCDQueue {
        return self.lowPriorityGlobalQueue!
    }
    
    class func backGroundPriority_Queue() ->GCDQueue {
        return self.backGroundPriorityQueue!
    }
    

    
    class func executeInMainQueue(afterDelaySecs sec:NSTimeInterval ,block:dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * sec)), (self.mainQueue!.dispatchQueue)!, block)
    }
 
    class func executeInGlobalQueue(afterDelaySecs sec:NSTimeInterval ,block:dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * sec)), (self.globalQueue?.dispatchQueue)!, block)
    }
    
    class func executeInHighPriorityGlobalQueue(afterDelaySecs sec:NSTimeInterval ,block:dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * sec)), (self.highPriorityGlobalQueue?.dispatchQueue)!, block)
    }
    
    class func executeInLowPriorityGlobalQueue(afterDelaySecs sec:NSTimeInterval ,block:dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * sec)), (self.lowPriorityGlobalQueue?.dispatchQueue)!, block)
    }
    
    class func executeInBackGroundGlobalQueue(afterDelaySecs sec:NSTimeInterval ,block:dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * sec)), (self.backGroundPriorityQueue?.dispatchQueue)!, block)
    }
    
    class func executeInMainQueue(block:dispatch_block_t) {
        dispatch_async((self.mainQueue?.dispatchQueue)!, block)
    }
    
    class func executeInGlobalQueue(block:dispatch_block_t) {
        dispatch_async((self.globalQueue?.dispatchQueue)!, block)
    }
    
    class func executeInHighGlobalQueue(block:dispatch_block_t) {
        dispatch_async((self.highPriorityGlobalQueue?.dispatchQueue)!, block)
    }
    
    class func executeInLowGlobalQueue(block:dispatch_block_t) {
        dispatch_async((self.lowPriorityGlobalQueue?.dispatchQueue)!, block)
    }
    
    class func executeInBackGroundGlobalQueue(block:dispatch_block_t) {
        dispatch_async((self.backGroundPriorityQueue?.dispatchQueue)!, block)
    }
    
}

