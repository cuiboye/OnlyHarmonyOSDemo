import {
  IQQOpenApi,
  OpenApiConfig,
  QQOpenApiFactory,
  ShareData,
  ShareResult,
  ShareResultType
} from "@tencent/qq-open-sdk";
import { common } from "@kit.AbilityKit";
import { CryptoJS } from '@ohos/crypto-js'
import { QQShareBean } from "../QQShareBean";
import { promptAction } from "@kit.ArkUI";

/**
 * QQ分享：目前只支持分享链接给好友
 */
export class QQShareInstance {
  public static readonly QQ_APP_ID: number = 101461422;
  public static readonly QQ_KEY: string = "e921ae65e5492483e772f903199663cc"
  public static qqOpenApi: IQQOpenApi

  constructor() {
  }

  //初始化
  static create() {
    let openApiOption: OpenApiConfig = {
      forceEnableWeb: false,
      autoHandleAuthResult: true,
    }
    QQShareInstance.qqOpenApi =
      QQOpenApiFactory.createApi(QQShareInstance.QQ_APP_ID, openApiOption)
  }

  //分享给QQ好友
  static shareToQQFriend(shareData:QQShareBean,context: common.UIAbilityContext) {
    // shareInfo.contentType = Number(shareInfo.contentType)
    let shareJson: Record<string, ESObject> = {}
    //类型？？暂无文档
    shareJson["msg_style"] = 0
    //标题
    shareJson["title"] = shareData.title??''
    //摘要
    shareJson["summary"] = shareData.summary
    //应用名
    shareJson["brief"] = "百度文库APP"
    //链接
    shareJson["url"] = shareData.url??''
    //缩略图
    if (shareData.url) {
      shareJson["picture_url"] = shareData.picture_url
    } else {
      shareJson["picture_url"] = "https://edu-wenku.bdimg.com/v1/android/pic/android/android_wenku_share_icon-1532496424806.png"
    }
    QQShareInstance.doShareToQQ(shareJson, context)
  }

  // 分享到QQ
  static async doShareToQQ(params: Record<string, ESObject>, context: common.UIAbilityContext) {
    try {
      let result: ShareResult = await QQShareInstance.qqOpenApi.share(2, QQShareInstance.GetShareData(params))

      //分享回调
      switch (result.resultType) {
        case ShareResultType.Success: {
          promptAction.showToast({message:"分享成功"})
        }
          break
        case ShareResultType.Cancel: {
          promptAction.showToast({message:"取消分享"})
        }
          break
        case ShareResultType.Error: {
          promptAction.showToast({message:"分享失败"})
        }
          break
      }
    } catch (e) {
      e.printStackTrace();
      //分享失败
    }
  }

  //获取分享参数
   static GetShareData(params: Record<string, ESObject>) {
    let shareData: ShareData = new ShareData()
    // 生成时间戳
    shareData.timestamp = Date.parse(new Date().toString()) / 1000
    // 生成随机整数
    shareData.nonce = Math.floor(Math.random() * 100000000 + 100)
    //分享图片ark业务数据
    shareData.shareJson = JSON.stringify(params)
    // 生成签名
    shareData.shareJsonSign = QQShareInstance.GetShareJsonSign(shareData)
    return shareData
  }

  //获取签名
  static GetShareJsonSign(shareData: ShareData) {
    let totalStr =
      `POSTconnect.qq.com/share?appid=${QQShareInstance.QQ_APP_ID}&nonce=${shareData.nonce}&ts=${shareData.timestamp}&${shareData.shareJson}`
    const hmac = CryptoJS.HmacSHA1(totalStr, QQShareInstance.QQ_KEY)
    return hmac.toString(CryptoJS.enc.Base64)
  }
}
