//
//  RequestARideViewController.m
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "RequestARideViewController.h"
#import "RideAnnotation.h"

@interface RequestARideViewController () <UISearchBarDelegate, MKMapViewDelegate>

// IBOutlets
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) UISearchBar* searchBar;

@property (strong, nonatomic) CLGeocoder* geocoder;

// Store all the annotations which we initially request, when the view loads
@property (strong, nonatomic) NSMutableArray<RideAnnotation *>* initialAnnotations;

@end

@implementation RequestARideViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title
    self.title = @"Four";
    
    // The title view is the search bar
    self.navigationItem.titleView = self.searchBar;
    
    
    // When the view initially loads, then request for a bunch of rides
    // starting near you. Pass all of these rides object, to the MKAnnotation
    
    
}

#pragma mark - Map View Delegate

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

#pragma mark - UISearch Bar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Search the map for location and latitide
    [self.geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        // for each placemark, find the destination rides
        for (CLPlacemark* placemark in placemarks) {
            CLLocationCoordinate2D coordinate = placemark.location.coordinate;
            
            
        }
    }];
}

#pragma mark - Getter

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _searchBar.barStyle = UIBarStyleBlackTranslucent;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"Search for destination location";
    }
    return _searchBar;
}

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

@end
