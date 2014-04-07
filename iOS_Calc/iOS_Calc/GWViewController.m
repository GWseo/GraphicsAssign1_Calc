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
    int result = [self.calc Calc:[self.DigitDisplay.text stringByAppendingString:@";"]];
    NSLog(@"StartCalculateBtn\n");
    self.DigitDisplay.text = [NSString stringWithFormat:@"%d",result];
}


- (IBAction)NumberBtnClick:(UIButton *)sender {
    if( ![self.DigitDisplay.text compare: @"0"]) self.DigitDisplay.text = @"";
    self.DigitDisplay.text = [self.DigitDisplay.text stringByAppendingString:[sender currentTitle]];
}

@end
