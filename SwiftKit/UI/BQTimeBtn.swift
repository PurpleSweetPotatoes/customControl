//
//  BQTimeBtn.swift
//  swift-Test
//
//  Created by MrBai on 2017/6/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

import UIKit

typealias BtnBlock = (UIButton) -> ()
typealias BtnUpdateBlock = (Int) -> String
class BQTimeBtn: UIButton {

    //MARK: - ***** Ivars *****
    private var mainColor: UIColor!
    private var count: Int = 60
    private var time: Int = 60
    private var timer: DispatchSourceTimer!
    private var interval: DispatchTimeInterval!
    private var touInBlock: BtnBlock?
    private var updateBlock: BtnUpdateBlock?
    //MARK: - ***** Class Method *****
    
    //MARK: - ***** initialize Method *****
    
    init(frame: CGRect, mainColor: UIColor, time:Int = 60, interval: DispatchTimeInterval = DispatchTimeInterval.seconds(1)) {
        super.init(frame: frame)
        self.mainColor = mainColor
        self.time = time
        self.count = time
        self.interval = interval
        self.backgroundColor = self.mainColor
        self.initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("被释放了")
        self.timer.cancel()
    }
    //MARK: - ***** public Method *****
    public func touchInSide(handle:@escaping BtnBlock){
        self.touInBlock = handle
    }
    public func updateTime(handle:@escaping BtnUpdateBlock){
        self.updateBlock = handle
    }
    public func startTimer() {
        self.timer.resume()
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.gray
    }
    //MARK: - ***** private Method *****
    private func initData() {
        self.timer = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        self.timer.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .seconds(0))
        timer.setEventHandler { [weak self] in
            self?.upDateTime()
        }
        self.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
    }
    @objc private func btnAction(btn:UIButton) {
        if let block = self.touInBlock {
            block(btn)
        }
    }
    private func upDateTime() {
        self.count -= 1
        if let block = self.updateBlock {
            self.setTitle(block(self.count), for: .normal)
        }
        if self.count == 0 {
            self.count = self.time
            self.timer.suspend()
            self.isUserInteractionEnabled = true
            self.backgroundColor = self.mainColor
        }
    }
    //MARK: - ***** LoadData Method *****
    
    //MARK: - ***** respond event Method *****
    
    //MARK: - ***** Protocol *****
    
    //MARK: - ***** create Method *****

}
