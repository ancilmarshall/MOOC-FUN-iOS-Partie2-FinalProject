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
#import "LHPBook+LHPExtensions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(IBAction)populateData:(id)sender;
{
    LHPBook* book = [LHPBook sharedInstance];
    
    [book addQuestion:@"What is the color of red" index:1 yes:2 no:3];
    [book addQuestion:@"What is the color of green" index:2 yes:3 no:4];
    [book addQuestion:@"What is the color of blue" index:3 yes:0 no:0];
    [book addQuestion:@"What is the color of black" index:4 yes:0 no:0];
    
}

-(IBAction)performFetch:(id)sender;
{
  
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:NSStringFromClass([LHPBook class])];
    
    //Note: Must fetch using a selector in the actual model, not a property in the category
//    fetchRequest.sortDescriptors =
//    @[ [NSSortDescriptor
//        sortDescriptorWithKey:NSStringFromSelector(@selector(indexNSNumber))
//        ascending:YES] ];
    
    NSError* error;
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    NSArray* arr = [moc executeFetchRequest:fetchRequest error:&error];
    if (!arr) {
        NSLog(@"Error fetching question data: %@",[error localizedDescription]);
    }
    
    NSLog(@"Number of items in Question mananaged object: %tu",[arr count]);
    
}



@end
