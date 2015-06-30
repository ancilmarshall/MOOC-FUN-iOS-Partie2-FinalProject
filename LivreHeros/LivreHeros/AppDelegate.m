//
//  AppDelegate.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "LHPBookViewController.h"
#import "LHPSettingsViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong,readwrite) NSManagedObjectContext* managedObjectContext;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Core Data setup
    NSURL* storeURL = [self SQLiteStoreURL];
    self.managedObjectContext = [self contextForStoreAtURL:storeURL];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //TODO: Check for device time and only use split view controller for the iPad or iPhone6+
    
    UIViewController* master = [LHPSettingsViewController new];
    UINavigationController* masterNavC = [[UINavigationController alloc] initWithRootViewController:master];
    
    UIViewController* detail = [LHPBookViewController new];
    UINavigationController* detailNavC = [[UINavigationController alloc] initWithRootViewController:detail];
    
    UISplitViewController* splitVC = [[UISplitViewController alloc] init];
    splitVC.viewControllers = @[masterNavC, detailNavC];
    
    //finish up window properties
    self.window.rootViewController = splitVC;
    [self.window makeKeyAndVisible];
    
    
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

-(void)saveToPersistentStore;
{
    // use performBlock to ensure that the block is performed on the correct queue of the moc
    [self.managedObjectContext performBlock:^{
        
        NSError* error = nil;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Problem saving context: %@",[error localizedDescription]);
        }
    }];
}

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
