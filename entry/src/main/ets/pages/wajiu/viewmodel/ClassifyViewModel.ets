
import axios, { AxiosResponse } from '@ohos/axios';
import { ClassifyBean } from '../entity/ClassifyBean';
/**
 * viewmodel
 */
class ClassifyViewModel{
  async getData(): Promise<ClassifyBean> {
      // 1.发送请求
    let response: AxiosResponse = await axios.get<ClassifyBean, AxiosResponse<ClassifyBean>>(
      'https://mock.apifox.com/m1/3626399-3255008-default/secondListData',
    )
    let classifyBean: ClassifyBean = JSON.parse(JSON.stringify(response)) as ClassifyBean

    // 2.处理响应
    if (classifyBean.states === 200) {
      // 成功
      return classifyBean;
    }
    return new ClassifyBean();
    // 失败
  }
}

let classifyViewModel = new ClassifyViewModel()
export default classifyViewModel as ClassifyViewModel

export const classifyData:ClassifyBean = {
  "states" : 200,
  "msg" : "请求成功",
  "result" : {
    "isLogin" : 2,
    "mainImg" : "http://image.59cdn.com/static/upload/file/20221222/1671695821494.jpg",
    "rankList" : [ {
      "rankingId" : 28,
      "navTitle" : "夏天榜",
      "rankingTitle" : "夏天酒畅销排行榜",
      "detailsImg" : "http://image.59cdn.com/static/upload/file/20200723/1595495302156.jpg",
      "rankingProduct" : [ {
        "loginFlag" : 2,
        "cname" : "闪耀系列长相思白葡萄酒_750ML_2023",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20240318/o_171075219097542.png",
        "productId" : 22244,
        "sort" : 1,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "利尔博雷司令半甜白葡萄酒_2022",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20221102/o_1667383285721.png",
        "productId" : 22172,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "星空莫斯卡托阿斯蒂低醇甜白起泡葡萄酒_2021",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20210916/o_1631772923911.png",
        "productId" : 8367,
        "sort" : 3,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      } ]
    }, {
      "rankingId" : 5,
      "navTitle" : "口碑榜",
      "rankingTitle" : "半年度最具口碑复购榜",
      "detailsImg" : "http://image.59cdn.com/static/upload/file/20221222/1671692187656.jpg",
      "rankingProduct" : [ {
        "loginFlag" : 2,
        "cname" : "闪耀系列长相思白葡萄酒_750ML_2023",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20240318/o_171075219097542.png",
        "productId" : 22244,
        "sort" : 1,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "欧百乐干红葡萄酒（新标）_2022",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20231116/o_170010490868992.png",
        "productId" : 22159,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "欧百乐无醇葡萄饮料",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20210622/o_1624357398840.jpg",
        "productId" : 9866,
        "sort" : 3,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 2,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      } ]
    }, {
      "rankingId" : 33,
      "navTitle" : "3年畅销",
      "rankingTitle" : "采购3年畅销款",
      "detailsImg" : "http://image.59cdn.com/static/upload/file/20230321/1679368533840.jpg",
      "rankingProduct" : [ {
        "loginFlag" : 2,
        "cname" : "欧百乐无醇葡萄饮料",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20210622/o_1624357398840.jpg",
        "productId" : 9866,
        "sort" : 1,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 2,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "毕克拉酒庄金标（纪念款）干红葡萄酒_2020_3支木箱",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20220310/o_1646884671512.png",
        "productId" : 23006,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "福斯克风干红葡萄酒_2021_6支彩色躺箱礼盒",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20220714/o_1657788611685.png",
        "productId" : 9974,
        "sort" : 3,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      } ]
    }, {
      "rankingId" : 25,
      "navTitle" : "礼盒榜",
      "rankingTitle" : "精装礼盒畅销榜",
      "detailsImg" : "http://image.59cdn.com/static/upload/file/20221222/1671692694320.jpg",
      "rankingProduct" : [ {
        "loginFlag" : 2,
        "cname" : "芙罗拉女神红葡萄酒_2021",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20231204/o_170168051831831.png",
        "productId" : 9715,
        "sort" : 1,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 2,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "安第斯雄鹰珍藏赤霞珠干红葡萄酒_2019_6支彩色躺箱礼盒",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20220311/o_1646990409805.png",
        "productId" : 9266,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "毕克拉酒庄金标（纪念款）干红葡萄酒_2020_3支木箱",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20220310/o_1646884671512.png",
        "productId" : 23006,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      } ]
    }, {
      "rankingId" : 11,
      "navTitle" : "智利榜",
      "rankingTitle" : "智利最热销榜",
      "detailsImg" : "http://image.59cdn.com/static/upload/file/20221222/1671692438785.jpg",
      "rankingProduct" : [ {
        "loginFlag" : 2,
        "cname" : "安第斯雄鹰珍藏赤霞珠干红葡萄酒_2019_6支彩色躺箱礼盒",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20220311/o_1646990409805.png",
        "productId" : 9266,
        "sort" : 1,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "阿尤干红葡萄酒_2021",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20240417/o_171334037542158.png",
        "productId" : 8926,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "领航星珍藏赤霞珠干红葡萄酒_2021_6支木箱",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20230328/o_1679980894440.jpg",
        "productId" : 22969,
        "sort" : 3,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      } ]
    }, {
      "rankingId" : 10,
      "navTitle" : "西班牙榜",
      "rankingTitle" : "西班牙最热销榜",
      "detailsImg" : "http://image.59cdn.com/static/upload/file/20221222/1671692543835.jpg",
      "rankingProduct" : [ {
        "loginFlag" : 2,
        "cname" : "欧百乐无醇葡萄饮料",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20210622/o_1624357398840.jpg",
        "productId" : 9866,
        "sort" : 1,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 2,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "金牛角酒庄干红葡萄酒",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20210825/o_1629886267321.png",
        "productId" : 4801,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "勇敢骑士干红葡萄酒_(新版)_2021",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20220720/o_1658314352323.png",
        "productId" : 8770,
        "sort" : 3,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 2,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      } ]
    }, {
      "rankingId" : 29,
      "navTitle" : "法国榜",
      "rankingTitle" : "法国最热销榜",
      "detailsImg" : "http://image.59cdn.com/static/upload/file/20221222/1671692620631.jpg",
      "rankingProduct" : [ {
        "loginFlag" : 2,
        "cname" : "阿兰颂酒庄干红葡萄酒_2022_6支木箱",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20220311/o_1646985062120.png",
        "productId" : 9979,
        "sort" : 1,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "凯格瑞中级庄干红葡萄酒_2019_3支木箱",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20231214/o_170254579180083.png",
        "productId" : 8747,
        "sort" : 2,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      }, {
        "loginFlag" : 2,
        "cname" : "双狮骑士干红葡萄酒_750ML",
        "picture" : "https://image.59cdn.com/static/upload/image/product/20210923/o_1632385183033.png",
        "productId" : 6804,
        "sort" : 3,
        "priceStr" : "登录后查看价格",
        "priceDecription" : "登录后查看价格",
        "isShouqing" : 1,
        "isQyBx" : 1,
        "productCountryPic" : "https://image.59cdn.com/images/pc_new/nationalFlag/null.jpg"
      } ]
    } ]
  }
}