//
//  TabInfo.h
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tab.h"

@protocol TabInfoDelegate;

@interface TabInfo : NSObject <UIWebViewDelegate>{
    UIWebView *webView;
}
@property(strong,nonatomic) NSString* title ;
@property(strong,nonatomic) UIImage* screenShot ;
@property(strong,nonatomic) Tab* tab;
@property(retain,nonatomic) UIWebView* tempWebView;
@property (nonatomic, weak) id<TabInfoDelegate> delegate;


- (id) initWithTab:(Tab*)tab;
- (void) updateScreenShot;
@end

@protocol TabInfoDelegate <NSObject>

- (void)reloadRequired;

@end
