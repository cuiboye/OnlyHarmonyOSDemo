/**
 * 修改图片颜色工具类,一般用于修改网络图片的颜色
 */
export class ColorUtils {
  /**
   * 将十六进制颜色值转换为4x5颜色矩阵
   * @param hexColor 十六进制颜色字符串，支持格式：#RRGGBB, #AARRGGBB
   * @returns 4x5颜色矩阵数组 (20个元素的number数组)
   */
  static hexToColorMatrix(hexColor: string): number[] {//将图片的颜色设置为hexColor（适用于图片上只有一种颜色）
    // 验证输入格式
    if (!/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$/.test(hexColor)) {
      throw new Error('Invalid hex color format. Expected #RRGGBB or #AARRGGBB');
    }

    // 提取颜色通道值
    let rgba = hexColor.substring(1)
    if (rgba.length === 6) {
      rgba = 'FF' + rgba // 添加默认Alpha通道
    }

    // 解析ARGB通道值(含归一化处理)
    const alpha = parseInt(rgba.substring(0, 2), 16) / 255
    const red = parseInt(rgba.substring(2, 4), 16) / 255
    const green = parseInt(rgba.substring(4, 6), 16) / 255
    const blue = parseInt(rgba.substring(6, 8), 16) / 255

    return [
      0, 0, 0, 0, red,
      0, 0, 0, 0, green,
      0, 0, 0, 0, blue,
      0, 0, 0, alpha, 0
    ]
  }

  /**
   * 返回原色滤镜矩阵（不改变图像颜色）
   * @returns 4x5单位颜色矩阵数组
   */
  static getOriginalColorMatrix(): number[] {//返回的是原图
    return [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0
    ]
  }

  /**
   * 返回颜色取反滤镜矩阵（将RGB通道取反，保持Alpha通道不变）
   * @returns 4x5颜色取反矩阵数组
   */
  static getInvertColorMatrix(): number[] {//将图片的颜色取反（适用于图片上存在多个颜色）
    return [
      -1, 0, 0, 0, 1,  // 红色通道取反
      0, -1, 0, 0, 1,  // 绿色通道取反
      0, 0, -1, 0, 1,  // 蓝色通道取反
      0, 0, 0, 1, 0    // Alpha通道不变
    ]
  }
}
