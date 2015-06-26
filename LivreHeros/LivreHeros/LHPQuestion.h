//
//  LHPQuestion.h
//  LivreHeros
//
//  Created by Ancil on 6/26/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LHPBook;

@interface LHPQuestion : NSManagedObject

@property (nonatomic, retain) NSNumber * noIndexNSNumber;
@property (nonatomic, retain) NSNumber * indexNSNumber;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * yesIndexNSNumber;
@property (nonatomic, retain) LHPBook *book;

@end
