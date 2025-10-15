import { common, wantConstant } from "@kit.AbilityKit";
import promptAction from "@ohos.promptAction";

export interface MailOptionsType {
  to?: Array<string> // 收件人
  cc?: Array<string> // 抄送人
  bcc?: Array<string> // 密送人
  subject?: string // 主题
  body?: string // 正文
  attachments?: Array<string> // 附件
}

/**
 * 调用系统邮箱工具类
 */
export class MailUtils {
  /**
   * 发送邮件
   * @param context UIAbilityContext
   * @param options 可选参数：收件人、抄送人、密送人、主题、正文、附件
   */
  static sendMail(
    context: common.UIAbilityContext,
    options?: MailOptionsType
  ): Promise<Object> {
    return new Promise((resolve, reject) => {
      let to: Array<string> = [];
      let cc: Array<string> = [];
      let bcc: Array<string> = [];
      let subject: string = '';
      let body: string = '';
      let attachments: Array<string> = [];

      if (options) {
        if (options.to) {
          to = options.to;
        }
        if (options.cc) {
          cc = options.cc;
        }
        if (options.bcc) {
          bcc = options.bcc;
        }
        if (options.subject) {
          subject = options.subject;
        }
        if (options.body) {
          body = options.body;
        }
        if (options.attachments) {
          attachments = options.attachments;
        }
      }

      let wantParam: Record<string, Object> = {
        'sceneType': 1,
        'email': to.map((item: string) => encodeURI(item)),
        'cc': cc.map((item: string) => encodeURI(item)),
        'bcc': bcc.map((item: string) => encodeURI(item)),
        'subject': encodeURI(subject),
        'body': encodeURI(body),
        'ability.params.stream': attachments.map((item: string) => encodeURI(item)),
        'ability.want.params.uriPermissionFlag': wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION
      };

      let abilityStartCallback: common.AbilityStartCallback = {
        onError(code: number, name: string, message: string) {
          console.info(`Mail send failed -> code: ${code}, name: ${name}, message: ${message}`);
          promptAction.showToast({message:message ?? '邮件发送失败'})
          reject({ code, name, message })
        },
        onResult(result: Object) {
          console.info(`Mail send result -> ${JSON.stringify(result)}`);
          resolve(result)
        }
      };

      context.startAbilityByType("mail", wantParam, abilityStartCallback,
        (err: Error) => {
          if (err) {
            console.info(`startAbilityByType fail, err: ${JSON.stringify(err)}`);
            promptAction.showToast({message:err?.message ?? '拉起邮件失败'})
            reject(err)
          } else {
            resolve(true)
            console.info(`startAbilityByType success`);
          }
        });
    })
  }
}
