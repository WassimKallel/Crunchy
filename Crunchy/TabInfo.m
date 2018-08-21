//
//  TabInfo.m
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//

#import "TabInfo.h"

@implementation TabInfo
@synthesize screenShot = _screenShot;

- (id) initWithTab:(Tab*)tab
{
    self = [super init];
    if(self)
    {
        self.tab = tab;
        self.title = @"new Tab";
        _screenShot = [[UIImage alloc] init];
        _tempWebView = [[UIWebView alloc] init];
        [_tempWebView setDelegate: self];
    }
    return self;
}

- (void) updateScreenShot
{
    CGFloat sideLength;
    if (_tab.tabWebView.bounds.size.height > _tab.tabWebView.bounds.size.width)
    {
        sideLength = _tab.tabWebView.bounds.size.width;
    }
    else
    {
        sideLength = _tab.tabWebView.bounds.size.height;
    }
    
    _tempWebView.frame = CGRectMake(0, 0, sideLength, sideLength);
    [_tempWebView setHidden:false];
    [_tempWebView loadRequest: _tab.request];
}


- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    UIGraphicsBeginImageContext(webView.frame.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [webView.layer renderInContext:c];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@",image);
    _screenShot = image;
    NSLog(@"working");
    [_delegate reloadRequired];
}



@end
