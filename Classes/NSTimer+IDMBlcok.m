//
//  NSTimer+IDMBlcok.m
//  PhotoBrowserDemo
//
//  Created by YamatoKira on 15/12/3.
//
//

#import "NSTimer+IDMBlcok.h"

@implementation NSTimer (IDMBlcok)

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats block:(void (^)())block {
    return [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(ky_blockInvoke:) userInfo:[block copy] repeats:repeats];
}


+ (void)ky_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
