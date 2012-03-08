//
//  MetaSearchDelegate.h
//  SOAPDemo
//
//  Created by Stephen McMahon on 3/3/12.
//

#import <Foundation/Foundation.h>

@class MetaSearchService;

@protocol MetaSearchServiceDelegate <NSObject>
- (void)metaSearchComplete:(MetaSearchService *)service;
@end
