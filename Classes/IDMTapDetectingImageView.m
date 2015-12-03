//
//  IDMTapDetectingImageView.m
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import "IDMTapDetectingImageView.h"
#import "NSTimer+IDMBlcok.h"

@interface IDMTapDetectingImageView ()

@property (nonatomic, strong) UIImage *cacheImage;

@property (nonatomic, strong) NSTimer *refreshTimer;

@property (nonatomic, assign) NSTimeInterval showNextImageDuration;

@property (nonatomic, assign) NSTimeInterval currentDuration;

@end

@implementation IDMTapDetectingImageView

@synthesize tapDelegate;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithImage:(UIImage *)image {
	if ((self = [super initWithImage:image])) {
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
	if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (void)dealloc {
    if (_refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
    _cacheImage = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
		case 1:
			[self handleSingleTap:touch];
			break;
		case 2:
			[self handleDoubleTap:touch];
			break;
		case 3:
			[self handleTripleTap:touch];
			break;
		default:
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
	if ([tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
		[tapDelegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
	if ([tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
		[tapDelegate imageView:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
	if ([tapDelegate respondsToSelector:@selector(imageView:tripleTapDetected:)])
		[tapDelegate imageView:self tripleTapDetected:touch];
}

#pragma mark GIF

- (void)setImage:(UIImage *)image {
    self.cacheImage = image;
    self.currentDuration = 0.f;
    self.showNextImageDuration = 0.f;
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
    
    
    if (image.images.count > 1) {
        [super setImage:image.images[0]];
        self.showNextImageDuration = [image.images[0] duration];
        __weak typeof(self) weakSelf = self;
        self.refreshTimer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^{
            __strong typeof(weakSelf) sSelf = weakSelf;
            if (sSelf) {
                [sSelf shouldShowNextImage];
            }
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
        [self.refreshTimer fire];
    }
    else {
        [super setImage:image];
    }
}

- (UIImage *)image {
    return self.cacheImage;
}

- (void)shouldShowNextImage {
    self.currentDuration += 0.1;
    if (self.currentDuration >= self.showNextImageDuration) {
        UIImage *currentImage = [super image];
        NSUInteger index = [self.cacheImage.images indexOfObject:currentImage];
        NSUInteger nextIndex = index == self.cacheImage.images.count - 1?0:index + 1;
        UIImage *nextImage = self.cacheImage.images[nextIndex];
        
        [super setImage:nextImage];
        
        // reset the next duration
        self.showNextImageDuration = nextImage.duration;
        
        // reset to zero
        self.currentDuration = 0.f;
    }
}



@end
