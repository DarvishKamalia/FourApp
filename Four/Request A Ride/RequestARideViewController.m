//
//  RequestARideViewController.m
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "RequestARideViewController.h"
#import "PopUpViewController.h"

#import "RideAnnotation.h"
#import "DataManager.h"

@interface RequestARideViewController () <UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

// IBOutlets
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) UISearchBar* searchBar;

@property (strong, nonatomic) CLGeocoder* geocoder;
@property (strong, nonatomic) CLLocationManager* manager;

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
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager requestWhenInUseAuthorization];

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.manager startUpdatingLocation];
        self.mapView.showsUserLocation = YES;
    }
}

- (void) fetchInitialRides:(CLLocation *) location
{    
    [[DataManager sharedManager] getRidesStartingNear:location within:5 block:^(NSArray *rides, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (Ride* object in rides) {
                RideAnnotation* ride = [[RideAnnotation alloc] initWithRide:object];
                [self.initialAnnotations addObject:ride];
            }
            [self.mapView addAnnotations:self.initialAnnotations];
        });
    }];
}

#pragma mark - CLLocation Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    [self.manager stopUpdatingLocation];
    [self fetchInitialRides:location];
}

#pragma mark - Map View Delegate

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Select annotation view
    
    if ([view.annotation isKindOfClass:[RideAnnotation class]]) {
        RideAnnotation* annotation = (RideAnnotation *)view.annotation;
        Ride * ride = annotation.ride;
        [self performSegueWithIdentifier:@"rideDetailsSegue" sender:ride];
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"rideDetailsSegue"]) {
        PopUpViewController* vc = segue.destinationViewController;
        vc.ride = sender;
    }
}


#pragma mark - UISearch Bar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Search the map for location and latitide
    [self.geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        // for each placemark, find the destination rides
        for (CLPlacemark* placemark in placemarks) {
            CLLocation *location = placemark.location;
            [[DataManager sharedManager] getRidesEndingNear:location within:5 block:^(NSArray *rides, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotations:self.initialAnnotations];
                    for (Ride* object in rides) {
                        RideAnnotation* ride = [[RideAnnotation alloc] initWithRide:object];
                        [self.mapView addAnnotation:ride];
                    }
                });
            }];
        }
    }];
    
    // Dismiss the search bar
    [searchBar resignFirstResponder];
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

-(NSMutableArray<RideAnnotation *> *)initialAnnotations
{
    if (!_initialAnnotations) {
        _initialAnnotations = [[NSMutableArray alloc] init];
    }
    return _initialAnnotations;
}

@end
