//
//  LHPSettingsViewController.h
//  LivreHeros
//
//  Created by Ancil on 6/29/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

//add this header to get the protocol needed
#import "SettingsView.h" //TODO: Sepearate the protocols from the class
#import "LHPBookViewControllerDelegateProtocol.h"
#import "LHPSettingsViewControllerDelegateProtocol.h"


@interface LHPSettingsViewController : UIViewController <LHPSettingsViewDelegateProtocol,LHPBookViewControllerDelegateProtocol>
@property (nonatomic,weak) id<LHPSettingsViewControllerDelegateProtocol> delegate;
@end

