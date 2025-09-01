import { CommonHeader } from '../common/common_header'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo, fileUri } from '@kit.CoreFileKit'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { common, Permissions } from '@kit.AbilityKit'
import { FileSelectLocalFileModel } from '../common/utils/LocalFileSelectUtils'
import FileUtils from '../common/FileUtils'
import PermissionUtils from '../common/utils/PermissionUtils'
import axios from '@ohos/axios'
import fs from '@ohos.file.fs';
import { promptAction } from '@kit.ArkUI'

/**
 * 保存图片到相册
 */
@Entry
@Component
struct SaveImagePage {
  private context = getContext(this) as common.UIAbilityContext
  private permissions: Array<Permissions> = ['ohos.permission.WRITE_MEDIA'];
  build() {
    Column() {
      CommonHeader()
      Button('选择文件')
        .onClick(async () => {
          PermissionUtils.checkPermissions(this.context, this.permissions, {
            successAuthorization: async (): Promise<void> => {
              const selectedFileList: Array<FileSelectLocalFileModel> = await FileUtils.selectFile(this.context)
              this.saveImage(selectedFileList[0].filePath ?? '')
            },
            refuseAuthorization: (): void => {

            }
          })
        })
      SaveButton({
        //使用SaveButton不需要手动去写申请权限的代码
        icon: SaveIconStyle.FULL_FILLED,
        text: SaveDescription.SAVE_IMAGE,
        buttonType: ButtonType.Capsule
      })
        .backgroundColor(Color.White)
        .fontColor($r('sys.color.font_emphasize'))
        .iconColor($r('sys.color.font_emphasize'))
        .width('calc(50% - 24vp)')
        .height(40)
        .fontSize(16)
        .onClick(async (event, result) => {
          const selectedFileList: Array<FileSelectLocalFileModel> = await FileUtils.selectFile(this.context)
          this.saveImageWithSaveButton(selectedFileList[0].filePath ?? '', result)
        })

      Button('通过复制文件的方式保存图片到相册')
        .onClick(async () => {
          let url = "https://inews.gtimg.com/news_bt/OBkbmPLeWLy4IM4oUDGvOIqSDSZ9lYOtW3qSXCYh78KXcAA/1000"
          this.saveImageWithCopy('hello',url)
        })
    }
    .height('100%')
    .width('100%')
  }

  /**
   * 使用axios从网络上下载图片保存到相册：先保存到沙箱，然后移动到相册，每次保存图片都会弹出申请授权保存图片的弹框
   */
  public async saveImageWithCopy(docName: string, url: string){
    const docExt: string = 'png'
    // 1. 创建路径
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/downloads/${docName}.png`
    try {
      //验证路径是否存在
      await FileUtils.directoryExists(targetPath);
      // 2. 开始下载文件
      await axios({
        url,
        method: 'GET',
        filePath: targetPath,
        responseType: 'ARRAY_BUFFER',
        onDownloadProgress: (progressEvent) => {
          const progress = progressEvent.total ?
            (progressEvent.loaded / progressEvent.total * 100) : 0;
          console.log('当前进度---', progress)
          // if(downCallback?.onDownProgress){
          //   downCallback?.onDownProgress(progress)
          // }
        }
      });
      // 判断文件大小是否大于0
      const fileSize = FileUtils.getFileSize(targetPath);
      if (fileSize <= 0) {
        // if(downCallback?.onDownErr){
        //   downCallback?.onDownErr('下载的文件大小为')
        // }
      }
      //先缓存 增加预览图
      let dirpath = applicationContext.tempDir + '/cameTem.png';
      let dirUri = fileUri.getUriFromPath(dirpath); // 通过传入的路径path生成uri
      let finalFile = fs.openSync(targetPath, fs.OpenMode.READ_ONLY)
      let dirFile = fs.openSync(dirpath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
      fs.copyFileSync(finalFile.fd, dirFile.fd)
      fs.closeSync(finalFile);
      fs.closeSync(dirFile);
      //保存到相册
      let srcFileUris: Array<string> = [dirUri];
      let photoCreationConfigs: Array<photoAccessHelper.PhotoCreationConfig> = [
        { fileNameExtension: 'png',
          photoType: photoAccessHelper.PhotoType.IMAGE,
        }
      ];
      let desFileUris: Array<string> = await photoAccessHelper.getPhotoAccessHelper(this.context)
        .showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
      let desFile: fileIo.File = await fileIo.open(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
      let srcFile: fileIo.File = await fileIo.open(dirUri, fileIo.OpenMode.READ_ONLY);
      await fileIo.copyFile(srcFile.fd, desFile.fd);
      fileIo.closeSync(srcFile);
      fileIo.closeSync(desFile);
      // if(downCallback?.onDownSuccess){
      //   downCallback?.onDownSuccess(targetPath)
      // }
      promptAction.showToast({message:'下载成功'})
    } catch (error) {
      let err = error as BusinessError
      FileUtils.cleanFile(targetPath);
      // if(downCallback?.onDownErr){
      //   downCallback?.onDownErr('下载失败')
      // }
      promptAction.showToast({message:'下载失败'})
    }
  }

  /**
   * 自己申请权限进行保存文件的操作
   * @param path
   */
  async saveImage(path: string) {
    //需要先将文件copy到沙箱然后才可以移动到相册中
    const filePath = FileUtils.copyFileNew(path, `${this.context.filesDir}/hello.png`)
    try {
      const imageSourceApi: image.ImageSource = image.createImageSource(filePath);

      const helper = photoAccessHelper.getPhotoAccessHelper(this.context);
      const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
      const file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      const imagePackerApi: image.ImagePacker = image.createImagePacker();
      const packOpts: image.PackingOption = {
        format: 'image/png',
        quality: 100,
      };
      imagePackerApi.packToData(imageSourceApi, packOpts).then((data) => {
        fileIo.writeSync(file.fd, data);
        fileIo.closeSync(file.fd);
        this.getUIContext().getPromptAction().showToast({
          message: '已保存至相册',
          duration: 1800
        })
      }).catch((error: BusinessError) => {
        console.log(`${error}`)
      });
    } catch (e) {
      console.log(`${e}`)
    }
  }

  /**
   * 使用SaveButton保存文件
   */
  async saveImageWithSaveButton(path: string, result?: SaveButtonOnClickResult) {
    //需要先将文件copy到沙箱然后才可以移动到相册中
    const filePath = FileUtils.copyFileNew(path, `${this.context.filesDir}/hello.png`)
    if (result === SaveButtonOnClickResult.SUCCESS) {
      try {
        const imageSourceApi: image.ImageSource = image.createImageSource(filePath);

        const helper = photoAccessHelper.getPhotoAccessHelper(this.context);
        const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
        const file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        const imagePackerApi: image.ImagePacker = image.createImagePacker();
        const packOpts: image.PackingOption = {
          format: 'image/png',
          quality: 100,
        };
        imagePackerApi.packToData(imageSourceApi, packOpts).then((data) => {
          fileIo.writeSync(file.fd, data);
          fileIo.closeSync(file.fd);
          this.getUIContext().getPromptAction().showToast({
            message: '已保存至相册',
            duration: 1800
          })
        }).catch((error: BusinessError) => {
          console.log(`${error}`)
        });
      } catch (e) {
        console.log(`${e}`)
      }
    }
  }
}