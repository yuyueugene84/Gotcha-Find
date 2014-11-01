//
//  RankedPage.m
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/2.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import "RankedPage.h"

@implementation RankedPage

@synthesize file_name;
@synthesize file_path;
@synthesize file_image;
@synthesize ranking;

-(id)init{
    self = [super init];
    if (self) {
        file_name = @"nil";
        file_path = @"nil";
        ranking = 1;
    }
    return self;
}

@end
