//
//  ViewController.m
//  ImageMatting
//
//  Created by ATH on 2019/10/22.
//  Copyright © 2019 ath. All rights reserved.
//

#import "ViewController.h"
#import "ImageMatting.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
      /************************************************/
    UILabel *originalimageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 150, 30)];
    [originalimageLabel setText:@"原图:"];
    [scrollView addSubview:originalimageLabel];
    
    ImageMatting *imageMatting = [[ImageMatting alloc]init];
    UIImageView *originalimageIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), 200)];
    UIImage *originalImage = [UIImage imageNamed:@"originalimage.jpg"];
    [originalimageIV setImage:originalImage];
    [scrollView addSubview:originalimageIV];
    
      /************************************************/
    UILabel *masterplateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(originalimageIV.frame)+30, 150, 30)];
    [masterplateLabel setText:@"模版图:"];
    [scrollView addSubview:masterplateLabel];
    UIImageView *masterplateIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(masterplateLabel.frame)+10, CGRectGetWidth(self.view.frame), 200)];
    [masterplateIV setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *masterplateImage = [UIImage imageNamed:@"masterplateImage.png"];

    [masterplateIV setImage:masterplateImage];
    [scrollView addSubview:masterplateIV];
    
      /************************************************/
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(masterplateIV.frame)+30, 150, 30)];
    [bgLabel setText:@"被扣图:"];
    [scrollView addSubview:bgLabel];
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(bgLabel.frame)+30, CGRectGetWidth(self.view.frame), 200)];
    UIImage *bgImage = [imageMatting generateBgImage:originalImage masterplateImage:masterplateImage startP:CGPointMake(120, 100)];
    [bgIV setImage:bgImage];
    [scrollView addSubview:bgIV];
    /************************************************/
    UILabel *targetLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(bgIV.frame)+30, 150, 30)];
    [targetLabel setText:@"扣出来的图:"];
    [scrollView addSubview:targetLabel];
    UIImageView *targetIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(targetLabel.frame)+30, CGRectGetWidth(self.view.frame), 200)];
    [targetIV setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *targetImage = [imageMatting generateTargetImage:originalImage masterplateImage:masterplateImage startP:CGPointMake(120, 100)];
    [targetIV setImage:targetImage];
    [scrollView addSubview:targetIV];
    
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(targetIV.frame)+50)];
}


@end
