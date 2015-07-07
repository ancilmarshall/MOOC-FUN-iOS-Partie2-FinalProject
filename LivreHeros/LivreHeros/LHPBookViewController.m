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

@interface LHPBookViewController () <UIGestureRecognizerDelegate>
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

typedef enum {
    kXMLFileTypeLocal = 0,
    kXMLFileTypeRemote
} XMLFileType;

@implementation LHPBookViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.book = [LHPBook sharedInstance];

    //add to notification observers to this object
    //TODO: remove notification center during dealloc
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xmlDownloadCompleted)
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
    
    //setup outlets
    self.navigationItem.title = NSLocalizedString(@"Book Hero!",
                                                  @"Book Hero Navigation bar title");
    
    //add the back button when using the split view controller
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;

    UIBarButtonItem* restartGameButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                      target:self
                                                      action:@selector(restart:)];
    self.navigationItem.rightBarButtonItem = restartGameButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;

    self.titleLabel.text = NSLocalizedString(
                                             @"New Question",
                                             @"Book Hero view title");
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.instructionsLabel.text = NSLocalizedString(
                                @"Swipe RIGHT to respond YES\n Swipe LEFT to respond NO",
                                @"User instructions to respond yes or no based on swipe gesture");
    
    self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.userResponseYesLabel.hidden = YES;
    self.userResponseNoLabel.hidden = YES;
    //[self resetConstraints];
    
    //use delegate pattern to communicate between the two view controllers
    self.delegate = (id)[[AppDelegate sharedDelegate] settingsViewController];
    
    // Game startup Logic
    //[self startXMLDownload];
    [self parseXmlFileType:kXMLFileTypeLocal];

}

-(void)startXMLDownload;
{
    [[LHPSessionManager sharedInstance] downloadXMLFile];
    [self.xmlDownloadActivityIndicator startAnimating];
}

-(void)resumeGame;
{
    BOOK_VC_LOG(@"Resuming Game");

    //make sure we're on the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //always continue questions from saved state of the book/game upon loading
        //except if book was completed on previous execution
        self.questionLabel.text = [self.book getCurrentQuestion];
        self.yesGesture.enabled = YES;
        self.noGesture.enabled = YES;
        [self.xmlDownloadActivityIndicator stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
    });
    
}

//TODO: Nothing for now, but hook up and parse. May need a to wait for notification (based on timer?)
-(void)xmlDownloadCompleted;
{
    BOOK_VC_LOG(@"Xml Download Notification received, parsing downloaded file");
    [self parseXmlFileType:kXMLFileTypeRemote];
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
    [self parseXmlFileType:kXMLFileTypeLocal];
}

-(void)parseXmlFileType:(XMLFileType)type;
{
    //each time we parse xlm, must reinit book by deleting questions from the core data stack
    [LHPBook reinitBookAndDeleteAllQuestions];
    
    NSURL* xmlURL;
    if (type == kXMLFileTypeLocal){
        xmlURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"xml"];
        [[NSFileManager defaultManager] moveItemAtURL:xmlURL
            toURL:[[LHPSessionManager sharedInstance] appDocumentsURL]  error:NULL];
    }
    else if (type == kXMLFileTypeRemote){
        xmlURL = [[LHPSessionManager sharedInstance] appDocumentsURL];
    }
    LHPXMLParserDelegate* xmlParserDelegate = [LHPXMLParserDelegate new];
    NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    xmlParser.delegate = xmlParserDelegate;
    
    BOOK_VC_LOG(@"Parsing XML Document");
    [xmlParser parse];
}

-(void)restart:(id)sender;
{
    [self.book restart];
    [self resumeGame];
}

//No longer need this function if the translucency of the tabbar and navigation bar is set to NO
// as the view is correctly resized
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
    [self adjustFontColorsForBackgroundColor:color];
}

-(void)adjustFontColorsForBackgroundColor:(UIColor* )color;
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGFloat aveColor = (red + green + blue)/3.0;
    
    if (aveColor < 0.3)
    {
        self.instructionsLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.questionLabel.textColor = [UIColor whiteColor];
        self.userResponseNoLabel.textColor = [UIColor whiteColor];
        self.userResponseYesLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.instructionsLabel.textColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.questionLabel.textColor = [UIColor blackColor];
        self.userResponseNoLabel.textColor = [UIColor blackColor];
        self.userResponseYesLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - GestureRecognizers



#pragma mark - User actions
-(IBAction)yes:(UIPanGestureRecognizer*)gesture;
{
    
    [self animateUserResponseLabel:self.userResponseYesLabel];
    [self executeUserResponse:kUserResponseYes];
}


-(IBAction)no:(UIPanGestureRecognizer*)gesture;
{
    [self animateUserResponseLabel:self.userResponseNoLabel];
    [self executeUserResponse:kUserResponseNo];
}


-(void)translateRotateView:(UIView*)view forGesture:(UIPanGestureRecognizer*)gesture;
{
    UIGestureRecognizerState gestureState = gesture.state;
    
    CGPoint translation;
    
    switch (gestureState) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            translation = [gesture translationInView:view];
            break;
            
        case UIGestureRecognizerStateCancelled:
            break;
            
        case UIGestureRecognizerStateEnded:
            break;
            
        case UIGestureRecognizerStateFailed:
            break;
            
        default:
            break;
    }
    
}

-(void)executeUserResponse:(UserResponse)response;
{
    NSString* question = [self.book getNextQuestion:response];
    self.questionLabel.text = (question) ? question : @"Book is complete";
    
    NSAssert(self.delegate != nil,@"Delegate not yet set");
    [self.delegate didUpdateScore:self.book.currentScore];
    
    //handle case when game is complete
    if (!question){
        LHPUsernameEntryViewController* usernameEntryVieController =
        [[LHPUsernameEntryViewController alloc] initWithScore:self.book.currentScore];

        usernameEntryVieController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:usernameEntryVieController animated:YES completion:nil];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.yesGesture.enabled = NO;
        self.noGesture.enabled = NO;
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

@end
