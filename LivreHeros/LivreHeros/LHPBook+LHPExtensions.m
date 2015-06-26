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
    
    if (book != nil){
        return book;
    }
    
    book = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([LHPBook class])
                                      inManagedObjectContext:moc];
    
    book.title = @"LivreHeros";
    
    [LHPBook save];
    
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
    

    [LHPBook save];
}

+(void)save;
{
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];

    // use performBlock to ensure that the block is performed on the correct queue of the moc
    [moc performBlock:^{
        
        NSError* error = nil;
        if (![moc save:&error])
        {
            NSLog(@"Problem saving context: %@",[error localizedDescription]);
        }

    }];
}

#pragma mark - Book Sequence Methods

typedef enum {
    kUserResponseNo = 0,
    kUserResponseYes
} UserResponse;


-(NSString*)getNextQuestion:(UserResponse)response;
{
    
    LHPQuestion* currentQuestion = [LHPQuestion questionEntityForIndex:self.currentIndex];
    NSUInteger nextIndex = (response == kUserResponseYes) ? currentQuestion.yesIndex: currentQuestion.noIndex;
    
    LHPQuestion* nextQuestion = [LHPQuestion questionEntityForIndex:nextIndex];
    self.currentIndex = nextIndex;
    
    [LHPBook save];
    
    return nextQuestion.text;
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










@end
