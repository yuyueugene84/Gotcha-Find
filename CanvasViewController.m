//
//  CanvasViewController.m
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/1.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@end

@implementation CanvasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[self drawRect:dirtyRect];
    
    [[NSColor whiteColor] set];//set bcackround color
    [NSBezierPath fillRect:dirtyRect];
}
@end
