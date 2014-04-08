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
    int BO;
    int BC;
    int lValue;
    int rValue;
}
//initializers
-(id)initWithValue:(int)V:(GWNumNode *)parent;
-(id)initWithPointer:(GWNumNode *)Child;
//setters
-(void)setRValue:(int)Value;
-(void)setLValue:(int)Value;
-(void)setRPointer:(GWNumNode *)Right;
-(void)setLPointer:(GWNumNode *)Left;
-(void)setOperator:(char)op;
-(void)setParent:(GWNumNode*)Pparent;

//calculate own result
-(int)GetResult;

//check state
-(BOOL)isChildFull;
-(BOOL)isLeftEmpty;
//setter cont`
-(void)setOpenBracket;
-(void)setCloseBracket;
-(BOOL)checkOpenBracket;
-(BOOL)checkCloseBracket;
//getters
-(char)getOperation;
-(GWNumNode *)getParent;
-(int)getOpenBracketCount;
-(int)getCloseBracketCount;
@end
