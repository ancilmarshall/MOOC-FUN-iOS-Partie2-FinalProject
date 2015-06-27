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
#import "LHPScore+LHPExtensions.h"

@interface ViewController ()
@property (nonatomic,strong) LHPBook* book;
@property (nonatomic,weak) IBOutlet UILabel* questionLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.book = [LHPBook sharedInstance];
    
    //always continue questions from saved state of the book/game upon loading
    //except if book was completed on previous execution
    if (self.book.currentIndex == 0){
        [self restart:nil];
    } else {
        self.questionLabel.text = [self.book getCurrentQuestion];
    }
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
    
    [LHPScore addScore:20 username:@"augustus"];
    
    NSArray* scores = [LHPScore fetchScores];
    for (LHPScore* score in scores){
        NSLog(@"%@",score);
    }
    
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
