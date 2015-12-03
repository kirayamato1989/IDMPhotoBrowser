//
//  NSTimer+IDMBlcok.h
//  PhotoBrowserDemo
//
//  Created by YamatoKira on 15/12/3.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (IDMBlcok)

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval
                              repeats:(BOOL)repeats
                                block:(void (^)())block;

@end
