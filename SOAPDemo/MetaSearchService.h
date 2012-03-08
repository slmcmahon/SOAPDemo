//
//  MetaSearch.h
//  SOAPDemo
//
//  Created by Stephen McMahon on 3/3/12.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "MetaSearchServiceDelegate.h"

extern NSString *const META_SEARCH_URL;
extern NSString *const META_SEARCH_SOAP;
extern NSString *const META_SEARCH_SOAP_ACTION;

@interface MetaSearchService : NSObject<ASIHTTPRequestDelegate,NSXMLParserDelegate> {
    NSMutableString *currentString;
}
@property (nonatomic, assign) id<MetaSearchServiceDelegate> delegate;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSString *searchTerm;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, assign) BOOL success;

-(void)performMetaSearch;
@end
