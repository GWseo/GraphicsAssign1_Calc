//
//  GWNumNode.m
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import "GWNumNode.h"
@implementation GWNumNode

/*
 initialization with left Value, and get ParentNode
 */
- (id)initWithValue:(int)V :(GWNumNode*)parent{
    if ( self = [super init]){
        parentNode = parent;
        lValue = V;
        ty = Leaf;
        BO = NO;
        BC = NO;
    }
    return self;
}
/*
 initialization with Child Node
 */
- (id)initWithPointer:(GWNumNode *)Child{
    if ( self = [super init]){
        if(!leftNode)leftNode = Child;
        else rightNode =Child;
        ty = Node;
        op = None;
        BO = NO;
        BC = NO;
    }
    return self;
}

// Setters
- (void)setRValue:(int)Value{
    rValue = Value;
    [self checkNil];
}

- (void)setLValue:(int)Value{
    lValue = Value;
    [self checkNil];
}
- (void)setRPointer:(GWNumNode *)Right{
    rightNode = Right;
    
    [self checkNil];
}

- (void)setLPointer:(GWNumNode *)Left{
    leftNode = Left;
    [self checkNil];
}

- (void)setParent:(GWNumNode *)Pparent{
    parentNode = Pparent;
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

/*
 Check Node is leaf or not
 */
- (void)checkNil{
    if ( (leftNode || rightNode)) ty = Node;
    else ty = Leaf;
}

/*
 Calulate result with rValue & lValue (Recursive)
 */
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
    NSLog(@"Result : %d\n",result);
    
    return result;
}
// Operations
- (int)addOperation{
    if (leftNode){
        lValue = [leftNode GetResult];
    }
    if (rightNode){
        rValue = [rightNode GetResult];
    }else{
        rValue = 0;
    }
    return lValue + rValue;
}

- (int)subOperation{
    int result=0;
    if (leftNode){
        lValue = [leftNode GetResult];
    }
    if (rightNode){
        rValue = [rightNode GetResult];
    }else{
        rValue = 0;
    }
    result = lValue - rValue;
    return result;
}
- (int)mulOperation{
    int result=0;
    if(leftNode){
        lValue = [leftNode GetResult];
        
    }
    if (rightNode){
        rValue = [rightNode GetResult];
    }else{
        rValue = 1;
    }
    result = lValue * rValue;
    
    return result;
}
- (int)divOperation{
    int result=0;
    if(leftNode){
        lValue = [leftNode GetResult];
        
    }
    if (rightNode){
        rValue = [rightNode GetResult];
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

// Check States
- (BOOL)isChildFull{
    if (rightNode && leftNode) return YES;
    else return NO;
}
- (BOOL)isLeftEmpty{
    if (lValue!=0) return NO;
    if (leftNode) return NO;
    else return YES;
}

- (void)setOpenBracket{
    BO++;
}

- (void)setCloseBracket{
    BC++;
}
- (int)getCloseBracketCount{
    return BC;
}

- (int)getOpenBracketCount{
    return BO;
}
- (BOOL)checkOpenBracket{
    if (BO) return YES;
    else return NO;
}
- (BOOL)checkCloseBracket{
    if (BC) return YES;
    else return NO;
}

// getters
- (char)getOperation{
    char oper=None;
    switch (op) {
        case Add:
            oper='+';
            break;
        case Sub:
            oper='-';
            break;
        case Mul:
            oper='*';
            break;
        case Div:
            oper='/';
            break;
        default:
            break;
    }
    return oper;
}
- (GWNumNode*)getParent{
    return parentNode;
}
- (GWNumNode*)getLNode{
    return leftNode;
}
- (GWNumNode*)getRNode{
    return rightNode;
}

@end
