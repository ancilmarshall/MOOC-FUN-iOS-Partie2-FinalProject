//
//  LHPSessionManager.m
//  LivreHeros
//
//  Created by Ancil on 6/28/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPSessionManager.h"


static NSString* const LHPServerScheme = @"http";
static NSString* const LPHServerHost = @"lip6.fr";
static NSString* const LPHServerPath = @"/Fabrice.Kordon/MOOC/histoire.xml";


@interface LHPSessionManager() <NSURLSessionDownloadDelegate, NSURLSessionDelegate>


@end

@implementation LHPSessionManager

#pragma mark - Initialization

+(instancetype) sharedInstance;
{
    static LHPSessionManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LHPSessionManager alloc] initSingleton];
    });
    return instance;
}

-(instancetype)initSingleton;
{
    self = [super init];
    if (self){
        // do more here if required
    }
    return self;
}

#pragma mark - NSURL Session Download
-(void)downloadXMLFile;
{
    NSURL* url = [self NSURLComponentsWithQueryItems:nil].URL;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request
                                            completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [data writeToFile:[[self appDocumentsURL] path] atomically:YES];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [task resume];

}


#pragma mark - NSURL construction
-(NSURLComponents*)NSURLComponentsWithQueryItems:(NSArray*)queryItems;
{
    
    NSURLComponents* components = [[NSURLComponents alloc] init];
    components.scheme = LHPServerScheme;
    components.host = LPHServerHost;
    components.path = LPHServerPath;
    components.queryItems = queryItems;
    
    return  components;
}


#pragma mark - NSURLSessionDownloadDelegate
/*
 * This function gets called when the download task is complete. Here we must move
 * the data from the temporary url to a permanent location in the app's container
 * This can be called in the background or foreground.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location;
{
    NSLog(@"In the NSURLSessionDownloadDelegate function");
    
    NSError* error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:[location path] toPath:[[self appDocumentsURL] path] error:&error];
    
    if (error){
        NSLog(@"Error copying downloaded file: %@",error.localizedDescription);
    }
}

- (NSURL *)appDocumentsURL
{
    NSError* directoryError;
    NSURL* directory = [[NSFileManager defaultManager]
                        URLForDirectory:NSDocumentDirectory
                        inDomain:NSUserDomainMask
                        appropriateForURL:nil
                        create:NO
                        error:&directoryError];
    
    if (directoryError){
        NSAssert(NO,@"Error opening a directory in the User's Documents directory");
    }
    
    NSURL* fileURL = [[directory URLByAppendingPathComponent:
                       [NSString stringWithFormat:@"book"]]
                      
                      URLByAppendingPathExtension:@"xml"];
    return fileURL;
}





@end
