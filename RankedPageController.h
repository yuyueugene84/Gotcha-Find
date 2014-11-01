//
//  RankedPageController.h
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/2.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankedPage.h"

@interface RankedPageController : NSObject{
    IBOutlet NSArrayController *arrayController;
}

//@property (strong) NSMutableArray *pages;

- (IBAction)newPage:(id)sender;
-(void)addToView:(NSString*)page_name and:(NSInteger)rank;



@end
