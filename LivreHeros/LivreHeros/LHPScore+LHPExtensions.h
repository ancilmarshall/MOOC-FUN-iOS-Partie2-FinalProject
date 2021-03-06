//
//  LHPScore+LHPExtensions.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPScore.h"

@interface LHPScore (LHPExtensions)
@property (nonatomic,assign) NSUInteger score;
+(void)addScore:(NSUInteger)value username:(NSString*)username;
+(NSArray*)fetchScores;
+(void)deleteScore:(LHPScore*)score;
+(void)deleteAllManagedObjects;
@end
