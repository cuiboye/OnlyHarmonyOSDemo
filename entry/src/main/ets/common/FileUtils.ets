import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import statvfs from '@ohos.file.statvfs';
import storageStatistics from "@ohos.file.storageStatistics";
import wantConstant from '@ohos.ability.wantConstant';
import fileuri from '@ohos.file.fileuri';
import { BusinessError } from '@kit.BasicServicesKit';
import Want from '@ohos.app.ability.Want';
import fileUri from '@ohos.file.fileuri';
import { filePreview } from '@kit.PreviewKit';
import LocalFileSelectUtils, { FileSelectLocalFileModel } from './utils/LocalFileSelectUtils';
import fileIo from '@ohos.file.fs';

/**
 * 文件相关操作
 */
export default class FileUtils {
  static createFile(context: common.Context) {
    //获取应用文件路径
    let filesDir = context.filesDir;
    //新建并打开文件
    //openSync：使用了openSync不需要使用await关键字来获取，可以直接获取file
    //open:调用
    let file = fs.openSync(filesDir + '/text.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    //写一段内容到文件
    let writeLen = fs.writeSync(file.fd, 'Try to write str')
    console.log('The length str is' + writeLen)

    //从文件读取一段内容
    let buf = new ArrayBuffer(1024);
    let readLen = fs.readSync(file.fd, buf, { offset: 0 })
    console.info("the content of file: " + buf.toString());
    //关闭文件
    fs.closeSync(file);
  }

  /**
   * 复制文件
   */
  copyFile(context: common.Context) {
    // 获取应用文件路径
    let filesDir = context.filesDir;

    // 打开文件
    let srcFile = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE);
    let destFile = fs.openSync(filesDir + '/destFile.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    // 读取源文件内容并写入至目的文件
    let bufSize = 4096;
    let readSize = 0;
    let buf = new ArrayBuffer(bufSize);
    let readLen = fs.readSync(srcFile.fd, buf, { offset: readSize });
    while (readLen > 0) {
      readSize += readLen;
      fs.writeSync(destFile.fd, buf);
      readLen = fs.readSync(srcFile.fd, buf, { offset: readSize });
    }
    // 关闭文件
    fs.closeSync(srcFile);
    fs.closeSync(destFile);
  }

  /**
   * 复制文件
   * @param filePath 源文件所在的路径
   * @param cachePath 移动到的目标文件所在的路径
   */
  static copyFileNew(filePath: string, cachePath: string): string {
    let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY)
    let file2 = fileIo.openSync(cachePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
    fileIo.copyFileSync(file.fd, file2.fd)
    fileIo.closeSync(file);
    fileIo.closeSync(file2);
    return cachePath
  }

  /**
   * 以流的形式读写文件
   */
  async readWriteFileWithStream(context: common.Context) {
    // 获取应用文件路径
    let filesDir = context.filesDir;

    // 打开文件流
    let inputStream = fs.createStreamSync(filesDir + '/test.txt', 'r+');
    let outputStream = fs.createStreamSync(filesDir + '/destFile.txt', "w+");
    // 以流的形式读取源文件内容并写入目的文件
    let bufSize = 4096;
    let readSize = 0;
    let buf = new ArrayBuffer(bufSize);
    let readLen = await inputStream.read(buf, { offset: readSize });
    readSize += readLen;
    while (readLen > 0) {
      await outputStream.write(buf);
      readLen = await inputStream.read(buf, { offset: readSize });
      readSize += readLen;
    }
    // 关闭文件流
    inputStream.closeSync();
    outputStream.closeSync();
  }

  /**
   * 查看文件列表
   */
  static queryFileList(context: common.Context) {
    // 获取应用文件路径
    let filesDir = context.filesDir;

    // 查看文件列表
    let options: OptionsData = {
      recursion: false,
      listNum: 0,
      filter: {
        suffix: ['.png', '.jpg', '.txt'], // 匹配文件后缀名为'.png','.jpg','.txt'
        // displayName: ['test*'],                    // 匹配文件全名以'test'开头
        fileSizeOver: 0, // 匹配文件大小大于等于0
        lastModifiedAfter: new Date(0).getTime(), // 匹配文件最近修改时间在1970年1月1日之后
      },
    }
    let files = fs.listFileSync(filesDir, options);
    for (let i = 0; i < files.length; i++) {
      console.info(`The name of file: ${files[i]}`);
    }
  }

  /**
   * 获取指定文件系统数据剩余空间大小，单位是Byte
   */
  static getFreeSize() {
    statvfs.getFreeSize('/data', (error, number) => {
      if (error) {
        console.error(`Invoke getFreeSize failed, code is ${error.code}, message is ${error.message}`);
      } else {
        console.info(`Invoke getFreeSize succeeded, size is ${number}`);
      }
    })
  }

  /**
   * 获取指定文件系统的总空间大小,，单位是Byte
   */
  static getTotalSize() {
    statvfs.getTotalSize('/data', (error, number) => {
      if (error) {
        console.error(`Invoke getFreeSize failed, code is ${error.code}, message is ${error.message}`);
      } else {
        console.info(`Invoke getFreeSize succeeded, size is ${number}`);
      }
    })
  }

  /**
   * 获取当前应用的存储空间大小,，单位是Byte
   */
  static getTotalAppSize() {
    storageStatistics.getCurrentBundleStats((err, bundleStats) => {
      if (err) {
        console.error(`Invoke getCurrentBundleStats failed, code is ${err.code}, message is ${err.message}`);
      } else {
        //应用安装文件大小（单位为Byte）
        //应用安装文件保存在以下目录：/data/storage/el1/bundle
        console.info(`Invoke getCurrentBundleStats succeeded, appsize is ${bundleStats.appSize}`);
        //应用缓存文件大小（单位为Byte）
        //应用的缓存文件保存在以下目录：
        // /data/storage/el1/base/cache
        // /data/storage/el1/base/haps/entry/cache
        // /data/storage/el2/base/cache
        // /data/storage/el2/base/haps/entry/cache
        console.info(`Invoke getCurrentBundleStats succeeded, cachesize is ${bundleStats.cacheSize}`);
        //应用文件存储大小（除应用安装文件和缓存文件）（单位为Byte）
        // 应用文件由本地文件、分布式文件以及数据库文件组成。
        // 本地文件保存在以下目录（注意缓存文件目录为以下目录的子目录）：
        // /data/storage/el1/base
        // /data/storage/el2/base
        // 分布式文件保存在以下目录：
        // /data/storage/el2/distributedfiles
        // 数据库文件保存在以下目录：
        // /data/storage/el1/database
        // /data/storage/el2/database
        console.info(`Invoke getCurrentBundleStats succeeded, dataSize is ${bundleStats.dataSize}`);
      }
    });
  }

  /**
   * 分享文件
   */
  static shareFile(context: common.UIAbilityContext) {
    // 获取文件的沙箱路径
    let pathInSandbox = context.filesDir + "/test.txt";
    // 将沙箱路径转换为uri
    let uri = fileuri.getUriFromPath(pathInSandbox);
    // 获取的uri为"file://com.example.demo/data/storage/el2/base/files/test.txt"

    let want: Want = {
      // 配置被分享文件的读写权限，例如对被分享应用进行读写授权
      flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      // 配置分享应用的隐式拉起规则
      action: 'ohos.want.action.sendData',
      uri: uri,
      type: 'text/plain'
    }
    context.startAbility(want)
      .then(() => {
        console.info('Invoke getCurrentBundleStats succeeded.');
      })
      .catch((err: BusinessError) => {
        console.error(`Invoke startAbility failed, code is ${err.code}, message is ${err.message}`);
      });
  }

  /**
   * 通过URI或路径，获取FileUri
   * @param uriOrPath URI或路径
   */
  static getFileUri(uriOrPath: string): fileUri.FileUri {
    return new fileUri.FileUri(uriOrPath);
  }

  /**
   * 通过URI或路径，获取文件名。
   * @param uriOrPath URI或路径
   */
  static getFileName(uriOrPath: string): string {
    return FileUtils.getFileUri(uriOrPath).name;
  }

  /**
   * 通过URI或路径，获取文件路径
   * @param uriOrPath URI或路径
   */
  static getFilePath(uriOrPath: string): string {
    return FileUtils.getFileUri(uriOrPath).path;
  }

  /**
   * 根据文件名获取文件后缀
   * @param fileName 例如: test.txt  test.doc
   */
  static getFileExtention(fileName: string) {
    if (fileName != undefined && fileName != null && fileName.length != 0 && fileName.includes(".")) {
      return fileName.substring(fileName.lastIndexOf(".") + 1);
    }
    return '';
  }

  /**
   * 文件预览
   * fileName：文件名称
   * uri：文件路径
   * mimeType：文件类型
   */
  static filePreview(context: common.UIAbilityContext,fileName: string, uri: string, mimeType: string) {
    let fileInfo: filePreview.PreviewInfo = {
      title: fileName,
      uri: uri,
      mimeType: mimeType, // 文件(夹)的媒体资源类型，如text/plain
    };
    filePreview.openPreview(context, fileInfo).then(() => {
      console.info('openPreview success');
    }).catch((err: BusinessError) => {
      console.error('openPreview failed, err = ' + err.message);
    });
  }

  static getMimeType(filePath: string): string {
    let mimeType = filePath.split('.').pop()
    if (mimeType?.includes('pdf')) {
      mimeType = 'application/pdf'
    } else if (mimeType?.includes('doc')) {
      mimeType = 'application/msword'
    } else if (mimeType?.includes('docx')) {
      mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    } else if (mimeType?.includes('txt')) {
      mimeType = 'text/plain'
    } else if (mimeType?.includes('ppt')) {
      mimeType = 'application/vnd.ms-powerpoint'
    } else if (mimeType?.includes('xls')) {
      mimeType = 'application/vnd.ms-excel'
    } else if (mimeType?.includes('xlsx')) {
      mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    }
    return mimeType ?? ''
  }

  static async selectFile(context: common.UIAbilityContext): Promise<Array<FileSelectLocalFileModel>> {
    const selectedFileList: Array<FileSelectLocalFileModel> = await LocalFileSelectUtils.openLocalFileSelectPageForFrag(context, 1, false, undefined)
    return selectedFileList
  }

  /**
   * 格式化文件大小
   */
  static getFormatFileSize(fileSize: number): string {
    if (fileSize < 1024) {
      return fileSize + "B";
    } else if (fileSize < 1024 * 1024) {
      return (fileSize / 1024).toFixed(1) + "KB";
    } else if (fileSize < 1024 * 1024 * 1024) {
      return (fileSize / (1024 * 1024)).toFixed(1) + "MB";
    } else if (fileSize < 1024 * 1024 * 1024 * 1024) {
      return (fileSize / (1024 * 1024 * 1024)).toFixed(1) + "GB";
    } else {
      return (fileSize / (1024 * 1024 * 1024 * 1024)).toFixed(1) + "TB";
    }
  }
}

class OptionsData {
  recursion?: boolean
  listNum?: number
  filter?: Filter
}

class Filter {
  suffix?: string[] // 匹配文件后缀名为'.png','.jpg','.txt'
  // displayName: ['test*'],                    // 匹配文件全名以'test'开头
  fileSizeOver?: number // 匹配文件大小大于等于0
  lastModifiedAfter?: number
}
