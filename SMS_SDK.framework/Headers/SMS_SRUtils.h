//
//  SRUtils.h
//  ShareREC
//
//  Created by 冯 鸿杰 on 14-4-25.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "SMS_SRReachability.h"

/**
 *	@brief	网络类型
 */
typedef enum
{
	SRNetworkTypeNone = 0, /**< 无网络 */
	SRNetworkTypeCellular = 1, /**< 蜂窝网络 */
    SRNetworkTypeWifi = 2, /**< wifi */
}
SRNetworkType;

/**
 *	@brief	圆角类型
 */
typedef enum
{
    SROvalTypeNone = 0,             /**< 无圆角 */
    SROvalTypeLeftTop = 1,          /**< 左上角 */
    SROvalTypeLeftBottom = 2,       /**< 左下角 */
    SROvalTypeRightTop = 4,         /**< 右上角 */
    SROvalTypeRightBottom = 8,      /**< 右下角 */
    SROvalTypeAll = SROvalTypeLeftTop | SROvalTypeLeftBottom | SROvalTypeRightBottom | SROvalTypeRightTop   /**< 全部 */
}
SROvalType;

@interface SMS_SRUtils : NSObject

/**
 *	@brief	获取ShareSDK.bundle中的本地字符串资源
 *
 *	@param 	name 	资源名称
 *
 *	@return	字符串
 */
+ (NSString *)localizedStringWithName:(NSString *)name;

/**
 *	@brief	URL编码
 *
 *  @param  string      需要进行URL编码字符串
 *	@param 	encoding 	编码标准
 *
 *	@return	编码后字符串
 */
+ (NSString *)urlEncodeWithString:(NSString *)string encoding:(NSStringEncoding)encoding;

/**
 *	@brief	URL解码
 *
 *  @param  string      需要进行URL解码字符串
 *	@param 	encoding 	编码标准
 *
 *	@return	解码后字符串
 */
+ (NSString *)urlDecodeWithString:(NSString *)string encoding:(NSStringEncoding)encoding;

/**
 *	@brief	使用HMac-SHA1进行签名
 *
 *  @param  string  字符串
 *	@param 	key 	密钥
 *
 *	@return	签名后的数据
 */
+ (NSData *)dataUsinghmacSha1StringWithString:(NSString *)string key:(NSString *)key;

/**
 *	@brief	使用Key进行HMAC-SHA1加密
 *
 *  @param  data    数据
 *	@param 	key 	密钥
 *
 *	@return	加密后数据
 */
+ (NSData *)dataUsingHMacSHA1WithData:(NSData *)data key:(NSData *)key;

/**
 *	@brief	使用BASE64编码数据
 *
 *  @param  data    数据
 *
 *	@return	编码后字符串
 */
+ (NSString *)stringUsingBase64EncodeWithData:(NSData *)data;

/**
 *	@brief	使用Base64进行解码得到二进制数据对象
 *
 *  @param  string  字符串
 *
 *	@return	二进制数据对象
 */
+ (NSData *)dataUsingBase64DecodeWithString:(NSString *)string;

/**
 *	@brief	使用SHA1算法进行签名
 *
 *  @param  string  字符串
 *
 *	@return	签名后字符串
 */
+ (NSString *)stringUsingSHA1WithString:(NSString *)string;

/**
 *	@brief	对数据进行CRC32校验
 *
 *	@param 	data 	数据
 *
 *	@return	校验值
 */
+ (NSString *)crc32WithData:(NSData *)data;

/**
 *	@brief	取得网卡的物理地址
 *
 *	@return	网卡物理地址
 */
+ (NSString *)macAddress;

/**
 *	@brief	获取设备型号
 *
 *	@return	设备型号
 */
+ (NSString *)deviceModel;

/**
 *	@brief	获取当前网络类型
 *
 *	@return	网络类型
 */
+ (SRNetworkType)currentNetworkType;

/**
 *	@brief	获取手机运营商代码
 *
 *	@return	手机运营商代码
 */
+ (NSString *)carrier;

/**
 *	@brief	对数据进行MD5散列
 *
 *  @param  data    数据
 *
 *	@return	MD5后的数据
 */
+ (NSData *)dataUsingMD5WithData:(NSData *)data;

/**
 *	@brief	使用MD5算法进行签名（16位）
 *
 *  @param  data  要签名数据
 *
 *	@return	签名后字符串
 */
+ (NSString *)hexDigestStringUsingMD5WithData:(NSData *)data;

/**
 *	@brief	使用MD5算法进行签名（16位）
 *
 *  @param  string  要签名字符串
 *
 *	@return	签名后字符串
 */
+ (NSString *)hexDigestStringUsingMD5WithString:(NSString *)string;

/**
 *	@brief	AES128位加密
 *
 *  @param  data    需要加密数据
 *	@param 	key 	密钥
 *	@param 	iv 	初始向量,允许为nil
 *  @param  encoding    字符编码
 *
 *	@return	加密后数据
 */
+ (NSData *)dataUsingAES128EncryptWithData:(NSData *)data
                                       key:(NSString *)key
                                        iv:(NSString *)iv
                                  encoding:(NSStringEncoding)encoding;

/**
 *	@brief	AES128位解密
 *
 *  @param  data    需要解密数据
 *	@param 	key 	密钥
 *	@param 	iv 	初始向量,允许为nil
 *  @param  encoding    字符编码
 *
 *	@return	解密后数据
 */
+ (NSData *)dataUsingAES128DecryptWithData:(NSData *)data
                                       key:(NSString *)key
                                        iv:(NSString *)iv
                                  encoding:(NSStringEncoding)encoding;

/**
 *	@brief	AES128位加密
 *
 *  @param  data    需要加密数据
 *	@param 	key 	密钥
 *	@param 	iv 	初始向量,允许为nil
 *  @param  options     选项
 *
 *	@return	加密后数据
 */
+ (NSData *)dataUsingAES128EncryptWithData:(NSData *)data
                                       key:(NSData *)key
                                        iv:(NSData *)iv
                                   options:(CCOptions)options;

/**
 *	@brief	AES128位解密
 *
 *  @param  data    需要解密数据
 *	@param 	key 	密钥
 *	@param 	iv 	初始向量,允许为nil
 *  @param  options     选项
 *
 *	@return	解密后数据
 */
+ (NSData *)dataUsingAES128DecryptWithData:(NSData *)data
                                       key:(NSData *)key
                                        iv:(NSData *)iv
                                   options:(CCOptions)options;

/**
 *	@brief	比较版本字符串
 *
 *	@param 	other 	需要对比的版本号
 *
 *	@return	NSOrderedAscending 表示大于指定版本 NSOrderedSame 表示两个版本相同  NSOrderedDescending 表示小于指定版本
 */
+ (NSComparisonResult)versionStringCompare:(NSString *)other;

/**
 *	@brief	获取图片对象
 *
 *	@param 	name 	图片名称
 *	@param 	bundleName 	Bundle名称
 *
 *	@return	图片对象
 */
+ (UIImage *)imageNamed:(NSString *)name bundleName:(NSString *)bundleName;

/**
 *	@brief	获取图片对象
 *
 *	@param 	name 	图片名称
 *	@param 	bundle 	资源包对象
 *
 *	@return	图片对象
 */
+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle;


/**
 *	@brief	裁剪图片
 *
 *  @param  image   图片对象
 *	@param 	rect 	裁剪范围
 *
 *	@return	裁剪后的图片对象
 */
+ (UIImage *)clipImageWithImage:(UIImage *)image rect:(CGRect)rect;

/**
 *	@brief	创建圆角图片
 *
 *  @param  image   图片对象
 *	@param 	size 	圆角图像的图片尺寸
 *	@param 	ovalWidth 	圆角宽度
 *	@param 	ovalHeight 	圆角高度
 *  @param  ovalType    圆角类型
 *
 *	@return	圆角图片对象引用
 */
+ (UIImage *)roundedRectImageWithImage:(UIImage *)image
                                  size:(CGSize)size
                             ovalWidth:(CGFloat)ovalWidth
                            ovalHeight:(CGFloat)ovalHeight
                              ovalType:(SROvalType)ovalType;

/**
 *	@brief	等比缩放照片
 *
 *  @param  image   图片对象
 *	@param 	size 	缩放的图片尺寸。如果该尺寸不是按照等比设置，则函数按照宽度或高度最大比例进行等比缩放。
 *
 *	@return	等比缩放后的图片对象
 */
+ (UIImage *)scaleImageWithImage:(UIImage *)image size:(CGSize)size;

/**
 *	@brief	获取NSDate的年份部分
 *
 *	@param 	date 	日期对象
 *
 *	@return	年份
 */
+ (NSInteger)getFullYearWithDate:(NSDate *)date;

/**
 *	@brief	获取NSDate的月份部分
 *
 *	@param 	date 	日期对象
 *
 *	@return	月份
 */
+ (NSInteger)getMonthWithDate:(NSDate *)date;

/**
 *	@brief	获取NSDate的日期部分
 *
 *	@param 	date 	日期对象
 *
 *	@return	日期
 */
+ (NSInteger)getDayWithDate:(NSDate *)date;

/**
 *	@brief	获取NSDate的小时部分
 *
 *	@param 	date 	日期对象
 *
 *	@return	小时
 */
+ (NSInteger)getHourWithDate:(NSDate *)date;

/**
 *	@brief	获取NSDate的分钟部分
 *
 *	@param 	date 	日期对象
 *
 *	@return	分钟
 */
+ (NSInteger)getMinuteWithDate:(NSDate *)date;

/**
 *	@brief	获取NSDate的秒部分
 *
 *	@param 	date 	日期对象
 *
 *	@return	秒
 */
+ (NSInteger)getSecondWithDate:(NSDate *)date;


/**
 *	@brief	根据字符串格式转换字符串为日期
 *
 *	@param 	format 	日期格式字符串
 *	@param 	dateString 	日期字符串
 *
 *	@return	日期对象
 */
+ (NSDate *)dateWithFormat:(NSString *)format dateString:(NSString *)dateString;

/**
 *	@brief	根据字符串格式转换字符串为日期
 *
 *	@param 	format 	日期格式字符串
 *	@param 	dateString 	日期字符串
 *	@param 	locale 	本地化参数
 *
 *	@return	日期对象
 */
+ (NSDate *)dateWithFormat:(NSString *)format dateString:(NSString *)dateString locale:(NSLocale *)locale;

/**
 *	@brief	根据字符串格式转换日期为字符串
 *
 *	@param 	format 	日期格式字符串
 *	@param 	date 	日期对象
 *
 *	@return	日期字符串
 */
+ (NSString *)stringWithFormat:(NSString *)format data:(NSDate *)date;

/**
 *	@brief	根据年月日返回日期
 *
 *	@param 	year 	年份
 *	@param 	month 	月份
 *	@param 	date 	日期
 *	@param 	hour 	小时
 *	@param 	minute 	分钟
 *	@param 	second 	秒
 *
 *	@return	日期对象
 */
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                    date:(NSInteger)date
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

/**
 *	@brief	获取颜色对象
 *
 *	@param 	rgb 	RGB颜色值
 *
 *	@return	颜色对象
 */
+ (UIColor *)colorWithRGB:(NSUInteger)rgb;

/**
 *	@brief	获取颜色对象
 *
 *	@param 	argb 	ARGB颜色值
 *
 *	@return	颜色对象
 */
+ (UIColor *)colorWithARGB:(NSUInteger)argb;

/**
 *	@brief	获取系统越狱标识
 *
 *	@return	YES表示已经越狱，否则没有越狱。
 */
+ (BOOL)isJailBroken;

/**
 *	@brief	获取运行进程
 *
 *	@return	运行进程
 */
+ (NSArray *)runningProcesses;

/**
 *	@brief	使用GZip进行数据压缩
 *
 *	@param 	data 	原始数据
 *
 *	@return	压缩数据
 */
+ (NSData *)dataUsingGZipCompressWithData:(NSData *)data;

/**
 *	@brief	使用GZip进行数据解压缩
 *
 *	@param 	data 	压缩数据
 *
 *	@return	解压后数据
 */
+ (NSData *)dataUsingGZipUncompressWithData:(NSData *)data;

/**
 *	@brief	判断是否为iPad设备
 *
 *	@return	YES：是，NO：否
 */
+ (BOOL)isPad;

/**
 *	@brief	判断是否包含链接
 *
 *	@param 	string 	字符串
 *
 *	@return	YES 表示包含链接，NO 表示不包含
 */
+ (BOOL)containURLWithString:(NSString *)string;


@end
