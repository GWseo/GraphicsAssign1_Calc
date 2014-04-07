//
//  GWCoreCalculator.h
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWCoreCalculator : NSObject

- (int) Calc:(NSString *)operation;
- (NSArray*)ParseOperation:(NSString*)operation;
- (void)pushNumber:(int)integerValue;
@end
