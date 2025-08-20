import { common } from "@kit.AbilityKit";
import { picker } from '@kit.CoreFileKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import FileUtils from "../FileUtils";

/**
 * 本地文件选择器
 */
class LocalFileSelectUtils {
  /**
   * 打开本地文件选择器
   * @param fragment        上下文
   * @param requestCode     请求码
   * @param isAllowMultiple 是否支持多选
   * @param limitMimeTypes  限制的文件类型mimeTypes
   */
  async openLocalFileSelectPageForFrag(fragment: common.UIAbilityContext, requestCode: number,
    isAllowMultiple?: boolean, limitMimeTypes ?: string[]): Promise<Array<FileSelectLocalFileModel>> {

    const documentSelectOptions = new picker.DocumentSelectOptions();
    // 选择文档的最大数目（可选）。
    documentSelectOptions.maxSelectNumber = 5;
    // 指定选择的文件或者目录路径（可选）。
    // documentSelectOptions.defaultFilePathUri = "file://docs/storage/Users/currentUser/test";
    // 选择文件的后缀类型['后缀类型描述|后缀类型']（可选，不传该参数，默认不过滤，即显示所有文件），若选择项存在多个后缀名，则每一个后缀名之间用英文逗号进行分隔（可选），后缀类型名不能超过100。此外2in1设备支持通配符方式['所有文件(*.*)|.*']（说明：从API version 17开始，手机支持该配置），表示为显示所有文件。
    documentSelectOptions.fileSuffixFilters = ['图片(.png, .jpg)|.png,.jpg', '文档|.txt', '视频|.mp4', '.pdf'];
    //选择是否对指定文件或目录授权，true为授权，当为true时，defaultFilePathUri为必选参数，拉起文管授权界面；false为非授权(默认为false)，拉起常规文管界面（可选）仅支持2in1设备。
    documentSelectOptions.authMode = false; //需要设置module.json5中的deviceTypes包含phone,tablet,2in1,
    //批量授权模式，默认为false（非批量授权模式）。当multAuthMode为true时为批量授权模式。当multAuthMode为true时，只有multiUriArray参数生效，其他参数不生效。仅支持手机设备。
    documentSelectOptions.multiAuthMode = false;
    //需要传入批量授权的uri数组（仅支持文件，文件夹不生效）。配合multAuthMode使用。当multAuthMode为false时，配置该参数不生效。仅支持手机设备。
    // documentSelectOptions.multiUriArray = ["file://docs/storage/Users/currentUser/test", "file://docs/storage/Users/currentUser/2test"];
    //开启聚合视图模式，支持拉起文件管理应用的聚合视图。默认为DEFAULT，表示该参数不生效，非聚合视图。当该参数置为非DEFAULT时，其他参数不生效。仅支持手机设备。
    documentSelectOptions.mergeMode = picker.MergeTypeMode.DEFAULT;
    //是否支持加密（仅支持文件，文件夹不生效），默认为false。该参数为true时，在Picker界面可以选择对文件进行加密。
    // documentSelectOptions.isEncryptionSupported = false;@since 19

    let uris: Array<string> = [];

    let models: Array<FileSelectLocalFileModel> = []
    // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
    // let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let context = fragment
    try {
      // 创建文件选择器实例
      const documentViewPicker = new picker.DocumentViewPicker(context);
      const documentSelectResult: Array<string> = await documentViewPicker.select(documentSelectOptions)
      //文件选择成功后，返回被选中文档的URI结果集。
      uris = documentSelectResult;
      console.info('documentViewPicker.select to file succeed and uris are:' + uris);

      for (let index = 0; index < uris.length; index++) {
        const element = uris[index];
        let fileModel: FileSelectFileItemModel = new FileSelectFileItemModel()
        fileModel.fileName = FileUtils.getFileName(element)
        fileModel.filePath = element
        fileModel.localFilePath = fileModel.filePath
        fileModel.fileExt = FileUtils.getFileExtention(element)
        fileModel.type = fileModel.fileExt

        // 获取文件大小
        let stat: fs.Stat = fs.statSync(FileUtils.getFilePath(element));
        let fileSize = stat.size
        fileModel.size = fileSize

        fileModel.wknHelper_sourceType = 'WKNFileSelectFileSourceLocal';

        models.push(fileModel)
      }
      return models
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Invoke documentViewPicker.select failed, code is ${error.code}, message is ${error.message}`);
    }
    return []
  }
}

export class FileSelectLocalFileModel {
  fileName ?: string
  filePath ?: string
  fileExt ?: string
  size?: number //文件大小
}

export class FileSelectFileItemModel extends FileSelectLocalFileModel {
  type ?: string
  localFilePath ?: string
  wknHelper_sourceType ?: string
}

export default new LocalFileSelectUtils()