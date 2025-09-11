import * as wxopensdk from '@tencent/wechat_open_sdk';
import { ErrCode } from '@tencent/wechat_open_sdk';
import { promptAction } from '@kit.ArkUI';

//微信sdk集成：https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/ohos.html
export class  WXCallbackInterface{
  public static WXCallbackCreate() {
    //注意：没有登录微信的话是不会执行回调的
    WXEventHandler.registerOnWXRespCallback((resp: wxopensdk.BaseResp) => {
      switch (resp.errCode) {
        case ErrCode.ERR_OK:
          // if (ShareUtil.getInstance().mShareListener != null) {
          //   ShareUtil.getInstance().mShareListener!.shareSuccess!()
          // }
          if(resp.name === "SendMessageToWXResp"){//分享
            promptAction.showToast({message:"微信分享成功"})
          }else if(resp.name === "SendAuthResp"){
            promptAction.showToast({message:"微信登录成功"})
          }
          break
        case ErrCode.ERR_USER_CANCEL:
          if(resp.name === "SendMessageToWXResp"){//分享
            promptAction.showToast({message:"微信分享取消"})
          }else if(resp.name === "SendAuthResp"){
            promptAction.showToast({message:"微信取消登录"})
          }
          break
        case ErrCode.ERR_AUTH_DENIED:
          if(resp.name === "SendMessageToWXResp"){//分享
            promptAction.showToast({message:"微信分享失败"})
          }else if(resp.name === "SendAuthResp"){
            promptAction.showToast({message:"微信登录失败"})
          }
          break
        default:
          break
      }
    })
  }
}

//微信回调实现
class WXApiEventHandlerImpl implements wxopensdk.WXApiEventHandler {
  private onReqCallbacks: Map<OnWXReq, OnWXReq> = new Map
  private onRespCallbacks: Map<OnWXResp, OnWXResp> = new Map

  registerOnWXReqCallback(on: OnWXReq) {
    this.onReqCallbacks.set(on, on)
  }

  unregisterOnWXReqCallback(on: OnWXReq) {
    this.onReqCallbacks.delete(on)
  }

  registerOnWXRespCallback(on: OnWXResp) {
    this.onRespCallbacks.set(on, on)
  }

  unregisterOnWXRespCallback(on: OnWXResp) {
    this.onRespCallbacks.delete(on)
  }

  onReq(req: wxopensdk.BaseReq): void {
    this.onReqCallbacks.forEach((on) => {
      on(req)
    })
  }

  onResp(resp: wxopensdk.BaseResp): void {
    this.onRespCallbacks.forEach((on) => {
      on(resp)
    })

    // 在此处理微信支付
    if (wxopensdk.Command.kCommandPay == resp.type) {
      // handleWxResult(resp)
    }

    // 在此处理微信小程序唤起
    if (wxopensdk.Command.kCommandLaunchMiniProgram == resp.type) {
      // handleWxMiniProgramResult(resp)
      console.log('aaabbb');
    }
  }
}

//请求监听
export type OnWXReq = (req: wxopensdk.BaseReq) => void

//响应监听
export type OnWXResp = (resp: wxopensdk.BaseResp) => void

export const WXEventHandler = new WXApiEventHandlerImpl


