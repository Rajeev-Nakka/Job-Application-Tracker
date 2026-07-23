import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllApplications from '@salesforce/apex/JobApplicationService.getAllApplications';
import updateStatus from '@salesforce/apex/JobApplicationService.updateStatus';

const STAGES = ['Saved', 'Applied', 'Interviewing', 'Offer', 'Rejected'];

export default class JobApplicationKanban extends LightningElement {
    wiredResult;
    applications = [];
    error;

    @wire(getAllApplications)
    wiredApplications(result) {
        this.wiredResult = result;
        if (result.data) {
            this.applications = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.applications = [];
        }
    }

    get columns() {
        return STAGES.map((stage) => {
            return {
                stage: stage,
                label: stage,
                apps: this.applications.filter((app) => app.Status__c === stage)
            };
        });
    }

    handleDragStart(event) {
        event.dataTransfer.setData('recordId', event.currentTarget.dataset.id);
    }

    handleDragOver(event) {
        event.preventDefault();
    }

    async handleDrop(event) {
        event.preventDefault();
        const recordId = event.dataTransfer.getData('recordId');
        const newStage = event.currentTarget.dataset.stage;

        try {
            await updateStatus({ applicationId: recordId, newStatus: newStage });
            await refreshApex(this.wiredResult);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Updated',
                    message: 'Application moved to ' + newStage,
                    variant: 'success'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating status',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error'
                })
            );
        }
    }
}