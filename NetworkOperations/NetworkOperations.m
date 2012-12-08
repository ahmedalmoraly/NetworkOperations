//
//  NetworkOperations.m
//  NetworkOperations
//
//  Created by Ahmad al-Moraly on 12/8/12.
//  Copyright (c) 2012 Innovaton. All rights reserved.
//

#import "NetworkOperations.h"

/**
 * The baseURl to be used in constructing all the requests.
 *
 * change this to be the name of the Base URL of your server.
 */

NSString * const kNetworkBaseURLString = @"http://beta.jawalk.ws/API/Show";

static NSString * const kNetworkOperationsAPIBaseURLString = @"http://imontada.net";


@interface NetworkOperation ()

+(NSMutableURLRequest *)requestWithMethod:(HTTPRequestMethod)requestMethod
                            andParameters:(NSDictionary *)parameters;


+(AFHTTPRequestOperation *)operationWithRequest:(NSURLRequest *)request
                                       progress:(void (^)(NSInteger, NSInteger, NSInteger))progress
                                        success:(void (^)(id))success
                                        failure:(void (^)(NSError *))failure;

+(NSMutableURLRequest *)imageUploadRequestWithImage:(UIImage *)image
                                           withName:(NSString *)name
                                               path:(NSString *)url
                                         parameters:(NSDictionary *)parameters;

+(NSURLRequest *)fileUploadRequestWithfilePath:(NSString *)filePath
                                          name:(NSString *)name
                                          path:(NSString *)url
                                    parameters:(NSDictionary *)parameters;

+(NSMutableURLRequest *)imagesUploadRequestWithImages:(NSArray *)images withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters;

+(NetworkOperation *)sharedClient;

+(NSString *)mimeTypeForFileURL:(NSURL *)fileURL;

@end

@implementation NetworkOperation


+(void)startReachabilityNotificationWithObserver:(id)observer andSelector:(SEL)selector {
    [self sharedClient];
    //[[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:AFNetworkingReachabilityDidChangeNotification object:nil];
}


+(void)stopReachabilityNotificationWithObserver:(id)observer {
    //[[NSNotificationCenter defaultCenter] removeObserver:observer name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

#pragma mark -
#pragma mark - Public API
+(AFHTTPRequestOperation *)operationWithParamerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod andSuccessBlock:(void (^)(id))success {
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod andParameters:parameters];
    return [self operationWithRequest:request progress:nil success:success failure:nil];
}

+(AFHTTPRequestOperation *)operationWithPath:(NSString *)url Paramerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod andSuccessBlock:(void (^)(id))success
{
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod path:url andParameters:parameters];
    return [self operationWithRequest:request progress:nil success:success failure:nil];
}

+(AFHTTPRequestOperation *)operationWithParamerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod andParameters:parameters];
    return [self operationWithRequest:request progress:nil success:success failure:failure];
}
+(AFHTTPRequestOperation *)operationWithPath:(NSString *)url Paramerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod path:url andParameters:parameters];
    return [self operationWithRequest:request progress:nil success:success failure:failure];
}

+(AFHTTPRequestOperation *)operationWithParamerters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod progressBlock:(void (^)(NSInteger, NSInteger, NSInteger))progress successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:requestMethod andParameters:parameters];
    return [self operationWithRequest:request progress:progress success:success failure:failure];
}

+(AFHTTPRequestOperation *)operationWithFullURL:(NSString *)url parameters:(NSDictionary *)parameters requestMethod:(HTTPRequestMethod)requestMethod successBlock:(void (^)(id))success andFailureBlock:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    switch (requestMethod) {
        case HTTPRequestMethodGET:
            [request setHTTPMethod:@"GET"];
            break;
        case HTTPRequestMethodPOST:
            [request setHTTPMethod:@"POST"];
        default:
            break;
    }
    
    return [self operationWithRequest:request progress:nil success:success failure:failure];
}

+(AFHTTPRequestOperation *)uploadFile:(NSString *)filePath withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters progress:(void (^)(NSInteger, NSInteger, NSInteger))progress success:(void (^)(id))success andFailure:(void (^)(NSError *))failure
{
    NSURLRequest *request = [self fileUploadRequestWithfilePath:filePath name:name path:url parameters:parameters];
    return [self operationWithRequest:request progress:progress success:success failure:failure];
}

+(AFHTTPRequestOperation *)uploadImage:(UIImage *)image withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters progress:(void (^)(NSInteger, NSInteger, NSInteger))progress success:(void (^)(id))success andFailure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self imageUploadRequestWithImage:image withName:name path:url parameters:parameters];
    
    return [self operationWithRequest:request progress:progress success:success failure:failure];
}

+(AFHTTPRequestOperation *)uploadImages:(NSArray *)images withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters progress:(void (^)(NSInteger, NSInteger, NSInteger))progress success:(void (^)(id))success andFailure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [self imagesUploadRequestWithImages:images withName:name path:url parameters:parameters];
    
    return [self operationWithRequest:request progress:progress success:success failure:failure];
}

#pragma
#pragma mark -
#pragma mark - Private API

+(NSMutableURLRequest *)requestWithMethod:(HTTPRequestMethod)requestMethod andParameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request;
    switch (requestMethod) {
        case HTTPRequestMethodGET:
            request = [[self sharedClient] requestWithMethod:@"GET" path:@"json_test.php?get=1" parameters:parameters];
            //[self sharedClient].parameterEncoding = AFFormURLParameterEncoding;
            break;
            
        case HTTPRequestMethodPOST:

            [self sharedClient].parameterEncoding = AFJSONParameterEncoding;
            request = [[self sharedClient] requestWithMethod:@"POST" path:@"json_test.php" parameters:parameters];
            break;
        default:
            request = nil;
            break;
    }
    
    return request;
}
+(NSMutableURLRequest *)requestWithMethod:(HTTPRequestMethod)requestMethod path:(NSString *)url andParameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request;
    switch (requestMethod) {
        case HTTPRequestMethodGET:
            request = [[self sharedClient] requestWithMethod:@"GET" path:url parameters:parameters];
            //[self sharedClient].parameterEncoding = AFFormURLParameterEncoding;
            break;
            
        case HTTPRequestMethodPOST:
            [self sharedClient].parameterEncoding = AFJSONParameterEncoding;
            request = [[self sharedClient] requestWithMethod:@"POST" path:url parameters:parameters];
            //
            break;
        default:
            request = nil;
            break;
    }
    
    return request;
}

+(AFHTTPRequestOperation *)operationWithRequest:(NSURLRequest *)request progress:(void (^)(NSInteger, NSInteger, NSInteger))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperation *operation = [[self sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Downloaded Response] %@\n", operation.responseString);
        
        if ([operation isKindOfClass:[AFJSONRequestOperation class]]) {
            // response was JSON no need to parse
            
            if ([responseObject valueForKeyPath:@"error"])
            {
                // error
                NSError *error = [NSError errorWithDomain:@"NetworkOperationJSONError" code:0 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"JSON did fail with error: %@", [responseObject objectForKey:@"error"]] forKey:NSLocalizedDescriptionKey]];
                
                if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Response ERROR] %@\n", error);
                if (failure) failure(error);
                
            }
            else
            {
                if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Parsed JSON Response] %@\n", responseObject);
                if (success) success(responseObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Downloading ERROR] %@\n", error);
        if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations Downloaded Response] %@\n", operation.responseString);
        if (failure) failure(error);
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (TURN_LOGGER_ON) NSLog(@"[NetworkOperations downloaded: %lld of %lld bytes]", totalBytesRead, totalBytesExpectedToRead);
        if (progress) progress(bytesRead, totalBytesRead, totalBytesExpectedToRead);
    }];
    
    [[self sharedClient] enqueueHTTPRequestOperation:operation];
    
    [operation addObserver:[self sharedClient] forKeyPath:@"isExecuting" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    
    return operation;
    
}


+(AFHTTPRequestOperation *)downloadFileWithURL:(NSString *)url withParameters:(NSDictionary *)parameters progress:(void (^)(NSInteger, NSInteger, NSInteger))progress fileSavingName:(NSString *)name success:(void (^)(NSString *filePath))success failure:(void (^)(NSError *))failure
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[self sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         
    {
        NSLog(@"[Network Operations File Downloaded Successfully]");
        // prepare file path to save
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *saveDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Downloads"];
 
        if (![fileManager fileExistsAtPath:saveDirectory])
        {
            [fileManager createDirectoryAtPath:saveDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *filename = (name) ? [name stringByAppendingPathExtension:operation.response.URL.pathExtension] : [operation.response.URL lastPathComponent];
        NSString *absolutePath = [saveDirectory stringByAppendingPathComponent:filename];
        
        if ([fileManager fileExistsAtPath:absolutePath])
        {
            absolutePath = [saveDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", filename, [NSDate date]]];
        }
        
        if ([fileManager createFileAtPath:absolutePath contents:operation.responseData attributes:nil]) {
            NSLog(@"File Saved to %@", absolutePath);
            if (success) {
                success(absolutePath);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"[Network Operations ERROR]: %@", error.description);
        if (failure) {
            failure(error);
        }
    }];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        NSLog(@"[Downloaded %lld of %lld bytes]", totalBytesRead, totalBytesExpectedToRead);
        if (progress) progress(bytesRead, totalBytesRead, totalBytesExpectedToRead);
    }];
    
    [[self sharedClient] enqueueHTTPRequestOperation:operation];
    return operation;
}



+(NSMutableURLRequest *)imageUploadRequestWithImage:(UIImage *)image withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters {
    
    NSString *mimeType;
    NSData *imageData = UIImagePNGRepresentation(image);
    mimeType = @"image/png";
    if (!imageData) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
        mimeType = @"image/jpg";
    }
    
    NSMutableURLRequest *request = [[self sharedClient] multipartFormRequestWithMethod:@"POST" path:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {    
        [formData appendPartWithFileData:imageData name:name fileName:@"uploadedImage.png" mimeType:mimeType];
    }];
    
    return request;
}

+(NSURLRequest *)fileUploadRequestWithfilePath:(NSString *)filePath name:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters
{
    filePath = [filePath stringByExpandingTildeInPath];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];

    NSMutableURLRequest *request = [[self sharedClient] multipartFormRequestWithMethod:@"POST" path:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileURL:fileUrl name:name error:nil];
    }];
    return request;

}

+(NSMutableURLRequest *)imagesUploadRequestWithImages:(NSArray *)images withName:(NSString *)name path:(NSString *)url parameters:(NSDictionary *)parameters {
    
    NSMutableURLRequest *request = [[self sharedClient] multipartFormRequestWithMethod:@"POST" path:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (UIImage *image in images)
        {
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            [array addObject:imageData];
        }
        
        [formData appendPartWithArrayOfFiles:array name:name fileName:@"uploadedImage.jpg" mimeType:@"image/jpg"];
        
    }];
    return request;
}

+(NSString *)mimeTypeForFileURL:(NSURL *)fileURL
{
    //NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileUrl];
    NSURLRequest* fileUrlRequest = [[NSURLRequest alloc] initWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:.1];
    
    NSError* error = nil;
    NSURLResponse* response = nil;
    [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
    
 //   fileData; // Ignore this if you're using the timeoutInterval
    // request, since the data will be truncated.
    
    NSString* mimeType = [response MIMEType];
    
    return mimeType;
}

+(NetworkOperation *)sharedClient {
    static NetworkOperation *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kNetworkOperationsAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self)
    {
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Accept" value:@"text/json"];
        [self setDefaultHeader:@"Accept" value:@"text/html"];
        
        [AFHTTPRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/pdf", @"application/xml", @"audio/mp4a-latm", @"audio/mpeg", @"audio/mp3", @"video/x-m4v", @"video/mp4", nil]];
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        //self.parameterEncoding = AFJSONParameterEncoding;
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([object isKindOfClass:[NSOperation class]] && [keyPath isEqualToString:@"isExecuting"]) {
        AFURLConnectionOperation *operation = object;
        if (operation.isExecuting) {
            NSString *body = nil;
            if (operation.request.HTTPBody) {
                body = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
            }
            
            NSLog(@"[Network Operations Start Operation With URL: %@ Parameters: %@ Request Method: %@]", operation.request.URL, body, operation.request.HTTPMethod);   
        }
        else if (operation.isFinished || operation.isCancelled) {
            [operation removeObserver:self forKeyPath:keyPath];
        }
    }
}


@end