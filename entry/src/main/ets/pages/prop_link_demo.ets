class Task {
  static id: number = 1
  name: string = '任务名称' + Task.id++
  finished: boolean = false
  taskChild?: TaskChild
}

@Observed
class TaskChild{
  childName:string = ''
}

@Entry
@Component
export struct ProgressTask {
  //总的任务数
  @State totalTasks: number = 0
  //已完成的任务数
  @State finishedTasks: number = 0
  //任务数的集合
  @State tasks: Task[] = []

  build() {
    Column() {
      TaskProgressCard({ finishedTasks: this.finishedTasks, totalTasks: this.totalTasks })
      Button('添加任务')
        .width(200)
        .height(35)
        .margin({ bottom: 20 })
        .onClick(() => {
          this.tasks.push(new Task())
        })
      TaskListWidget({ totalTasks: $totalTasks, finishedTasks: $finishedTasks, tasks: $tasks })
    }
  }
}

@Component
struct TaskProgressCard {
  //@Prop:父组件对应的变量改变时，这个变量也会更新
  @Prop totalTasks: number
  //已完成的任务数
  @Prop finishedTasks: number

  build() {
    Row() {
      Text('任务进度')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
      Stack() {
        Progress({
          value: this.finishedTasks,
          total: this.totalTasks,
          type: ProgressType.Ring
        }).width(100)
        Row() {
          Text(this.finishedTasks.toString()) //toString:将数字转为字符串
            .fontSize(24)
            .fontColor('#36D')
          Text(' / ' + this.totalTasks.toString())
            .fontSize(24)
        }
      }
    }.card().height(150).margin({ top: 20, bottom: 10 }).justifyContent(FlexAlign.SpaceEvenly)
  }
}

@Extend(Text) function taskSuccessed(finished: boolean) {
  .decoration({ type: finished ? TextDecorationType.LineThrough : TextDecorationType.None })
  .fontColor(finished ? Color.Blue : Color.Black)
  .fontSize(20)
}

@Styles function card() {
  .width('90%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({ radius: 6, color: '#1F00000', offsetX: 2, offsetY: 4 })
}

@Styles function listCardStyles() {
  .width('100%')
  .padding(20)
  .backgroundColor(Color.White)
  .borderRadius(15)
  .shadow({ radius: 6, color: '#1F00000', offsetX: 2, offsetY: 4 })
}

@Extend(Button) function deleteTaskStyles() {
  .fontColor(Color.White)
  .backgroundColor(Color.Red)
  .width(40)
  .height(40)
  .type(ButtonType.Circle)
  .margin({ left: 10, right: 10 })
}

@Component
struct TaskListWidget {
  @Link totalTasks: number
  //已完成的任务数
  @Link finishedTasks: number
  //任务数的集合
  @Link tasks: Task[]

  //选中状态后的操作
  handleTaskNumber() {
    this.totalTasks = this.tasks.length
    this.finishedTasks = this.tasks.filter(item => item.finished).length
  }

  build() {
    Column() {
      List({ space: 10 }) {
        ForEach(this.tasks, (task: Task, index) => {
          ListItemGroup()

          ListItem() {
            //注意：方法传递时，这里需要使用 bind(this)，否则方法中的this使用的是子类的this，会导致找不到对应的属性
            TaskListItemWidget({ task: task, handleTaskNumber: this.handleTaskNumber.bind(this) })
          }.swipeAction({ end: this.deleteTask(index) }) //swipeAction:ListView的侧滑效果
        }, (item: Task) => '' + item.name)
      }
    }
  }

  //删除任务
  @Builder deleteTask(index: number) {
    Button('➖')
      .deleteTaskStyles()
      .onClick(() => {
        this.tasks.splice(index, 1) //1表示删除
        this.handleTaskNumber()
      })
  }
}

@Component
struct TaskListItemWidget {
  task: Task = new Task()
  handleTaskNumber?: () => void
  build() {
    Row() {
      Text(this.task?.name).taskSuccessed(this.task?.finished??false)
      Checkbox()
        .select(this.task?.finished)
        .onChange((selected:boolean) => {
          this.task.finished = selected
          this.handleTaskNumber?.()
        })
    }.listCardStyles().justifyContent(FlexAlign.SpaceBetween)
  }
}
