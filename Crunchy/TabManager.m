//
//  TabManager.m
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//


#import "TabManager.h"

@implementation TabManager
@synthesize  tabsInfo = _tabsInfo;

-(id) initWithCollectionView:(UICollectionView*) collectionView
{
    self = [super init];
    if(self)
    {
        _collectionView = collectionView;
        _tabsInfo = [[NSMutableArray alloc] init];
        _tabsCount = 0;
    }
    return self;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (_tabsCount);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(250, 250);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TabTile *tabTile = [collectionView dequeueReusableCellWithReuseIdentifier:@"tile" forIndexPath:indexPath];
    tabTile.tag=indexPath.row;
    NSInteger index = indexPath.row;
    TabInfo *tabInfo = [_tabsInfo objectAtIndex:index];
    [tabTile setTabInfo:tabInfo];
    tabTile.delegate = self;
    NSLog(@"origin %@",NSStringFromCGPoint(tabTile.frame.origin));
    CGRect newFrame = tabTile.frame;
    newFrame.origin.y = 25;
    tabTile.frame = newFrame;
    return tabTile;
}

-(void) addTileWithTab:(Tab*) tab
{
    _tabsCount++;
    [self.collectionView reloadData];
    TabInfo *tabInfo = [[TabInfo alloc] initWithTab:tab];
    tabInfo.delegate = self;
    [_tabsInfo addObject:tabInfo];
}



-(void) updateTabInfo:(Tab*) tab
{
    for (TabInfo* tabInfo in _tabsInfo)
    {
        if([(tabInfo.tab)  isEqual:tab])
        {
            tabInfo.title = tab.pageTitle;
            [tabInfo updateScreenShot];
            [self.collectionView reloadData];
            break;
        }
    }
}
-(void) reloadRequired
{
    [self.collectionView reloadData];
}

-(bool) tabTileClosed:(TabInfo*) tabInfo
{
    if([self.collectionView numberOfItemsInSection:0] == 1)
    {
        NSLog(@"false");
        return false;
    }
    else{
        
        [_tabsInfo removeObject:tabInfo];
        _tabsCount --;
        [self.collectionView reloadData];
        [_delegate tabClosed:tabInfo.tab];
        NSLog(@"true");
        return true;
    }
}

- (void) tabSelected:(TabInfo*) tabInfo
{
    [_delegate tabSelected:tabInfo.tab];
}
@end
