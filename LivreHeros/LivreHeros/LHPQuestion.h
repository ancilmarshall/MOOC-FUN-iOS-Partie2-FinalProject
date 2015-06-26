//
//  LHPQuestion.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LHPBook;

@interface LHPQuestion : NSManagedObject

@property (nonatomic, retain) NSNumber * questionID;
@property (nonatomic, retain) NSString * questionString;
@property (nonatomic, retain) NSNumber * noID;
@property (nonatomic, retain) NSNumber * yesID;
@property (nonatomic, retain) LHPBook *book;

@end
