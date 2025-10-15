import { ComponentContent, promptAction, window } from '@kit.ArkUI';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { PromptActionParams } from './PromptActionParams';
import { WkBaseDialogOptions } from './WkBaseDialogOptions';

export class PromptActionManager {
  private static instance: PromptActionManager;
  private uiContext?: UIContext;
  private cacheWindow?: window.Window;
  private caches: Array<PromptActionParams> = new Array<PromptActionParams>();

  private constructor() {

  }

  static getInstance(): PromptActionManager {
    if (!PromptActionManager.instance) {
      PromptActionManager.instance = new PromptActionManager();
    }
    return PromptActionManager.instance;
  }


  /**
   * 创建并弹出自定义的弹窗
   */
  openCustomDialog<T extends WkBaseDialogOptions>(contentView: WrappedBuilder<[T]>, options: T): string {
    if (!options.dialogId) {
      options.dialogId = this.generateDialogId();
    }
    if (options.uiContext) {
      this.openPromptCustomDialog(options.uiContext, contentView, options);
    } else {
      if (this.isWindowFocused(this.cacheWindow)) {
        this.openPromptCustomDialog(this.uiContext!, contentView, options);
      } else {
        window.getLastWindow(getContext()).then((result: window.Window) => {
          this.cacheWindow = result;
          this.uiContext = result.getUIContext();
          this.openPromptCustomDialog(this.uiContext, contentView, options);
        })
      }
    }
    return options.dialogId;
  }


  /**
   * 创建并弹出dialogContent对应的自定义弹窗
   */
  private openPromptCustomDialog<T extends WkBaseDialogOptions>(uiContext: UIContext,
    wrappedBuilder: WrappedBuilder<[T]>, options: T) {

    if (!this.exist(options.dialogId ?? "")) {
      let componentContent = new ComponentContent(uiContext, wrappedBuilder, options);
      let option: promptAction.BaseDialogOptions = {
        alignment: options.alignment,
        maskColor: options.maskColor,
        isModal: options.isModal,
        showInSubWindow: options.showInSubWindow,
        autoCancel: options.autoCancel,
        transition: options.transition,
        onWillAppear: options.onWillAppear,
        onWillDisappear: options.onWillDisappear,
        onDidAppear: options.onDidAppear,
        //控制弹窗在页面弹出，返回还存在，还需showInSubWindow,为false
        levelMode:options.levelMode,
        levelUniqueId:options.levelUniqueId,
        immersiveMode:options.immersiveMode,
        onDidDisappear: () => {
          this.removeParams(options.dialogId ?? '');
          if (options.onDidDisappear) {
            options.onDidDisappear();
          }
        },
        onWillDismiss: (action: DismissDialogAction) => {
          if (options.onWillDismiss) {
            options.onWillDismiss(action);
          } else {
            if (action.reason == DismissReason.PRESS_BACK && options.backCancel) {
              action.dismiss()
            } else if (action.reason == DismissReason.TOUCH_OUTSIDE && options.autoCancel) {
              action.dismiss()
            }
          }
        },
      }
      this.addParams(options.dialogId ?? "", uiContext, componentContent); // 显示弹框时，添加
      let promptAction = uiContext.getPromptAction();
      promptAction.openCustomDialog(componentContent, option);
    } else {
      console.info(`弹框已存在---------------dialogId：${options.dialogId}`);
    }
  }


  /**
   * 关闭弹窗
   */
  closeCustomDialog(dialogId: string) {
    let promptActionParams: PromptActionParams | undefined = this.getArgById(dialogId);
    if (promptActionParams && promptActionParams.uiContext) {
      let promptAction = promptActionParams.uiContext.getPromptAction();
      promptAction.closeCustomDialog(promptActionParams.componentContent);
    }
  }


  /**
   * 刷新自定义弹窗
   */
  update<T extends WkBaseDialogOptions>(dialogId: string, params: T) {
    let promptActionParams: PromptActionParams | undefined = this.getArgById(dialogId);
    if (promptActionParams) {
      promptActionParams.componentContent.update(params);
    }
  }


  /**
   * 是否存在自定义弹窗
   */
  exist(dialogId: string): boolean {
    let arg = this.getArgById(dialogId);
    return arg != undefined;
  }


  /**
   * 生成弹框的ID
   */
  generateDialogId(): string {
    return `${new Date().getTime()}${Math.floor(this.secureRandBySync())}`;
  }

  secureRandBySync(): number {
    // 同步生成 [0, 1) 区间的随机数
    const rand = cryptoFramework.createRandom();
    const randData = rand.generateRandomSync(4);
    const uint32 = new Uint32Array(randData.data.buffer)[0];
    const result = uint32 / 4294967296;
    return result
  }

  /**
   * 根据dialogId获取封装参数
   */
  getArgById(dialogId: string): PromptActionParams | undefined {
    return this.caches.find(item => dialogId == item.dialogId);
  }

  /**
   * 判断当前窗口是否已获焦。
   */
  private isWindowFocused(window?: window.Window): boolean {
    try {
      let isFocused = window?.isFocused() ?? false;
      return isFocused;
    } catch (e) {
      return false;
    }
  }



  private addParams(dialogId: string, uiContext: UIContext, componentContent: ComponentContent<Object>) {
    let arg: PromptActionParams = { dialogId: dialogId, uiContext: uiContext, componentContent: componentContent }
    this.caches.unshift(arg);
  }


  private removeParams(dialogId: string) {
    let args = PromptActionManager.getInstance().caches;
    let index = args.findIndex((item) => item.dialogId == dialogId);
    if (index >= 0) {
      args.splice(index, 1);
    }
  }
}
