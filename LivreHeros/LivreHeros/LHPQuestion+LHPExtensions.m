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
+(void)insertQuestion:(NSString*)question qid:(NSUInteger)qid yes:(NSUInteger)yes no:(NSUInteger)no;
{
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    LHPQuestion* newQuestion =
    [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LHPQuestion class]) inManagedObjectContext:moc];
    
    newQuestion.question = question;
    newQuestion.qid = qid;
    newQuestion.yes = yes;
    newQuestion.no = no;
    
    // use performBlock to ensure that the block is performed on the correct queue of the moc
    // which is unknown in this instance.
    [moc performBlock:^{
        
        NSError* error = nil;
        if (![moc save:&error])
        {
            NSLog(@"Problem saving context: %@",[error localizedDescription]);
        }
        
    }];
}

+(NSString*)questionForQid:(NSUInteger)qid;
{
    NSAssert(qid>0,@"Qid must be an integer greater than zero");
    
    NSFetchRequest* fetchRequest = [NSFetchRequest
        fetchRequestWithEntityName:NSStringFromClass([self class])];
    fetchRequest.predicate = [NSPredicate
        predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(questionID)), @(qid)];;
    //fetchRequest.fetchLimit = 1;
    
    NSError* error = nil;
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    
    NSArray* fetchResult = [moc executeFetchRequest:fetchRequest error:&error];
    if (!fetchResult){
        NSLog(@"Error finding question for id: %tu, %@",qid,[error localizedDescription]);
    }
    NSAssert([fetchResult count] == 1,@"Expected only one entity in the CoreData model");
    NSAssert([[fetchResult firstObject] isKindOfClass:[self class]],@"Expected fetch result to be this class");
    
    LHPQuestion* question = (LHPQuestion*)[fetchResult firstObject];
    NSLog(@"Question for id: %tu is: %@",qid,question.question);
    
    return question.question;
}
#pragma mark - Simplification Accessor Methods

-(NSUInteger)qid;
{
    return [self.questionID unsignedIntegerValue];
}

-(void)setQid:(NSUInteger)qid;
{
    self.questionID = @(qid);
}


-(NSUInteger)no;
{
    return [self.noID unsignedIntegerValue];
}

-(void)setNo:(NSUInteger)no;
{
    self.noID = @(no);
}

-(NSUInteger)yes;
{
    return [self.yesID unsignedIntegerValue];
}

-(void)setYes:(NSUInteger)yes;
{
    self.yesID = @(yes);
}

@end
