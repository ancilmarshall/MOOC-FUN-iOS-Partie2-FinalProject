//
//  LHPQuestion+LHPExtensions.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPQuestion+LHPExtensions.h"
#import "AppDelegate.h"

@implementation LHPQuestion (LHPExtensions)

# pragma mark - Entity Management
+(LHPQuestion*)insertQuestion:(NSString*)text index:(NSUInteger)index yesIndex:(NSUInteger)yesIndex noIndex:(NSUInteger)noIndex book:(LHPBook *)book;
{
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    LHPQuestion* question =
    [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LHPQuestion class]) inManagedObjectContext:moc];
    
    question.text = text;
    question.index = index;
    question.yesIndex = yesIndex;
    question.noIndex = noIndex;
    question.book = book; //make the relationship connection
    
    // use performBlock to ensure that the block is performed on the correct queue of the moc
    // which is unknown in this instance.
    [moc performBlock:^{
        
        NSError* error = nil;
        if (![moc save:&error])
        {
            NSLog(@"Problem saving context: %@",[error localizedDescription]);
        }
        
    }];
    
    return question;
}

+(LHPQuestion*)questionEntityForIndex:(NSUInteger)index;
{
    // There is no question with index 0. Indicates there are no more questions available. End of book
    if (index == 0) {
        return nil;
    }
    
    NSFetchRequest* fetchRequest = [NSFetchRequest
        fetchRequestWithEntityName:NSStringFromClass([self class])];
    fetchRequest.predicate = [NSPredicate
        predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(text)), @(index)];;
    
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    __block NSArray* fetchResult = nil;
    [moc performBlock:^{
        
        NSError* error = nil;
        fetchResult = [moc executeFetchRequest:fetchRequest error:&error];
        if (!fetchResult){
            NSLog(@"Error finding question for id: %tu, %@",index,[error localizedDescription]);
        }
        NSAssert([fetchResult count] == 1,@"Expected only one entity in the CoreData model");
        NSAssert([[fetchResult firstObject] isKindOfClass:[self class]],@"Expected fetch result to be this class");
    }];
    
    return (LHPQuestion*)[fetchResult firstObject];
    
}

+(NSString*)questionForIndex:(NSUInteger)index;
{
    if (index == 0) {
        return nil;
    } else {
        return [LHPQuestion questionEntityForIndex:index].text;
    }
}

+(NSUInteger)yesIndexForIndex:(NSUInteger)index;
{
    return [LHPQuestion questionEntityForIndex:index].yesIndex;
}

+(NSUInteger)noIndexForIndex:(NSUInteger)index;
{
    return [LHPQuestion questionEntityForIndex:index].noIndex;
}


#pragma mark - Simplification Accessor Methods

-(NSUInteger)index;
{
    return [self.indexNSNumber unsignedIntegerValue];
}

-(void)setIndex:(NSUInteger)index;
{
    self.indexNSNumber = @(index);
}


-(NSUInteger)noIndex;
{
    return [self.noIndexNSNumber unsignedIntegerValue];
}

-(void)setNoIndex:(NSUInteger)index;
{
    self.noIndexNSNumber = @(index);
}

-(NSUInteger)yesIndex;
{
    return [self.yesIndexNSNumber unsignedIntegerValue];
}

-(void)setYesIndex:(NSUInteger)index;
{
    self.yesIndexNSNumber = @(index);
}

@end
