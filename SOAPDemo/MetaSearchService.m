//
//  MetaSearch.m
//  SOAPDemo
//
//  Created by Stephen McMahon on 3/3/12.
//

#import "MetaSearchService.h"
#import "ASIHTTPRequest.h"

NSString *const META_SEARCH_URL = @"http://peopleask.ooz.ie/soap.wsdl";
NSString *const META_SEARCH_SOAP = 
    @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
    @"xmlns:soap=\"http://peopleask.ooz.ie/soap\">"
    @"<soapenv:Header/><soapenv:Body><soap:GetQuestionsAbout><soap:query>%@</soap:query>"
    @"</soap:GetQuestionsAbout></soapenv:Body></soapenv:Envelope>";
NSString *const META_SEARCH_SOAP_ACTION = @"http://peopleask.ooz.ie/soap/GetQuestionsAbout";

@implementation MetaSearchService
@synthesize delegate = _delegate;
@synthesize searchTerm = _searchTerm;
@synthesize success = _success;
@synthesize statusMessage = _statusMessage;
@synthesize request = _request;
@synthesize results = _results;

-(void) dealloc {
    [_searchTerm release];
    [_statusMessage release];
    [_results release];
    [_request cancel];
    [_request setDelegate:nil];
    [_request release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        _results = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)performMetaSearch {
    NSURL *url = [NSURL URLWithString:META_SEARCH_URL];
    NSString *soap = [NSString stringWithFormat:META_SEARCH_SOAP, _searchTerm];
    NSData *data = [soap dataUsingEncoding:NSUTF8StringEncoding];
    
    // remove records from any previous calls so that we don't keep appending.
    [_results removeAllObjects];
    
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setDelegate:self];
    [_request addRequestHeader:@"SOAPAction" value:META_SEARCH_SOAP_ACTION];
    [_request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [data length]]];
    [_request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [_request setRequestMethod:@"POST"];
    [_request setTimeOutSeconds:10];
    [_request appendPostData:data];
    [_request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    _success = YES;
    _statusMessage = [request responseStatusMessage];
    NSString *responseString = [request responseString];
    NSLog(@"Response: %@", responseString);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
    if (self.delegate && [self.delegate respondsToSelector:@selector(metaSearchComplete:)])
        [_delegate metaSearchComplete:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    _success = NO;
    _statusMessage = [request responseStatusMessage];
    if (self.delegate && [self.delegate respondsToSelector:@selector(metaSearchComplete:)])
        [_delegate metaSearchComplete:self];
}
/*
 * The XML Parsing for this one is really easy since all we care about is the 'item' elements.
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"item"]) {
        currentString = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        [_results addObject:currentString];
    }
    if (currentString) {
        [currentString release];
        currentString = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (currentString) {
        [currentString appendString:string];
    }
}

@end
