//
//  LHPScore.h
//  LivreHeros
//
//  Created by Ancil on 6/26/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LHPScore : NSManagedObject

@property (nonatomic, retain) NSNumber * scoreValue;
@property (nonatomic, retain) NSString * username;

@end
