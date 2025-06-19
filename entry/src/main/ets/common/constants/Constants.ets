import ShopInfo, { Data, ProductInfoListEntity } from '../../pages/wajiu/TaskEntity';

export const APP_EXIT_INTERVAL: number = 4500;

export const TIME = 1000;

///可以用这样结构的数据模拟请求接口的数据，只要indexInfo和ShopInfo类中的数据结构一致就可以
export const indexInfo: ShopInfo = {
  "states": 200,
  "msg": "请求成功",
  "result": {
    "indexList": {
      "focus_picture": {
        "appNewIndexCategories": [
          {
            "indexName": "2024春天花会开",
            "picture": "https://image.59cdn.com/static/upload/image/app/20240401/o_1711938042571.jpg",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/activity?id=1535&clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "焦点图"
            }
          },
          {
            "indexName": "澳洲精品葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/app/20240321/o_1711014875389.jpg",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/activity?id=1530&clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "焦点图"
            }
          },
          {
            "indexName": "西班牙皇室之选梦迪系列",
            "picture": "https://image.59cdn.com/static/upload/image/app/20231124/o_1700805809122.jpg",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/activity?id=1468&clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "焦点图"
            }
          }
        ]
      },
      "home_button": {
        "appNewIndexCategories": [
          {
            "indexName": "新品",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513238733.png",
            "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"1\",\"gotoApp\":\"productNew:1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "现货",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513265798.png",
            "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"saleTypes:1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "预售",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513280650.png",
            "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"saleTypes:3\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "包销",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513290966.png",
            "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"saleTypes:2\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "OEM",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513307359.png",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/oem-index.html?clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "获奖酒",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513318184.png",
            "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"1\",\"gotoApp\":\"tagId:5\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "名庄现货",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513331160.png",
            "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"5\",\"login\":\"0\",\"gotoApp\":\"jpj\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "酒周边",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513343265.png",
            "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"4\",\"login\":\"1\",\"gotoApp\":\"zjb\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "品牌馆",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513369499.png",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/generalize.html?clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "营销海报",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513393408.png",
            "parameter": "{\"type\":\"3\",\"login\":\"0\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/posterList.html?clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "挖酒金融",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513417588.png",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/finance.html?clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "WSET",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513434059.png",
            "parameter": "{\"type\":\"3\",\"login\":\"0\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/course.html?clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          },
          {
            "indexName": "帮我卖酒",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513445398.png",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/hy-list.html?clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "首页按钮"
            }
          }
        ]
      },
      "announcement": {
        "appNewIndexCategories": [
          {
            "indexName": "服务升级|挖酒平台配送服务新增选择功能",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/headlines-detail.html?id=420&clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "挖酒头条"
            }
          },
          {
            "indexName": "2024年春节节前物流运输通知",
            "picture": "https://image.59cdn.com/static/upload/image/app/20230829/o_1693303090570.jpg",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/headlines-detail.html?id=421&clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "挖酒头条"
            }
          },
          {
            "indexName": "【小挖新闻社】2023年12月葡萄酒行业新资讯",
            "parameter": "{\"type\":\"3\",\"login\":\"1\",\"gotoUrl\":\"/api/shop/list/appProductList\",\"gotoApp\":\"https://m.wajiu.com/headlines-detail.html?id=419&clear=1\"}",
            "urlType": 1,
            "appIndex": {
              "cName": "挖酒头条"
            }
          }
        ]
      }
    },
    "brandHall": [
      {
        "id": 5,
        "name": "阿勒维萨",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:5\"}",
        "productCategoryId": 4,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544147902840.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752276246.jpg"
      },
      {
        "id": 20,
        "name": "安能",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:20\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149337482.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752070394.jpg"
      },
      {
        "id": 4,
        "name": "8 valley",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:4\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544147852381.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752283366.jpg"
      },
      {
        "id": 3,
        "name": "欧百乐",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:3\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544147829750.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752290693.jpg"
      },
      {
        "id": 12,
        "name": "毕克拉酒庄 ",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:12\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148949971.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752202046.jpg"
      },
      {
        "id": 2,
        "name": "凡度",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:2\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544147778588.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752299538.jpg"
      },
      {
        "id": 1,
        "name": "泊拉图",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:1\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544147680678.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752306614.jpg"
      },
      {
        "id": 27,
        "name": "MAOLA",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:27\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20190124/o_1548324225751.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20190124/o_1548324221962.jpg"
      },
      {
        "id": 21,
        "name": "vda",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:21\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149362200.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752057550.jpg"
      },
      {
        "id": 15,
        "name": "贝玛格雷酒庄",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:15\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149040057.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752158925.jpg"
      },
      {
        "id": 7,
        "name": "歌萄源",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:7\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148041384.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752250840.jpg"
      },
      {
        "id": 6,
        "name": "珀玛",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:6\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148013238.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752267806.jpg"
      },
      {
        "id": 26,
        "name": "爱百德",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:26\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181213/o_1544691927574.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544751902456.jpg"
      },
      {
        "id": 25,
        "name": "CARM",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:25\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149475757.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544751997878.jpg"
      },
      {
        "id": 24,
        "name": "FARINA",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:24\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149447256.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752009913.jpg"
      },
      {
        "id": 23,
        "name": "LG",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:23\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149416333.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752031893.jpg"
      },
      {
        "id": 22,
        "name": "雅曼",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:22\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149391722.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752044851.jpg"
      },
      {
        "id": 19,
        "name": "paul mas",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:19\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149232275.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752097619.jpg"
      },
      {
        "id": 18,
        "name": "bindi sergardi",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:18\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149209824.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752110351.jpg"
      },
      {
        "id": 17,
        "name": "意酒世界 ",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:17\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149184373.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752127456.jpg"
      },
      {
        "id": 16,
        "name": "干露集团",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:16\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149084395.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752148542.jpg"
      },
      {
        "id": 14,
        "name": "邵氏酒庄",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:14\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544149013545.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752177970.jpg"
      },
      {
        "id": 13,
        "name": "LGI",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:13\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148973963.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752190247.jpg"
      },
      {
        "id": 11,
        "name": "伊拉苏",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:11\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148205559.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752211474.jpg"
      },
      {
        "id": 10,
        "name": "penaflor",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:10\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148152665.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752221431.jpg"
      },
      {
        "id": 9,
        "name": "福牌",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:9\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148111834.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752230665.jpg"
      },
      {
        "id": 8,
        "name": "Maison Ventenac",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"brandId:8\"}",
        "productCategoryId": 2,
        "pcPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181207/o_1544148095564.jpg",
        "appPictrueAddress": "http://image.59cdn.com/static/upload/image/claim/20181214/o_1544752241304.jpg"
      }
    ],
    "banner_international": [
      {
        "indexName": "法国",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673513951988.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:3\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "3"
      },
      {
        "indexName": "西班牙",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514055590.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:191\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "191"
      },
      {
        "indexName": "德国",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514193037.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:208\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "208"
      },
      {
        "indexName": "智利",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514078492.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:327\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "327"
      },
      {
        "indexName": "意大利",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514141229.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:158\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "158"
      },
      {
        "indexName": "阿根廷",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514153194.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:244\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "244"
      },
      {
        "indexName": "保加利亚",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514175007.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:4017\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "4017"
      },
      {
        "indexName": "澳大利亚",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514066846.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:284\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "284"
      },
      {
        "indexName": "葡萄牙",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514201661.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:257\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "257"
      },
      {
        "indexName": "格鲁吉亚",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514218505.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:5015\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "5015"
      },
      {
        "indexName": "南非",
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514232630.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"bigCategory:2,originPlace:225\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "225"
      },
      {
        "picture": "https://image.59cdn.com/static/upload/image/app/20230112/o_1673514243015.png",
        "parameter": "{\"gotoUrl\":\"/api/shop/list/appProductList\",\"type\":\"2\",\"login\":\"0\",\"gotoApp\":\"originPlace:345\"}",
        "urlType": 1,
        "appIndex": {
          "cName": "国家馆"
        },
        "originPlace": "345"
      }
    ],
    "famousProducts": {
      "famousProductList": [
        {
          "cname": "达玛雅克酒庄干红葡萄酒 2019",
          "picture": "https://image.59cdn.com/static/upload/image/product/20240312/o_171022267348731.jpg",
        },
        {
          "cname": "伏尔泰酒庄干红葡萄酒2017",
          "picture": "https://image.59cdn.com/static/upload/image/product/20240312/o_17102246991345.png",
        },
        {
          "cname": "伏尔泰酒庄干红葡萄酒2024",
          "picture": "https://image.59cdn.com/static/upload/image/product/20240312/o_17102246991345.png",
        },
        {
          "cname": "深林单一园赤霞珠马尔贝克混酿干红葡萄酒_2017",
          "picture": "https://image.59cdn.com/static/upload/image/product/20210624/o_1624530250603.jpg",
        }
      ]
    },
    // "isLogin": 0,
    "kindSet": [
      {
        "kindName": "起泡甜白",
        "productInfoList": [
          {
            "productId": 488,
            "cname": "路易斯半干白起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20170915/o_1505468820337.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"488\"}"
          },
          {
            "productId": 489,
            "cname": "银色活力半干白起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20170902/o_1504345096356.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"489\"}"
          },
          {
            "productId": 494,
            "cname": "斯泰勒莫斯卡托低醇甜白起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20170929/o_1506666403708.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"494\"}"
          },
          {
            "productId": 911,
            "cname": "安娜-桃红卡瓦起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20210816/o_1629109150645.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"911\"}"
          },
          {
            "productId": 3842,
            "cname": "曙光莫斯卡托甜粉红葡萄酒_起泡",
            "picture": "https://image.59cdn.com/static/upload/image/product/20230328/o_1679971863261.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"3842\"}"
          },
          {
            "productId": 5846,
            "cname": "欧百乐莫斯卡托起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20231220/o_170305228450089.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"5846\"}"
          }
        ],
        "reqName": "category",
        "reqValue": "21"
      },
      {
        "kindName": "流行通货",
        "productInfoList": [
          {
            "productId": 6711,
            "cname": "人民小酒·经典清酱香型白酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20220301/o_1646097895169.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"6711\"}"
          },
          {
            "productId": 8464,
            "cname": "芙华罗顿村庄级歪脖干红葡萄酒_2020_普通彩箱",
            "picture": "https://image.59cdn.com/static/upload/image/product/20180920/o_1537431942974.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"8464\"}"
          },
          {
            "productId": 9781,
            "cname": "拉图嘉利副牌追忆干红_2019",
            "picture": "https://image.59cdn.com/static/upload/image/product/20230809/o_169154860523649.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"9781\"}"
          },
          {
            "productId": 21350,
            "cname": "庞特巴赫酒庄干红葡萄酒_2018",
            "picture": "https://image.59cdn.com/static/upload/image/product/20240123/o_170599599401655.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"21350\"}"
          },
          {
            "productId": 21941,
            "cname": "芙华罗顿村庄级歪脖干红葡萄酒_2020_普通彩箱",
            "picture": "https://image.59cdn.com/static/upload/image/product/20180920/o_1537431942974.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"21941\"}"
          }
        ],
        "reqName": "meunId",
        "reqValue": "4"
      },
      {
        "kindName": "缤纷起泡",
        "productInfoList": [
          {
            "productId": 489,
            "cname": "银色活力半干白起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20170902/o_1504345096356.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"489\"}"
          },
          {
            "productId": 488,
            "cname": "路易斯半干白起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20170915/o_1505468820337.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"488\"}"
          },
          {
            "productId": 494,
            "cname": "斯泰勒莫斯卡托低醇甜白起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20170929/o_1506666403708.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"494\"}"
          },
          {
            "productId": 911,
            "cname": "安娜-桃红卡瓦起泡葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20210816/o_1629109150645.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"911\"}"
          },
          {
            "productId": 3257,
            "cname": "多乐姿甜白起泡配制酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20201113/o_1605252509448.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"3257\"}"
          },
          {
            "productId": 3842,
            "cname": "曙光莫斯卡托甜粉红葡萄酒_起泡",
            "picture": "https://image.59cdn.com/static/upload/image/product/20230328/o_1679971863261.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"3842\"}"
          }
        ],
        "reqName": "meunId",
        "reqValue": "2"
      },
      {
        "kindName": "新颖小瓶",
        "productInfoList": [
          {
            "productId": 3001,
            "cname": "星座 双鱼座半甜白葡萄酒_250ML",
            "picture": "https://image.59cdn.com/static/upload/image/product/20211122/o_1637575635719.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"3001\"}"
          },
          {
            "productId": 3008,
            "cname": "星座 巨蟹座半甜白葡萄酒_250ML",
            "picture": "https://image.59cdn.com/static/upload/image/product/20211122/o_1637575338438.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"3008\"}"
          },
          {
            "productId": 3839,
            "cname": "曙光莫斯卡托甜白葡萄酒_起泡",
            "picture": "https://image.59cdn.com/static/upload/image/product/20230328/o_1679971943703.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"3839\"}"
          },
          {
            "productId": 3842,
            "cname": "曙光莫斯卡托甜粉红葡萄酒_起泡",
            "picture": "https://image.59cdn.com/static/upload/image/product/20230328/o_1679971863261.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"3842\"}"
          },
          {
            "productId": 4280,
            "cname": "黑羊威士忌_100毫升_100ML",
            "picture": "https://image.59cdn.com/static/upload/image/product/20240104/o_17043480185853.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"4280\"}"
          },
          {
            "productId": 4604,
            "cname": "忠诚朋友_187.5ML_6支手提盒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20230201/o_1675228710256.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"4604\"}"
          }
        ],
        "reqName": "tagId",
        "reqValue": "9"
      },
      {
        "kindName": "精装佳酿",
        "productInfoList": [
          {
            "productId": 21348,
            "cname": "方特城堡干红葡萄酒_2022_6支木箱",
            "picture": "https://image.59cdn.com/static/upload/image/product/20221114/o_1668402635439.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"21348\"}"
          },
          {
            "productId": 7878,
            "cname": "莫汉父子勃艮第丘干红葡萄酒_2021_6支木箱",
            "picture": "https://image.59cdn.com/static/upload/image/product/20221104/o_1667551036414.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"7878\"}"
          },
          {
            "productId": 4783,
            "cname": "安缇加尔1号酒庄安琪尔单一园干红葡萄酒_2013",
            "picture": "https://image.59cdn.com/static/upload/image/product/20191212/o_1576117029947.jpg",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"4783\"}"
          },
          {
            "productId": 5201,
            "cname": "梦迪珍酿丹魄干红葡萄酒_2012",
            "picture": "https://image.59cdn.com/static/upload/image/product/20220812/o_1660294016699.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"5201\"}"
          },
          {
            "productId": 5889,
            "cname": "巴龙汤尼礼品波特利口葡萄酒",
            "picture": "https://image.59cdn.com/static/upload/image/product/20210928/o_1632823925225.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"5889\"}"
          },
          {
            "productId": 6634,
            "cname": "凡度庄园传世干红葡萄酒_2017_6支木箱",
            "picture": "https://image.59cdn.com/static/upload/image/product/20210810/o_1628581358173.png",
            "jnPrice": "登录后查看价格",
            "parameter": "{\"gotoUrl\":\"/api/shop/goods\",\"type\":\"1\",\"gotoApp\":\"6634\"}"
          }
        ],
        "reqName": "tagId",
        "reqValue": "8"
      }
    ],
  }
}


