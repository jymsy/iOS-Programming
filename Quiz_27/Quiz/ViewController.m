//
//  ViewController.m
//  Quiz
//
//  Created by 蒋羽萌 on 15/10/9.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@property (nonatomic) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.questions=@[@"ewoeriwer", @"idlkfjsodf", @"oeirwoer"];
    self.answers=@[@"ieieieeiei", @"2312312", @"12333333"];
    
    self.questionLabel.text=self.questions[0];
    self.answerLabel.text = @"???";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showQuestion:(id)sender
{
    self.currentQuestionIndex++;
    if (self.currentQuestionIndex == [self.questions count]) {
        self.currentQuestionIndex=0;
    }
    
    NSString *question=self.questions[self.currentQuestionIndex];
//    self.questionLabel.text=question;
//    self.answerLabel.text=@"???";
    
    [self animationLabel:self.questionLabel newText:question];
    [self animationLabel:self.answerLabel newText:@"???"];
//    self.answerLabel.text=@"???";
}

-(IBAction)showAnswer:(id)sender
{
    NSString *answer = self.answers[self.currentQuestionIndex];
//    self.answerLabel.text = answer;
    [self animationLabel:self.answerLabel newText:answer];
}

-(void)animationLabel:(UILabel *)label newText:(NSString *)text
{
    CGFloat windowWidth = [[UIScreen mainScreen] bounds].size.width;
    CGRect origFrame = label.frame;
    
    [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
//        label.alpha = 0;
        CGRect newFrame = origFrame;
        newFrame.origin.x = windowWidth;
        label.frame = newFrame;
    } completion:^(BOOL finished){
        label.text = text;
        CGRect newFrame = origFrame;
        newFrame.origin.x = -windowWidth;
        label.frame = newFrame;
        [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
//            label.alpha = 1;
            label.frame = origFrame;
        } completion:NULL];
    }];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.questions=@[@"ewoeriwer", @"idlkfjsodf", @"oeirwoer"];
        self.answers=@[@"ieieieeiei", @"2312312", @"12333333"];
    }
    return self;
}

@end
