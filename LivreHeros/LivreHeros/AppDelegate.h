//
//  AppDelegate.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHPBookViewController;
@class LHPSettingsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic,readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong,readonly) LHPBookViewController* bookViewController;
@property (nonatomic,strong,readonly) LHPSettingsViewController* settingsViewController;

+ (AppDelegate*) sharedDelegate;
-(void)saveToPersistentStore;

@end

