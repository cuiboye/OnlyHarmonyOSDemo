import { HMRouter } from '@hadss/hmrouter';
import { webview } from '@kit.ArkWeb';
import { NavigationConstants } from '../../common/constants/NavigationConstants';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { fileIo, fileUri } from "@kit.CoreFileKit";
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import fs from '@ohos.file.fs';
const TAG = 'WebComponent';
const url: string = 'https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-dev-guide';

/**
 * WebView长截图
 */
@HMRouter({ pageUrl: NavigationConstants.WEBLONGSCREENSHOT_PAGE })
@Component
export struct WebLongScreenShot {
  context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  @State h5Width: number = 0;
  @State h5Height: number = 0;
  @State longPixelMap: PixelMap | undefined = undefined;
  private webviewController: webview.WebviewController = new webview.WebviewController();
  @State MainColor: string = '';

  aboutToAppear(): void {
    webview.WebviewController.initializeWebEngine();
    webview.WebviewController.enableWholeWebPageDrawing();
    webview.WebviewController.prepareForPageLoad(url, true, 2);
  }
  async getWebSize() {
    const SCRIPT = '[document.documentElement.scrollWidth, document.documentElement.scrollHeight]';
    try {
      this.webviewController.runJavaScriptExt(SCRIPT).then((result) => {
        if (result.getType() === webview.JsMessageType.ARRAY) {
          this.h5Width = (result.getArray() as number[])[0];
          this.h5Height = (result.getArray() as number[])[1];
          console.info(TAG, `h5Width is ${this.h5Width}, h5Height is ${this.h5Height}`);
        }
      });
    } catch (error) {
      console.error(TAG, `Run script to get web page size failed. Error: ${JSON.stringify(error)}`);
    }
  }
  async webSnapshot() {
    try {
      this.webviewController.webPageSnapshot({ id: 'webTest', size: { width: this.h5Width, height: this.h5Height } },
        async (error, result) => {
          if (result) {
            this.longPixelMap = result.imagePixelMap;

            //截取成功了

            //下面是保存到相册
            let imgPath = `${systemDateTime.getTime()}.png`
            let cachePath = this.context.cacheDir
            let fullPath = cachePath + imgPath
            let file = await fileIo.open(fullPath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
            let imagePacker: image.ImagePacker = image.createImagePacker()
            let packerOptions: image.PackingOption = { format: 'image/png', quality: 100 }
            imagePacker.packToFile(result.imagePixelMap, file.fd, packerOptions, async (err: BusinessError) => {
              if (err) {
                console.log('图片存储转换失败');
                // LogUtils.d('图片存储转换失败 - ', err.message)
              } else {
                // fullPath为保存的图片路径
                console.log(`图片存储成功 图片路径为：${fullPath}`);
                // LogUtils.d('图片存储成功 - ', fullPath)


                //下面的操作是将截图的图片保存到相册
                //先缓存 增加预览图
                let applicationContext = this.context.getApplicationContext();
                let dirpath = applicationContext.tempDir + '/cameTem.png';
                let dirUri = fileUri.getUriFromPath(dirpath); // 通过传入的路径path生成uri
                let finalFile = fs.openSync(fullPath, fs.OpenMode.READ_ONLY)
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
              }
            })
          }
        });
    } catch (error) {
      console.error(TAG, `webPageSnapshot err : ${JSON.stringify(error)}`);
    }
  }
  build() {
    Stack() {
      Web({
        // src: url,
        src: "https://tanbi.baidu.com/h5apptopic/browse/wkgpthorosharepage",
        controller: this.webviewController
      })
        .height('50%')
        .id('webTest')
        .borderRadius(20)
        .clip(true)
      Scroll() {
        Column() {
          Image(this.longPixelMap)
            .width('80%')
            .height('50%')
            .borderRadius(20)
            .clip(true)
        }
      }
      Button('WebPageSnapshot')
        .onClick(() => {
          this.webSnapshot();
        })
    }
  }
}
