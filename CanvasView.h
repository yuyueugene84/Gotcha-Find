//
//  CanvasView.h
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/4.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "mysql.h"
#import "my_global.h"

@interface CanvasView : NSView {

    
    //initial user click
    NSPoint anchor;
    //point when user release the button
    NSPoint endpoint;
    
    //rectangle bound
    NSRect dragBounds;
    //rectangle color
    NSColor *rectColor;    
    //background color
    NSColor *backgroundColor;
    
    //recttangle count
    NSInteger RectCount;
    
    //store NSRect value
    NSMutableArray *rectIndex;
    //store user selected rectangle
    NSMutableArray *selectedRect;
    
    //store color value of NSRect
    NSMutableArray *colorValue;
    NSValue *rectValue;
    int selectedRectIndex;
    BOOL rectSelected;
    
    
    //super view bound
    NSRect framebound;
    
    //super view center
    NSPoint framecenter;
    NSPoint frametop;
    NSPoint framemid;
    NSPoint framebottom;
    
    //nsimageview array
    NSMutableArray *imageviewarray;
    NSMutableArray *filepatharray;
    NSMutableArray *filenamearray;
    
    BOOL setRectcalled;
    BOOL newRectCreated;
}

@property (assign) IBOutlet NSArrayController *arrayController;
@property (assign) IBOutlet NSCollectionView *collectionview;

@end
