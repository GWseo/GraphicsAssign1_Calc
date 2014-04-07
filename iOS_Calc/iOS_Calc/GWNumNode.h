//
//  GWNumNode.h
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum { None, Add, Sub, Mul, Div} OP;
typedef enum { Leaf, Node} TYPE;

typedef enum { OpenBracket,CloseBracket} Bracket;
@interface GWNumNode : NSObject{
    GWNumNode * leftNode;
    GWNumNode * rightNode;
    GWNumNode * parentNode;
    OP op;
    TYPE ty;
    BOOL B;
    int lValue;
    int rValue;
}
-(id)initWithValue:(int)V:(GWNumNode *)parent;
-(id)initWithPointer:(GWNumNode *)Child;
-(void)setRValue:(int)Value;
-(void)setLValue:(int)Value;
-(void)setRPointer:(GWNumNode *)Right;
-(void)setLPointer:(GWNumNode *)Left;
-(void)setOperator:(char)op;
-(int)GetResult;
-(BOOL)isChildFull;
-(BOOL)isLeftEmpty;
-(void)setBracket;
-(BOOL)checkBracket;
-(GWNumNode *)getParent;
@end
