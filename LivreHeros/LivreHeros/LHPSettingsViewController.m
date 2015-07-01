//
//  LHPSettingsViewController.m
//  LivreHeros
//
//  Created by Ancil on 6/29/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

/*
 *                  NOTE
 * The auto-layout portion of this file is taken from my homework 2 from the
 * University of Washington's online iOS Part2 class. Only small adaptions were
 * made to meet the needs of this assignment. Also added 2 custom views to place
 * the labels and the sliders. Good code reuse principles applied here.
 */

#import "ScoreView.h"
#import "SettingsView.h"
#import "LHPSettingsViewController.h"

@interface LHPSettingsViewController ()
@property (nonatomic,strong) ScoreView* scoreView;
@property (nonatomic,strong) SettingsView* settingsView;
@property (nonatomic,strong) NSLayoutConstraint* scoreTopConstraint;
@property (nonatomic,strong) NSLayoutConstraint* scoreHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint* scoreWidthConstraint;
@property (nonatomic,strong) NSLayoutConstraint* settingsBottomConstraint;
@property (nonatomic,strong) NSLayoutConstraint* settingsHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint* settingsWidthConstraint;
@property (nonatomic,assign) CGSize viewSize; //holds size while rotating
@end

@implementation LHPSettingsViewController

//constants
const CGFloat kViewSpace = 10.0f;
const CGFloat kViewMargin = 10.0f;
const CGFloat kScoreHeightConstraintConstantPortrait = 300.0f;

//typedefs
typedef enum {TOTAL,FIXED} Length_Type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.viewSize = self.view.bounds.size;

    //set up UI elements, scoreView and Settings View
    UINib *scoreNib = [UINib nibWithNibName:@"ScoreView" bundle:[NSBundle mainBundle]];
    self.scoreView = [scoreNib instantiateWithOwner:self options:nil][0];
    self.scoreView.backgroundColor = [UIColor redColor];
    self.scoreView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scoreView];
    
    UINib *settingsNib = [UINib nibWithNibName:@"SettingsView" bundle:[NSBundle mainBundle]];
    self.settingsView = [settingsNib instantiateWithOwner:self options:nil][0];
    self.settingsView.backgroundColor = [UIColor blueColor];
    self.settingsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.settingsView.delegate = self;
    [self.view addSubview:self.settingsView];
    
    self.delegate = (id)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self initializeConstraints];
}

//must reset the viewSize when view appears to account for the iPad using the
//split view controller which has changes width when this is the master
-(void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:YES];
    self.viewSize = self.view.bounds.size;
    [self updateConstraintConstants];
    [self.view layoutIfNeeded];
    
    [self.settingsView initialize];
    
}


#pragma mark - LHPSettingsViewDelegateProtocol
-(void)LHPSettingsView:(SettingsView *)settingsView didUpdateBackGroundColor:(UIColor *)color;
{
    NSAssert(settingsView == self.settingsView, @"Expected settingsView to be same instance held in this object");
    NSAssert(self.delegate!=nil,@"Delegate object not yet set");
    NSAssert([self.delegate respondsToSelector:@selector(backgroundColorDidUpdate:)],
             @"Delegate does not implement required protocol method");
    
    [self.delegate backgroundColorDidUpdate:color];
}

#pragma mark - Autolayout and constraint methods

// initially waits till this lifecyle to make sure that topLayoutGuide is set
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self updateConstraintConstants];
}

/*
 * By setting up the constraints as follows, all the constraints are always active
 * Only their constants change. This set up fixes the red view's top constraint
 * and varies it's left, height and width constraint. The blue view's bottom constraint
 * is fixed, but its right, height and width constraints are varied based on orientation
 * and slider value.
 */
-(void)initializeConstraints
{

    // score View left constraint (always fixed)
    [NSLayoutConstraint constraintWithItem:self.scoreView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:kViewMargin].active = YES;
    
    // score view top constraint (changes based on orientation)
    self.scoreTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.scoreView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0];
    self.scoreTopConstraint.active = YES;
    
    // red view width constraint (changes based on orientation)
    self.scoreWidthConstraint =
    [NSLayoutConstraint constraintWithItem:self.scoreView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.scoreWidthConstraint.active = YES;
    
    //red view height constraint (changes based on orientation)
    self.scoreHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.scoreView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.scoreHeightConstraint.active = YES;
    
    //blue view right constraint (always fixed). Note negative sign in constant
    [NSLayoutConstraint constraintWithItem:self.settingsView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-kViewMargin].active = YES;
    
    // blue view bottom constraint (changes based on orientation)
    self.settingsBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.settingsView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
    self.settingsBottomConstraint.active = YES;
    
    // blue view width constraint (chagnes based on orientation)
    self.settingsWidthConstraint =
    [NSLayoutConstraint constraintWithItem:self.settingsView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.settingsWidthConstraint.active = YES;
    
    // blue view height constraint (chagnes based on orientation)
    self.settingsHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.settingsView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.settingsHeightConstraint.active = YES;
    
}

/*
 * Constraint constants need updating during rotation transition
 */
-(void)updateConstraintConstants
{
    // note the required negative sign
    self.scoreTopConstraint.constant = [self topContsraintConstant];
    self.settingsBottomConstraint.constant = -[self bottomConstraintConstant];
    
    CGFloat redConstant;
    CGFloat blueConstant;
    [self calcVariableDimensionsRed:&redConstant blue:&blueConstant];
    
    if ([self isPortrait])
    {
        self.scoreWidthConstraint.constant = [self getLength:FIXED];
        self.scoreHeightConstraint.constant = redConstant;
        self.settingsWidthConstraint.constant = [self getLength:FIXED];
        self.settingsHeightConstraint.constant = blueConstant;
    }
    else
    {
        self.scoreWidthConstraint.constant =  redConstant;
        self.scoreHeightConstraint.constant = [self getLength:FIXED];
        self.settingsWidthConstraint.constant = blueConstant;
        self.settingsHeightConstraint.constant = [self getLength:FIXED];
    }
}

#pragma mark - Variable length/height/width calculations based on orientation

/*
 * Calculation that returns the variable length of the views based on slider
 */
- (void) calcVariableDimensionsRed:(CGFloat*)redDimension
                              blue:(CGFloat*)blueDimension
{
    CGFloat alpha = [self calcAlpha];
    CGFloat length = [self getLength:TOTAL];
    CGFloat redDim;
    CGFloat blueDim;
    
    if ( alpha > 0.0 && alpha < 1.0 )
    {
        redDim = alpha * length - kViewSpace/2.0;
        blueDim = (1.0 - alpha)* length - kViewSpace/2.0;
        
    }
    else if (alpha == 1.0)
    {
        redDim = length;
        blueDim = 0.0;
    }
    else // alpha == 0.0
    {
        redDim = 0.0;
        blueDim = length;
    }
    
    //because of space between views, the calculation falls negative as as
    // alpha approaches 0.0 and 1.0. Capping them here is an easy solution
    if (blueDim < 0.0) {
        blueDim = 0.0;
    }
    if (redDim < 0.0) {
        redDim = 0.0;
    }
    
    *redDimension = redDim;
    *blueDimension = blueDim;
}

/*
 * Calculate the alpha value based on the orientation
 * NOTE: Used a fixed value for the height of the score view when in portrait mode
 * Would be better to calculate automatically based on subviews, but could not figure 
 * it out.
 */

-(CGFloat)calcAlpha;
{
    CGFloat alpha = 0.0f;
    CGFloat scoreViewHeight = 0.0f;
    CGFloat totalLength = 1.0f;
    
    if ( [self isPortrait]){
        totalLength = [self getLength:TOTAL];
        scoreViewHeight = kScoreHeightConstraintConstantPortrait;
        NSAssert(totalLength>0,@"Expected a strictly positive total length value");
        alpha = scoreViewHeight/totalLength;
    } else { // In landscape mode, the two views have equal widths
        alpha = 0.5f;
    }
    
    return alpha;
}


/*
 * Return value from view's top edge to top of red (or blue in landscape) view
 */
-(CGFloat)topContsraintConstant
{
    CGFloat length = self.topLayoutGuide.length;
    if (length == 0) // as in the case of landscape for iPhone
    {
        length = kViewMargin;
    }
    return length;
}

/*
 * Return value from view's bottom edge to the bottom edge of blue (or red) view
 */
-(CGFloat)bottomConstraintConstant
{
    return kViewMargin;
}

/*
 * Calculate the desired length based on lengthType parameter
 * TOTAL implies the total length of the longest dimension, ie. along the axis
 *  that varies based on the slider value. This is the total length of the red
 *  and blue views and the space between them along the varying axis
 *
 * FIXED implies the length that does not change and is the same in the red and
 *  blue views, e.g. their width in Portrait mode.
 */
-(CGFloat)getLength:(Length_Type)lengthType
{
    CGFloat length;
    
    //total length in Portrait, fixed length landscape
    if ( ([self isPortrait]  && lengthType == TOTAL)  ||
        ([self isLandscape] && lengthType == FIXED))
    {
        length = self.viewSize.height -
        [self topContsraintConstant] -
        [self bottomConstraintConstant];
    }
    //total length landscape or fixed length portrait
    else if ( ([self isLandscape] && lengthType == TOTAL)  ||
             ([self isPortrait]  && lengthType == FIXED))
    {
        length = self.viewSize.width - 2*kViewMargin;
    }
    
    return length;
}

/*
 * selector called when the slider is changed
 */
- (void)sliderValueChanged:(UISlider *)sender
{
    [self updateConstraintConstants];
    [self.view layoutIfNeeded];
}

/*
 * override this method to perform calculations during rotation
 */
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    //NSLog(@"View: %@, ToSize: %@",self.description, NSStringFromCGSize(size));
    
    //Noticed intermittent problems on iPhone6+ on the simulator where the
    //size reported is sometimes the primary view controller's size or the
    //secondary view controller's size. Quick hack here is to detect the size
    //and change it manually.
    //NOTE: Still not working after the change
    //TODO: Fix this issue
    
    if ((size.width > 440.0 && size.width < 441.0) &&
        (size.height> 413.0 && size.height < 415.0)){
        size = (CGSize){.width = 295, .height = 414};
        NSLog(@"View: %@, ToSizeNew: %@",self.description, NSStringFromCGSize(size));

    }
    
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];
    
    self.viewSize = size;
    [self updateConstraintConstants];
    [self.view layoutIfNeeded];
    
    [coordinator animateAlongsideTransition:
     ^(id<UIViewControllerTransitionCoordinatorContext> context) {
         [self.view layoutIfNeeded];
     } completion:nil];
}

#pragma mark - helper functions

- (BOOL)isPortrait
{
    return self.viewSize.height >= self.viewSize.width;
}

- (BOOL)isLandscape
{
    return ![self isPortrait];
}


@end
