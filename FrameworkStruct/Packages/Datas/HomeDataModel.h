//
//  HomeDataModel.h
//  FrameworkStruct
//
//  Created by  jggg on 2022/2/11.
//

/**
 定义首页相关数据，包括模块信息、活动信息、banner、金刚区等
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//主页模块信息
@interface HomeInfoModel: NSObject

@property (nonatomic, copy)NSString *id;
@property (nonatomic, assign)int refType;   //1(h5页面), 2(商品详情), 3(商品分类)
@property (nonatomic, assign)int isNeed;
@property (nonatomic, copy)NSString *imgUrl;//图片
@property (nonatomic, copy)NSString *name;//名称
@property (nonatomic, copy)NSString *refContent;//"页面地址", "商品id", "商品分类id"

@end

//活动商品信息
@interface ActivityGoodInfoModel: NSObject

@property (nonatomic, copy)NSString *id;
@property (nonatomic, assign)int goodsDataSource;   //1自选,2固定 3 h5
@property (nonatomic, assign)long price;
@property (nonatomic, assign)long originPrice;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *shorterName;
@property (nonatomic, copy)NSString *imgUrl;
@property (nonatomic, strong)NSArray *tagList;
@property (nonatomic, copy)NSString *refContent;
@property (nonatomic, copy)NSString *lowStr;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *serverTime;
@property (nonatomic, copy)NSString *activityEndTime;
@property (nonatomic, assign)int timeLimitFlag;//1展示 0不展示倒计时
@property(nonatomic, assign)BOOL inTheGroup;       //是否在团购中

@end

//主页活动信息
@interface ActivityInfoModel: NSObject

@property (nonatomic, copy)NSString *id;
@property (nonatomic, assign)BOOL isShowMore;
@property (nonatomic, assign)int type;
@property (nonatomic, assign)int showModule;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detailTitle;
@property (nonatomic, strong)NSArray<ActivityGoodInfoModel *> *contentList;
//@ApiModelProperty(value = "是否超低低价 1：是 0：否")
@property (nonatomic, assign)int lowPriceType;

@end

typedef NS_ENUM(NSUInteger, RefType) {
    RefTypeWeb = 1,
    RefTypeGoodsDetail,
    RefTypeGoodsList,
    RefTypeWebForNewPerson = 1024,
};

@interface CycleImageModel: NSObject

@property (copy, nonatomic)NSString *id;
@property (copy, nonatomic)NSString *imgUrl;
@property (assign, nonatomic)RefType refType;
@property (copy, nonatomic)NSString *refContent;
    
@end

//活动模块信息
@interface ActivityModuleInfoModel: NSObject
///展示的图片
@property (nonatomic, copy)NSString *coverPic;
///是否显示
@property (nonatomic, assign)BOOL ifShow;
///跳转链接
@property (nonatomic, copy)NSString *uploadUrl;

@end

//主页最外层的数据模型
@interface HomeDataModel : NSObject

@property (nonatomic, strong)NSArray<HomeInfoModel *> *mainList;
@property (nonatomic, strong)NSArray<ActivityInfoModel *> *activityList;
@property (nonatomic, strong)NSArray<CycleImageModel *> *homeBanner;
@property (nonatomic, strong)ActivityModuleInfoModel *activityModule;

@end

NS_ASSUME_NONNULL_END
