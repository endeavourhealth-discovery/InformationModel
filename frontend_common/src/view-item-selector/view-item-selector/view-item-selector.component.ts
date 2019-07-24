import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal, NgbModalRef} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ViewItemSelectorService} from '../view-item-selector.service';
import {ITreeOptions, TreeComponent, IActionMapping} from 'angular-tree-component/dist/angular-tree-component';

@Component({
    selector: 'app-view-item-selector',
    template: `
      <div>
        <div class="modal-header">
          <h4 class="modal-title">Dataset editor</h4>
          <button type="button" class="close" (click)="cancel()" aria-hidden="true">&times;</button>
        </div>
        <div class="modal-body">
          <div class="container-fluid">
            <div class="row">
              <div class="form-group col-md-6">
<!--                <loadingIndicator [done]="viewTree">-->
                  <label class="control-label">Model navigator</label>
                  <div class="scroll-box-300 bordered-box">
                    <tree-root #tree [nodes]="viewTree" [options]="treeOptions">
                      <ng-template #treeNodeTemplate let-node>
                        <span>{{node.data.name}}</span> <span *ngIf="node.data.object" class="badge badge-secondary">{{node.data.object}}</span>
                      </ng-template>
                    </tree-root>
                  </div>
<!--                </loadingIndicator>-->
              </div>
              <div class="form-group col-md-6">
                <label class="control-label">Selection</label>
                <div class="scroll-box-300 bordered-box">
                  <table class="table table-striped table-sm table-hover">
                    <tbody>
                      <tr class="d-flex show-child-on-hover" *ngFor="let item of selection; let i = index">
                        <td class="col-10">{{item.parent.data.name}}.{{item.data.name}} <span *ngIf="item.data.object" class="badge badge-secondary">{{item.data.object}}</span></td>
                        <td class="col-2">
                          <div class="child-to-show pull-right">
                              <button class="btn btn-xs btn-success" (click)="moveUp(selection, item)" [disabled]="i==0"><i class="fa fa-fw fa-arrow-up"></i></button>
                              <button class="btn btn-xs btn-success" (click)="moveDown(selection, item)" [disabled]="i==(selection.length-1)"><i class="fa fa-fw fa-arrow-down"></i></button>
                              <button class="btn btn-xs btn-danger" (click)="remove(selection, item)"><i class="fa fa-fw fa-trash"></i></button>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" (click)="ok()" name="selectConcept">OK</button>
          <button type="button" class="btn btn-danger" (click)="cancel()" name="cancelConcept">Cancel</button>
        </div>
      </div>
    `,
    providers: [LoggerService]
})
export class ViewItemSelectorComponent implements AfterViewInit {
    @ViewChild('focus') focusField: ElementRef;
    @ViewChild('tree') tree: TreeComponent;

    viewId: string;
    selection: any = [];
    treeOptions: ITreeOptions;

    viewTree: any = [];
    public static open(modalService: NgbModal, viewId: string, selection: any[] = []): NgbModalRef {
        const modalRef = modalService.open(ViewItemSelectorComponent, {backdrop: 'static', size: 'lg'});
        modalRef.componentInstance.viewId = viewId;
        modalRef.componentInstance.selection = selection;
        return modalRef;
    }

    constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private viewService: ViewItemSelectorService) {
        this.treeOptions = {
            displayField: 'name',
            childrenField: 'child_node',
            hasChildrenField: 'hasChildren',
            idField: 'id',
            isExpandedField: 'isExpanded',
            actionMapping: {
                mouse: {
                    dblClick: (tree, node, $event) => this.select(node)
                }
            }
        }
    }

    ngAfterViewInit(): void {
        if (this.focusField != null)
            this.focusField.nativeElement.focus();

        this.loadView();
    }

    loadView() {
        setTimeout(
            () => this.viewTree = [{
                "id" : "View.MedicalRecord",
                "name": "Medical record",
                "child_node": [
                    {
                        "id": "View.MedicalRecord.Demographics",
                        "name": "Patient Demographics",
                        "child_node": [
                            {
                                "id": "View.MedicalRecord.Patient",
                                "name": "Patient",
                                "child_node" : []
                            },
                            {
                                "id": "View.MedicalRecord.Address",
                                "name": "Address",
                                "child_node" : []
                            },
                        ]
                    },
                    {
                        "id": "View.MedicalRecord.Clinical",
                        "name": "Clinical",
                        child_node: [
                            {
                                "id": "View.MedicalRecord.Observation",
                                "name": "Observation",
                                "child_node": [
                                    {
                                        "id": "View.MedicalRecord.Observation.date",
                                        "name": "Effective date",
                                        "object": "Observation.date",
                                    },
                                    {
                                        "id": "View.MedicalRecord.Observation.code",
                                        "name": "Local code",
                                        "object": "Observation.code",
                                    }
                                ]
                            },
                            {
                                "id": "View.MedicalRecord.Medication",
                                "name": "Medication",
                                "child_node": []
                            },
                        ]
                    }
                ]
            }]
        );

/*
        this.viewService.getView(this.viewId)
            .subscribe(
                (result) => this.viewTree = result,
                (error) => this.logger.error(error)
            );
*/

        this.tree.treeModel.update();
    }

    select(item: any) {
        // Only allow leaf nodes
        if (item.data.object) {
            this.selection.push(item);
        }
    }

    moveUp(list: any[], item: any) {
        const i = list.indexOf(item);
        if (i < 1)
            return;

        [list[i], list[i-1]] = [list[i-1], list[i]];
    }

    moveDown(list: any[], item: any) {
        const i = list.indexOf(item);
        if (i < 0 || i == list.length-1)
            return;

        [list[i], list[i+1]] = [list[i+1], list[i]];
    }

    remove(list: any[], item: any) {
        const i = list.indexOf(item);
        if (i < 0)
            return;
        list.splice(i,1);
    }

    ok() {
        this.activeModal.close(this.selection);
    }

    cancel() {
        this.activeModal.dismiss();
    }
}
