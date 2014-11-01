//
//  RankedPage.h
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/2.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankedPage : NSObject{
    NSString *file_name;
    NSString *file_path;
    //NSImageView *imageview;
    NSImage *file_image;
    int ranking;
    
}

@property (strong) NSString *file_name;
@property (strong) NSString *file_path;
@property (strong) NSImage *file_image;
//@property (assign) IBOutlet NSImageView *imageview;
@property int ranking;

@end
