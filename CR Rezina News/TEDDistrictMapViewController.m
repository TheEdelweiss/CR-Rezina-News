//
//  TEDDistrictMapViewController.m
//  CR Rezina
//
//  Created by Stefan Popa on 15.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDDistrictMapViewController.h"
#import "NAMapView.h"
#import "NAAnnotation.h"

@interface TEDDistrictMapViewController ()

@end

@implementation TEDDistrictMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    // ------------------
    [super viewDidLoad];
    NAMapView *mapView = [[NAMapView alloc] initWithFrame:self.view.bounds];
    // ------------------
    
    // go home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"home.png"]
                                                                   style: UIBarButtonItemStylePlain
                                                                  target: self
                                                                  action: @selector(goBack)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject: homeButton];
    
    mapView.backgroundColor  = [UIColor clearColor];
  //  mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    mapView.minimumZoomScale = 0.5f;
    mapView.maximumZoomScale = 1.0f;
    
    // set centre on middle of map
    [mapView centreOnPoint: CGPointMake(693, 469) animated: YES];
    // load map image
    [mapView displayMap:[UIImage imageNamed:@"district_map"]];
    // add subview
    [self.view addSubview: mapView];

    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource: @"LocalitiesList"
                                                          ofType: @"plist"];
    // Build the array from the plist
    NSArray* plistData = [[NSArray alloc] initWithContentsOfFile: plistPath];
    
    // build annotations
    for (NSDictionary *item in plistData) {
        
        NAAnnotation *arrayItme = [NAAnnotation annotationWithPoint:
                                   CGPointMake([[item objectForKey: @"xPos"] floatValue],
                                               [[item objectForKey: @"yPos"] floatValue])];
        
        arrayItme.title = [item objectForKey: @"name"];
        arrayItme.subtitle = [item objectForKey: @"description"];
        
        if ([[item objectForKey: @"name"] isEqual:@"Rezina"]) {
            arrayItme.color = NAPinColorRed;
        }
        else if ([[item objectForKey: @"name"] isEqual:@"R - 13"] |
                 [[item objectForKey: @"name"] isEqual:@"R - 20"] |
                 [[item objectForKey: @"name"] isEqual:@"Cale Ferată"])
        {
            arrayItme.color = NAPinColorGreen;
        }
        else arrayItme.color = NAPinColorPurple;
       
        [mapView addAnnotation: arrayItme
                      animated: YES];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
