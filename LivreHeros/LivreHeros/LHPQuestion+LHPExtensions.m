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
