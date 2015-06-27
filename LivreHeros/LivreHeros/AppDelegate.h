//
//  AppDelegate.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic,readonly) NSManagedObjectContext* managedObjectContext;

+ (AppDelegate*) sharedDelegate;
-(void)saveToPersistentStore;

@end

