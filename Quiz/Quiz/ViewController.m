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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showQuestion:(id)sender
{
    NSLog(@"question");
    self.currentQuestionIndex++;
    if (self.currentQuestionIndex == [self.questions count]) {
        self.currentQuestionIndex=0;
    }
    
    NSString *question=self.questions[self.currentQuestionIndex];
    self.questionLabel.text=question;
    self.answerLabel.text=@"???";
}

-(IBAction)showAnswer:(id)sender
{
    NSString *answer = self.answers[self.currentQuestionIndex];
    self.answerLabel.text = answer;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"iiniti");
    if (self) {
        self.questions=@[@"ewoeriwer", @"idlkfjsodf", @"oeirwoer"];
        self.answers=@[@"ieieieeiei", @"2312312", @"12333333"];
    }
    return self;
}

@end
