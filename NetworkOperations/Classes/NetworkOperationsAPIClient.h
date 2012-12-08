#import "AFHTTPClient.h"

@interface NetworkOperationsAPIClient : AFHTTPClient

+ (NetworkOperationsAPIClient *)sharedClient;

@end
