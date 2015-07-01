//
//  SettingsView.h
//  LivreHeros
//
//  Created by Ancil on 6/30/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHPSettingsViewDelegateProtocol;

@interface SettingsView : UIView
@property (nonatomic,weak) id<LHPSettingsViewDelegateProtocol> delegate;
-(void)initialize;
@end

@protocol LHPSettingsViewDelegateProtocol <NSObject>

-(void)LHPSettingsView:(SettingsView*)settingsView didUpdateBackGroundColor:(UIColor*)color;

@end