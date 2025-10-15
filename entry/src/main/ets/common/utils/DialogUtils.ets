import { commonAlertDialog } from "../../dialog/DialogBuilder";
import { DialogDefaultConfig } from "../../dialog/DialogDefaultConfig";
import { PromptActionManager } from "../../dialog/PromptActionManager";
import { AppUtils } from "../AppUtils";
import { DialogOptions } from "../base/DialogOptions";
import { WkBaseDialogOptions } from "../base/WkBaseDialogOptions";

export class DialogUtils {
  private static defaultConfig: DialogDefaultConfig = new DialogDefaultConfig()

  static showSureCancelDialog(option?: DialogOptions, callback?: VoidCallback) {
    let defaultOption: DialogOptions = {
      title: option?.title ?? '',
      content: option?.content ?? '',
      leftBtnStr: option?.leftBtnStr ?? '取消',
      rightBtnStr: option?.rightBtnStr ?? '确定',
      alignment: DialogAlignment.Center,
      autoCancel: false, //点击外部是否可以消失
      backCancel: false, //侧滑返回是否可以消失
      leftCb: () => {
        DialogUtils.closeDialog(dialogId);
      },
      rightCb: () => {
        DialogUtils.closeDialog(dialogId);
        callback?.()
      }
    };
    let dialogId = DialogUtils.showCustomDialog(wrapBuilder(commonAlertDialog), defaultOption);
  }

  static closeDialog(dialogId: string) {
    PromptActionManager.getInstance().closeCustomDialog(dialogId)
  }

  static showCustomDialog<T extends WkBaseDialogOptions>(builder: WrappedBuilder<[T]>, options: T): string {
    DialogUtils.initDialogConfig(options)
    let dialogId = PromptActionManager.getInstance().openCustomDialog(builder, options)
    return dialogId
  }

  private static initDialogConfig(options: WkBaseDialogOptions) {
    options.uiContext = options.uiContext ?? AppUtils.getUIContext()
    options.isModal = options.isModal ?? DialogUtils.defaultConfig.isModal
    options.showInSubWindow = options.showInSubWindow ?? DialogUtils.defaultConfig.showInSubWindow
    options.autoCancel = options.autoCancel ?? DialogUtils.defaultConfig.autoCancel
    options.backCancel = options.backCancel ?? DialogUtils.defaultConfig.backCancel

    if (options.alignment || DialogUtils.defaultConfig.alignment) {
      options.alignment = options.alignment ?? DialogUtils.defaultConfig.alignment
    }

    if (options.maskColor || DialogUtils.defaultConfig.maskColor) {
      options.maskColor = options.maskColor ?? DialogUtils.defaultConfig.maskColor
    }
    if (options.transition || DialogUtils.defaultConfig.transition) {
      options.transition = options.transition ?? DialogUtils.defaultConfig.transition
    }
    if (options.onWillDismiss || DialogUtils.defaultConfig.onWillDismiss) {
      options.onWillDismiss = options.onWillDismiss ?? DialogUtils.defaultConfig.onWillDismiss
    }
    if (options.onDidDisappear || DialogUtils.defaultConfig.onDidDisappear) {
      options.onDidDisappear = options.onDidDisappear ?? DialogUtils.defaultConfig.onDidDisappear
    }
  }
}
