//
//  GCDTimer.swift
//  GCD
//
//  Created by GuangHuiWu on 11/6/15.
//  Copyright © 2015 ALman. All rights reserved.
//

import UIKit

class GCDTimer: AnyObject {
    
    var dispatch_Source : dispatch_source_t?
    
    
    init(dispatch_Source:dispatch_source_t) {
        
        self.dispatch_Source = dispatch_Source
    }
    
    func event(timeInterval interval:UInt64 ,block:dispatch_block_t){
        dispatch_source_set_timer(self.dispatch_Source!, dispatch_time(DISPATCH_TIME_NOW, 0), NSEC_PER_SEC, 0)
        dispatch_source_set_event_handler(self.dispatch_Source!,block)
    }
    
    func event(timeIntervalSecs sec:NSTimeInterval ,block:dispatch_block_t){
        dispatch_source_set_timer(self.dispatch_Source!, dispatch_time(DISPATCH_TIME_NOW, 0), UInt64(Double(NSEC_PER_SEC) * sec), 0)
        dispatch_source_set_event_handler(self.dispatch_Source!, block)
    }
    
    func start(){
        dispatch_resume(self.dispatch_Source!)
    }

    func destroy(){
        dispatch_source_cancel(self.dispatch_Source!)
    }
    
}
