//
//  GCDSemphore.swift
//  GCD
//
//  Created by GuangHuiWu on 11/6/15.
//  Copyright © 2015 ALman. All rights reserved.
//

import UIKit

class GCDSemphore: NSObject {

    let dispatchSemaphore:dispatch_semaphore_t?

    override init(){
        self.dispatchSemaphore = dispatch_semaphore_create(0)
    }
    
    init(value:Int){
        self.dispatchSemaphore = dispatch_semaphore_create(value)
    }
    
    func signal() ->CBool{
       return dispatch_semaphore_signal(self.dispatchSemaphore!) != 0
    }
    
    func wait(){
        dispatch_semaphore_wait(self.dispatchSemaphore!, DISPATCH_TIME_FOREVER)
    }
    
    func wait(delta:Int64){
        dispatch_semaphore_wait(self.dispatchSemaphore!, dispatch_time(DISPATCH_TIME_NOW, delta))
    }
}
