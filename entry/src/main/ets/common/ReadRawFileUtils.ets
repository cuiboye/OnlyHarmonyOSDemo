import { common } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';

/**
 * 读取rawfile下的文件内容
 */
export default class ReadRawFileUtils {
  static readRawFile(context: common.UIAbilityContext,fileCallBack:FileCallBack) {
    try {
      context.resourceManager.getRawFileContent("test.txt", (error: BusinessError, value: Uint8Array) => {
        if (error != null) {
          console.error("error is " + error);
        } else {
          const result = util.TextDecoder.create().decodeWithStream(value)
          console.info('result:' + result)
          fileCallBack.getFileContent(result);
        }
      });
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      console.error(`callback getRawFileContent failed, error code: ${code}, message: ${message}.`);
    }
  }
}

//接口回调
export interface FileCallBack {
  getFileContent: (content: string) => void
}