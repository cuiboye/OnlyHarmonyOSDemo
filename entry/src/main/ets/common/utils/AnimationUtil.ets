/**
 * 动画工具类
 */
export class AnimationUtil {
  /**
   * 创建一个从上到下的过渡效果
   * @param duration 过渡时间
   */
  static transitionFromUp(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.TOP).animation({duration: duration})),
      TransitionEffect.OPACITY.animation({delay: duration, duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.TOP).animation({duration: duration}))
    )
  }
  /**
   * 创建一个从下到上的过渡效果
   * @param duration 过渡时间
   */
  static transitionFromDown(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.BOTTOM).animation({duration: duration})),
      TransitionEffect.OPACITY.animation({delay: duration, duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.BOTTOM).animation({duration: duration}))
    )
  }
  /**
   * 创建一个从左到右的过渡效果
   * @param duration 过渡时间
   */
  static transitionFromLeft(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.START).animation({duration: duration})),
      TransitionEffect.OPACITY.animation({delay: duration, duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.START).animation({duration: duration}))
    )
  }
  /**
   * 创建一个从右到左的过渡效果
   * @param duration 过渡时间
   */
  static transitionFromRight(duration: number = 200): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.END).animation({duration: duration})),
      TransitionEffect.OPACITY.animation({delay: duration, duration: duration}).combine(
        TransitionEffect.move(TransitionEdge.END).animation({duration: duration}))
    )
  }
  /**
   * 创建一个从中心点开始的过渡效果
   * @param duration 过渡时间
   */
  static transitionFromCenter(duration: number = 200): TransitionEffect {
    return TransitionEffect.OPACITY.animation({duration: duration})
  }
}