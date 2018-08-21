//
//  Tab.h
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol TabDelegate;

@interface Tab : NSObject <UIWebViewDelegate>{
    UIWebView *webView;
}


@property(strong,nonatomic) IBOutlet UIWebView *tabWebView;
@property (nonatomic, weak) id<TabDelegate> delegate;
@property (nonatomic) BOOL isLoading;
@property (strong,nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSString *pageTitle;

@property(nonatomic) UIViewController *mainViewController;

- (id) initWithSuperView: (UIView*)Pview;
- (void) GoWithText: (NSString*) text;
- (void) setActive: (BOOL)status;

@end



@protocol TabDelegate <NSObject>

- (void)didChangeRefreshStatusWithLoadingStatus:(bool)status;
- (void)webPageTitleDidChange:(NSString*)title;
- (void) nextAndPreviousStatusChangeWithNextSatus:(bool) nextStatus andPreviousStatus: (bool) previousStatus;
- (void) pageDoneLoading:(Tab*) tab;
@end
