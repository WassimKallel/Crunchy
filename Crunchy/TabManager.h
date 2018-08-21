//
//  TabManager.h
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TabTile.h"
#import "Tab.h"
#import "TabInfo.h"

@protocol TabManagerDelegate;

@interface TabManager : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, TabInfoDelegate, TabTileDelegate>

@property(strong, nonatomic) NSMutableArray *tabsInfo;
@property(strong,nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSInteger tabsCount;
@property (nonatomic, weak) id<TabManagerDelegate> delegate;


-(id) initWithCollectionView:(UICollectionView*) collectionView;
-(void) addTileWithTab:(Tab*) tab;
-(void) updateTabInfo:(Tab*) tab;


@end
@protocol TabManagerDelegate <NSObject>
- (void) tabSelected:(Tab*) tab;
- (void) tabClosed:(Tab*) tab;

@end


