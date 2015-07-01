//
//  SettingsView.m
//  LivreHeros
//
//  Created by Ancil on 6/30/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "SettingsView.h"


@interface SettingsView()
@property (nonatomic,weak) IBOutlet UILabel* redLabel;
@property (nonatomic,weak) IBOutlet UILabel* greenLabel;
@property (nonatomic,weak) IBOutlet UILabel* blueLabel;
@property (nonatomic,weak) IBOutlet UISlider* redSlider;
@property (nonatomic,weak) IBOutlet UISlider* greenSlider;
@property (nonatomic,weak) IBOutlet UISlider* blueSlider;

@end

@implementation SettingsView

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    if (self){
        
        [self.redSlider addTarget:self
                           action:@selector(sliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
        
        [self.greenSlider addTarget:self
                           action:@selector(sliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
        
        [self.blueSlider addTarget:self
                           action:@selector(sliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
    
}


-(void)updateLabels;
{
    self.redLabel.text =
        [NSString stringWithFormat:NSLocalizedString(@"%tu % Red of the background color",
                                                     @"Settings Red % label"),
         (NSUInteger)[self.redSlider value]*100];
    
    self.greenLabel.text =
    [NSString stringWithFormat:NSLocalizedString(@"%tu % Green of the background color",
                                                 @"Settings Green % label"),
     (NSUInteger)[self.greenSlider value]*100];
    
    self.blueLabel.text =
    [NSString stringWithFormat:NSLocalizedString(@"%tu % Blue of the background color",
                                                 @"Settings Blue % label"),
     (NSUInteger)[self.blueSlider value]*100];
    
}

-(void)sliderValueChanged;
{
    [self updateLabels];
    UIColor* color = [UIColor colorWithRed:self.redSlider.value
                                     green:self.greenSlider.value
                                      blue:self.blueSlider.value
                                     alpha:1.0];
    
    NSAssert(self.delegate != nil,@"LHPSettingsView delegate not yet set");
    NSAssert([self.delegate respondsToSelector:@selector(LHPSettingsView:didUpdateBackGroundColor:)],
             @"LHPSettingsView delegate does not implement required protocol");
    
    [self.delegate LHPSettingsView:self didUpdateBackGroundColor:color];
}

@end