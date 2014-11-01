//
//  RankedPageController.m
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/2.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import "RankedPageController.h"

@implementation RankedPageController
//@synthesize pages = _pages;

-(IBAction)newPage:(id)sender
{
    RankedPage *newpage = [[RankedPage alloc] init];
    [newpage setFile_name:@"john"];
    [newpage setFile_path:@"/usr/local/include"];
    [newpage setRanking:1];
    
            NSString *path = @"/Users/yuyueugene84_macbook/Documents/gotcha/page_backup/01001.jpg";
            //NSImageView *imageview2 = [[NSImageView alloc]init];
            NSImage *picture = [[NSImage alloc] initWithContentsOfFile:path];
            //imageview2.image = picture;

            [newpage setFile_image:picture];
    
            //[newpage setImageview:imageview2];
    
    [arrayController addObject:newpage];
    //[self.pages addObject:newpage];
}

-(void)addToView:(NSString*)page_name and:(NSInteger)rank
{
    RankedPage *newpage = [[RankedPage alloc] init];
    
    [newpage setFile_name:page_name];
    
    NSLog(@"add2view page_name at rank%ld = %@\n", rank, page_name);
    
    NSMutableString *path  = [NSMutableString stringWithString:@"/Users/yuyueugene84_macbook/Documents/gotcha/page_backup/"];
    [path appendString:page_name];
    
    [newpage setFile_path:path];
    [newpage setRanking:(int)rank];
    
    NSLog(@"add2view path at rank%ld = %@\n", rank, path);
    
    //NSString *str = valuestring;
    NSImageView *imageview = [[NSImageView alloc]init];
    NSImage *picture = [[NSImage alloc] initWithContentsOfFile:path];
    imageview.image = picture;
    
    [newpage setImageview:imageview];
    
    [arrayController addObject:newpage];

}

@end
