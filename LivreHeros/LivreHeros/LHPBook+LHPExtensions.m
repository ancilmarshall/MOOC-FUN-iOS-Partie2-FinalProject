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
        NSAssert([fetchResult count]<=1,@"Expected 0 or 1 initial fetch results for Book object: %tu",[fetchResult count]);
        if (error != nil){
            NSLog(@"Error fetching initial book request: %@",[error localizedDescription]);
        }
        
        if ([fetchResult count] == 1){
            book = (LHPBook*)[fetchResult firstObject];
        }
        
    }];
    
    if (book == nil) {
        book = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LHPBook class])
                                          inManagedObjectContext:moc];
        book.title = @"LivreHeros";
        book.currentIndex = 1; //although set as default in IB, setting programatically here as well
        
        //add scores for testing purposes
        [LHPScore addScore:1 username:@"ancil"];
        [LHPScore addScore:2 username:@"brandon"];
        [LHPScore addScore:3 username:@"darien"];
        [LHPScore addScore:4 username:@"cyril"];
        [LHPScore addScore:5 username:@"shirley"];
        [LHPScore addScore:6 username:@"eutrice"];
        
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


#pragma mark - Book Sequence Methods

-(NSString*)getNextQuestion:(UserResponse)response;
{
    //increment the current score or level value
    self.currentScore += 1;
    
    //exit immediately if index is 0, meaning end of book
    if (self.currentIndex == 0){
        return nil;
    }
    
    LHPQuestion* currentQuestion = [LHPQuestion questionEntityForIndex:self.currentIndex];
    NSUInteger nextIndex = (response == kUserResponseYes) ? currentQuestion.yesIndex: currentQuestion.noIndex;
    
    LHPQuestion* nextQuestion = [LHPQuestion questionEntityForIndex:nextIndex];
    self.currentIndex = nextIndex;
    
    [[AppDelegate sharedDelegate] saveToPersistentStore];
    
    return nextQuestion.text;
}

-(NSString*)getCurrentQuestion;
{
    //exit immediately if inces is 0, meaning end of book
    if (self.currentIndex == 0){
        return nil;
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
