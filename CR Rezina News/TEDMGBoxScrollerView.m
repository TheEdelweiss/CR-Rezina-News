//
//  TEDMGBoxScrollerView.m
//  CR Rezina
//
//  Created by Stefan Popa on 17.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDMGBoxScrollerView.h"

@implementation TEDMGBoxScrollerView
{
    MGScrollView *scroller;
}

@synthesize scrollerDataSource;
@synthesize scrollerDelegate;
@synthesize numberOfItemsInScroller;


- (void)buildAndStart
{
    CGRect frame = [scrollerDataSource scrollViewDimensions];
    scroller = [[MGScrollView alloc] initWithFrame:frame];
    [self addSubview:scroller];
    scroller.alwaysBounceVertical = YES;
    scroller.delegate = self;
    
    [self reloadData];
}


- (void) viewDidLoad
{
    
}

// -----------------------------------------------------------------------------

- (BOOL) reloadData
{
    [scroller.boxes removeAllObjects];
    self.numberOfItemsInScroller = [scrollerDataSource numberOfBoxesInScroller];
    
    if (self.numberOfItemsInScroller > 0)
    {
        for (int i = 0; i < self.numberOfItemsInScroller; i++)
        {
            MGBox *Box = [scrollerDataSource boxAtIndex: i];
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget: self
                                                    action: @selector(indexOfBox:)];
        
            [Box addGestureRecognizer: singleFingerTap];
            
                [scroller.boxes insertObject: Box
                                     atIndex: i];
        }
        
        [scroller drawBoxesWithSpeed: 0.6];
        [scroller flashScrollIndicators];
        return YES;
    }
    return NO;
}

// -----------------------------------------------------------------------------

- (void)removeBox: (UIButton *)sender
{
    [self parentBoxOf:sender];
}

// -----------------------------------------------------------------------------

- (NSInteger) indexOfBox:(UITapGestureRecognizer *) recognizer
{
    int i = [scroller.boxes indexOfObject: recognizer.view];
    
    if (i == NSNotFound)
    {
        return -1; // not found
    }
    
    else{
        [scrollerDelegate articlesViewController: self
                            didSelectItemAtIndex: i];  //send index to delegate
        return i;
    }
}

// -----------------------------------------------------------------------------

- (NSUInteger) tagOfParentBox: (UIView *)view
{
    return [self parentBoxOf:view].tag;
}

// -----------------------------------------------------------------------------

- (MGBox *) parentBoxOf:(UIView *)view
{
    while (![view.superview isKindOfClass:[MGBox class]])
    {
        if (!view.superview)
        {
            return nil;
        }
        
        view = view.superview;
    }
    return (MGBox *)view.superview;
}

// -----------------------------------------------------------------------------

- (UIButton *) buttonWithTitle:(NSString *)title forAction:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Bold"
                                             size: 14];
    
    [button setTitleColor: [UIColor colorWithWhite: 0.9
                                             alpha: 0.9]
                 forState: UIControlStateNormal];
    
    [button setTitleShadowColor: [UIColor colorWithWhite: 0.2
                                                   alpha: 0.9]
                       forState: UIControlStateNormal];
    
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    button.frame = CGRectMake(0, 0, 296, 34);
    
    [button setTitle: title
            forState: UIControlStateNormal];
    
    [button addTarget: self
               action: selector
     forControlEvents: UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
   
    button.backgroundColor = [UIColor colorWithRed: 0.29
                                             green: 0.32
                                              blue: 0.35
                                             alpha: 1];
    
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 1);
    
    button.layer.shadowRadius = 0.8;
    button.layer.shadowOpacity = 0.6;
    
    return button;
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

#pragma mark - UIScrollViewDelegate (for snapping boxes to edges)

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [(MGScrollView *)scrollView snapToNearestBox];
}

// -----------------------------------------------------------------------------

- (void)scrollViewDidEndDragging: (UIScrollView *)scrollView
                  willDecelerate: (BOOL)decelerate
{
    if (!decelerate)
    {
        [(MGScrollView *)scrollView snapToNearestBox];
    }
}

@end
