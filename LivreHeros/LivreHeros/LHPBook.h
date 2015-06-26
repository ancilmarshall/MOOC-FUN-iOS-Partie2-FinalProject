//
//  LHPBook.h
//  LivreHeros
//
//  Created by Ancil on 6/26/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LHPQuestion;

@interface LHPBook : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *questions;
@end

@interface LHPBook (CoreDataGeneratedAccessors)

- (void)insertObject:(LHPQuestion *)value inQuestionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromQuestionsAtIndex:(NSUInteger)idx;
- (void)insertQuestions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeQuestionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInQuestionsAtIndex:(NSUInteger)idx withObject:(LHPQuestion *)value;
- (void)replaceQuestionsAtIndexes:(NSIndexSet *)indexes withQuestions:(NSArray *)values;
- (void)addQuestionsObject:(LHPQuestion *)value;
- (void)removeQuestionsObject:(LHPQuestion *)value;
- (void)addQuestions:(NSOrderedSet *)values;
- (void)removeQuestions:(NSOrderedSet *)values;
@end
