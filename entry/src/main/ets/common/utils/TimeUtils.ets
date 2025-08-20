import { DateUtils } from './DateUtils';

/***
 * 日期和时间工具类
 */
export class TimeUtils {
  static readonly TAG = "TimeUtils";
  static readonly SECONDS_IN_DAY: number = 60 * 60 * 24;
  static readonly MILLIS_IN_DAY = TimeUtils.SECONDS_IN_DAY * 1000
  static readonly DRAINAGE_COUNT = 3;
  static readonly ONE_MINUTE = 60;
  static readonly ONE_HOUR = 60 * TimeUtils.ONE_MINUTE;
  static readonly ONE_DAY = TimeUtils.ONE_HOUR * 24;

  /**
   * 判断是否是同一天
   * date1和date2为时间戳
   */
  static isSameDayOfMillis(date1: number | string | Date, date2: number | string | Date) {
    date1 = DateUtils.getFormatDate(date1);
    date2 = DateUtils.getFormatDate(date2);
    let blSameYear = date1.getFullYear() === date2.getFullYear();
    let blSameMonth = date1.getMonth() === date2.getMonth();
    let blSameDay = date1.getDate() === date2.getDate();
    return blSameYear && blSameMonth && blSameDay;
  }

  /**
   * 时间戳转时间字符串
   */
  public static timeStampToString(timeStamp: string): string {
    let result: string = ''
    if (timeStamp.length == 13) {
      result = DateUtils.getFormatDateStr(timeStamp, "yyyy/MM/dd")
    } else if (timeStamp.length == 10) {
      result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "yyyy/MM/dd");
    }
    return result;
  }

  /**
   * 获取时间的格式化字符串
   */
  public static getTimeFormat(stamp: number): string {
    let data = DateUtils.getFormatDate(stamp).toDateString()
    let result: string = ''
    if (data.length == 13) {
      result = DateUtils.getFormatDateStr(data, "yyyy/MM/dd")
    } else if (data.length == 10) {
      result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(data) * 1000), "yyyy/MM/dd");
    }
    return result;
  }

  /**
   * 时间戳转时间字符串
   */
  public static getTimeShort(timeStamp: string): string {
    let result: string = ''
    if (timeStamp.length == 13) {
      result = DateUtils.getFormatDateStr(timeStamp, "HH:mm")
    } else if (timeStamp.length == 10) {
      result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "yyyy/MM/dd");
    }
    return result;
  }

  /**
   * 时间戳转时间字符串
   */
  static getTimeDay(timeStamp: string): string {
    let result: string = ''
    if (timeStamp.length == 13) {
      result = DateUtils.getFormatDateStr(timeStamp, "yyyy-MM-dd")
    } else if (timeStamp.length == 10) {
      result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "yyyy-MM-dd");
    }
    return result;
  }

  /**
   * 时间戳转时间字符串
   */
  public static getTimeDayWithDot(timeStamp: string): string {
    let result: string = ''
    if (timeStamp.length == 13) {
      result = DateUtils.getFormatDateStr(timeStamp, "yyyy.MM.dd")
    } else if (timeStamp.length == 10) {
      result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "yyyy-MM-dd");
    }
    return result;
  }

  /**
   * 时间戳转时间字符串
   */
  public static getFormatDataForIndexDataLib(timeStamp: string): string {
    let result = "";
    try {
      if (timeStamp.length == 10) {
        timeStamp = (Number.parseFloat(timeStamp) * 1000).toString();
      }
      if (Date.now() - Number.parseFloat(timeStamp) < 60 * 1000) {
        return "刚刚";
      }
      if (timeStamp.length == 13) {
        result = DateUtils.getFormatDateStr(timeStamp, "MM.dd HH:mm")
      } else if (timeStamp.length == 10) {
        result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "MM.dd HH:mm");
      }
      return result;

    } catch (e) {
      ;
    }
    return result;
  }


  /**
   * 首页资料库卡片时间格式转换
   */
  public static getFormatDataForIndexDataLibNew(timeStamp: string): string {
    let result = "";
    try {
      let time = 0;
      if (timeStamp.length == 13) {
        time = Number.parseInt(timeStamp);
      } else if (timeStamp.length == 10) {
        time = Number.parseInt(timeStamp) * 1000;

      }
      let now = Date.now();
      let ago = (now - time) / 1000;
      if (ago > TimeUtils.ONE_DAY * 2) {
        // 48小时以上：xx.xx xx:xx
        if (timeStamp.length == 13) {
          result = DateUtils.getFormatDateStr(timeStamp, "MM.dd HH:mm")
        } else if (timeStamp.length == 10) {
          result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "MM.dd HH:mm");
        }

      } else if (ago >= TimeUtils.ONE_DAY) {
        // 24-48小时：昨天 xx:xx
        let minute: string = '';
        if (timeStamp.length == 13) {
          minute = DateUtils.getFormatDateStr(timeStamp, "HH:mm")
        } else if (timeStamp.length == 10) {
          minute = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "HH:mm");
        }
        result = "昨天 " + minute;
      } else if (ago >= TimeUtils.ONE_HOUR) {
        // 1-24小时
        result = Math.ceil(ago / TimeUtils.ONE_HOUR) + "小时前";
      } else if (ago >= 50 * TimeUtils.ONE_MINUTE) {
        // 50-60分钟
        result = "50分钟前";

      } else if (ago >= 40 * TimeUtils.ONE_MINUTE) {
        // 40-50分钟
        result = "40分钟前";

      } else if (ago >= 30 * TimeUtils.ONE_MINUTE) {
        // 30-40分钟
        result = "30分钟前";

      } else if (ago >= 20 * TimeUtils.ONE_MINUTE) {
        // 20-30分钟
        result = "20分钟前";

      } else if (ago >= 10 * TimeUtils.ONE_MINUTE) {
        // 10-20分钟
        result = "10分钟前";

      } else if (ago >= TimeUtils.ONE_MINUTE) {
        // 1-10分钟
        result = Math.ceil(ago / TimeUtils.ONE_MINUTE) + "分钟前";
      } else {
        // 小于一分钟
        result = "刚刚";
      }
    } catch (e) {
      ;
    }
    return result;
  }

  /**
   * 格式化后时间
   */
  public static getFormatDataForIndexDataLib9000(timeStamp: string): string {
    let result = "";
    try {
      let time = 0;
      if (timeStamp.length == 13) {
        time = Number.parseInt(timeStamp);
      } else if (timeStamp.length == 10) {
        time = Number.parseInt(timeStamp) * 1000;

      }
      let now = Date.now();
      let ago = (now - time) / 1000;
      if (ago > TimeUtils.ONE_DAY * 2) {
        // 48小时以上：x天前
        let day = Math.ceil(ago / TimeUtils.ONE_DAY);
        result = (day > 30 ? 30 : day) + "天前";
      } else if (ago >= TimeUtils.ONE_DAY) {
        // 24-48小时：昨天
        result = "昨天";
      } else if (ago >= TimeUtils.ONE_HOUR) {
        // 1-24小时
        result = Math.ceil(ago / TimeUtils.ONE_HOUR) + "小时前";
      } else if (ago >= 50 * TimeUtils.ONE_MINUTE) {
        // 50-60分钟
        result = "50分钟前";

      } else if (ago >= 40 * TimeUtils.ONE_MINUTE) {
        // 40-50分钟
        result = "40分钟前";

      } else if (ago >= 30 * TimeUtils.ONE_MINUTE) {
        // 30-40分钟
        result = "30分钟前";

      } else if (ago >= 20 * TimeUtils.ONE_MINUTE) {
        // 20-30分钟
        result = "20分钟前";

      } else if (ago >= 10 * TimeUtils.ONE_MINUTE) {
        // 10-20分钟
        result = "10分钟前";

      } else if (ago >= TimeUtils.ONE_MINUTE) {
        // 1-10分钟
        result = Math.ceil(ago / TimeUtils.ONE_MINUTE) + "分钟前";
      } else {
        // 小于一分钟
        result = "刚刚";
      }
    } catch (e) {
      ;
    }

    return result;
  }

  /**
   * 个人中心资料库卡片时间转换
   */
  public static getFormatDataForUserCenterDataLib(timeStamp: string): string {
    let result:string = "";
    try {
      let time:number = 0;
      let length:number = timeStamp.length
      if (length == 13) {
        time = Number.parseInt(timeStamp);
      } else if (length == 10) {
        time = Number.parseInt(timeStamp) * 1000;
      }
      let now = Date.now();
      let ago = (now - time) / 1000;
      if (ago < TimeUtils.ONE_MINUTE) {
        result = "1分钟前";
      } else {
        result = TimeUtils.getFormatDataForIndexDataLibNew(timeStamp);
      }
    } catch (e) {
      ;
    }
    return result;
  }

  /**
   * 时间戳转时间字符串
   */
  public static getTimeDayAndTime(timeStamp: string): string {
    let result: string = ''
    if (timeStamp.length == 13) {
      result = DateUtils.getFormatDateStr(timeStamp, "yyyy年MM月dd日 HH:mm")
    } else if (timeStamp.length == 10) {
      result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "yyyy年MM月dd日 HH:mm");
    }
    return result;
  }

  /**
   * 时间戳转时间字符串
   */
  public static getTimeDayAndTime2(timeStamp: string): string {
    let result = "";
    if (!TimeUtils.isEmpty(timeStamp)) {
      if (timeStamp.length == 13) {
        result = DateUtils.getFormatDateStr(timeStamp, "yyyy.MM.dd HH:mm")
      } else if (timeStamp.length == 10) {
        result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "yyyy.MM.dd HH:mm");
      }
    }
    return result;
  }

  static isEmpty(str: string | undefined): boolean {
    return undefined == str || null == str || "" == str || '' == str;
  }

  /**
   * 时间戳转时间字符串
   */
  public static getTimeDayAndTime3(timeStamp: string): string {
    let result = "";

    if (!TimeUtils.isEmpty(timeStamp)) {
      if (timeStamp.length == 13) {
        result = DateUtils.getFormatDateStr(timeStamp, "yyyyMMddHHmmss")
      } else if (timeStamp.length == 10) {
        result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "yyyyMMddHHmmss");
      }
    }
    return result;
  }

  /**
   * 时间戳转时间字符串
   */
  public static getSimpleTime(timeStamp: string): string {
    let result = '';

    if (timeStamp.length == 13) {
      result = DateUtils.getFormatDateStr(timeStamp, "HH:mm")
    } else if (timeStamp.length == 10) {
      result = DateUtils.getFormatDateStr(new Date(Number.parseFloat(timeStamp) * 1000), "HH:mm");
    }

    return result;
  }

  /**
   * 单位，秒
   */
  public static getTimeDes(time: number): string {
    let needReturn = "0秒";
    if (time > 0) {
      try {
        let diffTime = Date.now() / 1000 - time;
        let secondTime = 60;
        let mintTime = 3600;
        let hourTime = mintTime * 24;
        let dayTime = hourTime * 30;
        let monthTime = dayTime * 12;
        if (diffTime <= 0) {
          needReturn = "0秒";
        } else if (diffTime <= secondTime) {
          needReturn = diffTime + "秒"; // 向下取整，获取间隔
        } else if (diffTime <= mintTime) {
          needReturn = Math.ceil(diffTime / 60) + "分钟"; // 向下取整，获取间隔
        } else if (diffTime <= hourTime) {
          needReturn = Math.ceil(diffTime / 3600) + "小时"; // 向下取整，获取间隔
        } else if (diffTime <= dayTime) {
          needReturn = Math.ceil(diffTime / hourTime) + "天"; // 向下取整，获取间隔
        } else if (diffTime <= monthTime) {
          needReturn = Math.ceil(diffTime / dayTime) + "月"; // 向下取整，获取间隔
        } else {
          needReturn = Math.ceil(diffTime / monthTime) + "年"; // 向下取整，获取间隔
        }
      } catch (e) {

      }
    }
    return needReturn;
  }

  public static formatSecondsTime(secs: number): string {
    if (secs < 0) {
      return "";
    }
    let hour = secs / 3600; // 小时
    let minute = (secs - hour * 3600) / 60; // 分钟
    let second = secs % 60; // 秒
    if (hour > 0) {
      let str = `${hour}:${minute}:${second}`
      return str;
    } else {
      let str = `${minute}:${second}`;
      return str;
    }
  }

  /**
   * 通过时间戳获取时间轴标签
   * @return 今天\昨天\近一周\更早
   */
  public static convertTimeLineTag(timeStamp: number): string {
    let timeLineTag = "";
    try {
      if (timeStamp < 10000000000) {
        timeStamp *= 1000;
      }

      let old: Date = new Date(timeStamp);
      let now: Date = new Date();
      let oldTime = 0;
      let nowTime = 0;
      if (old != null) {
        oldTime = old.getTime();
      }
      if (now != null) {
        nowTime = now.getTime();
      }
      if (oldTime > 0 && nowTime >= oldTime) {
        let day = (nowTime - oldTime) / (24 * 60 * 60 * 1000);
        if (day < 1) {
          timeLineTag = "今天";
        } else if (day == 1) {
          timeLineTag = "昨天";
        } else if (day < 7) {
          timeLineTag = "近一周";
        } else {
          timeLineTag = "更早";
        }
      }
    } catch (e) {
    }
    return timeLineTag;
  }
}
