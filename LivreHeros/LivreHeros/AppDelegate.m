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
#import "LHPBook+LHPExtensions.h"
#import "LHPSettingsViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong,readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong,readwrite) LHPBookViewController* bookViewController;
@property (nonatomic,strong,readwrite) LHPSettingsViewController* settingsViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Core Data setup
    NSURL* storeURL = [self SQLiteStoreURL];
    self.managedObjectContext = [self contextForStoreAtURL:storeURL];
    
    //initialize the LHPBook singleton immediately after the moc is setup and on App launch
    (void)[LHPBook sharedInstance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    self.settingsViewController = [LHPSettingsViewController new];
    UINavigationController* settingsNavC = [[UINavigationController alloc]
                                            initWithRootViewController:self.settingsViewController];
    self.bookViewController = [LHPBookViewController new];
    UINavigationController* bookNavC = [[UINavigationController alloc]
                                        initWithRootViewController:self.bookViewController];
    
    
    //Check for device type and only use split view controller for the iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        UISplitViewController* splitVC = [[UISplitViewController alloc] init];
        splitVC.viewControllers = @[settingsNavC, bookNavC];
        self.window.rootViewController = splitVC;
    }else{
        UITabBarController* tabBarC = [[UITabBarController alloc] init];
        tabBarC.viewControllers = @[bookNavC,settingsNavC];
        self.window.rootViewController = tabBarC;
    }
        
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
