/**
 * 断点常量
 */
export class BreakpointConstants {
  /**
   * 较小设备，基本不用
   */
  static readonly BREAKPOINT_XS: string = 'xs';
  /**
   * 横向断点
   * 手机（竖屏），阔折叠（内屏，外屏），小折叠竖屏，双折叠（外屏幕竖屏），三折叠（F态竖屏）
   *
   * 纵向断线
   * 平板（横屏）,三折叠（G态竖屏）
   */
  static readonly BREAKPOINT_SM: string = 'sm';
  /**
   * 横向断点
   * 双折叠（内屏，外屏），三折叠（M态竖屏）
   *
   * 纵向断线
   * 阔折叠（外屏），双折叠（内屏，外屏），三折叠（M态竖屏）
   */
  static readonly BREAKPOINT_MD: string = 'md';
  /**
   * 横向断点
   * 平板（横屏）,三折叠（G态竖屏）
   *
   * 纵向断线
   * 手机（竖屏），阔折叠（内屏），小折叠（内屏），双折叠（外屏幕竖屏），三折叠（F态竖屏）
   */
  static readonly BREAKPOINT_LG: string = 'lg';
  /**
   * 断点以应用窗口宽度为判断条件
   */
  static readonly BREAKPOINT_SCOPE: number[] = [0, 320, 600, 840];
}