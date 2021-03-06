//
//  LHPSessionManager.h
//  LivreHeros
//
//  Created by Ancil on 6/28/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString* const kLHPSessionManagerXMLDownloadCompleteNotification;
extern NSString* const kLHPSessionManagerXMLDownloadErrorNotification;

@interface LHPSessionManager : NSObject
+(instancetype)sharedInstance;
-(void)downloadXMLFile;
- (NSURL *)appDocumentsURL;

@end
