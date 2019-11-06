//
//  MVC2Config.m
//  EasyApp
//
//  Created by 靳小飞 on 2018/1/29.
//  Copyright © 2018年 靳小飞. All rights reserved.
//

#import "MVC2Base.h"

@interface BinderHelper : NSObject
+ (instancetype)shareBinderHelp;
@property (nonatomic, strong) NSMutableDictionary *binderMap;
@end

@implementation BinderHelper
+ (instancetype)shareBinderHelp
{
    static BinderHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BinderHelper alloc] init];
        instance.binderMap = [NSMutableDictionary dictionary];
    });
    
    return instance;
}
@end
#pragma mark - Binder
@implementation Binder
- (void)dealloc
{
    NSLog(@"%@ -- dealloc", NSStringFromClass(self.class));

    [self unBind];
}

+ (instancetype)binderWithModule:(NSString *)module
{
    Binder *b = [[BinderHelper shareBinderHelp].binderMap objectForKey:module];
    if (!b) {
        b = [Binder new];
        b.module = module;
        [[BinderHelper shareBinderHelp].binderMap setObject:b forKey:module];
    }
    return b;
}
+ (void)unBinderWithModule:(NSString *)module
{
    Binder *b = [[BinderHelper shareBinderHelp].binderMap objectForKey:module];
    if (b) {
        [b unBind];
    }
}
- (void)unBind
{
    [self.branches removeAllObjects];
    [self.contexts removeAllObjects];
    [self removeSubBinders];
    
    [[BinderHelper shareBinderHelp].binderMap removeObjectForKey:self.module];
}
- (void)addSubBinder:(Binder *)binder
{
    [self.subBinders addObject:binder];
    binder.superBinder = self;
}
- (void)removeSubBinders
{
    for (id<Binder> binder in self.subBinders) {
        [binder removeSubBinders];
    }
    [self.subBinders removeAllObjects];
}
- (void)removeFromSuperBinder
{
    if ([self.superBinder.subBinders containsObject:self]) {
        [self.superBinder.subBinders removeObject:self];
        self.superBinder = nil;
    }
}
#pragma mark - branch
// bind
- (void)bind:(id<Branch>)branch protocol:(Protocol *)protocol{
    [self bind:branch protocol:protocol identity:nil];
}
- (void)bind:(id<Branch>)branch protocol:(Protocol *)protocol identity:(NSString *)identity
{
    [self.branches setObject:branch forKey:[self getBranchKey:protocol identity:identity]];
}
// get
- (id<Branch>)branch:(Protocol *)protocol {
    return [self branch:protocol identity:nil];
}
- (id<Branch>)branch:(Protocol *)protocol identity:(NSString *)identity
{
    return [self.branches objectForKey:[self getBranchKey:protocol identity:identity]];
}
// unbind
- (void)unbind:(Protocol *)protocol {
    [self unbind:protocol identity:nil];
}
- (void)unbind:(Protocol *)protocol identity:(NSString *)identity
{
    [self.branches removeObjectForKey:[self getBranchKey:protocol identity:identity]];
}

- (NSString *)getBranchKey:(Protocol *)protocol identity:(NSString *)identity
{
    return [NSString stringWithFormat:@"%@%@", NSStringFromProtocol(protocol), identity];
}
- (NSMapTable *)branches
{
    if (!_branches) {
        _branches = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    return _branches;
}
#pragma mark - context
// add
- (void)addCtx:(id<Context>)ctx
{
    [self addCtx:ctx identity:nil];
}
- (void)addCtx:(id<Context>)ctx identity:(NSString *)identity
{
    [self.contexts setObject:ctx forKey:[self getContextKey:ctx.class identity:identity]];
}
// remove
- (void)removeCtx:(Class)cls
{
    [self removeCtx:cls identity:nil];
}
- (void)removeCtx:(Class)cls identity:(NSString *)identity
{
    [self.contexts removeObjectForKey:[self getContextKey:cls identity:identity]];
}
// get
- (id<Context>)ctx:(Class)cls
{
    return [self ctx:cls identity:nil];
}
- (id<Context>)ctx:(Class)cls identity:(NSString *)identity
{
    id<Context> ctx = [self.contexts objectForKey:[self getContextKey:cls identity:identity]];
    return ctx;
}
- (NSString *)getContextKey:(Class)cls identity:(NSString *)identity
{
    return [NSString stringWithFormat:@"%@%@", NSStringFromClass(cls), identity];
}

@synthesize branches = _branches;
@synthesize contexts = _contexts;
@synthesize module = _module;
@synthesize superBinder = _superBinder;

@synthesize subBinders = _subBinders;
- (NSMutableArray<Binder *> *)subBinders
{
    if (!_subBinders) {
        _subBinders = [NSMutableArray array];
    }
    return _subBinders;
}
- (NSMutableDictionary *)contexts
{
    if (!_contexts) {
        _contexts = [NSMutableDictionary dictionary];
    }
    return _contexts;
}
@end
#pragma mark - BranchRequest
@implementation BranchRequest

@synthesize module;

@synthesize branch;

@synthesize action;

@synthesize target;

@synthesize info;

@end
