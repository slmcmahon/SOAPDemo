//
//  SearchResultsViewController.m
//  SOAPDemo
//
//  Created by Stephen McMahon on 3/3/12.
//

#import "SearchResultsViewController.h"

@implementation SearchResultsViewController
@synthesize items = _items;

- (void)dealloc {
    [_items release];
    [super dealloc];
}

- (void)viewDidLoad {
    [self setTitle:@"Results"];
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    
    return cell;
}

@end
