//
//  AppDelegate.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface AppDelegate ()
@property (nonatomic,strong,readwrite) NSManagedObjectContext* managedObjectContext;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSURL* storeURL = [self SQLiteStoreURL];
    self.managedObjectContext = [self contextForStoreAtURL:storeURL];
    return YES;
}

#pragma mark - Shared AppDelegate helper function
+ (AppDelegate*) sharedDelegate;
{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    NSAssert([delegate isKindOfClass:[AppDelegate class]], @"Expected to use our app delegate class");
    return (AppDelegate *)delegate;
    
}

# pragma mark - CoreData helper functions
- (NSURL *)SQLiteStoreURL;
{
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask];
    NSAssert([URLs count] > 0, @"Expected to find a document URL");
    NSURL *documentDirectory = URLs[0];
    return [[documentDirectory URLByAppendingPathComponent:@"livreHeros"]
            URLByAppendingPathExtension:@"sqlite"];
}

- (NSManagedObjectContext*)contextForStoreAtURL:(NSURL *)storeURL;
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSError *error = nil;
    NSString *storeType = (storeURL == nil) ? NSInMemoryStoreType : NSSQLiteStoreType;
    if (![psc addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Couldn't add store (type=%@): %@", storeType, error);
        return nil;
    }
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;
    return moc;
}


@end
