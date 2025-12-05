import { CommonHeader } from '../common/common_header'
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { BusinessError, print } from '@kit.BasicServicesKit';
import { ReadOptions } from '@kit.CoreFileKit';
import fs, { WriteOptions } from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';

/**
 * 使用系统的print打印文件
 * 待打印文件列表，支持图片(.jpg.png.gif.bmp.webp)和pdf。文件需先保存到应用沙通过fileUri.getUriFromPath获取到沙箱uri,再作为参数传入到本接口。
 * 注意：
 * 1）需要在module.json5中添加权限 "ohos.permission.PRINT"
 * 2）“幼儿园大班数学.pdf”这个文件如果在沙箱中没有,可以将rawfile中的“幼儿园大班数学.pdf”文件拷贝到沙箱中
 */
@HMRouter({ pageUrl: NavigationConstants.PRINTFILE_PAGE })
@Component
export struct PrintFile {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      CommonHeader({ title: 'wrapBuilder的使用' })
      Button('打印文件')
        .onClick(()=>{
          this.printFile("")
        })
    }
    .height('100%')
    .width('100%')
  }

  /**
   * 打印文件-只支持图片和pdf
   */
  printFile(filePath: string) {
    //这里用沙箱文件测试
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/幼儿园大班数学.pdf`;

    let file = fs.openSync(targetPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    // let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

    // 设置待打印文件名称`jobName`。
    let jobName: string = 'test';
    // 创建三方应用实现的PrintDocumentAdapter接口实例`printAdapter`。
    let printAdapter: print.PrintDocumentAdapter = {
      onStartLayoutWrite(jobId: string,
        oldAttrs: print.PrintAttributes,
        newAttrs: print.PrintAttributes,
        fd: number,
        writeResultCallback: (jobId: string, writeResult: print.PrintFileCreationState) => void): void {
        console.info('printxxx', 'jobId:', jobId, 'oldAttrs:', JSON.stringify(oldAttrs), 'newAttrs:',
          JSON.stringify(newAttrs), 'fd:', fd.toString());
        let bufSize = 4096;
        let readSize = 0;
        let buf = new ArrayBuffer(bufSize);
        let readOptions: ReadOptions = {
          offset: readSize,
          length: bufSize
        };
        let readLen = fs.readSync(file.fd, buf, readOptions);
        while (readLen > 0) {
          readSize += readLen;
          let writeOptions: WriteOptions = {
            length: readLen
          };
          fs.writeSync(fd, buf, writeOptions);
          readOptions.offset = readSize;
          readLen = fs.readSync(file.fd, buf, readOptions);
        }

        writeResultCallback(jobId, print.PrintFileCreationState.PRINT_FILE_CREATED);
      },
      onJobStateChanged(): void {
      }
    };
    // 创建打印参数`printAttributes`。
    let printAttributes: print.PrintAttributes = {
      copyNumber: 1,
      pageRange: {
        startPage: 0,
        endPage: 5,
        pages: []
      },
      pageSize: print.PrintPageType.PAGE_ISO_A3,
      directionMode: print.PrintDirectionMode.DIRECTION_MODE_AUTO,
      colorMode: print.PrintColorMode.COLOR_MODE_MONOCHROME,
      duplexMode: print.PrintDuplexMode.DUPLEX_MODE_NONE
    };
    // 调用系统打印接口，并传入以上三个参数。
    print.print(jobName, printAdapter, printAttributes, this.context).then((printTask: print.PrintTask) => {
      printTask.on('succeed', () => {
        console.info('print state is succeed');
      });
    }).catch((err: BusinessError) => {
      console.error('print err ' + JSON.stringify(err));
    });
  }
}