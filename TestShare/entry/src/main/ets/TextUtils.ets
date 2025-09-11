export namespace TextUtils {
  /**
   * 判断空值
   */
  export function isEmpty(str: string | undefined): boolean {
    return undefined == str || null == str || "" == str || '' == str;
  }
}