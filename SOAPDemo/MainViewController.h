//
//  MainViewController.h
//  SOAPDemo
//
//  Created by Stephen McMahon on 3/3/12.
//

#import <UIKit/UIKit.h>
#import "MetaSearchService.h"
#import "MBProgressHUD.h"

@class MBProgressHUD;

@interface MainViewController : UIViewController<MetaSearchServiceDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) MetaSearchService *metaSearchService;
@property (nonatomic, retain) MBProgressHUD *hud;

-(IBAction)search:(id)sender;

@end
