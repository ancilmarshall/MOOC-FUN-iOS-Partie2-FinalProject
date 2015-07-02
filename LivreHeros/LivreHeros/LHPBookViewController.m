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
#import "LHPUsernameEntryViewController.h"
#import "LHPXMLParserDelegate.h"

@interface LHPBookViewController ()
@property (nonatomic,strong) LHPBook* book;
@property (nonatomic,weak) IBOutlet UILabel* questionLabel;
@property (nonatomic,weak) IBOutlet UILabel* titleLabel;
@property (nonatomic,weak) IBOutlet UILabel* instructions;
@end

@implementation LHPBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[LHPSessionManager sharedInstance] downloadXMLFile];
    
    self.book = [LHPBook sharedInstance];
    
    NSURL* xmlURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"xml"];
    
    //NSURL* xmlURL = [[LHPSessionManager sharedInstance] appDocumentsURL];
    //NSLog(@"\n%@",xmlURL);

    //NSString* str = [NSString stringWithContentsOfURL:xmlURL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"\n%@",str);
    
    LHPXMLParserDelegate* xmlParserDelegate = [LHPXMLParserDelegate new];
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    xmlParser.delegate = xmlParserDelegate;
    
    [xmlParser parse];
    
    //always continue questions from saved state of the book/game upon loading
    //except if book was completed on previous execution
    self.questionLabel.text = [self.book getCurrentQuestion];
    
    //TODO; only if split view controller on iPad... make logic for iPhone and tabController
    self.delegate = (id)[[[self.splitViewController viewControllers] firstObject] topViewController];
    
}

#pragma mark - LHPSettingsViewControllerDelegateProtocol
-(void)backgroundColorDidUpdate:(UIColor*)color;
{
    self.view.backgroundColor = color;
}

-(void)restart:(id)sender;
{
    [self.book restart];
    //self.questionLabel.text = [self.book getCurrentQuestion];

}

-(IBAction)yes:(id)sender;
{
    [self executeUserResponse:kUserResponseYes];
}

-(IBAction)no:(id)sender;
{
    [self executeUserResponse:kUserResponseNo];
}

-(void)executeUserResponse:(UserResponse)response;
{
    NSString* question = [self.book getNextQuestion:response];
    self.questionLabel.text = (question) ? question : @"Book is complete";
    
    NSAssert(self.delegate != nil,@"Delegate not yet set");
    [self.delegate didUpdateScore:self.book.currentScore];
    
    if (!question){
        LHPUsernameEntryViewController* usernameEntryVieController =
        [[LHPUsernameEntryViewController alloc] initWithScore:self.book.currentScore];

        usernameEntryVieController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:usernameEntryVieController animated:YES completion:nil];
        
    }
}

@end
