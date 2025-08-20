import { i18n, intl } from '@kit.LocalizationKit';

/**
 * 日期工具类
 */
export class DateUtils {

  /**
   * 获取格式化日期，将传入的日期格式化为Date
   */
  static getFormatDate(date?: number | string | Date): Date {
    if (date == undefined || date == null) {
      date = new Date();
    } else if (typeof date == "string") {
      if (date.length == 0) {
        date = new Date();
      } else {
        if (date.toString().length == 10 || date.toString().length == 13) {
          date = DateUtils.toNumber(date);
          if (typeof date == 'number') {
            date = new Date(date);
            return date;
          }
        }
        let dateStr = date.replaceAll("-", '/')
          .replace("年", '/')
          .replace("月", '/')
          .replace("日", ' ')
          .replace("  ", ' ')
          .replace("时", ':')
          .replace("分", ':')
          .replace("秒", '')
        date = new Date(dateStr);
      }
    } else if (typeof (date) == "number") {
      date = new Date(date);
    } else {
      date = new Date(date);
    }
    return date;
  }


  /**
   * 时间戳转时间字符串
   * @return yyyy年MM月dd
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
   * 获取格式化日期，将传入的日期格式化为指定格式的字符串
   */
  static getFormatDateStr(date: number | string | Date, format?: string): string {
    date = DateUtils.getFormatDate(date)
    if (format === undefined || format == '') {
      format = "yyyy-MM-dd HH:mm:ss";
    }
    const year = date.getFullYear();
    const month = DateUtils.padZero(date.getMonth() + 1);
    const day = DateUtils.padZero(date.getDate());
    const hours = DateUtils.padZero(date.getHours());
    const minutes = DateUtils.padZero(date.getMinutes());
    const seconds = DateUtils.padZero(date.getSeconds());
    let formattedDate = format.replace("yyyy", year.toString());
    formattedDate = formattedDate.replace("MM", month);
    formattedDate = formattedDate.replace("dd", day);
    formattedDate = formattedDate.replace("HH", hours);
    formattedDate = formattedDate.replace("mm", minutes);
    formattedDate = formattedDate.replace("ss", seconds);
    return formattedDate;
  }


  /**
   * 获取今天的日期
   * @returns
   */
  static getToday(): Date {
    return new Date();
  }

  /**
   * 获取今天的时间戳
   * @returns
   */
  static getTodayTime(): number {
    return new Date().getTime();
  }

  /**
   * 获取今天的时间，字符串类型
   * @param format 格式化字符串,(yyyy-MM-dd HH:mm:ss)
   * @returns
   */
  static getTodayStr(format?: string): string {
    return DateUtils.getFormatDateStr(new Date(), format)
  }

  /**
   * 判断日期是否是今天
   */
  static isToday(date: number | string | Date) {
    let today = DateUtils.getTodayStr("yyyy-MM-dd");
    let day = DateUtils.getFormatDateStr(date, "yyyy-MM-dd")
    return today === day;
  }


  /**
   * 获取当前年
   */
  static getNowYear(): number {
    let date = new Date();
    return date.getFullYear();
  }

  /**
   * 获取当前月
   */
  static getNowMonth(): number {
    let date = new Date();
    return date.getMonth() + 1;
  }

  /**
   * 获取当前日
   */
  static getNowDay(): number {
    let date = new Date();
    return date.getDate();
  }


  /**
   * 判断是否是闰年
   */
  static isLeapYear(year: number | Date = new Date()): boolean {
    year = year instanceof Date ? year.getFullYear() : year;
    return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
  }

  /**
   * 获取指定年份的天数
   */
  static getDaysByYear(year: number): number {
    if (DateUtils.isLeapYear(year)) {
      return 366;
    } else {
      return 365;
    }
  }

  /**
   * 获取指定月份的天数
   */
  static getDaysByMonth(year: number, month: number): number {
    if (month == 2) {
      if (DateUtils.isLeapYear(year)) {
        return 29;
      } else {
        return 28;
      }
    } else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
      return 31;
    } else {
      return 30;
    }
  }


  /**
   * 判断两个日期是否是同一年
   */
  static isSameYear(date1: number | string | Date, date2: number | string | Date) {
    date1 = DateUtils.getFormatDate(date1);
    date2 = DateUtils.getFormatDate(date2);
    let blSameYear = date1.getFullYear() === date2.getFullYear();
    return blSameYear;
  }

  /**
   * 判断两个日期是否是同一月
   */
  static isSameMonth(date1: number | string | Date, date2: number | string | Date) {
    date1 = DateUtils.getFormatDate(date1);
    date2 = DateUtils.getFormatDate(date2);
    let blSameYear = date1.getFullYear() === date2.getFullYear();
    let blSameMonth = date1.getMonth() === date2.getMonth();
    return blSameYear && blSameMonth;
  }

  /**
   * 判断两个日期是否是同一周
   */
  static isSameWeek(date1: number | string | Date, date2: number | string | Date) {
    let oneDayTime = 1000 * 60 * 60 * 24;
    let dayCount1 = DateUtils.getFormatDate(date1).getTime() / oneDayTime;
    let dayCount2 = DateUtils.getFormatDate(date2).getTime() / oneDayTime;
    let i1 = DateUtils.toInt(((dayCount1 + 4) / 7).toString())
    let i2 = DateUtils.toInt(((dayCount2 + 4) / 7).toString())
    return i1 === i2;
  }

  /**
   * 将字符串转换为整数。
   */
  static toInt(value: string, defaultValue: number = 0): number {
    try {
      const parsedValue = parseInt(value);
      if (isNaN(parsedValue)) {
        return defaultValue;
      }
      return parsedValue;
    } catch (e) {
      return defaultValue
    }
  }

  /**
   * 判断是否是同一天
   */
  static isSameDay(date1: number | string | Date, date2: number | string | Date) {
    date1 = DateUtils.getFormatDate(date1);
    date2 = DateUtils.getFormatDate(date2);
    let blSameYear = date1.getFullYear() === date2.getFullYear();
    let blSameMonth = date1.getMonth() === date2.getMonth();
    let blSameDay = date1.getDate() === date2.getDate();
    return blSameYear && blSameMonth && blSameDay;
  }


  /**
   * 获取日历对象,并设置日历对象内部的时间日期
   */
  static getCalendar(date?: number | string | Date, type: string = "gregory",
    locale: string = "zh-Hans"): i18n.Calendar {
    date = DateUtils.getFormatDate(date);
    let calendar: i18n.Calendar = i18n.getCalendar(locale, type);
    calendar.setTime(date);
    return calendar;
  }


  /**
   * 获取日历对象中与field相关联的值。
   */
  static getCalendarField(field: string, date?: number | string | Date, type: string = "gregory",
    locale: string = "zh-Hans"): number {
    date = DateUtils.getFormatDate(date);
    let calendar: i18n.Calendar = i18n.getCalendar(locale, type);
    calendar.setTime(date);
    return calendar.get(field);
  }

  /**
   * 在日历的给定字段进行加减操作。
   */
  static getCalendarAdd(date: number | string | Date, field: string, amount: number, type: string = "gregory",
    locale: string = "zh-Hans"): Date {
    date = DateUtils.getFormatDate(date);
    let calendar: i18n.Calendar = i18n.getCalendar(locale, type);
    calendar.setTime(date);
    calendar.add(field, amount);
    return new Date(calendar.getTimeInMillis());
  }

  /**
   * 判断指定的日期在日历中是否为周末
   */
  static isWeekend(date?: number | string | Date) {
    date = DateUtils.getFormatDate(date);
    let calendar: i18n.Calendar = i18n.getCalendar("zh-Hans");
    calendar.setTime(date);
    return calendar.isWeekend(date);
  }


  /**
   * 比较日历和指定日期相差的天数
   */
  static compareDays(date1: number | string | Date, date2: number | string | Date): number {
    date1 = DateUtils.getFormatDate(date1);
    date2 = DateUtils.getFormatDate(date2);
    let calendar: i18n.Calendar = i18n.getCalendar("zh-Hans");
    calendar.setTime(date1);
    return calendar.compareDays(date2);
  }

  /**
   * 比较指定日期相差的毫秒数
   */
  static compareDate(date1: number | string | Date, date2: number | string | Date, floor: boolean = false): number {
    let dateTime1: number = DateUtils.getFormatDate(date1).getTime();
    let dateTime2: number = DateUtils.getFormatDate(date2).getTime();
    let diff = dateTime2 - dateTime1;
    if (floor) {
      return Math.floor(diff);
    }
    return diff;
  }

  /**
   * 获取前几天日期或后几天日期
   */
  static getAmountDay(date: number | string | Date, amount: number): Date {
    let dateTime = DateUtils.getFormatDate(date);
    return DateUtils.getCalendarAdd(dateTime, "date", amount);
  }

  /**
   * 获取前几天日期或后几天日期,返回字符串
   */
  static getAmountDayStr(date: number | string | Date, amount: number, format: string = "yyyy-MM-dd"): string {
    return DateUtils.getFormatDateStr(DateUtils.getAmountDay(date, amount), format);
  }

  /**
   * 获取前一天日期
   */
  static getBeforeDay(date: number | string | Date): Date {
    return DateUtils.getAmountDay(date, -1);
  }

  /**
   * 获取前一天日期,返回字符串
   */
  static getBeforeDayStr(date: number | string | Date, format: string = "yyyy-MM-dd"): string {
    return DateUtils.getAmountDayStr(date, -1, format);
  }

  /**
   * 获取后一天日期
   */
  static getAfterDay(date: number | string | Date): Date {
    return DateUtils.getAmountDay(date, 1);
  }

  /**
   * 获取后一天日期,返回字符串
   */
  static getAfterDayStr(date: number | string | Date, format: string = "yyyy-MM-dd"): string {
    return DateUtils.getAmountDayStr(date, 1, format);
  }

  /**
   * 获取给定日期是当月的第几周
   */
  static getWeekOfMonth(date: number | string | Date): number {
    date = DateUtils.getFormatDate(date);
    return DateUtils.getCalendarField('week_of_month', date);
  }

  /**
   * 获取给定的日期是星期几
   */
  static getWeekDay(date: number | string | Date): number {
    return DateUtils.getFormatDate(date).getDay();
  }

  /**
   * 获取给定年份和月份的最后一天是几号
   */
  static getLastDayOfMonth(year: number, month: number): number {
    return new Date(year, month, 0).getDate();
  }

  /**
   * 格式化时间日期字符串（DateTimeFormat）
   */
  static getFormatTime(date: Date, options: intl.DateTimeOptions = {
    dateStyle: "short",
    timeStyle: "short", hourCycle: "h24"
  },
    locale: string = "zh-CN"): string {
    const dateTimeFormat = new intl.DateTimeFormat(locale, options);
    return dateTimeFormat.format(date);
  }

  /**
   * 格式化时间日期段字符串（DateTimeFormat）
   */
  static getFormatRange(startDate: Date, endDate: Date,
    options: intl.DateTimeOptions = { dateStyle: "short", timeStyle: "short", hourCycle: "h24" },
    locale: string = "zh-CN"): string {
    const dateTimeFormat = new intl.DateTimeFormat(locale, options);
    return dateTimeFormat.formatRange(startDate, endDate);
  }

  /**
   * 格式化相对时间
   */
  static getFormatRelativeTime(value: number, unit: string, options?: intl.RelativeTimeFormatInputOptions,
    locale: string = "zh-CN"): string {
    let relativeTimeFormat = new intl.RelativeTimeFormat(locale, options);
    return relativeTimeFormat.format(value, unit);
  }

  /**
   * 格式化时间戳，获取提示性时间字符串
   * @param date
   * @returns
   */
  static getTipDateStr(date: number | string | Date): string {
    let timeMs = DateUtils.getFormatDate(date).getTime();
    if (timeMs.toString().length == 10) {
      timeMs = timeMs * 1000
    }
    let dateNow = new Date();
    let dateUp = new Date(timeMs);
    if (dateNow.getTime() - timeMs < 60 * 1000) {
      return "刚刚";
    } else if (dateNow.getTime() - timeMs < 60 * 60 * 1000) {
      return ((dateNow.getTime() - timeMs) / (60 * 1000)).toFixed() + "分钟前";
    } else if (dateNow.getTime() - timeMs < 24 * 60 * 60 * 1000) {
      return ((dateNow.getTime() - timeMs) / (60 * 60 * 1000)).toFixed() + "小时前";
    } else if (dateNow.getTime() - timeMs < 360 * 24 * 60 * 60 * 1000) {
      return DateUtils.getFormatDateStr(dateUp, "MM月dd日");
    } else {
      return DateUtils.getFormatDateStr(dateUp, "yyyy-MM-dd");
    }
  }

  /**
   * 补零操作
   */
  private static padZero(num: number): string {
    return num.toString().padStart(2, "0");
  }

  /**
   * 格式化字符串时间戳。
   */
  private static toNumber(value: string): number | string {
    try {
      let parsedValue = parseFloat(value);
      if (isNaN(parsedValue)) {
        return value;
      }
      if (parsedValue.toString().length != value.length) {
        return value;
      }
      return parsedValue;
    } catch (e) {
      return value
    }
  }
}