//
//  Tab.m
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tab.h"



@implementation Tab


@synthesize tabWebView = _tabWebView;
@synthesize isLoading = _isLoading;


- (id) initWithSuperView: (UIView*)Pview
{
    self = [super init];
    if(self)
    {
        _tabWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [Pview frame].size.width,  [Pview frame].size.height)];
        [_tabWebView setContentMode:UIViewContentModeScaleAspectFill];
        _tabWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleHeight);
        [Pview addSubview: _tabWebView];
        NSURL *url = [NSURL URLWithString:@"http://google.com" relativeToURL:nil];
        _request = [NSURLRequest requestWithURL:url];
        [_tabWebView loadRequest:_request];
        [_tabWebView setHidden:false];
        _tabWebView.clipsToBounds = YES;
        _tabWebView.delegate = self;
        _pageTitle = [[NSString alloc] init];
        
    }
    return self;
}

- (void) GoWithText: (NSString*) text
{
    NSString *urlToLoad;
    NSRange posOfSpace = [text rangeOfString:@" "];
    if (posOfSpace.location == NSNotFound) {
        NSRange posOfDot = [text rangeOfString:@"."];
        if (posOfDot.location == NSNotFound) {
            urlToLoad = [self googleSearch:text];
        } else {
            NSRange posOfHttp = [text rangeOfString:@"http://"];
            if (posOfHttp.location == NSNotFound) {
                urlToLoad = [NSString stringWithFormat:@"http://%@",text];
            } else {
                urlToLoad = [NSString stringWithString:text];
            }
        }
    } else {
        urlToLoad = [self googleSearch:text];
    }
    NSURL *url = [NSURL URLWithString:urlToLoad];
    _request = [NSURLRequest requestWithURL:url];
    [_tabWebView loadRequest:_request];
}

- (NSString *) googleSearch: (NSString *) keyword{
    
    NSString *parameters = [keyword stringByReplacingOccurrencesOfString:@" "
                                                              withString:@"+"];
    
    NSString *urlToLoad = [NSString stringWithFormat:@"http://google.com/#q=%@",parameters];
    return urlToLoad;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_delegate nextAndPreviousStatusChangeWithNextSatus:[_tabWebView canGoForward] andPreviousStatus: [_tabWebView canGoBack]];
    _isLoading = false ;
    [self.delegate didChangeRefreshStatusWithLoadingStatus:false];
    _pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title;"];
    [self.delegate webPageTitleDidChange:[webView stringByEvaluatingJavaScriptFromString:@"document.title;"]];
    [self.delegate pageDoneLoading:self];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.delegate didChangeRefreshStatusWithLoadingStatus:false];
    _isLoading = false ;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.delegate webPageTitleDidChange:@"Loading ..."];
    [self.delegate didChangeRefreshStatusWithLoadingStatus:true];
    _isLoading = true ;
}

- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    return YES;
}

- (void)viewWillDisappear
{
    if ([_tabWebView isLoading])
        [_tabWebView stopLoading];
}

- (void)setActive:(BOOL)status
{
    NSLog(@"tabChange");
    if (status)
    {
        [_tabWebView setHidden:FALSE];
    }
    else
    {
        [_tabWebView setHidden:TRUE];
    }
}

-(void)setImageAsThumbnail:(UIImage*)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSLog(@"%@",imageData);
}

@end
