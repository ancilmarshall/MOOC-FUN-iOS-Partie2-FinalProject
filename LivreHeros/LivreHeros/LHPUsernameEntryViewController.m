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
@property (nonatomic,weak) IBOutlet UILabel* instructionsLabel;
@property (nonatomic,weak) IBOutlet UITextField* inputText;
@end

@implementation LHPUsernameEntryViewController

-(instancetype)initWithScore:(NSUInteger)score;
{
    self = [super init]; //TODO: Should this be intiWithCoder?
    {
        _score = score;
    }
    return self;
}

// remember that we must wait till viewDidLoad for the outlets to be set
-(void)viewDidLoad;
{
    self.instructionsLabel.text = NSLocalizedString(@"Please enter your name",
                                                    @"Instructions to player to enter name");
    self.scoreLabel.text = [NSString stringWithFormat:
                            NSLocalizedString(@"Score: %tu",
                                              @"Username Entry Score Label"),
                            self.score];
    self.inputText.placeholder = NSLocalizedString(@"Enter your name here",
                                                   @"Username Entry InputText placeholder instructions");
    self.inputText.delegate = self;

}

-(IBAction)save:(id)sender;
{
    self.username = self.inputText.text;
    if ( [self.username isEqualToString:@""]){

    UIAlertController* alertController =
        [UIAlertController
            alertControllerWithTitle:NSLocalizedString(@"Empty username field",
                                                       @"Username Entry alert title when username field is empty")
                             message:NSLocalizedString(@"Please enter a username",
                                                       @"message to user to correct empty username")
                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       //nothing needed
                                                       
                                                   }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion: nil];
    }
    else {
        [LHPScore addScore:self.score username:self.username];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)cancel:(id)sender;
{
    UIAlertController* alertController =
    [UIAlertController
     alertControllerWithTitle:NSLocalizedString(@"Cancelling Player Name entry",
                                                @"Username Entry alert title when user cancels")
     message:NSLocalizedString(@"Are you sure you want to cancel?",
                               @"Question to user to verify he wants to cancel")
     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes",nil)
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [self dismissViewControllerAnimated:YES
                                                                            completion:nil];
                                               }];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:NSLocalizedString(@"No",nil)
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                }];
    
    
    [alertController addAction:yes];
    [alertController addAction:no];
    [self presentViewController:alertController animated:YES completion: nil];
    
}

//TODO: verify that this works to save the most recent data
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self save:nil];
    return NO;
}

@end
