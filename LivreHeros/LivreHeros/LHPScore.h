//
//  LHPScore.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LHPScore : NSManagedObject

@property (nonatomic, retain) NSString * usernameString;
@property (nonatomic, retain) NSNumber * scoreValue;

@end
