import {Component, OnInit} from '@angular/core';
import {WorkflowManagerService} from './workflow-manager.service';
import {Task} from 'app/models/Task';
import {LoggerService} from 'eds-angular4';
import {TaskType, TaskTypeHelper} from '../models/TaskType';
import {Router} from '@angular/router';

@Component({
  selector: 'app-workflow-manager',
  templateUrl: './workflow-manager.component.html',
  styleUrls: ['./workflow-manager.component.css']
})
export class WorkflowManagerComponent implements OnInit {
  taskTypeFilter: TaskType = null;
  tasks: Task[];

  constructor(protected logger: LoggerService,
              protected workflowManagerService: WorkflowManagerService,
              protected router: Router) {
  }

  ngOnInit(): void {
    this.loadTasks();
  }

  loadTasks(taskType?: number): void {
    this.taskTypeFilter = taskType;
    this.workflowManagerService.getTasks(this.taskTypeFilter)
      .subscribe(
        (result) => this.tasks = result,
        (error) => this.logger.error(error)
      );
  }

  private getTaskTypeName(taskType: TaskType): string {
    return TaskTypeHelper.getName(taskType);
  }

  gotoTask(task: Task) {
    switch (task.type) {
      case TaskType.ATTRIBUTE_MODEL: {
        this.router.navigate(['attributeModel', task.identifier]);
        break;
      }
      default: {
        this.logger.error('Unknown task type');
      }
    }
  }
}
