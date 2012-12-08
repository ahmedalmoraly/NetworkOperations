#import "NetworkOperationsAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kNetworkOperationsAPIBaseURLString = @"<# API Base URL #>";

@implementation NetworkOperationsAPIClient

+ (NetworkOperationsAPIClient *)sharedClient {
    static NetworkOperationsAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kNetworkOperationsAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
