//
//  ViewController.swift
//  GCD
//
//  Created by GuangHuiWu on 11/6/15.
//  Copyright © 2015 ALman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var nsTimer : NSTimer?
    
    var imgView : UIImageView?
    var image :UIImage?
    var imageCache = Dictionary<String,UIImage>()
    
    var dispatch_Source : dispatch_source_t?

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        self.servailQueue()
//        self.concurrentQueue()
    
//        self.afterExecute()
        self.loadImage()
        
//        self.groupExecute()
        
//        self.gcdTimer()
//        self.nsTimerExecute()
        
//        self.gcdSemaphore()
        
    }
    
    // 多线程加载图片
    func loadImage(){
        
        self.imgView = UIImageView.init(frame: CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 300))
        self.imgView?.alpha = 0

        self.view.addSubview(self.imgView!)
        let urlString = "http://pic7.nipic.com/20100601/172848_091313069981_2.jpg"

        
        GCDQueue .executeInGlobalQueue { () -> Void in
            
            // 处理业务逻辑
            
            // 缓存图片
            let cacheImage = self.imageCache[urlString] as UIImage?
            
            if !(cacheImage != nil) {
            
                let request = NSURLRequest(URL: NSURL(string: urlString)!)
                
                let session = NSURLSession.sharedSession()
                
                let task =  session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    
                    do{
                        NSLog("\(data)")
                        self.image = UIImage(data: data!)
                        self.imageCache[urlString] = self.image
                        // 更新UI
                        GCDQueue.executeInMainQueue({ () -> Void in
                            
                            UIView.animateWithDuration(2, animations: { () -> Void in
                                
                                self.imgView?.image = self.image
                                self.imgView?.alpha = 1
                                
                                }, completion: { (Bool) -> Void in
                                    
                            })
                            
                        })
                    }
                    
                })
                
                task.resume()
                
            }else{
            
                UIView.animateWithDuration(2, animations: { () -> Void in
                    
                    self.imgView?.image = cacheImage
                    self.imgView?.alpha = 1
                    
                    }, completion: { (Bool) -> Void in
                        
                })
            }
        }
    }
    
    // 线程组
    func groupExecute(){
        
        // 创建线程组
        let group = GCDGroup()
        
        // 创建并行队列
        let queue = GCDQueue.init(concurrent: true)
        
        // 让线程在group中执行
        
        queue.execute(inGroup: group) { () -> Void in
            sleep(1)
            NSLog("线程1执行完毕")
        }

        queue.execute(inGroup: group) { () -> Void in
            sleep(3)
            NSLog("线程2执行完毕")
        }
        // 1 ... n-1 线程
        
        // 监听线程，线程组n-1执行完毕后执行
        queue.notify(inGroup: group) { () -> Void in
            
            NSLog("线程n执行完毕")
            
        }
        
    }
    
    // NSThread 延迟时间精确度高，可以取消延迟执行的操作；GCD 精确度低，不能取消，代码简练
    func afterExecute(){
        
        NSLog("启动")
        self.performSelector("threadEvent:", withObject: self, afterDelay: 2.0)
        // 取消NSThread延迟操作
//        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        
        GCDQueue.executeInMainQueue(afterDelaySecs: 2.0) { () -> Void in
            
            NSLog("GCD 线程事件")
        }
    }
    func threadEvent(sender:AnyObject){
        NSLog("NSThread 线程事件")
    }
    
    
    // NSTimer 要比GCDTimer 精确度高，但要放在特定的runLoop里边 ， GCDTimer在tableView中的使用效果比较好
    func nsTimerExecute(){
        self.nsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFire", userInfo: nil, repeats: true)
    }
    func timerFire(sender:AnyObject){
        
        NSLog("NSTimer 定时器")
        
    }

    
    // 信号量 两个异步线程 顺序执行
    func gcdSemaphore(){
        
        let semaphore = GCDSemphore.init()
        
        GCDQueue.executeInGlobalQueue { () -> Void in
            
            print("线程 1 ")
            // 发送信号
            semaphore.signal()
        }

        GCDQueue.executeInGlobalQueue { () -> Void in
            
            // 等待信号
            semaphore.wait()
            print("线程 2 ")
        }

    }
    
    
    // 定时器
    func gcdTimer(){
        
//        self.dispatch_Source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))

        self.dispatch_Source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, GCDQueue.main_Queue().dispatchQueue)
        
        let gTimer = GCDTimer.init(dispatch_Source: self.dispatch_Source!)
        
        gTimer.event(timeInterval: NSEC_PER_SEC, block: { () -> Void in
            NSLog("gcdTimer")
        })
        
        gTimer.start()
        
    }
    
    
    
    // 并发队列 一次执行多个 没有顺序
    func concurrentQueue(){
        
        let queue = GCDQueue.init(concurrent: true)
        
        queue.execute { () -> Void in
            print("1")
        }

        queue.execute { () -> Void in
            print("2")
        }

        queue.execute { () -> Void in
            print("3")
        }

        queue.execute { () -> Void in
            print("4")
        }

        queue.execute { () -> Void in
            print("5")
        }

        queue.execute { () -> Void in
            print("6")
        }

        queue.execute { () -> Void in
            print("7")
        }

        
    }
    
    // 串行队列 FIFO
    func servailQueue(){
    
        let queue = GCDQueue.init(serival: true)
       
        queue.execute { () -> Void in
            
            print("1")
            
        }
        queue.execute { () -> Void in
            
            print("2")
            
        }
        queue.execute { () -> Void in
            
            print("3")
            
        }
        queue.execute { () -> Void in
            
            print("4")
            
        }
    }
}

