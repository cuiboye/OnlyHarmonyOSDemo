import { common } from "@kit.AbilityKit";
import {
  AuthInfo,
  IWBAPI,
  MultiImageObject,
  TextObject,
  UiError,
  WBAPI,
  WbASListener,
  WeiboMultiMessage
} from "core";
import { ArrayList } from "@kit.ArkTS";
import { fileUri } from "@kit.CoreFileKit";
import { promptAction } from "@kit.ArkUI";
import { TextUtils } from "../TextUtils";

//微博分享
export class WeiboShareInstance{
  public static readonly WEIBO_APP_KEY = "2612367117" //
  public static readonly WEIBO_REDIRECT_URL = "https://api.weibo.com/oauth2/default.html"
  public static readonly WEIBO_SCOPE = "email,direct_messages_read,direct_messages_write,"
    + "friendships_groups_read,friendships_groups_write,statuses_to_me_read,"
    + "follow_app_official_microblog," + "invitation_write"
  private static readonly TAG = "commonShareAction_WeiboShareExecutor"
  public  static mWBAPI: IWBAPI | null = null

  //初始化方法
  public static  initSdk(context: common.UIAbilityContext) {
    let authInfo: AuthInfo = new AuthInfo(context,
      WeiboShareInstance.WEIBO_APP_KEY,
      WeiboShareInstance.WEIBO_REDIRECT_URL,
      WeiboShareInstance.WEIBO_SCOPE, true)
    WBAPI.getInstance().registerApp(authInfo)
    WeiboShareInstance.mWBAPI = WBAPI.getInstance()
  }

  /**
   * @param title
   * @param desc
   * @param webUrl
   * @param shareImageDownloadLocalPath 本地图片路径
   * @param type  1:纯文字  2:图片  3:文字+图片
   */
  static  share(title: string, desc: string,webUrl: string, shareImageDownloadLocalPath:string,context: common.UIAbilityContext,type:number) {
    try {
      let message: WeiboMultiMessage = new WeiboMultiMessage()

      if(type === 1){//纯文字
        message.textObject = WeiboShareInstance.getTextObj(title, desc,webUrl)
      }else if(type === 2){//图片
        message.multiImageObject = WeiboShareInstance.getImageObj(shareImageDownloadLocalPath)
      }else if(type ===3){//文字+图片
        message.textObject = WeiboShareInstance.getTextObj(title, desc,webUrl)
        message.multiImageObject = WeiboShareInstance.getImageObj(shareImageDownloadLocalPath)
      }

      if (WeiboShareInstance.mWBAPI != null) {
        WeiboShareInstance.mWBAPI.shareMessage(context, message, WeiboShareInstance.getListener())
      }
    } catch (e) {

    }
  }

  //获取文字对象
  static  getTextObj(title: string, desc: string,webUrl: string) {
    let textObject: TextObject = new TextObject()
    let text = "我正在使用微博客户端发博器分享文字。"
    text = (TextUtils.isEmpty(title) ? "" : (title + "\n"))
      + (TextUtils.isEmpty(desc) ? "" : (desc + "\n"))
      + (TextUtils.isEmpty(webUrl) ? "" : (webUrl))
    textObject.text = text
    return textObject
  }

  //获取图片对象
  static getImageObj(shareImageDownloadLocalPath: string) {
    let multiImage: MultiImageObject = new MultiImageObject()
    let uris = new ArrayList<string>()
    uris.add(fileUri.getUriFromPath(shareImageDownloadLocalPath))
    multiImage.uriStrs = uris.convertToArray()
    return multiImage
  }

  //获取回调
  static  getListener() {
    let mListener: WbASListener = {
      onComplete: () => {
        // if (ShareUtil.getInstance().mShareListener != null) {
        //   ShareUtil.getInstance().mShareListener!.shareSuccess!();
        // }
        promptAction.showToast({message:"微博回调成功"})
      },
      onError: (error: UiError) => {
        promptAction.showToast({message:"微博回调失败"})
      },
      onCancel: () => {
        promptAction.showToast({message:"微博回调取消"})
      }
    }
    return mListener
  }
}
