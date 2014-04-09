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
    int index=0, subIndex=0;
    
    NSLog(@"operation\n");
    
    while ([operation length]!=index){
        if ([[operation substringWithRange:NSMakeRange(index, 1)] isEqualToString:@"(" ]) {
            subIndex=index+1;
            int depth = 0;
            while (YES){
                if([[operation substringWithRange:NSMakeRange(subIndex, 1)] isEqualToString:@")" ] ){
                    if (depth) {
                        depth--;
                        subIndex++;
                        continue;
                    }
                    else {
                        NSString* ReplaceOperation =[operation substringWithRange:NSMakeRange(index+1, subIndex-index-1)];
                        NSString *tempOperation = [NSString stringWithFormat:@"%@+0",ReplaceOperation];
                        
                        int tempResult = [self Calc:tempOperation];
                        NSLog(@"temp result : %d\n",tempResult);
                        operation = [operation stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)",ReplaceOperation] withString:[NSString stringWithFormat:@"%d",tempResult] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [operation length]) ];
                        break;
                    }
                }
                else if([[operation substringWithRange:NSMakeRange(subIndex, 1)] isEqualToString:@"(" ] ){
                    depth ++;
                }
                subIndex++;
            }
        }
        index ++;
    }
    @autoreleasepool {
        [self ParseOperation:operation];
        //check bracket
        if (![self checkBracket]) return -1;
        
        //make tree
        [self makeTree];
        
        //perform calculate
        result = [_root GetResult];
        
        NSLog(@"result : %d, root : %@\n",result, _root);
        
        //release datas
        _root = nil;
        _parseOperations =nil;
    }
    return result;
}


- (NSMutableArray *)ParseOperation:(NSString *)operation
{
    int index=0;
    int integerValue =0;
    BOOL integerFlag = NO;
    while (index<[operation length]) {
        switch ([operation characterAtIndex:index]){
                case '(':
                [self pushOperation:@"("];
                integerFlag=NO;
                break;
                
                case ')':
                if(integerFlag)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@")"];
                integerFlag=NO;
                break;
                
                case '*':
                if(integerFlag)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"*"];
                integerFlag=NO;
                break;
                
                case '/':
                if(integerFlag)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"/"];
                integerFlag=NO;
                break;
                
                case '+':
                if(integerFlag)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"+"];
                integerFlag=NO;
                break;
                
                case '-':
                if(integerFlag)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"-"];
                integerFlag=NO;
                break;
                
                case ';':
                if(integerFlag)[self pushNumber:integerValue];
                integerValue = 0;
                [self pushOperation:@"+"];
                [self pushNumber:0];
                integerFlag=NO;
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
                integerFlag = YES;
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
                    GWNumNode *temp;
                    parent = node;
                    node = [[GWNumNode alloc]initWithValue:[num intValue] :node];
                    temp = [parent getRNode];
                    [parent setRPointer:node];
                    [node setRPointer:temp];
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
                    //parent = node;
                    //node = [[GWNumNode alloc]initWithValue:0 :parent];
                    //if ([parent isLeftEmpty]) [parent setLPointer:node];
                    //else [parent setRPointer:node];
                }
            }else if([op isEqualToString:@")"]){
                [node setCloseBracket];
                int BracketReferenceCount = 0;
                while (YES) {
                    if([node checkOpenBracket]) {
                        if (BracketReferenceCount)  BracketReferenceCount-=[node getOpenBracketCount];
                        else break;
                    }
                    node =parent;
                    parent = [node getParent];
                    if ([parent checkCloseBracket]) BracketReferenceCount+= [node getCloseBracketCount];
                }
                //if (!parent) {
                //    parent = [[GWNumNode alloc]initWithPointer:node];
                //}
                //node = parent;
                //parent = [node getParent];
                
                
            }
            else{
                //operation priority
                
                //Backup
                GWNumNode *temp, *new;
                temp = node;
                
                if (([op characterAtIndex:0] == '-') || ([op characterAtIndex:0]=='+') ){
                    int bracketReferenceCount =0;
                    while (YES) {
                        if ([parent checkOpenBracket]){
                            bracketReferenceCount-=[parent getOpenBracketCount];
                            if(bracketReferenceCount<=0)break;
                        }
                        if ([node checkCloseBracket]) {
                            bracketReferenceCount+=[node getCloseBracketCount];
                            while (bracketReferenceCount<=0) {
                                node = parent;
                                parent = [node getParent];
                            }
                        }
                        if (([parent getOperation]== '*') || ([parent getOperation] =='/')){
                            node = parent;
                            parent = [node getParent];
                        }else{
                            //insert node
                            /*
                            if (!parent) {
                                //node = temp;
                                parent = [node getParent];
                                
                                break;
                            //}else{
                            */
                             new = [[GWNumNode alloc]initWithPointer:node];
                                [new setParent:parent];
                                if([parent isLeftEmpty])[parent setLPointer:new];
                                else [parent setRPointer:new];
                            //}
                            node = new;
                            
                            break;
                        }
                    }
                }else if (([op characterAtIndex:0] == '*') || ([op characterAtIndex:0]=='/') ){
                    if ([node getOperation] != None){
                        new = [[GWNumNode alloc]initWithValue:0 :node];
                        if ([node isLeftEmpty]) {
                            [new setLPointer:[node getLNode]];
                            [node setLPointer:new];
                        }else{
                            [new setLPointer:[node getRNode]];
                            [node setRPointer:new];
                        }
                        node = new;
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

- (BOOL)checkBracket{
    BOOL result = NO;
    int index = 0;
    int referenceCount=0;
    while ([_parseOperations count] != index) {
        if ([_parseOperations[index] isKindOfClass:[NSString class]]){
            NSString* Bracket = [_parseOperations objectAtIndex:index];
            if([Bracket isEqualToString:@"("]) referenceCount++;
            else if([Bracket isEqualToString:@")"]) referenceCount--;
        }
        index++;
    }
    if(referenceCount==0)   result=YES;
    else                    result=NO;
    return result;
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