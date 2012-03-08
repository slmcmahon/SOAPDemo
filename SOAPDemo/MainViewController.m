//
//  MainViewController.m
//  SOAPDemo
//
//  Created by Stephen McMahon on 3/3/12.
//

#import "MainViewController.h"
#import "MetaSearchService.h"
#import "SearchResultsViewController.h"

@interface MainViewController(local)
- (void)performSearch;
@end

@implementation MainViewController
@synthesize searchField = _searchField;
@synthesize metaSearchService = _metaSearchService;
@synthesize hud = _hud;

- (void)dealloc {
    [_searchField release];
    [_metaSearchService release];
    [_hud release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _metaSearchService = [[MetaSearchService alloc] init];
        [_metaSearchService setDelegate:self];
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return self;
}

- (void)viewDidLoad {
    self.title = @"Search";
    [super viewDidLoad];
}

- (IBAction)search:(id)sender {
    [self performSearch];
}

- (void)performSearch {
    // dismiss the keyboard
    [_searchField resignFirstResponder];
    
    // setup progress indicator
    _hud.labelText = @"Searching...";
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    _metaSearchService.searchTerm = _searchField.text;
    [_metaSearchService performMetaSearch];
}

- (void)metaSearchComplete:(MetaSearchService *)service {
    [_hud hide:YES];
    
    if (!_metaSearchService.success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service Failure" 
                                                        message:[NSString stringWithFormat:@"Service Error: %@", _metaSearchService.statusMessage]
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    SearchResultsViewController *results = [[SearchResultsViewController alloc] 
                                            initWithNibName:@"SearchResultsViewController" bundle:nil];
    
    [results setItems:_metaSearchService.results];
    [self.navigationController pushViewController:results animated:YES];
    [results release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [_searchField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    // just added this as a convenience.  Might be bad form for an app with multiple UITextFields
    [self performSearch];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
