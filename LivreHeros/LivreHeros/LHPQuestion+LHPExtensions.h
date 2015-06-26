//
//  LHPQuestion+LHPExtensions.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPQuestion.h"
#import "LHPBook.h"

@interface LHPQuestion (LHPExtensions)
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,assign) NSUInteger noIndex;
@property (nonatomic,assign) NSUInteger yesIndex;

+(LHPQuestion*)insertQuestion:(NSString*)text index:(NSUInteger)index yesIndex:(NSUInteger)yesIndex noIndex:(NSUInteger)noIndex book:(LHPBook*)book;
+(NSString*)questionForIndex:(NSUInteger)index;
+(NSUInteger)yesIndexForIndex:(NSUInteger)index;
+(NSUInteger)noIndexForIndex:(NSUInteger)index;
+(LHPQuestion*)questionEntityForIndex:(NSUInteger)index;

@end
