//
//  RankedPageView.m
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/3.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import "RankedPageView.h"

@implementation RankedPageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	[[NSColor grayColor] setFill];
    NSRectFill(dirtyRect);
    // Drawing code here.
}

@end
