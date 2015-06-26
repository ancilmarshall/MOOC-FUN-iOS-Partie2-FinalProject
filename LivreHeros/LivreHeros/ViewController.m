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
@property (nonatomic,strong) LHPBook* book;
@property (nonatomic,weak) IBOutlet UILabel* questionLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.book = [LHPBook sharedInstance];
    
    [self restart:nil];
}

-(IBAction)populateData:(id)sender;
{
    //do nothing
}

-(IBAction)performFetch:(id)sender;
{
  
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:NSStringFromClass([LHPBook class])];
    
    NSError* error;
    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
    NSArray* arr = [moc executeFetchRequest:fetchRequest error:&error];
    if (!arr) {
        NSLog(@"Error fetching question data: %@",[error localizedDescription]);
    }
    
    NSLog(@"%@",self.book);
    
    NSLog(@"%@",[self.book getNextQuestion:kUserResponseYes]);
    
}

-(IBAction)restart:(id)sender;
{
    [self.book restart];
    self.questionLabel.text = [self.book getCurrentQuestion];

}

-(IBAction)yes:(id)sender;
{
    NSString* question = [self.book getNextQuestion:kUserResponseYes];
    self.questionLabel.text = (question) ? question : @"Book is complete";
}

-(IBAction)no:(id)sender;
{
    NSString* question = [self.book getNextQuestion:kUserResponseNo];
    self.questionLabel.text = (question) ? question : @"Book is complete";
}

@end
