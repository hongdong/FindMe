//
//  RealtimeSearchUtil.m
//  BussinessLink
//
//  Created by dhcdht on 14-5-8.
//  Copyright (c) 2014年 Li Zhiping. All rights reserved.
//

#import "RealtimeSearchUtil.h"

static RealtimeSearchUtil *defaultUtil = nil;

@interface RealtimeSearchUtil()
{
    id _source;
    SEL _selector;
    RealtimeSearchResultsBlock _resultBlock;
}

/**
 *  当前搜索线程
 */
@property (strong, nonatomic) NSThread *searchThread;
/**
 *  搜索线程队列
 */
@property (strong, nonatomic) dispatch_queue_t searchQueue;

@end

@implementation RealtimeSearchUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        _asWholeSearch = YES;
        _searchQueue = dispatch_queue_create("cn.realtimeSearch.queue", NULL);
    }
    
    return self;
}

/**
 *  实时搜索单例实例化
 *
 *  @return 实时搜索单例
 */
+ (instancetype)currentUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUtil = [[RealtimeSearchUtil alloc] init];
    });
    
    return defaultUtil;
}

#pragma mark - private

- (void)realtimeSearch:(NSString *)string
{
    [self.searchThread cancel];
    
    //开启新线程
    self.searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(searchBegin:) object:string];
    [self.searchThread start];
}

- (void)searchBegin:(NSString *)string
{
    dispatch_async(self.searchQueue, ^{
        if (string.length == 0) {
            _resultBlock(_source);
        }
        else{
            NSMutableArray *results = [NSMutableArray array];
            NSString *subStr = [string lowercaseString];
            for (id object in _source) {
                NSString *tmpString = @"";
                if (_selector) {
                    if([object respondsToSelector:_selector])
                    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        tmpString = [[object performSelector:_selector] lowercaseString];
#pragma clang diagnostic pop
                        
                    }
                }
                else if ([object isKindOfClass:[NSString class]])
                {
                    tmpString = [object lowercaseString];
                }
                else{
                    continue;
                }
                
                if([tmpString rangeOfString:subStr].location != NSNotFound)
                {
                    [results addObject:object];
                }
            }
            
            _resultBlock(results);
        }
    });
}

#pragma mark - public

/**
 *  开始搜索，只需要调用一次，与[realtimeSearchStop]配套使用
 *
 *  @param source      要搜索的数据源
 *  @param selector    获取元素中要比较的字段的方法
 *  @param resultBlock 回调方法，返回搜索结果
 */
- (void)realtimeSearchWithSource:(id)source searchText:(NSString *)searchText collationStringSelector:(SEL)selector resultBlock:(RealtimeSearchResultsBlock)resultBlock
{
    if (!source || !searchText || !resultBlock) {
        _resultBlock(source);
        return;
    }
    
    _source = source;
    _selector = selector;
    _resultBlock = resultBlock;
    [self realtimeSearch:searchText];
}

/**
 *  从fromString中搜索是否包含searchString
 *
 *  @param searchString 要搜索的字串
 *  @param fromString   从哪个字符串搜索
 *
 *  @return 是否包含字串
 */
- (BOOL)realtimeSearchString:(NSString *)searchString fromString:(NSString *)fromString
{
    if (!searchString || !fromString || (fromString.length == 0 && searchString.length != 0)) {
        return NO;
    }
    if (searchString.length == 0) {
        return YES;
    }
    
    NSUInteger location = [[fromString lowercaseString] rangeOfString:[searchString lowercaseString]].location;
    return (location == NSNotFound ? NO : YES);
}

/**
 * 结束搜索，只需要调用一次，在[realtimeSearchBeginWithSource:]之后使用，主要用于释放资源
 */
- (void)realtimeSearchStop
{
    [self.searchThread cancel];
}

@end
