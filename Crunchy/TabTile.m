//
//  TabTile.m
//  Crunchy
//
//  Created by Wassim Kallel on 8/15/18.
//  Copyright © 2018 Wassim Kallel. All rights reserved.
//


#import "TabTile.h"

@implementation TabTile
@synthesize label = _label;
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(130, 130);
        spinner.tag = 12;
        [spinner startAnimating];
        self.backgroundView = spinner;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 230, 25)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"new tab";
        [_label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [self.contentView addSubview: _label];
        CALayer *layer = self.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 15;
        layer.borderWidth = 2;
        layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void) setTabInfo:(TabInfo*) tabInfo
{
    _tabInfo = tabInfo;
    [self setLabelText:tabInfo.title];
    self.contentView.backgroundColor = [UIColor clearColor];
    if (![(tabInfo.screenShot) isEqual:[NSNull null]])
    {
        self.backgroundView = [[UIImageView alloc] initWithImage:tabInfo.screenShot];
    }
}
- (void) setLabelText:(NSString*) newLabel
{
    _label.text = newLabel;
}


float oldY;
BOOL dragging;

-(void) simpleTouch{
    if(dragging != true)
    {
        [_delegate tabSelected:_tabInfo];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    oldY = touchLocation.y;
    [self performSelector:@selector(simpleTouch) withObject: nil afterDelay:0.1];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    CGRect frame = self.frame;
    frame.origin.y =  self.frame.origin.y + touchLocation.y - oldY;
    frame.origin.x = self.frame.origin.x;
    if((frame.origin.y) < 25)
    {
        self.frame = frame;
    }
    dragging = true;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.frame.origin.y < -100)
    {
        NSLog(@"exceed");
        [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame  = CGRectMake(self.frame.origin.x, -250, self.frame.size.width,self.frame.size.height);
        } completion:^(BOOL finished) {
        }];
        if(![self.delegate tabTileClosed: self.tabInfo])
        {
            [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame  = CGRectMake(self.frame.origin.x, 25, self.frame.size.width,self.frame.size.height);
            } completion:^(BOOL finished) {
            }];
            
        }
        
    }
    else
    {
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame  = CGRectMake(self.frame.origin.x, 25, self.frame.size.width,self.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
    dragging = false;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame  = CGRectMake(self.frame.origin.x, 25, self.frame.size.width,self.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    NSLog(@"touchesCancelled");
    dragging = false;
}
@end

