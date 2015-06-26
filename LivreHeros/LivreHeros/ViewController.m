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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [LHPQuestion insertQuestion:@"What is the color of red"
                            qid:1
                            yes:2
                             no:3];
    
    [LHPQuestion insertQuestion:@"What is the color of green"
                            qid:2
                            yes:3
                             no:4];
    

    
}

-(IBAction)performFetch:(id)sender;
{
  
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:NSStringFromClass([LHPQuestion class])];
    
    //Note: Must fetch using a selector in the actual model, not a property in the category
    fetchRequest.sortDescriptors =
    @[ [NSSortDescriptor
        sortDescriptorWithKey:NSStringFromSelector(@selector(questionID))
        ascending:YES] ];
    
    NSError* error;
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    NSArray* questions = [moc executeFetchRequest:fetchRequest error:&error];
    if (!questions) {
        NSLog(@"Error fetching question data: %@",[error localizedDescription]);
    }
    
    NSLog(@"Number of items in Question mananaged object: %tu",[questions count]);
    
}



@end
