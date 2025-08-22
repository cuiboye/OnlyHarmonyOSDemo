import { CommonHeader } from '../common/common_header'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { image } from '@kit.ImageKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { common, Permissions } from '@kit.AbilityKit'
import { FileSelectLocalFileModel } from '../common/utils/LocalFileSelectUtils'
import FileUtils from '../common/FileUtils'
import PermissionUtils from '../common/utils/PermissionUtils'

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
    }
    .height('100%')
    .width('100%')
  }

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