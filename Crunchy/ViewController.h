//
//  ViewController.h
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tab.h"
#import "TabManager.h"
#import "HistoryManager.h"



@interface ViewController : UIViewController < UIWebViewDelegate, UITextFieldDelegate, TabDelegate,TabManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *adressBar;
@property (strong,nonatomic) NSMutableArray *tabs;
@property (strong,nonatomic) Tab *activeTab;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *tabAreaView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIView *interactiveTabBar;
@property (weak, nonatomic) IBOutlet UIScrollView *TabScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *tabTilesCollectionView;
@property (retain,nonatomic) TabManager *tabManager;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *tileLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *testImageView;
@property (weak, nonatomic) IBOutlet UIButton *ExpandButton;
@property (strong,nonatomic) HistoryManager *historyManager;
@property (weak, nonatomic) IBOutlet UITableView *HistoryTableView;
@property (nonatomic) BOOL videoPlayingStatus;

- (IBAction)GoPressed:(id)sender;
- (IBAction)AddPressed:(id)sender;

@end

