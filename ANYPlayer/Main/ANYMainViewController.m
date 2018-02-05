//
//  ANYMainViewController.m
//  ANYVideoCache
//
//  Created by Anyhong on 2018/1/16.
//  Copyright © 2018年 Anyhong. All rights reserved.
//

#import "ANYMainViewController.h"
#import "ANYPlayerViewController.h"

@interface ANYMainViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrUrl;
@end

@implementation ANYMainViewController



#pragma mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    

}

- (void)setupData {
 
    
//    self.arrUrl = @[@"http://124.164.10.40/view.video.tianya.cn/v/201801171600566248ca8f01d.mp4?wsrid_tag=5a600b61_chengwangtong42_21376-14073&wsiphost=local",
//                    @"http://view.video.tianya.cn/v/2017122816250866410a82d65.mp4",
//                    @"http://view.video.tianya.cn/v/2017122723563107892bd4e12.mp4",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/2017122723563107892bd4e12.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/2017122816250866410a82d65.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/20171226000026170b32064f0.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/20171226151944103844f97df.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/201712261612483049f38a05b.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/2017122816250866410a82d65.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/201712262248266545db7d5ce.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://125.77.131.56/view.video.tianya.cn/v/20171228140231286917b283a.mp4?wsrid_tag=5a5f1908_PSfjqzdxwg63_27086-46451&wsiphost=local",
//                    @"http://api.video.tianya.cn/v/play/2017122816250866410a82d65",
//                    @"http://api.video.tianya.cn/v/play/20171226000026170b32064f0",
//                    @"http://api.video.tianya.cn/v/play/20171226151944103844f97df",
//                    @"http://api.video.tianya.cn/v/play/2017122816250866410a82d65",
//                    @"http://api.video.tianya.cn/v/play/201712261612483049f38a05b",
//                    @"http://api.video.tianya.cn/v/play/201712262248266545db7d5ce",
//                    @"http://api.video.tianya.cn/v/play/20171228140231286917b283a",
//                    @"http://api.video.tianya.cn/v/play/20171226204226248368b6914",
//                    @"http://api.video.tianya.cn/v/play/20171226171351334d3e5a86f",
//                    @"http://api.video.tianya.cn/v/play/201712201042035496d35825f",
//                    @"http://api.video.tianya.cn/v/play/20171227133339875aafea135",
//                    @"http://api.video.tianya.cn/v/play/20171228120519328ec6dc19d",
//                    @"http://api.video.tianya.cn/v/play/2017122723563107892bd4e12",
//                    @"http://ac-qguazwk4.clouddn.com/936ab1cda3fab48f1aad.mp4",
//
//                    // This url will redirect.
//                    @"http://v.polyv.net/uc/video/getMp4?vid=9c9f71f62d5f24a7f9c6273e469a71a0_9",
//
//                    @"http://lavaweb-10015286.video.myqcloud.com/%E5%B0%BD%E6%83%85LAVA.mp4",
//                    @"http://lavaweb-10015286.video.myqcloud.com/lava-guitar-creation-2.mp4",
//                    @"http://lavaweb-10015286.video.myqcloud.com/hong-song-mei-gui-mu-2.mp4",
//                    @"http://lavaweb-10015286.video.myqcloud.com/ideal-pick-2.mp4",
//
//                    // This path is a https.
//                    // "https://bb-bang.com:9002/Test/Vedio/20170110/f49601b6bfe547e0a7d069d9319388f4.mp4",
//                    // "http://123.103.15.1JPVideoPlayerDemoNavAndStatusTotalHei:8880/myVirtualImages/14266942.mp4",
//
//                    // This video saved in amazon, maybe load sowly.
//                    // "http://vshow.s3.amazonaws.com/file147801253818487d5f00e2ae6e0194ab085fe4a43066c.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_01.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_02.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_03.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_04.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_05.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_06.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_07.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_08.mp4",
//
//                    // To simulate the cell have no video to play.
//                    // "",
//                    @"http://120.25.226.186:32812/resources/videos/minion_10.mp4",
//                    @"http://120.25.226.186:32812/resources/videos/minion_11.mp4",
//                    @"http://lavaweb-10015286.video.myqcloud.com/%E5%B0%BD%E6%83%85LAVA.mp4",
//                    @"http://lavaweb-10015286.video.myqcloud.com/lava-guitar-creation-2.mp4",
//                    @"http://lavaweb-10015286.video.myqcloud.com/hong-song-mei-gui-mu-2.mp4",
//                    @"http://lavaweb-10015286.video.myqcloud.com/ideal-pick-2.mp4",
//
//                    // The vertical video.
//                    @"https://bb-bang.com:9002/Test/Vedio/20170425/74ba5b355c6742c084414d4ebd520696.mp4",
//
//                    @"http://static.smartisanos.cn/common/video/video-jgpro.mp4",
//                    @"http://static.smartisanos.cn/common/video/smartisanT2.mp4",
//                    @"http://static.smartisanos.cn/common/video/ammounition-video.mp4",
//                    @"http://static.smartisanos.cn/common/video/m1-white.mp4",
//                    @"http://static.smartisanos.cn/common/video/t1-ui.mp4",
//                    @"http://static.smartisanos.cn/common/video/smartisant1.mp4",
//                    @"http://static.smartisanos.cn/common/video/ammounition-video.mp4",
//                    @"http://static.smartisanos.cn/common/video/proud-driver.mp4",
//                    @"http://static.smartisanos.cn/common/video/proud-farmer.mp4",
//
//                    // Long video
//                    @"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
    
    self.arrUrl = @[ @{@"video" : @"http://view.video.tianya.cn/th/2018020121332503538fa8574.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018020121332503538fa8574",
                       @"title" : @"哈哈，好好玩，好可爱"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180131230343180b306874e.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180131230343180b306874e",
                       @"title" : @"如果你是英雄，可能我这首歌这口气唱不了，因为-英雄气短 ????????"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180201010545091d89bb7a2.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180201010545091d89bb7a2",
                       @"title" : @"勤劳的姑娘"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180131232850595aefacb2c.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180131232850595aefacb2c",
                       @"title" : @"152年来首次“超级蓝血月全食”，错过就是一辈子！"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180126163610378879842af.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180126163610378879842af",
                       @"title" : @"在卧室光着脚丫第一次自学C哩C哩哦。好投入的样子哈哈。不要见笑哦??"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180130112349253a11a805c.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180130112349253a11a805c",
                       @"title" : @"熟透的舞蹈教练！！！????"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180130142054314c0467548.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180130142054314c0467548",
                       @"title" : @"［春晚报名］32姑娘，我同意还不行吗？"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180130014226500fbf53526.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180130014226500fbf53526",
                       @"title" : @"大家好"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180127173906362ec060882.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180127173906362ec060882",
                       @"title" : @"卸妆之后 一个字 丑"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2017111520522789455cc45cb.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2017111520522789455cc45cb",
                       @"title" : @"以我的审美观点这妞纯粹属于畸形范畴??"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018013016402814921344cdc.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018013016402814921344cdc",
                       @"title" : @"涂口红以后的淑女吃法和女汉子吃法，不要错过哦。"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180202042923529fa958333.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180202042923529fa958333",
                       @"title" : @"这是成都哪里？"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180128191542928ed76bb13.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180128191542928ed76bb13",
                       @"title" : @"爱情骗子我问你!"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018012516464973997a8e559.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018012516464973997a8e559",
                       @"title" : @"我要去学武功"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018013123522741217600145.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018013123522741217600145",
                       @"title" : @"??"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018013123522741217600145.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018013123522741217600145",
                       @"title" : @"??"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180131224512142e8d1cb90.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180131224512142e8d1cb90",
                       @"title" : @"这种拍摄方法。。。。哈哈哈??"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180129163308439725e0c5f.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180129163308439725e0c5f",
                       @"title" : @"化浓烈的妆，喝最烈的酒，c最爱的人！"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018012923042363020b52710.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018012923042363020b52710",
                       @"title" : @"可不可爱"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180127222702956307c10fb.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180127222702956307c10fb",
                       @"title" : @"下雪啦"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180124142000623727f469e.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180124142000623727f469e",
                       @"title" : @"哈哈??"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201801301249048670c97239b.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201801301249048670c97239b",
                       @"title" : @"跳的不错"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180130143042947478e085a.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180130143042947478e085a",
                       @"title" : @"小心有诈………"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201801300725012272ad8a293.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201801300725012272ad8a293",
                       @"title" : @"看一次笑一次、已经笑岔气了！嗯…那一声是相当的灵性"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018020121345422753cc099c.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018020121345422753cc099c",
                       @"title" : @"看着身材挺好的，但是有可能是衣服的原因，嘻嘻"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018012518432725435b6eeec.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018012518432725435b6eeec",
                       @"title" : @"小姐姐真棒，身材太好了，羡慕。"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180120080030473335992e0.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180120080030473335992e0",
                       @"title" : @"嘻嘻，给你们扭一下秧歌"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201801151823193938163a146.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201801151823193938163a146",
                       @"title" : @"真的挺累的，不信的自己可以试试。"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180110171342352661b6b26.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180110171342352661b6b26",
                       @"title" : @"有些人走着走着就散了"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018010615595920540b70b59.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018010615595920540b70b59",
                       @"title" : @"来看小妹妹如何教别人健身的，不过好像没啥用（偷笑）"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018010509224250498a10840.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018010509224250498a10840",
                       @"title" : @"这个活也是绝了，我的天"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180102164152317159d9fe7.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180102164152317159d9fe7",
                       @"title" : @"看不下去了，这么妖娆的啊，还玩不玩了"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180101113830192a39ff1b7.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180101113830192a39ff1b7",
                       @"title" : @"2018第一天，来一发，加油！"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201801012045448656d9c2390.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201801012045448656d9c2390",
                       @"title" : @"丝袜都掉了，尴尬，哈哈"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2017123012422779438d677b8.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2017123012422779438d677b8",
                       @"title" : @"大晚上的，哈哈，"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201712251643175039bb8b65c.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201712251643175039bb8b65c",
                       @"title" : @"身材有长进没，我想听好听的话。"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20171216001026472955ef00d.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20171216001026472955ef00d",
                       @"title" : @"看看人家，再看看自己，哎。"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201712141334018768668e676.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201712141334018768668e676",
                       @"title" : @"你觉得呢？"},
                     @{@"video" : @"(null)", @"image" : @"(null)", @"title" : @"腿上绑的啥，求科普"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018012512485991240c6dd5f.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018012512485991240c6dd5f",
                       @"title" : @"北京的雪一直没有等到，所以我就干脆自己造一个雪景好了。"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180126152423647d1a4c819.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180126152423647d1a4c819",
                       @"title" : @"刚刚出去了会，她们闲着无聊，这位姐姐就随性了一下，哈哈"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180131231414611b57fc033.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180131231414611b57fc033",
                       @"title" : @"哈哈，放电"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20171128231153971b5b2ba14.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20171128231153971b5b2ba14",
                       @"title" : @"这个刘海剪的我很无奈，就差个头巾去种地了"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201706272335536818d841e49.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201706272335536818d841e49",
                       @"title" : @"今天在婆婆家休息"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180128003055689055ab20c.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180128003055689055ab20c",
                       @"title" : @"我的一个远房表妹"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180131173341746892d4cb9.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180131173341746892d4cb9",
                       @"title" : @"美女“闪亮”登场"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180201144952390107460fb.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180201144952390107460fb",
                       @"title" : @"像不像冰雪王国呢？"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180129223026898a7e60fce.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180129223026898a7e60fce",
                       @"title" : @"好天气！！！！"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180130112349253a11a805c.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180130112349253a11a805c",
                       @"title" : @"熟透的舞蹈教练！！！????"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201801311208224907f2149ac.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201801311208224907f2149ac",
                       @"title" : @"哥只是个搬运工。听不懂，翻译一下。多谢！"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201801312353505910a1038b5.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201801312353505910a1038b5",
                       @"title" : @"茶卡盐湖，（中国的玻利维亚）倒影"},
                     @{@"video" : @"http://view.video.tianya.cn/th/20180131232629895522fc2e2.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/20180131232629895522fc2e2",
                       @"title" : @"留沙坡"},
                     @{@"video" : @"http://view.video.tianya.cn/th/2018013123232714342da6d14.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/2018013123232714342da6d14",
                       @"title" : @"雪骑转山"},
                     @{@"video" : @"http://view.video.tianya.cn/th/201801251948190871b7ddd1a.jpg",
                       @"image" : @"http://api.video.tianya.cn/v/play/201801251948190871b7ddd1a",
                       @"title" : @"2017回忆录柴达木盆（戈壁滩）"}];
}

- (void)setupUI {
    CGRect frame = self.view.bounds;
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 40;
    tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"清理"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(actionClean:)];
    self.navigationItem.rightBarButtonItems = @[right];
}

- (void)actionClean:(id)sender {
    
}


#pragma mark tableview代理及数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrUrl.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.arrUrl objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.textLabel.text = dict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.arrUrl objectAtIndex:indexPath.row];
    NSString *url = dict[@"image"];
    
    ANYPlayerViewController *playVC = [[ANYPlayerViewController alloc] init];
    playVC.videoUrl = url;
    [self.navigationController pushViewController:playVC animated:YES];
}
@end
