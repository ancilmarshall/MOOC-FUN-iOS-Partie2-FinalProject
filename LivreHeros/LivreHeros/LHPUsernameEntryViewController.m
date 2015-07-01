//
//  LHPUsernameEntryViewController.m
//  LivreHeros
//
//  Created by Ancil on 7/1/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPUsernameEntryViewController.h"
#import "LHPScore+LHPExtensions.h"

@interface LHPUsernameEntryViewController () <UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UILabel* scoreLabel;
@property (nonatomic,weak) IBOutlet UITextField* inputText;
@end

@implementation LHPUsernameEntryViewController

-(instancetype)initWithScore:(NSUInteger)score;
{
    self = [super init]; //TODO: Should this be intiWithCoder?
    {
        self.score = score;
        self.scoreLabel.text = [NSString stringWithFormat:
            NSLocalizedString(@"Score: %tu",
                              @"Username Entry Score Label"),
                           score];
    }
    return self;
}


-(IBAction)save:(id)sender;
{
    self.username = self.inputText.text;
    if ( [self.username isEqualToString:@""]){
        NSLog(@"Empty User name"); //TODO alert user
        NSAssert(NO,@"Empty Username");
    }
    [LHPScore addScore:self.score username:self.username];
}


-(IBAction)cancel:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(BOOL)resignFirstResponder;
//{
//    [super resignFirstResponder];
//    return NO;
//    
//}

@end
