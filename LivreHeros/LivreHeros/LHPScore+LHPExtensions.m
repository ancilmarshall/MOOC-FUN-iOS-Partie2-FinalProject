//
//  LHPScore+LHPExtensions.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import "LHPScore+LHPExtensions.h"

@implementation LHPScore (LHPExtensions)


#pragma mark - Initialization
+(void)addScore:(NSUInteger)value username:(NSString*)username;
{
    
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    
    LHPScore* score = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
    score.username = username;
    score.score = value;
    
    [[AppDelegate sharedDelegate] saveToPersistentStore];
    
}

+(NSArray*)fetchScores;
{
    
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scoreNSNumber" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];
    request.fetchLimit = 5;
    
    __block NSArray* fetchResults = nil;
    [moc performBlockAndWait:^{
        
        NSError* error = nil;
        fetchResults = [moc executeFetchRequest:request error:&error];
        if (error !=nil){
            NSLog(@"Error fetching scores: %@",[error localizedDescription]);
        }
        
    }];
    
    return fetchResults;
}

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

+(void)deleteScore:(LHPScore*)score;
{
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    [moc deleteObject:score];
    [[AppDelegate sharedDelegate] saveToPersistentStore];

}

#pragma mark - Convenience accessor methods
-(NSUInteger)score;
{
    return [self.scoreNSNumber unsignedIntegerValue];
}

-(void)setScore:(NSUInteger)score;
{
    self.scoreNSNumber = @(score);
}


#pragma mark - Helper functions
//override description
-(NSString*)description;
{
    NSString* str = [NSString
        stringWithFormat:@"\nScore: %tu User: %@",self.score,self.username];
    return str;
}



@end
