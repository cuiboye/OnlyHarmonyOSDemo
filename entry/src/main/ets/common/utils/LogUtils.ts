import { hilog } from '@kit.PerformanceAnalysisKit'

const DOMAIN: number = 0xFF00
type msgType = string | number | boolean | object


export interface LogUtilsCallerStackFrameAtInfo {
  text?: string
  classFunction?: string
  className?: string
  functionName?: string
  location?: string
  filePath?: string
  fileDirPath?: string
  fileName?: string
  fileTitle?: string
  lineNumber?: number
  columnNumber?: number
}

export interface LogUtilsCallerStackFrameInfo {
  index?: number
  text?: string
  at?: LogUtilsCallerStackFrameAtInfo
}

export interface LogUtilsCallerInfo {
  stackTrace?: string[]
  stackFrame?: LogUtilsCallerStackFrameInfo
}

/**
 * wk Log 工具
 */
export class LogUtils {

  /** 是否启用调用栈信息打印，默认关闭，开发时 可自行按需开启 */
  static IS_CALLER_INFO_ENABLED: boolean = false

  private static readonly VERBOSE = 1
  private static readonly DEBUG = 2
  private static readonly INFO = 3
  private static readonly WARN = 4
  private static readonly ERROR = 5
  public static readonly LEVEL = LogUtils.VERBOSE


  private static domain: number = DOMAIN
  private static format: string = '%{public}s'
  private static tag: string = 'WenkuLog'

  static isEmpty(str: string | undefined): boolean {
    return undefined == str || null == str || "" == str || '' == str;
  }

  /**
   * 打印verbose级别信息
   *
   * @param tag
   * @param msg
   */
  public static v(tag?: string, msg?: string): void {
    // if (!ApplicationConfig.IS_DEBUG) {
    //   return
    // }
    if (LogUtils.isEmpty(msg)) {
      return
    }
    if (LogUtils.LEVEL <= LogUtils.VERBOSE) {
      LogUtils.i(`${LogUtils.getCallerInfoStr(3)}${tag?.length ? (' #'+tag) : ''} ➤ ${msg}`)
    }
  }

  static d(tagsOrMsg?: string[] | msgType, ...args: msgType[]) {
    // if (!ApplicationConfig.IS_DEBUG) {
    //   return
    // }
    let tags: string[] = []
    if (Array.isArray(tagsOrMsg)) {
      tags = tagsOrMsg
    } else {
      args = [tagsOrMsg as msgType, ...args]
    }

    if (!LogUtils.changeFormat(args)) {
      return
    }
    if (LogUtils.LEVEL <= LogUtils.DEBUG) {
      hilog.debug(LogUtils.domain, LogUtils.tag, `${LogUtils.getCallerInfoStr(3)}${tags.length ? (' #'+tags.join(' #')) : ''} ➤ ${LogUtils.format}`, args)
    }

  }

  static dJson(tag: string, obj: object) {
    if (LogUtils.LEVEL <= LogUtils.DEBUG) {
      LogUtils.d(tag, JSON.stringify(obj))
    }
  }

  static i(tagsOrMsg?: string[] | msgType, ...args: msgType[]) {
    // if (!ApplicationConfig.IS_DEBUG) {
    //   return
    // }
    let tags: string[] = []
    if (Array.isArray(tagsOrMsg)) {
      tags = tagsOrMsg
    } else {
      args = [tagsOrMsg as msgType, ...args]
    }

    if (!LogUtils.changeFormat(args)) {
      return
    }
    if (LogUtils.LEVEL <= LogUtils.INFO) {
      hilog.info(LogUtils.domain, LogUtils.tag, `${LogUtils.getCallerInfoStr(3)}${tags.length ? (' #'+tags.join(' #')) : ''} ➤ ${LogUtils.format}`, args)
    }

  }

  static w(tagsOrMsg?: string[] | msgType, ...args: msgType[]) {
    // if (!ApplicationConfig.IS_DEBUG) {
    //   return
    // }
    let tags: string[] = []
    if (Array.isArray(tagsOrMsg)) {
      tags = tagsOrMsg
    } else {
      args = [tagsOrMsg as msgType, ...args]
    }

    if (!LogUtils.changeFormat(args)) {
      return
    }
    if (LogUtils.LEVEL <= LogUtils.WARN) {
      hilog.warn(LogUtils.domain, LogUtils.tag, `${LogUtils.getCallerInfoStr(3)}${tags.length ? (' #'+tags.join(' #')) : ''} ➤ ${LogUtils.format}`, args)
    }

  }

  static e(tagsOrMsg?: string[] | msgType, ...args: msgType[]) {
    // if (!ApplicationConfig.IS_DEBUG) {
    //   return
    // }
    let tags: string[] = []
    if (Array.isArray(tagsOrMsg)) {
      tags = tagsOrMsg
    } else {
      args = [tagsOrMsg as msgType, ...args]
    }

    if (!LogUtils.changeFormat(args)) {
      return
    }
    if (LogUtils.LEVEL <= LogUtils.ERROR) {
      hilog.error(LogUtils.domain, LogUtils.tag, `${LogUtils.getCallerInfoStr(3)}${tags.length ? (' #'+tags.join(' #')) : ''} ➤ ${LogUtils.format}`, args)
    }

  }

  /**
   * 根据传参修改 format
   * @param args
   * @returns
   */
  private static changeFormat(args: msgType[]): boolean {
    if (!args?.length) { // 未传参数
      args = ['[No Parameter]']
      hilog.warn(LogUtils.domain, LogUtils.tag, LogUtils.format, args)
      return false
    }

    const separator: string = ','
    const tmpArr: msgType[] = []

    args.forEach(item => {
      const type = typeof item
      switch (type) {
        case 'string':
        case 'number':
          tmpArr.push(item)
          break
        case 'boolean':
          tmpArr.push(item === false ? 'false' : 'true')
          break
        case 'object':
          tmpArr.push(`[${(item as object).constructor.name} Class]`)
          break
        default:
          tmpArr.push('[Unknown]')
          break
      }
    })
    LogUtils.format = tmpArr.join(separator)
    return true
  }

  private static getCallerInfoStr(stackFrameIndex?: number): string {
    let callerInfoStr: string = ''
    if (LogUtils.IS_CALLER_INFO_ENABLED) {
      let callerInfo = LogUtils.getCallerInfo(stackFrameIndex)
      callerInfoStr = `[at (${callerInfo.stackFrame?.at?.location}) - ${callerInfo.stackFrame?.at?.classFunction}]`
    }
    return callerInfoStr
  }

  public static getCallerInfo(stackFrameIndex?: number): LogUtilsCallerInfo {
    let error = new Error()
    let callerInfo: LogUtilsCallerInfo = {}
    callerInfo.stackTrace = error.stack?.trim()?.split("\n")
    callerInfo.stackFrame = {}
    callerInfo.stackFrame.index = stackFrameIndex ?? 1
    callerInfo.stackFrame.text = callerInfo.stackTrace?.[callerInfo.stackFrame.index]

    if (callerInfo.stackFrame.text?.length) {
      callerInfo.stackFrame.at = {}
      callerInfo.stackFrame.at.text = callerInfo.stackFrame.text.trim()

      let atComponents = callerInfo.stackFrame.at.text.split(" ")
      callerInfo.stackFrame.at.classFunction = atComponents[1]

      let atClassFunctionComponents = callerInfo.stackFrame.at.classFunction.split(".")
      callerInfo.stackFrame.at.className = atClassFunctionComponents.length > 1 ? atClassFunctionComponents[0] : undefined
      callerInfo.stackFrame.at.functionName = atClassFunctionComponents.length > 1 ? atClassFunctionComponents[1] : callerInfo.stackFrame.at.classFunction

      callerInfo.stackFrame.at.location = atComponents[2].substring(1, atComponents[2].length - 1)

      let atLocationComponents = callerInfo.stackFrame.at.location.split(":")
      callerInfo.stackFrame.at.filePath = atLocationComponents[0]
      callerInfo.stackFrame.at.fileDirPath = callerInfo.stackFrame.at.filePath.substring(0, callerInfo.stackFrame.at.filePath.lastIndexOf("/"))
      callerInfo.stackFrame.at.fileName = callerInfo.stackFrame.at.filePath.substring(callerInfo.stackFrame.at.filePath.lastIndexOf("/") + 1)
      callerInfo.stackFrame.at.fileTitle = callerInfo.stackFrame.at.fileName.substring(0, callerInfo.stackFrame.at.fileName.lastIndexOf("."))
      callerInfo.stackFrame.at.lineNumber = Number(atLocationComponents[1])
      callerInfo.stackFrame.at.columnNumber = Number(atLocationComponents[2])
    }

    return callerInfo
  }

  static isDebuggable() {
    return LogUtils.LEVEL <= LogUtils.DEBUG
  }
}
