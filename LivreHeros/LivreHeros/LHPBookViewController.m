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
@property (nonatomic,weak) IBOutlet UILabel* instructionsLabel;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* instructionsLabelBottomConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* titleLabelTopConstraint;
@end

const static CGFloat kConstraintMargin = 8.0f;

@implementation LHPBookViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];

    [[LHPSessionManager sharedInstance] downloadXMLFile];
    
    self.book = [LHPBook sharedInstance];

    self.navigationItem.title = NSLocalizedString(@"Book Hero!",
                                                  @"Book Hero Navigation bar title");

    NSURL* xmlURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"xml"];
    
    //NSURL* xmlURL = [[LHPSessionManager sharedInstance] appDocumentsURL];
    //NSLog(@"\n%@",xmlURL);

    //NSString* str = [NSString stringWithContentsOfURL:xmlURL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"\n%@",str);
    
    LHPXMLParserDelegate* xmlParserDelegate = [LHPXMLParserDelegate new];
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    xmlParser.delegate = xmlParserDelegate;
    
    [xmlParser parse];
    
    self.titleLabel.text = NSLocalizedString(
                                             @"New Question",
                                             @"Book Hero view title");
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //always continue questions from saved state of the book/game upon loading
    //except if book was completed on previous execution
    self.questionLabel.text = [self.book getCurrentQuestion];
    
    self.instructionsLabel.text = NSLocalizedString(
                                @"Swipe RIGHT to respond YES\n Swipe LEFT to respond NO",
                                @"User instructions to respond yes or no based on swipe gesture");
    
    self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self resetConstraints];
    
    self.delegate = (id)[[AppDelegate sharedDelegate] settingsViewController];
}

-(void)restart:(id)sender;
{
    [self.book restart];
    //self.questionLabel.text = [self.book getCurrentQuestion];
}

-(void)resetConstraints;
{
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    if (self.tabBarController){
        CGFloat height = [[self tabBarController] tabBar].frame.size.height;
        self.instructionsLabelBottomConstraint.constant = height+kConstraintMargin;
    }
    
    if (self.navigationController){
        CGFloat height = [[self navigationController] navigationBar].frame.size.height;
        self.titleLabelTopConstraint.constant = height+statusBarHeight+kConstraintMargin;
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark - LHPSettingsViewControllerDelegateProtocol
-(void)backgroundColorDidUpdate:(UIColor*)color;
{
    self.view.backgroundColor = color;
}

#pragma mark - User actions
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

#pragma mark - Rotation support
/*
 * override this method to perform calculations during rotation
 */
//TODO: provide logic to calculate new heights based on size since the
// navigation bar and status bar changes sizes after rotation which is
// not conveyed before the rotation happens

//- (void)viewWillTransitionToSize:(CGSize)size
//       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//
//    [super viewWillTransitionToSize:size
//          withTransitionCoordinator:coordinator];
//    
//    [self resetConstraints];
//    [coordinator animateAlongsideTransition:
//     ^(id<UIViewControllerTransitionCoordinatorContext> context) {
//         [self.view layoutIfNeeded];
//     } completion:nil];
//}

@end
