//
//  ViewController.m
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//


#import "ViewController.h"

@interface ViewController()

@end

@implementation ViewController

@synthesize tabs = _tabs;
@synthesize tabAreaView = _tabAreaView;
@synthesize tabManager = _tabManager;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    return self;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void) customInit
{
    self.tabs = [NSMutableArray array];
    self.HistoryTableView.rowHeight = UITableViewAutomaticDimension;
    self.HistoryTableView.estimatedRowHeight = 44.0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_historyManager = [[HistoryManager alloc] init];
    //_HistoryTableView.hidden = true;
    //_HistoryTableView.delegate = _historyManager;
    //_HistoryTableView.dataSource = _historyManager;
    
    _tabManager = [[TabManager alloc] initWithCollectionView:_tabTilesCollectionView];
    _tabManager.delegate = self;
    _tabTilesCollectionView.delegate = _tabManager;
    _tabTilesCollectionView.dataSource = _tabManager;
    
    UIView * statusBarView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:statusBarView];
    // Do any additional setup after loading the view, typically from a nib.
    [_adressBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addTab];
    _adressBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    _refreshButton = [_refreshButton initWithImage:[UIImage imageNamed:@"Refresh-24.png"] style:UIBarButtonItemStyleDone target:self action:@selector(refresh:)];
    [self.view sendSubviewToBack:_tabAreaView];
    //[_interactiveTabBar setHidden:true];
    _interactiveTabBar.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.8];
    [_tileLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_tabTilesCollectionView setPagingEnabled:
     YES];
}



- (IBAction)refresh:(id)sender {
    [_activeTab.tabWebView reload];
}

- (IBAction)stopRefresh:(id)sender {
    [_activeTab.tabWebView stopLoading];
}

- (void) orientationChanged:(NSNotification *)note
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    UIView * statusBarView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenHeight , 20)];
    statusBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackPressed:(id)sender {
    [_activeTab.tabWebView goBack];
}

- (IBAction)ForwardPressed:(id)sender {
    [_activeTab.tabWebView goForward];
}


- (IBAction)GoPressed:(id)sender {
    NSString *typedText = _adressBar.text;
    [_adressBar endEditing:YES];
    [_activeTab GoWithText:typedText];
}

- (IBAction)AddPressed:(id)sender {
    [self addTab];
}


- (void) addTab
{
    Tab *newTab = [[Tab alloc] initWithSuperView: _tabAreaView];
    [_tabs addObject:newTab];
    newTab.delegate = self;
    [newTab setActive:true];
    if(_activeTab != nil)
    {
        [_activeTab setActive:false];
    }
    _activeTab = newTab;
    [_tabManager addTileWithTab:newTab];
}


-(void) tabClosed:(Tab *)tab
{
    NSLog(@"%@",tab);
    NSLog(@" activeTab %@",_activeTab);
    if([tab isEqual:_activeTab]){
        NSLog(@"need change tab");
        NSUInteger index = [_tabs indexOfObject:tab];
        NSLog(@"%lu", (unsigned long)index);
        if(index == 0)
        {
            [self tabSelected:_tabs[1]];
        }
        else
        {
            NSLog(@"new tab %@",(_tabs[(index - 1)]));
            [self tabSelected:_tabs[(index - 1)]];
        }
    }
    [tab setActive:false];
    [_tabs removeObject: tab];
    NSLog(@"%@",_tabs);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _adressBar.text = _activeTab.tabWebView.request.URL.absoluteString;
    _adressBar.textAlignment = NSTextAlignmentLeft;
    [textField selectAll:self];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _adressBar.text = [_activeTab.tabWebView stringByEvaluatingJavaScriptFromString:@"document.title;"];
    _adressBar.textAlignment = NSTextAlignmentCenter;
}

- (NSMutableArray *) tabs
{
    if (!_tabs) {
        _tabs = [NSMutableArray new];
    }
    return _tabs;
}

- (void) setActiveTab: (Tab*)tab
{
    _activeTab = tab;
    [tab setActive:true];
    _adressBar.text = [_activeTab.tabWebView stringByEvaluatingJavaScriptFromString:@"document.title;"];
    _adressBar.textAlignment = NSTextAlignmentCenter;
    [self didChangeRefreshStatusWithLoadingStatus: tab.isLoading];
    [self nextAndPreviousStatusChangeWithNextSatus:tab.tabWebView.canGoForward andPreviousStatus:tab.tabWebView.canGoBack];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *typedText = _adressBar.text;
    [_adressBar endEditing:YES];
    [_activeTab GoWithText:typedText];
    
    return YES;
}

- (void) didChangeRefreshStatusWithLoadingStatus:(bool)isLoading
{
    if(isLoading)
    {
        _refreshButton = [_refreshButton initWithImage:[UIImage imageNamed:@"Stop-24.png"] style:UIBarButtonItemStyleDone target:self action:@selector(stopRefresh:)];
    }
    else
    {
        _refreshButton = [_refreshButton initWithImage:[UIImage imageNamed:@"Refresh-24.png"] style:UIBarButtonItemStyleDone target:self action:@selector(refresh:)];
    }
}

- (void) nextAndPreviousStatusChangeWithNextSatus:(bool) nextStatus andPreviousStatus: (bool) previousStatus
{
    if (nextStatus == TRUE)
    {
        [_forwardButton setEnabled:TRUE];
    }
    else
    {
        [_forwardButton setEnabled:FALSE];
    }
    if (previousStatus == TRUE)
    {
        [_backButton setEnabled:TRUE];
    }
    else
    {
        [_backButton setEnabled:FALSE];
    }
    
}

- (void) webPageTitleDidChange:(NSString*)title
{
    if(_adressBar.isFocused)
    {
        [_adressBar setText:title];
    }
}
- (IBAction)showTabBar:(id)sender {
    [_ExpandButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    NSLog(@"%@",self);
    [_ExpandButton addTarget:self action:@selector(hideTabBar:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:.5 delay:0.0 options:0.0
                     animations:^{
                         self->_interactiveTabBar.transform = CGAffineTransformTranslate ( self->_interactiveTabBar.transform, 0.0, 300 );
                     }
                     completion:nil];
    [UIView animateWithDuration:.5 delay:0.0 options:0.0
                     animations:^{
                         self->_ExpandButton.transform = CGAffineTransformRotate(self->_ExpandButton.transform, M_PI);
                     }
                     completion:nil];
}

- (IBAction)hideTabBar:(id)sender
{
    [_ExpandButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    NSLog(@"%@",self);
    [_ExpandButton addTarget:self action:@selector(showTabBar:) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:.5 delay:0.0 options:0.0
                     animations:^{
                         self->_interactiveTabBar.transform = CGAffineTransformTranslate ( self->_interactiveTabBar.transform, 00.0, -300 );
                     }
                     completion:nil];
    
    [UIView animateWithDuration:.5 delay:0.0 options:0.0
                     animations:^{
                         self->_ExpandButton.transform = CGAffineTransformRotate(self->_ExpandButton.transform, M_PI);
                     }
                     completion:nil];
}

- (void) pageDoneLoading:(Tab *)tab
{
    [_tabManager updateTabInfo: tab];
    [self textFieldDidEndEditing:_adressBar];
    //    [_historyManager addEntryWithTitle:tab.pageTitle andUrlString:tab.tabWebView.request.URL.absoluteString];
}



-(void) tabSelected:(Tab *)tab
{
    [self hideTabBar:self];
    NSLog(@"invoked ViewController");
    for (NSObject* tabAvailable in _tabs)
    {
        if([((Tab*)tabAvailable) isEqual:tab])
        {
            [self setActiveTab: (Tab*)tab];
        }
        else
        {
            [((Tab*)tabAvailable) setActive:false];
        }
    }
    
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint(_interactiveTabBar.bounds, point))
    {
        [self hideTabBar:nil];
        return YES;
    }
    return NO;
}

@end
