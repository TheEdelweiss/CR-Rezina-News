//
//  TEDAboutViewController.m
//  CR Rezina
//
//  Created by Popa Stefan on 3/10/13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDAboutViewController.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"

@interface TEDAboutViewController ()

@end

@implementation TEDAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    // ---------------
    
    // frame for articles scroller
    CGRect scrollerFrame =
    CGRectMake(0, 0, screenWidth, screenHeight -
               self.navigationController.navigationBar.frame.size.height);
    // ---------------
    
    
	MGScrollView *scroller = [[MGScrollView alloc] initWithFrame: scrollerFrame];
    scroller.alwaysBounceVertical = YES;
    // ---------------------------------
    scroller.backgroundColor = [UIColor clearColor];
    [self.view addSubview: scroller];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"home.png"]
                                                                   style: UIBarButtonItemStylePlain
                                                                  target: self
                                                                  action: @selector(goBack)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject: homeButton];
    
    // fonts styles
    UIFont *titleFont = [UIFont fontWithName: @"OpenSans-Bold"
                                        size: 14];
    UIFont *contentFont = [UIFont fontWithName: @"OpenSans-SemiboldItalic"
                                          size: 12];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"About"
                                                          ofType: @"plist"];
    // Build the array from the plist
    NSArray* plistData = [[NSArray alloc] initWithContentsOfFile: plistPath];
    
    for (NSDictionary *item in plistData) {
    
        MGStyledBox *box = [MGStyledBox box];
        
        NSString *title = [[NSString alloc]initWithFormat: @"%@",
                           [item objectForKey: @"boxTitle"]];
        
        MGBoxLine *titleLine = [MGBoxLine multilineWithText: title
                                                       font: titleFont
                                                    padding: 14];
        titleLine.linePadding = 6;
        titleLine.itemPadding = 0;
        [box.middleLines addObject: titleLine];
        
        
        NSString *content = [[NSString alloc]initWithFormat: @"%@",
                             [item objectForKey: @"boxContent"]];
        
        MGBoxLine *shortContentLine = [MGBoxLine multilineWithText: content
                                                              font: contentFont
                                                           padding: 14];
        shortContentLine.linePadding = 6;
        shortContentLine.itemPadding = 0;
        [box.middleLines addObject: shortContentLine];
        
        [scroller.boxes addObject: box];
        
    }
    [scroller drawBoxesWithSpeed: 0.6];
    [scroller flashScrollIndicators];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
