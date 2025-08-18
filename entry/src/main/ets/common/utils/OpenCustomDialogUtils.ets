import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction, UIContext } from '@kit.ArkUI';

type CloseOpenCustomDialog = ()=>void

export class OpenCustomDialogUtils {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    OpenCustomDialogUtils.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    OpenCustomDialogUtils.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    OpenCustomDialogUtils.options = options;
  }

  static openDialog(dialogContent: ComponentContent<Object>, options?: promptAction.BaseDialogOptions) {
    if (OpenCustomDialogUtils.contentNode !== null) {
      OpenCustomDialogUtils.ctx.getPromptAction()
        .openCustomDialog(dialogContent, options)
        .then(() => {
          console.info('OpenCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`OpenCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  static closeDialog(contentNode?: ComponentContent<Object>,closeCallback?:CloseOpenCustomDialog) {
    if (contentNode !== null) {
      OpenCustomDialogUtils.ctx.getPromptAction()
        .closeCustomDialog(contentNode)
        .then(() => {
          closeCallback?.()
          console.info('CloseCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  static updateDialog(options: promptAction.BaseDialogOptions) {
    if (OpenCustomDialogUtils.contentNode !== null) {
      OpenCustomDialogUtils.ctx.getPromptAction()
        .updateCustomDialog(OpenCustomDialogUtils.contentNode, options)
        .then(() => {
          console.info('UpdateCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`UpdateCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }
}