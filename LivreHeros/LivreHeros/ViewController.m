//
//  ViewController.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "LHPQuestion+LHPExtensions.h"
#import "LHPBook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(IBAction)populateData:(id)sender;
{
    [LHPQuestion insertQuestion:@"What is the color of red"
                          index:1
                       yesIndex:2
                        noIndex:3];
    
    [LHPQuestion insertQuestion:@"What is the color of green"
                          index:2
                       yesIndex:3
                        noIndex:4];
    
    [LHPQuestion insertQuestion:@"What is the color of blue"
                          index:3
                       yesIndex:0
                        noIndex:0];
    
    [LHPQuestion insertQuestion:@"What is the color of black"
                          index:4
                       yesIndex:0
                        noIndex:0];
    
}

-(IBAction)performFetch:(id)sender;
{
  
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:NSStringFromClass([LHPBook class])];
    
    //Note: Must fetch using a selector in the actual model, not a property in the category
//    fetchRequest.sortDescriptors =
//    @[ [NSSortDescriptor
//        sortDescriptorWithKey:NSStringFromSelector(@selector(questionID))
//        ascending:YES] ];
    
    NSError* error;
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    NSArray* questions = [moc executeFetchRequest:fetchRequest error:&error];
    if (!questions) {
        NSLog(@"Error fetching question data: %@",[error localizedDescription]);
    }
    
    NSLog(@"Number of items in Question mananaged object: %tu",[questions count]);
    

    
}



@end
