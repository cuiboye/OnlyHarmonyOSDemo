import { HMRouter } from '@hadss/hmrouter';
import { AppUtils } from '../common/AppUtils';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { common, wantConstant } from '@kit.AbilityKit';
import FileUtils from '../common/FileUtils';
import axios from '@ohos/axios';
import { CommonHeader } from '../common/common_header';
import { MailUtils } from '../common/utils/MailUtils';

/**
 * 使用邮箱发送文件
 */
@HMRouter({ pageUrl: NavigationConstants.SENDFILEWITHEMAIL_PAGE })
@Component
export struct SendFileWithEmailPage {
  context = getContext(this) as common.UIAbilityContext

  build() {
    Column() {
      CommonHeader({title:'使用邮箱发送文件'})
      Button('发送邮件')
        .onClick(()=>{
          this.downloadFile("http://wkbjcloudbos.bdimg.com/v1/wenku109//bwmark/bdea8523a3c18d8f32257e0124cdd060?responseContentDisposition=attachment%3B%20filename%3D%22%25E7%25BA%25A2%25E5%25A4%25B4%25E6%2596%2587%25E4%25BB%25B6%25E6%25A8%25A1%25E6%259D%25BFWord%25E6%25A8%25A1%25E6%259D%25BF.doc%22%3B%20filename%2A%3Dutf-8%27%27%25E7%25BA%25A2%25E5%25A4%25B4%25E6%2596%2587%25E4%25BB%25B6%25E6%25A8%25A1%25E6%259D%25BFWord%25E6%25A8%25A1%25E6%259D%25BF.doc&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2025-09-26T08%3A23%3A15Z%2F3600%2Fhost%2Fc71bd57f0dcef84a445b1885ca7cfadee582a198bb20c1e854125d3912e4f1e3&token=eyJ0eXAiOiJKSVQiLCJ2ZXIiOiIxLjAiLCJhbGciOiJIUzI1NiIsImV4cCI6MTc1ODg3ODU5NSwidXJpIjp0cnVlLCJwYXJhbXMiOlsicmVzcG9uc2VDb250ZW50RGlzcG9zaXRpb24iLCJyZXNwb25zZUNvbnRlbnRUeXBlIiwicmVzcG9uc2VDYWNoZUNvbnRyb2wiXX0%3D.eD7f3Cbrd%2FxVnzvgIM7H6PSLsqlH1IC6csblnqy74d4%3D.1758878595")
        })
    }.height('100%')
  }

  private async downloadFile(url: string): Promise<boolean> {
    // 1. 创建路径
    let applicationContext = this.context.getApplicationContext();
    const targetPath = `${applicationContext.filesDir}/app/test.doc`;
    try {
      await FileUtils.directoryExists(targetPath);
      // 2. 开始下载文件
      await axios({
        url,
        method: 'GET',
        filePath: targetPath,
        responseType: 'ARRAY_BUFFER',
        onDownloadProgress: (progressEvent) => {

        }
      });
      // 判断文件大小是否大于0
      const fileSize = FileUtils.getFileSize(targetPath);
      if (fileSize <= 0) {
        throw new Error('下载的文件大小为0');
      }

      //可以使用这个发送
      // this.sendEmil(targetPath,"我是主题","我是内容")

      //也可以使用这个发送
      let attachments = new Array<string>()
      attachments.push('file://' + AppUtils.getContext().applicationInfo.name+targetPath)
      MailUtils.sendMail(this.context,{attachments:attachments,})
      return true;
    } catch (error) {
      console.error('下载失败:', error);
      // 错误后需要清理错误文件，因为axios指定下载路径后就会创建这个文件然后往里写内容，就算没写文件也给自动创建了，所以失败需要清理掉。
      FileUtils.cleanFile(targetPath);
      return false;
    }
  }

  sendEmil(filePath: string, subject?: string, body?: string) {
    const uri = 'file://' + AppUtils.getContext().applicationInfo.name + filePath
    let wantParam: Record<string, Object> = {
      'sceneType': 1,
      // 收件人邮箱地址，多值以逗号分隔，对数组内容使用encodeURI()方法进行url编码
      'email': [encodeURI('')],
      // 邮件主题，对内容使用encodeURI()方法进行url编码
      'subject': encodeURI(subject ?? ''),
      // 邮件正文，对内容使用encodeURI()方法进行url编码
      'body': encodeURI(body ?? ''),
      // 附件uri，多值以逗号分隔，对数组内容使用encodeURI()方法进行url编码
      'ability.params.stream': [encodeURI(uri)],
      'ability.want.params.uriPermissionFlag': wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION
    };
    let abilityStartCallback: common.AbilityStartCallback = {
      onError: (code: number, name: string, message: string) => {
        //
      },
      onResult: (result) => {
        //
      }
    }
    AppUtils.getContext().startAbilityByType("mail", wantParam, abilityStartCallback)
  }
}