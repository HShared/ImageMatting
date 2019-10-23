//
//  ImaeMatting.m
//  ImageMatting
//
//  Created by ATH on 2019/10/22.
//  Copyright © 2019 ath. All rights reserved.
//

#import "ImageMatting.h"

@implementation ImageMatting
-(id)init{
    if(self = [super init]){
        self.filterColorValue = 200;
    }
    return self;
}

-(UIImage *)generateTargetImage:(UIImage *)originalImage masterplateImage:(UIImage *)masterplateImage startP:(CGPoint)startP{
    //获取原图的RGBA数据
    unsigned char *originalImageData = [self convertUIImageToData:originalImage];
    //获取模版图的RGBA数据
    unsigned char *masterplateImageData = [self convertUIImageToData:masterplateImage];
    CGFloat targetImageW = masterplateImage.size.width;//目标图的宽等于模版度宽
    CGFloat targetImageH = masterplateImage.size.height;//目标图高等于模版图高
    CGFloat targetImageLen =targetImageW*targetImageH * 4 * sizeof(unsigned char);
    unsigned char *targetImageData = malloc(targetImageLen);
    memset(targetImageData, 0,targetImageLen);
   for(int h=0;h<targetImageH;h++){//高
        for(int w=0;w<targetImageW;w++){//宽
            int index = h*targetImageW+w;
            //获取模版图各个点的R（Red）、G（Green）、B（Blue）、A（透明度）的值
            unsigned char masterplateImageR = *(masterplateImageData + index*4);
            unsigned char masterplateImageG = *(masterplateImageData + index*4+1);
            unsigned char masterplateImageB = *(masterplateImageData + index*4+2);
            unsigned char masterplateImageA = *(masterplateImageData + index*4+3);
            if(masterplateImageA!=0){
                //将在模版图中R、G、B的值大于filterColorValue的点
                //所对应原图的点的颜色值拷贝到目标图中
                if(masterplateImageR>self.filterColorValue
                   &&masterplateImageG>self.filterColorValue
                   &&masterplateImageB>self.filterColorValue){
                     int orignalImageIndex = (h+startP.y)*originalImage.size.width+(w+startP.x);
                    //所对应原图的点的r、g、b
                    unsigned char r = *(originalImageData+orignalImageIndex*4);
                    unsigned char g = *(originalImageData+orignalImageIndex*4+1);
                    unsigned char b = *(originalImageData+orignalImageIndex*4+2);
                    unsigned char a = *(originalImageData+orignalImageIndex*4+3);
                    //拷贝
                    memset(targetImageData+index*4,r, 1);
                    memset(targetImageData+index*4+1,g, 1);
                    memset(targetImageData+index*4+2,b, 1);
                    memset(targetImageData+index*4+3,a, 1);
                }
                else{
                    //保留边界部分，直接将模版图中不属于白色部分且透明度不为0的点的颜色值拷贝到生成的图当中
                    memset(targetImageData+index*4,masterplateImageR, 1);
                    memset(targetImageData+index*4+1,masterplateImageG, 1);
                    memset(targetImageData+index*4+2,masterplateImageB, 1);
                    memset(targetImageData+index*4+3,masterplateImageA, 1);
                }
            }
        }
    }
   return [self convertDataToUIImage:targetImageData image:masterplateImage.size];
}

-(UIImage *)generateBgImage:(UIImage *)originalImage masterplateImage:(UIImage *)masterplateImage startP:(CGPoint)startP{
     //获取原图的RGBA数据
    unsigned char *originalImageData = [self convertUIImageToData:originalImage];
     //获取模版图的RGBA数据
    unsigned char *masterplateImageData = [self convertUIImageToData:masterplateImage];
    CGFloat masterplateImageW = masterplateImage.size.width;
    CGFloat masterplateImageH = masterplateImage.size.height;
    for(int h=0;h<masterplateImageH;h++){//高
        for(int w=0;w<masterplateImageW;w++){//宽
            int index = h*masterplateImageW+w;
            unsigned char masterplateImageA = *(masterplateImageData + index*4+3);
            if(masterplateImageA>240){
                int originalImageIndex = (h+startP.y)*originalImage.size.width+w+startP.x;
                unsigned char r = *(originalImageData+originalImageIndex*4);
                unsigned char g = *(originalImageData+originalImageIndex*4+1);
                unsigned char b = *(originalImageData+originalImageIndex*4+2);
                float alpha = 0.6f;
                int darkR = 20;
                int darkG = 20;
                int darkB = 20;
                //黑色半透明（0.6）和原图的颜色值进行中和
                r =(unsigned char)(darkR*alpha+ r*(1-alpha));
                g =(unsigned char)(darkG*alpha+ g*(1-alpha));
                b =(unsigned char)(darkB*alpha+ b*(1-alpha));
                //拷贝，在被抠部分加一层黑色遮罩
               memset(originalImageData+originalImageIndex*4,r, 1);
               memset(originalImageData+originalImageIndex*4+1,g, 1);
               memset(originalImageData+originalImageIndex*4+2,b, 1);
            }
            
        }
    }
    return [self convertDataToUIImage:originalImageData image:originalImage.size];
}

-(unsigned char *)convertUIImageToData:(UIImage *)image{
    CGImageRef imageref = [image CGImage];
    CGSize imageSize = image.size;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *data = malloc(imageSize.width*imageSize.height*4);
    memset(data, 0,imageSize.width*imageSize.height*4);
    CGContextRef context = CGBitmapContextCreate(data, imageSize.width, imageSize.height,8,4*imageSize.width, colorSpace,kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), imageref);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return (unsigned char *)data;
}

-(UIImage *)convertDataToUIImage:(unsigned char *)imageData image:(CGSize)size{
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSInteger dataLength = width*height *4;
    CGDataProviderRef provide = CGDataProviderCreateWithData(NULL,
                                                             imageData,
                                                             dataLength,
                                                             NULL);
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageref = CGImageCreate(width,
                                        height,
                                        8,
                                        32,
                                        4*width,colorSpace,
                                        kCGImageAlphaPremultipliedLast
                                        |kCGBitmapByteOrderDefault,
                                        provide,
                                        NULL,
                                        NO,
                                        renderingIntent);
    UIImage *imageNew = [UIImage imageWithCGImage:imageref];
    CFRelease(imageref);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provide);
    return imageNew;
    
}


@end
