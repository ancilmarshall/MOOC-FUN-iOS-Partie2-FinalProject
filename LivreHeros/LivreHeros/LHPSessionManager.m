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
NSString* const kLHPSessionManagerXMLDownloadCompleteNotification =
    @"LHPSessionManagerXMLDownloadCompleteNotification";
NSString* const kLHPSessionManagerXMLDownloadErrorNotification =
    @"LHPSessionManagerXMLDownloadErrorNotification";


#if 0 && defined(DEBUG)
#define SESSION_MANAGER_LOG(format, ...) NSLog(@"Server Manager: " format, ## __VA_ARGS__)
#else
#define SESSION_MANAGER_LOG(format, ...)
#endif

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

//compare downloaded file to file in app
// if no file exists -> use downloaded file
//                   -> parse
// if file is different -> use new file (user confirmation required )
//                   -> parse
// if file is same -> discard downloaded file
//                 ->  don't parse


#pragma mark - NSURL Session Download
-(void)downloadXMLFile;
{
    NSURL* url = [self NSURLComponentsWithQueryItems:nil].URL;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request
                                            completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            SESSION_MANAGER_LOG(@"Download complete");
            
            if (![response isKindOfClass:[NSHTTPURLResponse class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kLHPSessionManagerXMLDownloadErrorNotification object:nil];
            }
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
            
            if (error!=nil)
            {
                if (httpResp.statusCode == 200){
                    
                    NSURL* appURL = [self appDocumentsURL];
                    
                    //TODO: probably a neater way to do this
                    //if file does not exist, use downloaded data
                    if(![[NSFileManager defaultManager] fileExistsAtPath:[appURL path]]){
                        [data writeToFile:[[self appDocumentsURL] path] atomically:YES];
                        
                        //post a notification when file is done
                        SESSION_MANAGER_LOG(@"Download complete, new file, posting notification");
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLHPSessionManagerXMLDownloadCompleteNotification
                                                                            object:nil];
                    }
                    else // file exists, check for equality
                    {
                        NSString* currentFileContents =
                        [NSString stringWithContentsOfURL: appURL
                                                 encoding: NSUTF8StringEncoding
                                                    error: NULL];
                        
                        NSString* downloadedFileContents =
                        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        
                        //if files are equal, do nothing, otherwise, save new data
                        if ( ![currentFileContents isEqualToString:downloadedFileContents]){
                            [data writeToFile:[[self appDocumentsURL] path] atomically:YES];
                            SESSION_MANAGER_LOG(@"Download complete, updated file, posting notification");
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:kLHPSessionManagerXMLDownloadCompleteNotification
                                                                                object:nil];
                        }
                    }
                    
                } else {
                    SESSION_MANAGER_LOG(@"Error in HTTP Repsonse\nStatus code: %tu",httpResp.statusCode);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLHPSessionManagerXMLDownloadErrorNotification object:nil];
                }
            } else {
                SESSION_MANAGER_LOG(@"Error in NSURLSessionTask\nError: %@\nHTTP Repsonse\nStatus code: %tu",
                      [error localizedDescription],httpResp.statusCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:kLHPSessionManagerXMLDownloadErrorNotification object:nil];
            }
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
    SESSION_MANAGER_LOG(@"In the NSURLSessionDownloadDelegate function");
    
    NSError* error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:[location path] toPath:[[self appDocumentsURL] path] error:&error];
    
    if (error){
        SESSION_MANAGER_LOG(@"Error copying downloaded file: %@",error.localizedDescription);
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

- (NSURL *)downloadedDocumentsURL
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
                       [NSString stringWithFormat:@"downloaded"]]
                      
                      URLByAppendingPathExtension:@"xml"];
    return fileURL;
}


@end
