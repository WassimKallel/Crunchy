//
//  historyManager.h
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface HistoryManager : NSObject <UITableViewDataSource, UITableViewDelegate>
@property(strong,nonatomic) DBManager* DBManager;

-(id)init;
-(void) addEntryWithTitle:(NSString*) title andUrlString:(NSString*) url;
-(void)loadData;
-(void)loadDataWithKeyword:(NSString*)keyword;
@end
