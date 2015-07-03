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
@property (nonatomic,weak) IBOutlet UILabel* userResponseYesLabel;
@property (nonatomic,weak) IBOutlet UILabel* userResponseNoLabel;
@property (nonatomic,weak) IBOutlet UIGestureRecognizer* yesGesture;
@property (nonatomic,weak) IBOutlet UIGestureRecognizer* noGesture;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *xmlDownloadActivityIndicator;

@end

const static CGFloat kConstraintMargin = 8.0f;

#if 0 && defined(DEBUG)
#define BOOK_VC_LOG(format, ...) NSLog(@"LHPBookViewController: " format, ## __VA_ARGS__)
#else
#define BOOK_VC_LOG(format, ...)
#endif


@implementation LHPBookViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.book = [LHPBook sharedInstance];

    //add to notification center
    //TODO: remove notification center during dealloc
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(parseXml)
                                                 name:kLHPSessionManagerXMLDownloadCompleteNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(parseComplete)
                                                 name:kLHPXMLParserDeletageCompletionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNetworkError)
                                                 name:kLHPSessionManagerXMLDownloadErrorNotification
                                               object:nil];
    
    [[LHPSessionManager sharedInstance] downloadXMLFile];
    [self.xmlDownloadActivityIndicator startAnimating];
    
    
    //NSLog(@"\n%@",xmlURL);
    //NSString* str = [NSString stringWithContentsOfURL:xmlURL encoding:NSUTF8StringEncoding error:NULL];
    //BOOK_VC_LOG(@"\n%@",str);
    
    self.navigationItem.title = NSLocalizedString(@"Book Hero!",
                                                  @"Book Hero Navigation bar title");

    self.titleLabel.text = NSLocalizedString(
                                             @"New Question",
                                             @"Book Hero view title");
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.instructionsLabel.text = NSLocalizedString(
                                @"Swipe RIGHT to respond YES\n Swipe LEFT to respond NO",
                                @"User instructions to respond yes or no based on swipe gesture");
    
    self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self resetConstraints];
    
    self.delegate = (id)[[AppDelegate sharedDelegate] settingsViewController];
    
    self.userResponseYesLabel.hidden = YES;
    self.userResponseNoLabel.hidden = YES;
    
}

-(void)resumeGame;
{
    //always continue questions from saved state of the book/game upon loading
    //except if book was completed on previous execution
    self.questionLabel.text = [self.book getCurrentQuestion];
    self.yesGesture.enabled = YES;
    self.noGesture.enabled = YES;
    [self.xmlDownloadActivityIndicator stopAnimating];
}

//TODO: Nothing for now, but hook up and parse. May need a to wait for notification (based on timer?)
-(void)parseXml;
{
    BOOK_VC_LOG(@"Xml Download Notification received, parsing downloaded file");
    
    //reinit book and delet questions from the core data stack
    [LHPBook reinitBookAndDeleteAllQuestions];
    
    NSURL* xmlURL = [[LHPSessionManager sharedInstance] appDocumentsURL];
    LHPXMLParserDelegate* xmlParserDelegate = [LHPXMLParserDelegate new];
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    xmlParser.delegate = xmlParserDelegate;
    [xmlParser parse];
    
}

-(void)parseComplete;
{
    BOOK_VC_LOG(@"Parse Complete Notification received");
    [self resumeGame];
}

// if a network error occured, use test.xml file
-(void)handleNetworkError;
{
    BOOK_VC_LOG(@"Network Error Notification received");
    
    NSURL* xmlURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"xml"];
    LHPXMLParserDelegate* xmlParserDelegate = [LHPXMLParserDelegate new];
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    xmlParser.delegate = xmlParserDelegate;
    
    BOOK_VC_LOG(@"Parsing test.xml");
    [xmlParser parse];
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
    [self animateUserResponseLabel:self.userResponseYesLabel];
    [self executeUserResponse:kUserResponseYes];
}

-(IBAction)no:(id)sender;
{

    [self animateUserResponseLabel:self.userResponseNoLabel];
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

-(void)animateUserResponseLabel:(UILabel*)label;
{
    label.alpha = 0.8;
    label.hidden = NO;
    [UIView animateWithDuration:1 animations:^{
        label.alpha = 0.0;
    } completion:^(BOOL finished) {
        label.hidden = YES;
    }];
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
