//
//  GCDGroup.swift
//  GCD
//
//  Created by GuangHuiWu on 11/6/15.
//  Copyright © 2015 ALman. All rights reserved.
//

import UIKit

class GCDGroup: NSObject {

    let dispatchGroup = dispatch_group_create()
    
    func enter(){
        dispatch_group_enter(dispatchGroup)
    }
    
    func leave(){
        dispatch_group_leave(dispatchGroup)
    }
    
    func wait(){
        dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
    }
    
    func wait(delta:Int64) ->CBool {
        return dispatch_group_wait(dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0
    }
}
