//
//  SNZDBManager.m
//  SenzSDKDemo
//
//  Created by yue.dai on 15/4/13.
//  Copyright (c) 2015年 Senz+. All rights reserved.
//

#import "SNZDBManager.h"

@implementation SNZDBManager

//
//#pragma mark - Open & Close
//
//-(Boolean)openDatabase
//{
//    if (dbIsOpen)
//    {
//        [HAMLogTool warn:@"Trying to open database when database is already open!"];
//        return true;
//    }
//
//    if (sqlite3_open([[HAMFileTools filePath:DBNAME] UTF8String], &database)
//        != SQLITE_OK)
//    {
//        sqlite3_close(database);
//        [HAMLogTool error:@"Fail to open database!"];
//        return false;
//    }
//
//    dbIsOpen=YES;
//    return true;
//}
//
//-(void)closeDatabase
//{
//    if (!dbIsOpen)
//        return;
//
//    if (statement)
//    {
//        sqlite3_finalize(statement);
//        statement=nil;
//    }
//    sqlite3_close(database);
//    dbIsOpen=NO;
//}
//
//#pragma mark - Common Methods
//
//-(Boolean)isDatabaseExist
//{
//    int rc = sqlite3_open_v2([[HAMFileTools filePath:DBNAME] UTF8String], &database, SQLITE_OPEN_READWRITE, NULL);
//    if (rc == 0)
//        sqlite3_close(database);
//    return rc == 0;
//}
//
//-(Boolean)runSQL:(NSString*)sql
//{
//    char *errorMsg;
//
//    [self openDatabase];
//    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK)
//    {
//        [HAMLogTool error:[NSString stringWithFormat:@"Run SQL '%@' fail : %s",sql,errorMsg]];
//        [self closeDatabase];
//        return false;
//    }
//    [self closeDatabase];
//    return true;
//}
//
//-(NSString*)stringAt:(int)column
//{
//    char* text=(char*)sqlite3_column_text(statement, column);
//
//    if (text)
//        return [NSString stringWithUTF8String:text];
//    else
//        return nil;
//}
//
//-(void)bindString:(NSString*)string at:(int)column{
//    sqlite3_bind_text(statement, column, [string UTF8String], -1, NULL);
//}
//
//#pragma mark - Clear & Init
//
//- (void)clear{
//    [self runSQL:@"DELETE FROM COUPON;"];
//    //    [self runSQL:@"DROP TABLE IF EXISTS COUPON;"];
//}
//
//- (void)initDatabase{
//    [self runSQL:@"CREATE TABLE IF NOT EXISTS TESTDATA(TESTID int, ACCURACY double, RSSI int);"];
//}



@end
