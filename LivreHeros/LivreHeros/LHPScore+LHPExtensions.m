//
//  LHPScore+LHPExtensions.m
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPScore+LHPExtensions.h"

@implementation LHPScore (LHPExtensions)

-(NSUInteger)score;
{
    return [self.scoreNSNumber unsignedIntegerValue];
}

-(void)setScore:(NSUInteger)score;
{
    self.scoreNSNumber = @(score);
}

@end
