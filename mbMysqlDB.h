//
//  mbMysqlDB.h
//  GotchaFind
//
//  Created by Eugene Chang on 14/4/5.
//  Copyright (c) 2014年 Eugene Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "mysql.h"

@interface mbMysqlDB : NSObject
{
    MYSQL* mysql;
    NSString* lastError;
}

- (void)connect; // connect to Database
- (void)mysqlError; // error message and save in the *lastError
- (void)disconnect; // disconnect from Database
- (NSString*) r_escape:(NSString*)s; // escape simbols in the SQL string
- (NSInteger) autoincrementID; // give last value Autoincriment field
- (BOOL) connected; // test to connect
- (void) errorMessage; // show NSAlert dialog message with lastError

@property (copy)NSString* socket;
@property (copy)NSString* serverName;
@property (copy)NSString* dbName;
@property NSInteger port;
@property (copy)NSString* userName;
@property (copy)NSString* password;
@property (readonly)MYSQL* mysql;

@end
