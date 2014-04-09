//
//  GWViewController.m
//  iOS_Calc
//
//  Created by gyuwon_mac on 4/7/14.
//  Copyright (c) 2014 pnu. All rights reserved.
//

#import "GWViewController.h"
#import "GWCoreCalculator.h"

@interface GWViewController ()
@property (weak, nonatomic) IBOutlet UILabel *DigitDisplay;
@property (nonatomic, strong) GWCoreCalculator *calc;
@end

@implementation GWViewController
@synthesize DigitDisplay;
@synthesize calc =_calc;

- (GWCoreCalculator *)calc{
    if(!_calc) _calc = [[GWCoreCalculator alloc]init];
    return _calc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)StartCalculateBtn:(id)sender {
    NSLog(@"StartCalculate\n");
    int result = 0;
    @try {
        result = [self.calc Calc:[self.DigitDisplay.text stringByAppendingString:@";"]];
        self.DigitDisplay.text = [NSString stringWithFormat:@"%d",result];
    }
    @catch (NSException *exception) {
        NSLog([exception reason]);
        self.DigitDisplay.text = @"ERROR!!!!! PUSH CLEAR";
    }
    @finally {
        
    }
    NSLog(@"Done\n");
}

- (IBAction)ClearBtnClick:(UIButton *)sender {
    self.DigitDisplay.text = @"0";
}
- (IBAction)EraseBtn:(id)sender {
    self.DigitDisplay.text = [self.DigitDisplay.text substringWithRange:NSMakeRange(0, [self.DigitDisplay.text length]-1)];
    if ([self.DigitDisplay.text isEqualToString:@""]) {
        self.DigitDisplay.text = @"0";
    }
}

- (IBAction)NumberBtnClick:(UIButton *)sender {
    if( ![self.DigitDisplay.text compare: @"0"]) self.DigitDisplay.text = @"";
    self.DigitDisplay.text = [self.DigitDisplay.text stringByAppendingString:[sender currentTitle]];
}

@end
