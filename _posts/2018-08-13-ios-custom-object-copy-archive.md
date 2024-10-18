---
title: iOS自定义对象及子类及模型套模型的拷贝、归档存储的通用代码
date: 2018-08-13 12:00:00 +0800
tags: [iOS]
categories: [代码人生, iOS]
---

### runtime实现通用copy

如果自定义类的子类，模型套模型你真的会copy吗，小心有坑。
copy需要自定义类继承NSCopying协议

<!--more-->

```objc
#import <objc/runtime.h>

- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] allocWithZone:zone] init];
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [[self valueForKey:strName] copy];//如果还套了模型也要copy呢
            [obj setValue:value forKey:strName];
        }
        free(ivar);
        class = class_getSuperclass(class);//记住还要遍历父类的属性呢
    }
    return obj;
}
```

### runtime实现通用归档解档

归档解档需要自定义类继承NSCoding协议


```objc
#import <objc/runtime.h>

#pragma mark - 归档、解档
- (void)encodeWithCoder:(NSCoder *)encoder {
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [self valueForKey:strName];
            [encoder encodeObject:value forKey:strName];
        }
        free(ivar);
        class = class_getSuperclass(class);//记住还要遍历父类的属性呢
    }
}
```

```objc
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        Class class = [self class];
        while (class != [NSObject class]) {
            unsigned int count = 0;
            //获取类中所有成员变量名
            Ivar *ivar = class_copyIvarList(class, &count);
            for (int i = 0; i < count; i++) {
                Ivar iva = ivar[i];
                const char *name = ivar_getName(iva);
                NSString *strName = [NSString stringWithUTF8String:name];
                //进行解档取值
                id value = [decoder decodeObjectForKey:strName];
                //利用KVC对属性赋值
                [self setValue:value forKey:strName];
            }
            free(ivar);
            class = class_getSuperclass(class);//记住还要遍历父类的属性呢
        }
    }
    return self;
}
```
