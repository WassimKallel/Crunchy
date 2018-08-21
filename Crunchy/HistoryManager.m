//
//  historyManager.m
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//


#import "HistoryManager.h"

@implementation HistoryManager

-(id) init
{
    self = [super init];
    if(self)
    {
        _DBManager = [[DBManager alloc] initWithDatabaseFilename:@"History.db"];
    }
    return self;
}


-(void)loadData{
    // Form the query.
    NSString *query = @"select * from history";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Get the results.
    if (array != nil) {
        array = nil;
    }
    array = [[NSMutableArray alloc] initWithArray:[self.DBManager loadDataFromDB:query]];
    NSLog(@"%@",array);
    
    // Reload the table view.
    //[self.tblPeople reloadData];
}
-(void)loadDataWithKeyword:(NSString*)keyword{
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM history WHERE title Like '%%%@%%';",keyword];
    NSLog(@"query %@",query);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Get the results.
    if (array != nil) {
        array = nil;
    }
    array = [[NSArray alloc] initWithArray:[self.DBManager loadDataFromDB:query]];
    NSLog(@"%@",array);
    
    // Reload the table view.
    //[self.tblPeople reloadData];
}
-(void) addEntryWithTitle:(NSString*) title andUrlString:(NSString*) url
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO history VALUES(null, '%@', '%@', '%@')",title,url,dateString];
    [_DBManager executeQuery:query];
    if (_DBManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", _DBManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}
@end

