//
//  LHPBook+LHPExtensions.m
//  LivreHeros
//
//  Created by Ancil on 6/26/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import "LHPBook+LHPExtensions.h"
#import "LHPQuestion+LHPExtensions.h"
#import "LHPScore+LHPExtensions.h"

@implementation LHPBook (LHPExtensions)



#pragma mark - Initialization
// only allow one instance of the LHPBook class for this app
+(instancetype) sharedInstance;
{
    static LHPBook* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LHPBook insertBook];
    });
    return instance;
}

// create the book instance and save to persistent store
+(LHPBook*)insertBook;
{
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    
    //perform fetch to inquire if book is available in the data store
    //since this function is peformed only once per app execution, ok to do this fetch here
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([LHPBook class])];
    __block LHPBook* book = nil;
    
    //Note: Need to perform this synchronously to check that book is nil after the block executes
    [moc performBlockAndWait:^{
        
        NSError* error = nil;
        NSArray* fetchResult = [moc executeFetchRequest:request error:&error];
        NSAssert([fetchResult count]<=1,@"Expected 0 or 1 initial fetch results for Book object: %tu",
                 [fetchResult count]);
        if (error != nil){
            NSLog(@"Error fetching initial book request: %@",[error localizedDescription]);
        }
        
        if ([fetchResult count] == 1){
            book = (LHPBook*)[fetchResult firstObject];
        }
        
    }];
    
    // if book is nil, when we need to create a new instance, insert into context and save to store
    // otherwise do nothing and return the book instance found
    if (book == nil) {
        book = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LHPBook class])
                                          inManagedObjectContext:moc];
        book.title = @"LivreHeros";
        book.currentIndex = 1; //although set as default in IB, setting programatically here as well
                
        [[AppDelegate sharedDelegate] saveToPersistentStore];
    }
    
    return book;
}

// convenience method to add a LHPQuestion to the store as well as create the relationship to the the book
-(void)addQuestion:(NSString*)text index:(NSUInteger)index yes:(NSUInteger)yesIndex no:(NSUInteger)noIndex;
{
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];

    LHPQuestion* question =
    [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LHPQuestion class]) inManagedObjectContext:moc];
    
    question.text = text;
    question.index = index;
    question.yesIndex = yesIndex;
    question.noIndex = noIndex;
    question.book = self; //simplest method to create the many-to relationship, as the inverse method
                          //involves getting the NSMutableOrderedSet from the book and adding the question
                          //using KVC pattern (although, it's only 2 lines of code anyway... )
    
    [[AppDelegate sharedDelegate] saveToPersistentStore];
}

-(void)restart;
{
    self.currentIndex = 1;
    self.currentScore = 0;
}

+(void)reinitBookAndDeleteAllQuestions;
{
    
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([LHPBook class])];
    
    __block LHPBook* book;
    //Note: Need to perform this synchronously to get book after block executes
    [moc performBlockAndWait:^{
        
        NSError* error = nil;
        NSArray* fetchResult = [moc executeFetchRequest:request error:&error];
        NSAssert([fetchResult count]==1,@"Expected 1 fetch results for Book object: %tu",
                 [fetchResult count]);
        if (error != nil){
            NSLog(@"Error fetching book request: %@",[error localizedDescription]);
        }
        
        book = (LHPBook*)[fetchResult firstObject];
    }];

    [moc deleteObject:book];
    [[AppDelegate sharedDelegate] saveToPersistentStore];
    
    //now delete all the question entities from the persistent store
    [LHPQuestion deleteAllManagedObjects];
    
    //now insert a new book entry, that is empty
    [LHPBook insertBook];
}


#pragma mark - Book Sequence Methods

-(NSString*)getNextQuestion:(UserResponse)response;
{
    
    //exit immediately if index is 0, meaning end of book
    if (self.currentIndex == 0){
        return nil;
    }
    
    LHPQuestion* currentQuestion = [LHPQuestion questionEntityForIndex:self.currentIndex];
    NSUInteger nextIndex = (response == kUserResponseYes) ? currentQuestion.yesIndex: currentQuestion.noIndex;
    
    LHPQuestion* nextQuestion = [LHPQuestion questionEntityForIndex:nextIndex];
    self.currentIndex = nextIndex;
    
    //increment the current score or level value only if nextIndex != 0
    if (self.currentIndex != 0){
        self.currentScore += 1;
    }
    
    [[AppDelegate sharedDelegate] saveToPersistentStore];
    
    return nextQuestion.text;
}

-(NSString*)getCurrentQuestion;
{
    if (self.currentIndex == 0){
        [self restart];
    }
    LHPQuestion* currentQuestion = [LHPQuestion questionEntityForIndex:self.currentIndex];
    return currentQuestion.text;
    
}


# pragma mark - Category convenient accessors

-(NSUInteger)currentIndex;
{
    return [self.currentIndexNSNumber unsignedIntegerValue];
}

-(void)setCurrentIndex:(NSUInteger)currentIndex;
{
    self.currentIndexNSNumber = @(currentIndex);
}

-(NSUInteger)currentScore;
{
    return [self.currentScoreNSNumber unsignedIntegerValue];
}

-(void)setCurrentScore:(NSUInteger)currentScore;
{
    self.currentScoreNSNumber = @(currentScore);
}

#pragma mark - Helper functions

-(NSString*)description;
{
    LHPBook* book = [LHPBook sharedInstance];
    NSOrderedSet* questions = book.questions;
    NSMutableString* str = [NSMutableString new];
    [str appendFormat:@"\nBook title:%@\n\tCurrent Index: %tu\n",self.title,self.currentIndex];
    for ( LHPQuestion* question in questions ){
        [str appendFormat:@"%@\n",question];
    }
    return str;
}







@end
