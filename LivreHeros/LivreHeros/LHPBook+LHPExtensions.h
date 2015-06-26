//
//  LHPBook+LHPExtensions.h
//  LivreHeros
//
//  Created by Ancil on 6/26/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPBook.h"

@interface LHPBook (LHPExtensions)
@property (nonatomic,assign) NSUInteger currentIndex;
+(instancetype)sharedInstance;
-(void)addQuestion:(NSString*)text index:(NSUInteger)index yes:(NSUInteger)yesIndex no:(NSUInteger)noIndex;
@end
