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
    
    [[AppDelegate sharedDelegate] saveToPersistentStore];
    
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
        predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(indexNSNumber)), @(index)];;
    
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    __block NSArray* fetchResult = nil;
    [moc performBlockAndWait:^{
        
        NSError* error = nil;
        fetchResult = [moc executeFetchRequest:fetchRequest error:&error];
        if (!fetchResult){
            NSLog(@"Error finding question for id: %tu, %@",index,[error localizedDescription]);
        }
        //NSAssert([fetchResult count] == 1,@"Expected only one entity in the CoreData model");
        //NSAssert([[fetchResult firstObject] isKindOfClass:[self class]],@"Expected fetch result to be this class");
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

#pragma mark - Helper functions
+(void)deleteAllManagedObjects;
{
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    __block NSArray* fetchResults = nil;
    [moc performBlockAndWait:^{
        
        NSError* error = nil;
        fetchResults = [moc executeFetchRequest:request error:&error];
        if (error !=nil){
            NSLog(@"Error fetching objects: %@",[error localizedDescription]);
        }
        
        for (NSManagedObject* object in fetchResults){
            [moc deleteObject:object];
        }
    }];
    
    [[AppDelegate sharedDelegate] saveToPersistentStore];
    
}

//override description
-(NSString*)description;
{
    NSString* str = [NSString
        stringWithFormat:@"\nQuestionEntity: %tu \n\tYes:  %tu \n\tNo:   %tu\n\tText: %@",
                     self.index,self.yesIndex,self.noIndex,self.text];
    return str;
}



@end
