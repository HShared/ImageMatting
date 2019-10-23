//
//  ImaeMatting.h
//  ImageMatting
//
//  Created by ATH on 2019/10/22.
//  Copyright © 2019 ath. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//一张图实际上是由很多个点组成的，每个点就是一个颜色值，
//一个点分别包过R、G、B、A。R表示红色，G表示绿色、B表示蓝色，A表示透明度。
//R、G、B、A分别用一个字节来表示，因此表示一个点需要四子节，一个字节的最大值为255，16进制为0xff
//抠图实际上就是把要扣的图的部分点的颜色值（RGBA）拷贝出来，放到新的一张图中
@interface ImageMatting : NSObject

@property(nonatomic,assign)NSInteger filterColorValue;//颜色阈值，模版图中R、G、B同时要大于该值的像素点才会将原图的对应点设置到扣出来的图的对应点中

/**
 从原图中抠出一张与模版图形状一致的图

 @param originalImage 原图
 @param masterplateImage 模版图（大小要小于原图）
                         模版图的形状内填充颜色要求为白色（边界可为其它颜色，抠出的图的边
                         界颜色将与模版图的边界颜色一致）
 @param startP  开始抠图的位置（以原图左上角为坐标原点）
 @return 扣出来的与模版图形状一致的图
 */
-(UIImage *)generateTargetImage:(UIImage *)originalImage masterplateImage:(UIImage *)masterplateImage startP:(CGPoint)startP;

/**
 在原图中添加模版图一层黑色半透明遮罩

 @param originalImage 原图
 @param masterplateImage 模版图，依据模版图的透明度进行扣图
 @param startP 开始抠图的位置（以原图左上角为坐标原点，其大小为模版图的大小，因此模版图不能大于原图）
 @return 经过处理后的原图
 */
-(UIImage *)generateBgImage:(UIImage *)originalImage masterplateImage:(UIImage *)masterplateImage startP:(CGPoint)startP;

/**
 将UIImage转为RGBA数据
 @param image 要转的UIImage
 @return RGBA数据，一维数组
 */
-(unsigned char *)convertUIImageToData:(UIImage *)image;
/**
 将RGBA数据(一维数组)转为UIImage
 
 @param imageData RGBA
 @param size UIImage的宽和高
 @return 返回生成的UIImage
 */
-(UIImage *)convertDataToUIImage:(unsigned char *)imageData image:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
