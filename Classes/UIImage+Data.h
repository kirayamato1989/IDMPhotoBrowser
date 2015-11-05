//
//  UIImage+Data.h
//  feeling
//
//  Created by YamatoKira on 15/11/5.
//  Copyright © 2015年 isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Data)

+ (NSData *)convertImageIntoData:(UIImage *)image error:(NSError * __autoreleasing*)error;


@end
