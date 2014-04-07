//
//  GWNumNode.h
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum { None, Add, Sub, Mul, Div, OpenBracket, CloseBracket} OP;
typedef enum { Leaf, Node} TYPE;
@interface GWNumNode : NSObject{
    GWNumNode * leftNode;
    GWNumNode * rightNode;
    GWNumNode * parentNode;
    OP op;
    TYPE ty;
    int lValue;
    int rValue;
}
-(id)initWithValue:(int)V:(GWNumNode *)parent;
-(id)initWithPointer:(GWNumNode *)Child;
-(void)setRValue:(int)Value;
-(void)setRPointer:(GWNumNode *)Right;
-(void)setLPointer:(GWNumNode *)Left;
-(void)setOperator:(char)op;
-(int)GetResult;
-(BOOL)isChildFull;
-(BOOL)isLeftEmpty;
@end
