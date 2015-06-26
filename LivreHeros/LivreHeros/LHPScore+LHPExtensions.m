//
//  LHPScore+LHPExtensions.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPScore+LHPExtensions.h"

@implementation LHPScore (LHPExtensions)

-(NSString*)username;
{
    return self.usernameString;
}

-(void)setUsername:(NSString*)username;
{
    self.usernameString = username;
}

-(NSUInteger)score;
{
    return [self.scoreValue unsignedIntegerValue];
}

-(void)setScore:(NSUInteger)score;
{
    self.scoreValue = @(score);
}

@end
