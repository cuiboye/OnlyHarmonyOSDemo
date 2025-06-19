import axios from '@ohos/axios'
import { MatchPattern } from '@ohos.UiTest';
import ShopInfo, {
  AnnouncementAppNewIndexCategoriesEntity,
  AppNewIndexCategoriesEntity,
  BannerInternationalEntity,
  BrandHallEntity,
  FamousProductListEntity,
  HomeButtonAppNewIndexCategoriesEntity,
  KindSetEntity,
  ProductInfoListEntity
} from '../../TaskEntity';
import { WaterfallFlowPage } from '../../waterfall_flow_page';
import observer from '@ohos.telephony.observer';

import common from '@ohos.app.ability.common';
import util from '@ohos.util';
import hilog from '@ohos.hilog';
import { indexInfo } from '../../../../common/constants/Constants';
import BreakpointSystem from '../../../../common/MediaData';
import HomeBanner from './home_banner';
import HomeButton from './home_button';
import HomeOrder from './home_order';
import HomeNews from './home_news';
import NationalPavilion from './national_pavilion';
import BrandPavilion from './brand_pavilion';
import HomeExcellentProducts from './home_excellent_products';
import HomeKindList from './home_kind_list';
import { CommonHeader } from '../../../../common/common_header';
import HomeSearch from './home_search';
import { AxiosResponse } from '@ohos/axios';
import { AxiosError } from '@ohos/axios';

/**
 * 挖酒首页
 */

@Component
@Entry
export struct HomePage {
  //最好给Provider设置一个别名，不然变量名被修改可能会有问题
  //轮播图数据
  @Provide('bannerList') bannerList: AppNewIndexCategoriesEntity[] = []
  //棋盘格数据
  @Provide('homeButtonList') homeButtonList: HomeButtonAppNewIndexCategoriesEntity[] = []
  //国家馆
  @Provide('bannerInternationalList') bannerInternationalList: BannerInternationalEntity[] = []
  //品牌馆
  @Provide('brandHallList') brandHallList: BrandHallEntity[] = []
  //名庄优品
  @Provide('famousProductList') famousProductList: FamousProductListEntity[] = []
  //新闻
  @Provide('newsList') newsList: AnnouncementAppNewIndexCategoriesEntity[] = []
  @Provide('kindSetList') kindSetList: KindSetEntity[] = []

  @StorageProp('topStatusHeight') topStatusHeight: number = 0

  aboutToAppear() {
    //1)
    //===start用于预览测试，使用的时本地数据===
    // this.bannerList = indexInfo?.result?.indexList?.focus_picture?.appNewIndexCategories ?? []
    // this.homeButtonList = indexInfo?.result?.indexList?.home_button?.appNewIndexCategories ?? []
    // this.bannerInternationalList = indexInfo?.result?.banner_international ?? []
    // this.brandHallList = indexInfo?.result?.brandHall ?? []
    // this.famousProductList = indexInfo?.result?.famousProducts?.famousProductList ?? []
    // this.newsList = indexInfo?.result?.indexList?.announcement?.appNewIndexCategories ?? []
    // this.kindSetList = indexInfo?.result?.kindSet  ?? []
    //===end用于预览测试，使用的时本地数据===


    //2)接口请求数据
    this.getShopListByAxiosAsync().then(indexInfo => {
      if(indexInfo?.states == 200){
        this.bannerList = indexInfo?.result?.indexList?.focus_picture?.appNewIndexCategories ?? []
        this.homeButtonList = indexInfo?.result?.indexList?.home_button?.appNewIndexCategories ?? []
        this.bannerInternationalList = indexInfo?.result?.banner_international ?? []
        this.brandHallList = indexInfo?.result?.brandHall ?? []
        this.famousProductList = indexInfo?.result?.famousProducts?.famousProductList ?? []
        this.newsList = indexInfo?.result?.indexList?.announcement?.appNewIndexCategories ?? []
        this.kindSetList = indexInfo?.result?.kindSet  ?? []
      }
    })


    //3)获取rawfile中的json数据，然后转为实体类
    // let context = getContext(this) as common.UIAbilityContext;
    //  //这里有个坑，resourceManager在预览模式不支持
    // const rm = context.resourceManager;
    //  rm.getRawFileContent("index.json").then(value => {
    //   let rawFile = value;
    //   let textdecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    //   let retStr = textdecoder.decodeWithStream(rawFile, { stream: false });
    //   // console.log('host_config打印: ' + JSON.stringify(retStr));
    //    //打印日志使用hilog，使用console日志有的打印不出来
    //
    //    //JSON.stringify：将字符串转为json
    //    //JSON.parse 将json转为对象
    //   hilog.info(100,'host_config打印1: ' , JSON.stringify(retStr));
    //    let dataBean = JSON.parse(retStr) as ShopInfo
    //    hilog.info(100,'host_config打印3: ' , dataBean.states.toString());
    // })
  }

  async getShopListByAxiosAsync(): Promise<ShopInfo | undefined>  {
    //非同步写法
    // axios.get<ShopInfo, AxiosResponse<ShopInfo>, null>(
    //   'https://apifoxmock.com/m1/4179570-3819509-default/index',
    //   // { params: { key: "value" } }
    // ).then( (response:AxiosResponse<ShopInfo>)=> {
    //   console.log("result data: " + response.data);
    //   console.log("result status: " + response.status);
    //   console.log("result statusText: " + response.statusText);
    //   console.log("result headers: " + response.headers);
    //   console.log("result config: " + response.config);
    // }).catch((error: AxiosError) => {
    //   console.error("result:" + error.message);
    // });

    //同步写法
    // 1.发送请求
    let  resp:AxiosResponse<ShopInfo> = await axios.get<ShopInfo, AxiosResponse<ShopInfo>, null>(
      'https://apifoxmock.com/m1/4179570-3819509-default/index',
      // { params: { key: "value" } }
    )

    // 2.处理响应
    if (resp.status === 200) {
      // 查询成功
      console.log('testTag', '查询商铺成功！', JSON.stringify(resp.data))
      return resp.data;
    }
    return undefined;
    // 查询失败
    // console.log('testTag', '查询商铺信息失败！error:', JSON.stringify(resp))
  }

  build() {
    Column(){
      CommonHeader({showTitleBar:false})
      HomeSearch()
      Scroll() {

        Column() {
          HomeBanner()
          HomeButton()
          HomeOrder()
          HomeNews()
          NationalPavilion()
          BrandPavilion()
          HomeExcellentProducts()
          HomeKindList()
        }
        //
        //   //比较使用 ===
        //
        //   //todo
        //   //注意：如果Grid的最外层是Scroll的话，会导致Grid无法滑动，可以将Grid替换为List 通过list的lanes属性可
        //   // 以达到grid的效果。 在外层使用scroll包裹导致的滑动冲突替换为list后也没有了
        //
        //   //
        //   // //瀑布流
        //   // //注意：Scroll嵌套WaterFlow滚动时无法联动，api10已经解决
        //   // //参考链接：https://developer.huawei.com/consumer/cn/forum/topic/0204137264128132694
        //   // WaterfallFlowPage()
        // }
      }
      .scrollBar(BarState.Off) //隐藏滚动条
      .edgeEffect(EdgeEffect.Spring) //滚动到边缘回弹
      .layoutWeight(1)
    }.backgroundColor($r('app.color.eeeeee'))
  }
  //鸿蒙上架应用市场指南：
  //https://developer.huawei.com/consumer/cn/doc/app/agc-help-harmonyos-releaseapp-0000001126380068

  //使用hdc命令的时候需要使用下面目录中的hdc，否则执行hdc命令会有问题
  // windows
  // C:\Users\cuiboye\AppData\Local\Huawei\Sdk\hmscore\3.1.0\toolchains

  // Mac,注意：格式不能变，否则hdc命令会不生效
  // export PATH=/Users/tom/Library/Huawei/Sdk/hmscore/3.1.0/toolchains:$PATH

  //如果ohpm没有了，可以在Build,Execution,Deployment中的Ohpm选项中下载
}

//报错：Failed to find the incremental input file: /Users/tom/.ohos/config/auto_debug_HongmengDemo_com.example.myapplication_890086000102043708.cer.
//解决：
// 1）删除build-profile.json5文件内，signingConfigs对应部份的内容后解决了，删除后形如： "signingConfigs": []
// 2）点击File ——》Project Structure——》Project ——》Signing Configs 选择 Automatically generate signature 自动签名就可以了

