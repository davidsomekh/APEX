import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import FIRST_NAME_FIELD from '@salesforce/schema/User.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/User.LastName';
import COMPANY_NAME_FIELD from '@salesforce/schema/User.CompanyName';

// Specify all the fields to query
const FIELDS = [
    'Dongle__c.Id',
    'Dongle__c.Name',
    'Dongle__c.SolidCAM_Mill_2D__c',
    'Dongle__c.Spiral_Machining__c',
    'Dongle__c.iMachining3D__c',
    'Dongle__c.Recoginition_Features__c',
    'Dongle__c.Hole_Recognition__c',
    'Dongle__c.Reduced_HolesR__c',
    'Dongle__c.HSM__c',
    'Dongle__c.HSS_Rough__c',
    'Dongle__c.Mill_2D_V__c',
    'Dongle__c.HSS_V__c',
    'Dongle__c.SolidCAM_Turning__c',
    'Dongle__c.Multi_Turret_Sync__c',
    'Dongle__c.Convert5X__c',
    'Dongle__c.X5_axis__c',
    'Dongle__c.Simultaneous5axesReduced__c',
    'Dongle__c.Machine_Simulation__c',
    'Dongle__c.X5x_Drill__c',
    'Dongle__c.Probe__c',
    'Dongle__c.Probe_Level2__c',
    'Dongle__c.MultiBlade5x__c',
    'Dongle__c.Port_5x__c',
    'Dongle__c.Contour_5x__c',
    'Dongle__c.Screw_Machining__c',
    'Dongle__c.New_Maintenance_End_Date__c'
];



export default class WireGetRecordDynamicContact   extends LightningElement {
    @api recordId;
    userId = USER_ID;
    today = new Date().toLocaleDateString();
    @wire(getRecord, { recordId: '$userId', fields: [FIRST_NAME_FIELD, LAST_NAME_FIELD, COMPANY_NAME_FIELD] })
    user;
    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    dongle;
    get firstName() {
        return getFieldValue(this.user.data, FIRST_NAME_FIELD);
    }

    get lastName() {
        return getFieldValue(this.user.data, LAST_NAME_FIELD);
    }

    get companyName() {
        return getFieldValue(this.user.data, COMPANY_NAME_FIELD);
    }
    
    get showSolidCAMMill2D() {
        console.log(this.recordId);
        return this.dongle.data && this.dongle.data.fields.SolidCAM_Mill_2D__c.value;
    }
    get showIMachining2D() {
        return this.dongle.data && this.dongle.data.fields.Spiral_Machining__c.value;
    }
    get showIMachining3D() {
        return this.dongle.data && this.dongle.data.fields.iMachining3D__c.value;
    }
    get showAFRM() {
        return this.dongle.data && 
               this.dongle.data.fields.Recoginition_Features__c.value && 
               this.dongle.data.fields.Hole_Recognition__c.value && 
               !this.dongle.data.fields.Reduced_HolesR__c.value;
    }
    get showHSM() {
        return this.dongle.data && this.dongle.data.fields.HSM__c.value;
    }
    get showHSSRough() {
        return this.dongle.data && this.dongle.data.fields.HSS_Rough__c.value;
    }
    get showMillXpress() {
        return this.dongle.data && 
               (this.dongle.data.fields.Mill_2D_V__c.value || 
                this.dongle.data.fields.HSS_V__c.value);
    }
    get showTurning() {
        return this.dongle.data && this.dongle.data.fields.SolidCAM_Turning__c.value;
    }
    get showMultiTurret() {
        return this.dongle.data && this.dongle.data.fields.Multi_Turret_Sync__c.value;
    }
    get show5AxisConversion() {
        return this.dongle.data && this.dongle.data.fields.Convert5X__c.value;
    }
    get showHSS() {
        return this.dongle.data && 
               (this.dongle.data.fields.Simultaneous5axesReduced__c.value === '3-axis' || 
                this.dongle.data.fields.X5_axis__c.value);
    }
    get showSim4Axis() {
        return this.dongle.data && 
               ((this.dongle.data.fields.Simultaneous5axesReduced__c.value === '3/4 axis') || (
                this.dongle.data.fields.X5_axis__c.value && 
                (!this.dongle.data.fields.Simultaneous5axesReduced__c.value  || this.dongle.data.fields.Simultaneous5axesReduced__c.value === '')));
    }
    get showSim5Axis() {
        return this.dongle.data && 
        ((!this.dongle.data.fields.Simultaneous5axesReduced__c.value  || this.dongle.data.fields.Simultaneous5axesReduced__c.value === '') && 
         this.dongle.data.fields.X5_axis__c.value);
    }
    get showMachineSimulation() {
        return this.dongle.data && this.dongle.data.fields.Machine_Simulation__c.value;
    }
    // ... similar getters for other modules
    get show5AxisDrilling() {
        return this.dongle.data && this.dongle.data.fields.X5x_Drill__c.value;
    }
    get showProbeFull() {
        return this.dongle.data && this.dongle.data.fields.Probe__c.value;
    }
    get showProbeHomeDefinition() {
        return this.dongle.data && this.dongle.data.fields.Probe_Level2__c .value;
    }
    get showMultiBlade() {
        return this.dongle.data && this.dongle.data.fields.MultiBlade5x__c.value;
    }
    get showPortMachining() {
        return this.dongle.data && this.dongle.data.fields.Port_5x__c.value;
    }
    get showContour5X() {
        return this.dongle.data && this.dongle.data.fields.Contour_5x__c.value;
    }
    get showScrewMachining() {
        return this.dongle.data && this.dongle.data.fields.Screw_Machining__c.value;
    }
    get showReinstallationFee() {
        let date90DaysAgo = new Date();
        date90DaysAgo.setDate(date90DaysAgo.getDate() - 90);
        return this.dongle.data && ( this.dongle.data.fields.New_Maintenance_End_Date__c.value <  date90DaysAgo 
            || !this.dongle.data.fields.New_Maintenance_End_Date__c.value);
    }
    
}