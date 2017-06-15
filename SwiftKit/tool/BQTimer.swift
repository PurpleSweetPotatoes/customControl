//
//  BQTimer.swift
//  swift-test
//
//  Created by baiqiang on 2017/6/15.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit

class BQTimer {
    private var timer: DispatchSourceTimer!
    init(interval: Int = 1, handler: (()->())?) {
        self.timer = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        self.timer.scheduleRepeating(deadline: .now(), interval: .seconds(interval))
        self.timer.setEventHandler(handler: handler)
    }
    
    @discardableResult
    public func start() -> BQTimer {
        self.timer.resume()
        return self
    }
    
    @discardableResult
    public func suspend() -> BQTimer {
        self.timer.suspend()
        return self
    }
    
    @discardableResult
    public func cancel() -> BQTimer {
        self.timer.cancel()
        return self
    }
}
