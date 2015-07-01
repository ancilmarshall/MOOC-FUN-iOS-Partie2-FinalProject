//
//  LHPSettingsViewController.h
//  LivreHeros
//
//  Created by Ancil on 6/29/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsView.h" //TODO: Sepearate the protocols

@protocol LHPSettingsViewControllerDelegateProtocol;

@interface LHPSettingsViewController : UIViewController <LHPSettingsViewDelegateProtocol>
@property (nonatomic,weak) id<LHPSettingsViewControllerDelegateProtocol> delegate;
@end

@protocol LHPSettingsViewControllerDelegateProtocol <NSObject>

-(void)backgroundColorDidUpdate:(UIColor*)color;

@end