//
//  GWCoreCalculator.h
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWNumNode.h"

@interface GWCoreCalculator : NSObject
/*
 Get operations as String
 */
- (int) Calc:(NSString *)operation;

@end
