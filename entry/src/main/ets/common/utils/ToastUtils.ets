import { ComponentContent, promptAction} from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AppUtils } from '../AppUtils';
import { ShowToastOptions } from '../ShowToastOptions';
import { LogUtils } from './LogUtils';

export class ToastConfig {
  showMode: promptAction.ToastShowMode = promptAction.ToastShowMode.DEFAULT;
  alignment?: Alignment = undefined
  offset: Offset = { dx: 0, dy: 0 }
  duration: number = 2000;
  duration_short: number = 1500;
  duration_long: number = 2000;
  backgroundColor: ResourceStr = '#ffffff'
}

export class ToastUtils {
  private constructor() {
  }

  private static defaultConfig: ToastConfig = new ToastConfig()
  private static currentToast: ComponentContent<ShowToastOptions> | null = null;
  private static timerId: number = -1;

  public static show(message: string | Resource) {
    ToastUtils.showToast(message)
  }

  /**
   * 弹出toast 默认时长为2s
   */
  static showToast(message: string | Resource, options?: ToastOptions) {
    if ((typeof message === 'string' && message.length > 0) || message) {
      try {
        AppUtils.getUIContext().getPromptAction().showToast({
          message: message,
          duration: options?.duration ?? ToastUtils.defaultConfig.duration,
          showMode: options?.showMode ?? ToastUtils.defaultConfig.showMode,
          alignment: options?.alignment ?? ToastUtils.defaultConfig.alignment,
          offset: options?.offset ?? ToastUtils.defaultConfig.offset,
          textColor: options?.textColor,
          backgroundColor: options?.backgroundColor ?? ToastUtils.defaultConfig.backgroundColor,
          backgroundBlurStyle: BlurStyle.NONE
        })
      } catch (error) {
        LogUtils.d(`Wenku Exception: showToast. Code: ${error.code}.`);
      }
    }
  }


  /**
   * 弹出toast,时长为:1.5s,
   */
  static showShortToast(message: string | Resource, options?: ToastOptions) {
    if ((typeof message === 'string' && message.length > 0) || message) {
      AppUtils.getUIContext().getPromptAction().showToast({
        message: message,
        duration: options?.duration ?? ToastUtils.defaultConfig.duration_short,
        showMode: options?.showMode ?? ToastUtils.defaultConfig.showMode,
        alignment: options?.alignment ?? ToastUtils.defaultConfig.alignment,
        offset: options?.offset ?? ToastUtils.defaultConfig.offset,
        textColor: options?.textColor,
        backgroundColor: options?.backgroundColor,
        backgroundBlurStyle: BlurStyle.NONE
      })
    }
  }


  /**
   * 弹出toast,时长为:2s
   */
  static showLongToast(message: string | Resource, options?: ToastOptions) {
    if ((typeof message === 'string' && message.length > 0) || message) {
      AppUtils.getUIContext().getPromptAction().showToast({
        message: message,
        duration: options?.duration ?? ToastUtils.defaultConfig.duration_long,
        showMode: options?.showMode ?? ToastUtils.defaultConfig.showMode,
        alignment: options?.alignment ?? ToastUtils.defaultConfig.alignment,
        offset: options?.offset ?? ToastUtils.defaultConfig.offset,
        textColor: options?.textColor,
        backgroundColor: options?.backgroundColor,
        backgroundBlurStyle: BlurStyle.NONE
      })
    }
  }

  /**
   * 显示错误信息
   * @param businessError BusinessError
   */
  public static showErrorToast(businessError: BusinessError): void {
    try {
      ToastUtils.show(`Error Code: ${businessError.code} ${businessError.message}`,);
    } catch (error) {
      LogUtils.d(`Catch: showError showToast. Code: ${error.code}.`);
    }
  }

  /**
   * 不依赖UI组件的全局自定义吐司弹窗（具备穿透、不受返回键影响等能力）
   * <br>
   * 默认2s
   */
  public static openCustomToast(options: ShowToastOptions) {
    // 获取OverlayManager对象
    let overlay = AppUtils.getUIContext().getOverlayManager();
    if (ToastUtils.currentToast) {
      overlay.removeComponentContent(ToastUtils.currentToast);
      clearTimeout(ToastUtils.timerId);
    }
    LogUtils.d("ToastUtils.openCustomToast");
    // 创建浮层节点
    ToastUtils.currentToast =
      new ComponentContent<ShowToastOptions>(AppUtils.getUIContext(), wrapBuilder(customToastBuilder), options);
    overlay.addComponentContent(ToastUtils.currentToast);
    // 删除overlay上的指定节点
    ToastUtils.timerId = setTimeout(() => {
      overlay.removeComponentContent(ToastUtils.currentToast);
      ToastUtils.currentToast = null;
    }, options?.duration ?? 2_000);
  }
}


export class ToastOptions {
  duration?: number;
  bottom?: string | number;
  showMode?: promptAction.ToastShowMode;
  alignment?: Alignment;
  offset?: Offset;
  backgroundColor?: ResourceColor
  textColor?: ResourceColor
}

@Builder
function customToastBuilder(options: ShowToastOptions) {
  Stack() {
    Text(options.message)
      .fontSize(options.textSize ?? 16)
      .fontColor(options.textColor ?? '#ffffff')
      .padding(options.padding ?? {
        left: 15,
        right: 15,
        top: 14,
        bottom: 14
      })
      .backgroundColor(options.backgroundColor ?? '#f21f1f1f')
      .borderRadius(options.borderRadius ?? 15)
      .backgroundBlurStyle(options.backgroundBlurStyle ?? BlurStyle.NONE)
      .shadow(options.shadow ?? undefined)
  }
  .width('100%')
  .height('100%')
  .alignContent(options.alignment ?? Alignment.Center)
  .offset(options.offset ?? { x: 0, y: 0 })
  .hitTestBehavior(HitTestMode.Transparent)
}