import { BusinessError } from "@kit.BasicServicesKit";
import { common } from "@kit.AbilityKit";
import { systemShare } from "@kit.ShareKit";
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import fileIO from "@ohos.fileio";
import { fileUri, picker } from "@kit.CoreFileKit";

/**
 * 系统分享
 */
export class SystemShareUtils {
  static share(uiContext: UIContext, filePath: string, uniformDataType: utd.UniformDataType) {
    try {
      let utdTypeId = utd.getUniformDataTypeByMIMEType('*', uniformDataType);
      if (utdTypeId) {
        // 构造ShareData，需配置一条有效数据信息
        let shareData: systemShare.SharedData = new systemShare.SharedData({
          utd: utdTypeId,
          uri: filePath ?? ''
        });
        let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
        let context: common.UIAbilityContext = uiContext.getHostContext() as common.UIAbilityContext;
        controller.show(context, {
          previewMode: systemShare.SharePreviewMode.DEFAULT,
          selectionMode: systemShare.SelectionMode.SINGLE
        });
      }
    } catch (e) {
      let error: BusinessError = e as BusinessError;
      console.error(`Failed to getUniformDataTypeByFilenameExtension. Code: ${error.code}, message: ${error.message} `);
    }
  }

  /**
   * 获取UniformDataType，fileExt不够用的话再增加
   */
  static getUniformDataType(fileExt?: string): utd.UniformDataType {
    if ("docx" === fileExt || "doc" === fileExt) {
      return utd.UniformDataType.WORD_DOC
    } else if ("pptx" === fileExt || "ppt" === fileExt) {
      return utd.UniformDataType.PPT
    } else if ("xls" === fileExt || "xlsx" === fileExt) {
      return utd.UniformDataType.EXCEL_XLT
    } else if ("pdf" === fileExt) {
      return utd.UniformDataType.PDF
    } else if ("xmind" === fileExt) {
      return utd.UniformDataType.WORD_DOC
    } else if ("txt" === fileExt) {
      return utd.UniformDataType.TEXT
    }
    return utd.UniformDataType.WORD_DOC
  }

  static fileExist(filePath: string): boolean {
    try {
      const stat = fileIO.statSync(filePath);
      if (stat.isFile()) { // 如果是文件存在返回true
        console.log('fileIO 文件存在')
        return true
      } else {
        console.log('fileIO 文件不存在')
        return false
      }
    } catch (e) {
      return false
    }
  }

  /**
   * 获取Download的完整路径
   */
  static async getDownloadPath(fileName: string, context: common.Context): Promise<string> {
    try {
      let uri: string = '';
      const documentViewPicker = new picker.DocumentViewPicker(context);
      const documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.pickerMode = picker.DocumentPickerMode.DOWNLOAD;

      let documentSaveResult: Array<string> = await documentViewPicker.save(documentSaveOptions)
      uri = documentSaveResult[0];
      return new fileUri.FileUri(uri + '/' + fileName).path;
    } catch (e) {
      console.log(`error is ${e}}`)
      return ''
    }
  }
}