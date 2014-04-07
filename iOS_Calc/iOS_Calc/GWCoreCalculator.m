//
//  GWCoreCalculator.m
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import "GWCoreCalculator.h"
#import "GWNumNode.h"
@interface GWCoreCalculator()
@property (nonatomic, strong)NSMutableArray *parseOperations;
@end
@implementation GWCoreCalculator
@synthesize parseOperations = _parseOperations;

- (NSMutableArray*) parseOperations{
    if(!_parseOperations)_parseOperations = [[NSMutableArray alloc] init];
    return _parseOperations;
}


- (int) Calc:(NSString *)operation
{
    int result=0;
    NSLog(@"operation\n");
    [self ParseOperation:operation];
    //check bracket
    
    //push operation stack
    
    //mul and div operation
    
    //add and sub operation
    
    
    return result;
}

- (NSMutableArray *)ParseOperation:(NSString *)operation
{
    int index=0;
    int integerValue =0;
    while (index<[operation length]) {
        switch ([operation characterAtIndex:index]){
                case '(':
                [self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"("];
                break;
                
                case ')':
                [self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@")"];
                break;
                
                case '*':
                [self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"*"];
                break;
                
                case '/':
                [self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"/"];
                break;
                
                case '+':
                [self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"+"];
                break;
                
                case '-':
                [self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"-"];
                break;
                
                case ';':
                [self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"+"];
                [self pushNumber:0];
                break;
                
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                case '0':
                integerValue*=10;
                integerValue+=[operation characterAtIndex:index]-'0';
                break;
            default:
                NSLog(@"Error!!\n");
                break;
        
        }
        index++;
    }
    return _parseOperations;
}
- (void)pushNumber:(int)integerValue{
    NSNumber* num = [NSNumber numberWithInt:integerValue];
    [_parseOperations addObject:num];
    NSLog(@"push num : %d\n",integerValue);
}

- (void)pushOperation:(NSString*)operator{
    NSCharacterSet* oper = [NSCharacterSet characterSetWithCharactersInString:operator ];
    [_parseOperations addObject:oper];
    NSLog(@"push oper : %@\n",operator);
}
@end