//
//  CanvasView.m
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/4.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import "CanvasView.h"
#import <Quartz/Quartz.h>
#import "mbMysqlDB.h"
#import "mbMysqlQuery.h"
#import "mysql.h"
#import "my_global.h"
#import "RankedPageController.h"
#import "RankedPage.h"

@implementation CanvasView

@synthesize arrayController;
@synthesize collectionview;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code here.
        rectIndex = [[NSMutableArray alloc]init];
        colorValue = [[NSMutableArray alloc]init];
        
        selectedRect = [[NSMutableArray alloc]init];
        
        setRectcalled = NO;
        rectSelected = NO;
        
        //calculating all the necessary values to determine the region of user input rectangles
        framebound = [self bounds];  
        framecenter.x = (framebound.size.width)/2;
        framecenter.y = (framebound.size.height)/2;
        framebottom.x = 0.0;
        framebottom.y = (framebound.size.height)*1/3;
        framemid.x = 0.0;
        framemid.y = (framebound.size.height)*2/3;
    }
    return self;
}

//set view coordinate start from top left corner
- (BOOL)isFlipped
{
    return YES;
}

//rendering rectangles on canvasview
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    //fill canvas background with gray
    [[NSColor grayColor] setFill];
    NSRectFill(dirtyRect);

    // Drawing code here.
    //loop and render all rectangles in rectIndex
    if (rectIndex != nil) {
        for (int i=0; i< rectIndex.count; i++) {
            NSValue *returnvalue;
            NSRect returnRect;
            NSColor *currentcolor;
            
            //get the index, color, and geometric values of the i-th rectangles inside the arrays, and render it
            returnvalue = [rectIndex objectAtIndex:i];
            returnRect = [returnvalue rectValue];
            currentcolor = [colorValue objectAtIndex:i];
            
            if ([currentcolor isEqual:[NSColor redColor]]) {
                [[NSColor redColor] set];
            }
            if ([currentcolor isEqual:[NSColor greenColor]]) {
                [[NSColor greenColor] set];
            }
            if ([currentcolor isEqual:[NSColor blueColor]]) {
                [[NSColor blueColor] set];
            }
            //NSLog(@"rectSelected = %d", rectSelected);
            
            //refresh the view, after each update
            [NSBezierPath fillRect:returnRect];
            
            
            /*unfinished select & editing function
            if (rectSelected == 0 ) {
             
                    NSValue *rectvalue2;
                    NSRect selectRect;
                    rectvalue2 = [selectedRect objectAtIndex:selectedRectIndex];
                    selectRect = [rectvalue2 rectValue];
                    [[NSColor yellowColor] set];
                    NSFrameRectWithWidth(selectRect, 3);

            }
            
            if (rectSelected == 0 && selectedRectIndex == i) {
                NSLog(@"helo!");
                [[NSColor yellowColor] set];
                NSFrameRectWithWidth ( returnRect, 2);
            }//end if
            
            */
            //end of select and editing function
            
        }//end for
    }//end if


    
    //when a new rectangle is created
    if (newRectCreated) {
        if ([rectColor isEqual:[NSColor redColor]]) {
            [[NSColor redColor] set];
            [NSBezierPath fillRect:dragBounds];
            [self setNeedsDisplayInRect:dragBounds];
            newRectCreated = NO;
        }
        if ([rectColor isEqual:[NSColor blueColor]]) {
            [[NSColor blueColor] set];
            [NSBezierPath fillRect:dragBounds];
            [self setNeedsDisplayInRect:dragBounds];
            newRectCreated = NO;
        }
        if ([rectColor isEqual:[NSColor greenColor]]) {
            [[NSColor greenColor] set];
            [NSBezierPath fillRect:dragBounds];
            [self setNeedsDisplayInRect:dragBounds];
            newRectCreated = NO;
        }
    }//end if
    
    
    
//    CGPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
//    CGRect rect = [self bounds];
//    if ([self mouse:point inRect:rect]) {
//    }

}//end drawRect


//event handling when mouse button is pressed down
- (void)mouseDown:(NSEvent *)theEvent
{
    
    NSPoint pt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    anchor = pt;
    //NSLog(@"anchor: x=%f y=%f\n", anchor.x, anchor.y);
    rectSelected = NO;
    
    //detect if cursor is inside any of the drawn rectangle
    for (int j=0; j<rectIndex.count; j++) {
        NSValue *returnvalue;
        NSRect returnRect;
        
        returnvalue = [rectIndex objectAtIndex:j];
        returnRect = [returnvalue rectValue];
        
        if ([self mouse:anchor inRect:returnRect]) {
            selectedRectIndex = j;
            
            //if user cursor is inside one of the rectangle drawn
            rectSelected = YES;
            
            NSLog(@"selectedRectIndex: j=%d\n", selectedRectIndex);
            
            NSValue *selectedValue =[NSValue valueWithBytes:&returnRect objCType:@encode(NSRect)];
            [selectedRect addObject:selectedValue];
            
//            NSValue *rectvalue;
//            NSRect selectRect;
//            rectvalue = [rectIndex objectAtIndex:selectedRectIndex];
//            selectRect = [rectvalue rectValue];
//            [[NSColor yellowColor] set];
//            NSFrameRectWithWidth(selectRect, 20);
            
        }
    }//end for
    
    //rectSelected = NO;
    
    [self setNeedsDisplay:YES];

}//end mousedown

//mouse start dragging
- (void)mouseDragged:(NSEvent *)theEvent
{
    if (rectSelected == NO) {
    
        NSPoint dragpoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        //NSLog(@"dragpoint: x=%f y=%f\n", dragpoint.x, dragpoint.y);
        dragBounds = [self createRect:anchor and:dragpoint];
        newRectCreated = YES;
        [self setNeedsDisplay:YES];
    }
    
}

//mouse button lifted
- (void)mouseUp:(NSEvent *)theEvent
{
    //if no previous drawn rect is selected
    if (rectSelected == NO) {

        //NSRect dragRect;
        NSPoint pt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        endpoint = pt;
        NSLog(@"endpoint: x=%f y=%f\n", endpoint.x, endpoint.y);
        dragBounds = [self createRect:anchor and:endpoint];
        newRectCreated = YES;
        [self setNeedsDisplay:YES];
        
        [self setRect:dragBounds];
        setRectcalled = NO;
    }
    //rectSelected = NO;
}

//create a new rectangle for rendering while dragging
-(NSRect)createRect:(NSPoint)startpoint and:(NSPoint)endingpoint
{
    NSRect newRect;
    newRect.origin = anchor;
    newRect.size.width = endingpoint.x - startpoint.x;
    newRect.size.height = endingpoint.y - startpoint.y;
    //NSLog(@"startpoint: x=%f y=%f\n", startpoint.x, startpoint.y);
    //NSLog(@"endingpoint: x=%f y=%f\n", endingpoint.x, endingpoint.y);
    
    return newRect;
}

//add NSRect to rectIndex, and NSColor value to color array
-(void)setRect:(NSRect)rect
{

    setRectcalled = YES;
    
    //add new NSRect object into rectvalue
    rectValue=[NSValue valueWithBytes:&rect objCType:@encode(NSRect)];
    [rectIndex addObject:rectValue];
    
    if ([rectColor isEqual:[NSColor redColor]] && (colorValue.count == RectCount)) {
        [colorValue addObject:[NSColor redColor]];
    }
    if ([rectColor isEqual:[NSColor blueColor]] && (colorValue.count == RectCount)) {
        [colorValue addObject:[NSColor blueColor]];
    }
    if ([rectColor isEqual:[NSColor greenColor]] && (colorValue.count == RectCount)) {
        [colorValue addObject:[NSColor greenColor]];
    }
    
    NSLog(@"the rectIndex is %@\n",rectIndex);
    
    NSLog(@"the colorArray is %@\n", colorValue);
    
    //NSLog(@"the colorValue is %@\n", colorValue);
    //[rectIndex addObject:rectValue];
    NSLog(@"array count==%lu\n",(unsigned long)rectIndex.count);
    
    RectCount = RectCount + 1;
    
    setRectcalled = NO;
    
}

-(IBAction)queryButtonPressed:(id)sender{
    
    mbMysqlDB* db = [[mbMysqlDB alloc] init];
    
    
    //setting connection with mysql database
    db.socket = @"/tmp/mysql.sock";
    db.serverName = @"127.0.0.1";
    db.dbName = @"gotcha_db2";
    db.userName = @"root";
    db.password = @"overlord88";
    db.port = 3306;
    
    mbMysqlQuery* query = [[mbMysqlQuery alloc]initWithDatabase:db];

    NSMutableString *sqlstring = [NSMutableString stringWithString:@""];
//    NSMutableString *titlestring = [NSMutableString stringWithString:@""];
//    NSMutableString *textstring = [NSMutableString stringWithString:@""];
//    NSMutableString *imagestring = [NSMutableString stringWithString:@""];
    int blockcount = 0;
    
    if (rectIndex != nil) {

        for (int i=0; i< rectIndex.count; i++) {
            NSColor *currentcolor = [colorValue objectAtIndex:i];
            NSValue *returnvalue;
            NSRect returnRect;
            
            returnvalue = [rectIndex objectAtIndex:i];
            returnRect = [returnvalue rectValue];
            
            NSPoint rectCenter;
            rectCenter.x = 0.0;
            rectCenter.y = 0.0;
            
            int region = 0;
            double ratio = 0;
            ratio = (returnRect.size.width)/(returnRect.size.height);
            NSLog(@"ratio = %f\n", ratio);
            NSMutableString *str_ratio = [NSMutableString stringWithFormat:@"%f",ratio];
            NSLog(@"str_ratio = %@\n", str_ratio);
            
            
            
            //get the center of query rectangle
            returnvalue = [rectIndex objectAtIndex:i];
            returnRect = [returnvalue rectValue];
            rectCenter.x = returnRect.origin.x + returnRect.origin.x;
            rectCenter.y = returnRect.origin.y + returnRect.origin.y;
            
            NSMutableString *str_center_x = [NSMutableString stringWithFormat:@"%f",rectCenter.x];
            NSMutableString *str_center_y = [NSMutableString stringWithFormat:@"%f",rectCenter.y];
            
            
            //title block detected
            if ([currentcolor isEqual:[NSColor greenColor]]) {
                
                NSMutableString *titlestring = [NSMutableString stringWithString:@""];
                region = [self checktitleregion:rectCenter];
                NSMutableString *str_region = [NSMutableString stringWithFormat:@"%d", region];
                
                if (blockcount > 0) {
                    [sqlstring appendString:@" UNION ALL "];
                }
                
                [titlestring appendString:@"SELECT region, block_name, page_name, ratio, abs("];
                [titlestring appendString:str_ratio];
                [titlestring appendString:@" - ratio)*0.5 AS rat, ((POWER(("];
                [titlestring appendString:str_center_x];
                [titlestring appendString:@" - center_x),2) + POWER(("];
                [titlestring appendString:str_center_y];
                [titlestring appendString:@" - center_y),2))/10000) as dist_mod, MIN(abs("];
                [titlestring appendString:str_ratio];
                [titlestring appendString:@" - ratio)*0.5 + (POWER(("];
                [titlestring appendString:str_center_x];
                [titlestring appendString:@" - center_x),2) + POWER(("];
                [titlestring appendString:str_center_y];
                [titlestring appendString:@" - center_y),2))/10000) as rank FROM block_title WHERE region = "];
                [titlestring appendString:str_region];
                [titlestring appendString:@" "];
                blockcount = blockcount + 1;
                
                NSLog(@"titlestring = %@\n", titlestring);
                
                [sqlstring appendString:titlestring];
            }
            
            //text block detected
            if ([currentcolor isEqual:[NSColor redColor]]) {
                
                
                NSMutableString *textstring = [NSMutableString stringWithString:@""];
                region = [self checkregion:rectCenter];
                NSMutableString *str_region = [NSMutableString stringWithFormat:@"%d", region];
                
                if (blockcount > 0) {
                    [sqlstring appendString:@" UNION ALL "];
                }
                
                //assemble the sql string 
                [textstring appendString:@"SELECT region, block_name, page_name, ratio, abs("];
                [textstring appendString:str_ratio];
                [textstring appendString:@" - ratio)*0.5 AS rat, ((POWER(("];
                [textstring appendString:str_center_x];
                [textstring appendString:@" - center_x),2) + POWER(("];
                [textstring appendString:str_center_y];
                [textstring appendString:@" - center_y),2))/10000) as dist_mod, MIN(abs("];
                [textstring appendString:str_ratio];
                [textstring appendString:@" - ratio)*0.5 + (POWER(("];
                [textstring appendString:str_center_x];
                [textstring appendString:@" - center_x),2) + POWER(("];
                [textstring appendString:str_center_y];
                [textstring appendString:@" - center_y),2))/10000) as rank FROM block_text WHERE region = "];
                [textstring appendString:str_region];
                [textstring appendString:@" "];
                blockcount = blockcount + 1;
                
                NSLog(@"textstring = %@\n", textstring);
                
                [sqlstring appendString:textstring];
            }
            
            //image block detected
            if ([currentcolor isEqual:[NSColor blueColor]]) {
                
                NSMutableString *imagestring = [NSMutableString stringWithString:@""];
                region = [self checkregion:rectCenter];
                NSMutableString *str_region = [NSMutableString stringWithFormat:@"%d", region];
                
                
                if (blockcount > 0) {
                    [sqlstring appendString:@" UNION ALL "];
                }
                
                [imagestring appendString:@"SELECT region, block_name, page_name, ratio, abs("];
                [imagestring appendString:str_ratio];
                [imagestring appendString:@" - ratio)*0.5 AS rat, ((POWER(("];
                [imagestring appendString:str_center_x];
                [imagestring appendString:@" - center_x),2) + POWER(("];
                [imagestring appendString:str_center_y];
                [imagestring appendString:@" - center_y),2))/10000) as dist_mod, MIN(abs("];
                [imagestring appendString:str_ratio];
                [imagestring appendString:@" - ratio)*0.5 + (POWER(("];
                [imagestring appendString:str_center_x];
                [imagestring appendString:@" - center_x),2) + POWER(("];
                [imagestring appendString:str_center_y];
                [imagestring appendString:@" - center_y),2))/10000) as rank FROM block_text WHERE region = "];
                [imagestring appendString:str_region];
                [imagestring appendString:@" "];
                blockcount = blockcount + 1;
                
                NSLog(@"imagestring = %@\n", imagestring);
                
                [sqlstring appendString:imagestring];
            }
            
            
            
        }//end for
    }//end if
    
    
    [sqlstring appendString:@" GROUP BY page_name ORDER BY rank ASC"];
    NSLog(@"sqlstring = %@\n", sqlstring);
    
    //clear array controller of collectionview
    [[arrayController content] removeAllObjects];
    
    
    @try{
        [db connect];
        
        query.sql = sqlstring;
        [query execQuery];
        
        NSInteger len = query.recordCount;
        
        //NSLog(@"record count = %ld", (long)query.recordCount);

        //RankedPageController *controller = [[RankedPageController alloc] init];
        
        for(int i=0;i<len;i++){
            NSInteger region = [query integerValFromRow:i Column:0];
            NSString *block_name = [query stringValFromRow:i Column:1];
            NSString *page_name = [query stringValFromRow:i Column:2];
            double ratio = [query doubleValFromRow:i Column:3];
            double rat = [query doubleValFromRow:i Column:4];
            double dist_mod = [query doubleValFromRow:i Column:5];
            double rank = [query doubleValFromRow:i Column:6];
            
            //RankedPage *newpage = [[RankedPage alloc] init];
            
            //[controller addToView:page_name and:i];
            
            //create RankedPage, or NSCollectionView Cell
            RankedPage *newpage = [[RankedPage alloc] init];
            
            [newpage setFile_name:page_name];
            
            //location of where your document page images are:
            NSMutableString *path  = [NSMutableString stringWithString:@"/Users/yuyueugene84_macbook/Documents/gotcha/page_backup/"];
            
            //assemble the full file name of the document image i want to retrieve
            [path appendString:page_name];
            
            
            [newpage setFile_path:path];
            //[newpage setRanking:(int)rank];
            [newpage setRanking:(i+1)];
            
            //NSString *str = valuestring;
//            NSImageView *imageview = [[NSImageView alloc]init];
            
            //set thumbnail image in the NSCollectionview cell
            NSImage *picture = [[NSImage alloc] initWithContentsOfFile:path];
            [newpage setFile_image:picture];
            
            //add the NSCollectionview cell into an array
            [arrayController addObject:newpage];
            
            
            NSLog(@"region at row%ld = %ld\n", (long)i, region);
            NSLog(@"block_name at row%ld = %@\n", (long)i, block_name);
            NSLog(@"page_name at row%ld = %@\n", (long)i, page_name);
            NSLog(@"ratio at row%ld = %f\n", (long)i, ratio);
            NSLog(@"rat at row%ld = %f\n", (long)i, rat);
            NSLog(@"dist_mod at row%ld = %f\n", (long)i, dist_mod);
            NSLog(@"rank at row%ld = %f\n", (long)i, rank);

        }//end for
    }//end try
    @catch (NSException *exception) {
        // ...
        [db errorMessage];
    }

}


//Event Handlings for all the buttons in the user interface
//when title button pressed
-(IBAction)titleBlockSelected:(id)sender{
    rectColor = [NSColor greenColor];
    //[[myButton cell] setBackgroundColor:[NSColor redColor]];
    [self setNeedsDisplay:YES];
}

//when image button pressed
-(IBAction)imageBlockSelected:(id)sender{
    rectColor = [NSColor blueColor];    
    [self setNeedsDisplay:YES];
}

//when text button pressed
-(IBAction)textBlockSelected:(id)sender{
    rectColor = [NSColor redColor];
    [self setNeedsDisplay:YES];
}

//clear everything in canvas
-(IBAction)clearButton:(id)sender{
    [self reset2zero];
    [self setNeedsDisplay:YES];

}

//delete the selected rectangle
-(IBAction)editButton:(id)sender{
    [rectIndex removeObjectAtIndex:selectedRectIndex];
    [colorValue removeObjectAtIndex:selectedRectIndex];
    rectSelected = NO;
    [self setNeedsDisplay:YES];
}

-(int)checktitleregion:(NSPoint)queryRectCenter
{
    int region;
    
    NSLog(@"framebottom.y = %f\n", framebottom.y);
    NSLog(@"framemid.y = %f\n", framemid.y);
    
    if ((0 < queryRectCenter.y)&&(queryRectCenter.y <= framebottom.y)) {
        region = 1;
    }
    if ((framebottom.y < queryRectCenter.y)&&(queryRectCenter.y <= framemid.y)) {
        region = 2;
    }
    if ((framemid.y < queryRectCenter.y)&&(queryRectCenter.y < 480.0)) {
        region = 3;
    }
    
    NSLog(@"title is at region %d\n", region);
    
    return region;
}


//determine the region
-(int)checkregion:(NSPoint)queryRectCenter
{
    int region;
    
    if ((queryRectCenter.x < framecenter.x)&&(queryRectCenter.y < framecenter.y)) {
        region = 1;
    }
    if ((queryRectCenter.x > framecenter.x)&&(queryRectCenter.y < framecenter.y)) {
        region = 2;
    }
    if ((queryRectCenter.x < framecenter.x)&&(queryRectCenter.y > framecenter.y)) {
        region = 3;
    }
    if ((queryRectCenter.x > framecenter.x)&&(queryRectCenter.y > framecenter.y)) {
        region = 4;
    }
    
    return region;
}

//reset all variables when called
-(void)reset2zero
{
    newRectCreated = NO;
    setRectcalled = NO;
    RectCount = 0;
    rectIndex = nil;
    colorValue = nil;
    rectColor = nil;
    filepatharray = nil;
    filenamearray = nil;

    
    rectIndex = [[NSMutableArray alloc]init];
    colorValue = [[NSMutableArray alloc]init];
    
    filepatharray = [[NSMutableArray alloc]init];
    filenamearray = [[NSMutableArray alloc]init];
    [[arrayController content] removeAllObjects];
    //arrayController = [[NSArrayController alloc]init];
    
}
@end
