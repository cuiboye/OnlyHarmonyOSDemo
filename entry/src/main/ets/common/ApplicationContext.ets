import { common } from "@kit.AbilityKit";

/**
 * Context
 */
export class ApplicationContext {
  private static context: common.UIAbilityContext;

  private constructor() {
  }

  /**
   * 获取全局Context
   */
  public static getContext(): common.UIAbilityContext {
    return ApplicationContext.context;
  }

  /**
   * 设置全局Context
   */
  public static setContext(context: common.UIAbilityContext) {
    ApplicationContext.context = context;
  }
}
