//
//  ViewController.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHPSettingsViewController.h"
#import "LHPSettingsViewControllerDelegateProtocol.h"
#import "LHPBookViewControllerDelegateProtocol.h"

@interface LHPBookViewController : UIViewController <LHPSettingsViewControllerDelegateProtocol>
@property (nonatomic,weak) id<LHPBookViewControllerDelegateProtocol>delegate;
@end

