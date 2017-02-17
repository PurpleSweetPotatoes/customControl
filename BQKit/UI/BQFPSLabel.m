//
//  BQFPSLabel.m
//  TableViewTest
//
//  Created by baiqiang on 16/5/18.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "BQFPSLabel.h"
#import "BQWeakProxy.h"
 
@interface BQFPSLabel()
{
    NSUInteger _count;
    NSTimeInterval _lastTime;
    CADisplayLink *_link;
}
@end

@implementation BQFPSLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _count = 0;
        _lastTime = 0;
        self.text = @"60 fps";
        _link = [CADisplayLink displayLinkWithTarget:[BQWeakProxy proxyWithTarget:self] selector:@selector(updateCount:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc {
    [_link invalidate];
}
- (void)updateCount:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    ++_count;
    NSTimeInterval addTiem = link.timestamp - _lastTime;
    if (addTiem < 1) return;
    int fps = (int)round(_count / addTiem);
    NSString *fpsString = [NSString stringWithFormat:@"%d fps",fps];
    _count = 0;
    _lastTime = link.timestamp;
    self.text = fpsString;
}
@end
