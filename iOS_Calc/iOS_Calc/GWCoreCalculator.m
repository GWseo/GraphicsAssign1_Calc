//
//  GWCoreCalculator.m
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import "GWCoreCalculator.h"

@interface GWCoreCalculator()
@property (nonatomic, strong)NSMutableArray *parseOperations;
@property (nonatomic, strong)GWNumNode* root;
@end
@implementation GWCoreCalculator
@synthesize parseOperations = _parseOperations;
@synthesize root = _root;

- (NSMutableArray*) parseOperations{
    if(!_parseOperations){
        _parseOperations = [[NSMutableArray alloc] init];
        NSLog(@"parse operation array create\n!");
    }
    return _parseOperations;
}
- (GWNumNode *) root{
    return _root;
}

- (int) Calc:(NSString *)operation
{
    int result=0;
    _root=nil;
    NSLog(@"operation\n");
    [self ParseOperation:operation];
    //check bracket
    
    //make tree
    [self makeTree];
    //perform calculate
    
    result = [_root GetResult];
    
    NSLog(@"result : %d, root : %@\n",result, _root);
    return result;
}

- (NSMutableArray *)ParseOperation:(NSString *)operation
{
    int index=0;
    int integerValue =0;
    while (index<[operation length]) {
        switch ([operation characterAtIndex:index]){
                case '(':
                //[self pushNumber:integerValue];
                //integerValue = 0;
                [self pushOperation:@"("];
                break;
                
                case ')':
                if(integerValue)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@")"];
                break;
                
                case '*':
                if(integerValue)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"*"];
                break;
                
                case '/':
                if(integerValue)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"/"];
                break;
                
                case '+':
                if(integerValue)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"+"];
                break;
                
                case '-':
                if(integerValue)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"-"];
                break;
                
                case ';':
                if(integerValue)[self pushNumber:integerValue];
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
    NSLog(@"parsed operations count : %d",[[self parseOperations] count]);
    return _parseOperations;
}


- (void)makeTree{
    GWNumNode *node=nil;
    GWNumNode *parent = nil;
    int index = 0;
    NSLog(@"make tree, %d\n",[_parseOperations count]);
    while (index != [_parseOperations count] ){
        if([_parseOperations[index] isKindOfClass:[NSNumber class ]]){
            NSNumber* num = [_parseOperations objectAtIndex:index];
            NSLog(@"this is number : %d\n",[num intValue]);
            
            if(node){
                //parent = node;
                if([node isLeftEmpty] ){
                    //[parent setLPointer:node];
                    parent = [node getParent];

                    [node setLValue:[num intValue]];
                }
                else{
                    
                    parent = node;
                    node = [[GWNumNode alloc]initWithValue:[num intValue] :node];
                    [parent setRPointer:node];
                }
               
            }else{
                node = [[GWNumNode alloc] initWithValue:[num intValue]: parent];
            }
        }
        else{
            NSString* op = [_parseOperations objectAtIndex:index];
            NSLog(@"is this not : %@\n",op);
            if ([op isEqualToString:@"("]) {
                if( !node ){
                    node = [[GWNumNode alloc]initWithValue:0 :node];
                    [node setOpenBracket];
                    
                }else{
                    [node setOpenBracket];
                    parent = node;
                    node = [[GWNumNode alloc]initWithValue:0 :parent];
                    if ([parent isLeftEmpty]) [parent setLPointer:node];
                    else [parent setRPointer:node];
                }
            }else if([op isEqualToString:@")"]){
                [node setCloseBracket];
                
                while (YES) {
                    if([node checkOpenBracket]) break;
                    node =parent;
                    parent = [node getParent];
                }
                if (!parent) {
                    parent = [[GWNumNode alloc]initWithPointer:node];
                }
                node = parent;
                parent = [node getParent];
                
                
            }
            else{
                //operation priority
                
                //Backup
                GWNumNode *temp, *new;
                temp = node;
                
                if (([op characterAtIndex:0] == '-') || ([op characterAtIndex:0]=='+') ){
                    while (YES) {
                        if ([parent checkOpenBracket]){
                            break;
                        }
                        if ([node checkCloseBracket]) {
                            while ([node checkOpenBracket]) {
                                node = parent;
                                parent = [node getParent];
                            }
                        }
                        if (([parent getOperation]== '*') || ([parent getOperation] =='/')){
                            node = parent;
                            parent = [node getParent];
                        }else{
                            //insert node
                            if (!parent) {
                                node = temp;
                                parent = [node getParent];
                                break;
                            }
                            new = [[GWNumNode alloc]init];
                            [new setLPointer:node];
                            [new setParent:parent];
                            [parent setRPointer:new];
                            
                            node = new;
                            
                            break;
                        }
                    }
                    
                }
                
                [node setOperator:[op characterAtIndex:0]];
                
                
            }
        }
        index++;
    }
    _root = [self getRoot:node];
    NSLog(@"root done?? %@",node);
}
- (void)pushNumber:(int)integerValue{
    NSNumber* num = [NSNumber numberWithInt:integerValue];
    [[self parseOperations] addObject:num];
    NSLog(@"push num : %d\n",integerValue);
}

- (void)pushOperation:(NSString*)operator{
    NSString* oper = [NSString stringWithString:operator ];
    [[self parseOperations] addObject:oper];
    NSLog(@"push oper : %@\n",operator);
}

- (GWNumNode *)getRoot:(GWNumNode *)node{
    GWNumNode *parent = [node getParent];
    GWNumNode *root = node;
    while (parent){
        root= parent;
        parent = [parent getParent];
        NSLog(@"get root : %@",root);
    }
    return root;
}
@end