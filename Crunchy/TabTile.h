//
//  TabTile.h
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tab.h"
#import "TabInfo.h"

@protocol TabTileDelegate;

@interface TabTile : UICollectionViewCell

@property (strong,nonatomic) Tab* tab;
@property (strong,nonatomic) UILabel* label;
@property (strong,nonatomic) UIImage* screenshot;
@property (strong,nonatomic) TabInfo* tabInfo;

@property (nonatomic, weak) id<TabTileDelegate> delegate;


- (void) setTabInfo:(TabInfo*) tabInfo;

@end

@protocol TabTileDelegate <NSObject>
- (bool) tabTileClosed:(TabInfo*) tabInfo;
- (void) tabSelected:(TabInfo*) tabInfo;
@end


