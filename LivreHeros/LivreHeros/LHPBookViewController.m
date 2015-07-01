//
//  ViewController.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "LHPBookViewController.h"
#import "LHPBook+LHPExtensions.h"
#import "LHPQuestion+LHPExtensions.h"
#import "LHPSessionManager.h"
#import "LHPSettingsViewController.h"
#import "LHPScore+LHPExtensions.h"
#import "LHPXMLParserDelegate.h"

@interface LHPBookViewController ()
@property (nonatomic,strong) LHPBook* book;
//@property (nonatomic,weak) IBOutlet UILabel* questionLabel;
@end

@implementation LHPBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[LHPSessionManager sharedInstance] downloadXMLFile];
    
    self.book = [LHPBook sharedInstance];
    
    //NSURL* xmlURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"xml"];
    
    NSURL* xmlURL = [[LHPSessionManager sharedInstance] appDocumentsURL];
    //NSLog(@"\n%@",xmlURL);

    //NSString* str = [NSString stringWithContentsOfURL:xmlURL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"\n%@",str);
    
    LHPXMLParserDelegate* xmlParserDelegate = [LHPXMLParserDelegate new];
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    xmlParser.delegate = xmlParserDelegate;
    
    [xmlParser parse];
    
    //always continue questions from saved state of the book/game upon loading
    //except if book was completed on previous execution
    if (self.book.currentIndex == 0){
        //[self restart:nil];
    } else {
        //self.questionLabel.text = [self.book getCurrentQuestion];
    }
    
}

#pragma mark - LHPSettingsViewControllerDelegateProtocol
-(void)backgroundColorDidUpdate:(UIColor*)color;
{
    self.view.backgroundColor = color;
}


//- (void)viewWillTransitionToSize:(CGSize)size
//       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super viewWillTransitionToSize:size
//          withTransitionCoordinator:coordinator];
//    
//    NSLog(@"View: %@, ToSize: %@",self.description, NSStringFromCGSize(size));
//    
//}


//
//-(IBAction)populateData:(id)sender;
//{
//    //do nothing
//}

//-(IBAction)performFetch:(id)sender;
//{
//  
//    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]
//                                    initWithEntityName:NSStringFromClass([LHPBook class])];
//    
//    NSError* error;
//    NSManagedObjectContext* moc = [[AppDelegate sharedDelegate] managedObjectContext];
//    NSArray* arr = [moc executeFetchRequest:fetchRequest error:&error];
//    if (!arr) {
//        NSLog(@"Error fetching question data: %@",[error localizedDescription]);
//    }
//    
//    NSLog(@"%@",(LHPBook*)[arr firstObject]);
//    
//}
//
//-(IBAction)restart:(id)sender;
//{
//    [self.book restart];
//    //self.questionLabel.text = [self.book getCurrentQuestion];
//
//}
//
//-(IBAction)yes:(id)sender;
//{
//    NSString* question = [self.book getNextQuestion:kUserResponseYes];
//    //self.questionLabel.text = (question) ? question : @"Book is complete";
//}
//
//-(IBAction)no:(id)sender;
//{
//    NSString* question = [self.book getNextQuestion:kUserResponseNo];
//    //self.questionLabel.text = (question) ? question : @"Book is complete";
//}

@end
