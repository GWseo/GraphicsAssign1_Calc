//
//  GWNumNode.m
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import "GWNumNode.h"
@implementation GWNumNode

- (id)initWithValue:(int)Value :(GWNumNode*)parent{
    if ( self = [super init]){
        parentNode = parent;
        lValue = Value;
        ty = Leaf;
    }
    return self;
}

- (id)initWithPointer:(GWNumNode *)Child{
    if ( self = [super init]){
        leftNode = Child;
        ty = Node;
        op = None;
    }
    return self;
}
- (void)setRValue:(int)Value{
    rValue = Value;
    
    [self checkNil];
}
- (void)setRPointer:(GWNumNode *)Right{
    rightNode = Right;
    
    [self checkNil];
}
- (void)setOperator:(char)oper{
    switch (oper) {
        case '+':
            op = Add;
            break;
        case '-':
            op = Sub;
            break;
        case '*':
            op = Mul;
            break;
        case '/':
            op = Div;
            break;
        
        default:
            NSLog(@"Wrong Operation\n");
            break;
    }
}


- (void)checkNil{
    if ( !(leftNode && rightNode)) ty = Leaf;
    else ty = Node;
}

- (int)GetResult{
    int result=0;
    if ( ty == Node){
        switch (op){
            case Add:
                result = [self addOperation];
                break;
            
            case Sub:
                result = [self subOperation];
                break;
        
            case Div:
                result = [self divOperation];
                break;
            
            case Mul:
                result = [self mulOperation];
                break;
            case None:
                NSLog(@"ERROR! OPERATION IS NOT SET!!!\n");
                break;
            default:
                break;
        }
    }
    else{
        result = lValue;
    }
    
    return result;
}

- (int)addOperation{
    if (!leftNode){
        lValue = [leftNode GetResult];
        if (!rightNode){
            rValue = [rightNode GetResult];
        }
    }
    return lValue + rValue;
}

- (int)subOperation{
    int result=0;
    if (!leftNode){
        lValue = [leftNode GetResult];
        if (!rightNode){
            rValue = [rightNode GetResult];
        }
    }
    result = lValue - rValue;
    return result;
}
- (int)mulOperation{
    int result=0;
    if(!leftNode){
        lValue = [leftNode GetResult];
        if (!rightNode){
            rValue = [rightNode GetResult];
        }
    }
    result = lValue * rValue;
    
    return result;
}
- (int)divOperation{
    int result=0;
    if(!leftNode){
        lValue = [leftNode GetResult];
        if (!rightNode){
            rValue = [rightNode GetResult];
        }
    }
    if(rValue != 0){
        result = lValue/rValue;
    }else{
        NSLog(@"Div 0 ERROR!!\n");
        [NSException raise:@"Div 0 Error" format:@"lValue = %d, rValue = %d\n",lValue,rValue];
        result = 0;
    }
    
    return result;
}
@end
