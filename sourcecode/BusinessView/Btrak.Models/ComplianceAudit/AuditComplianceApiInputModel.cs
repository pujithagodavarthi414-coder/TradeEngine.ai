using System;
using System.Collections.Generic;
using System.Text;
using Btrak.Models.Widgets;
using BTrak.Common;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditComplianceApiInputModel : InputModelBase
    {
        public AuditComplianceApiInputModel() : base(InputTypeGuidConstants.AuditComplianceInputModelCommandTypeGuid)
        {
        }

        public Guid? AuditId { get; set; }
        public Guid? ConductId { get; set; }
        public Guid? ParentAuditId { get; set; }
        public List<Guid> MultipleAuditIds { get; set; }
        public string MultipleAuditIdsXml { get; set; }
        public string AuditName { get; set; }
        public string AuditDescription { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }
        public bool RecurringAudit { get; set; }
        public bool IsAudit { get; set; }
        public Guid? ResponsibleUserId { get; set; }
        public CronExpressionInputModel[] SchedulingDetails {get; set; }
        public string SchedulingDetailsString { get; set; }
        public string AuditTagsModelXml { get; set; }
        public string CronExpression { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public DateTime? ConductStartDate { get; set; }
        public DateTime? ConductEndDate { get; set; }
        public bool? IsPaused { get; set; }
        public bool IsRAG { get; set; }
        public bool CanLogTime { get; set; }
        public float? InBoundPercent { get; set; }
        public float? OutBoundPercent { get; set; }
        public List<AuditTagsModel> AuditTagsModels { get; set; }
        public Guid? CondcuResponsibleId { get; set; }
        public bool? EnableQuestionLevelWorkFlow { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? DateFrom { get; set; }
        public Guid? UserId { get; set; }
        public string PeriodValue { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? ProjectId { get; set; }
        public bool? IsSubmitted { get; set; }
        public bool? IsForFilter { get; set; }
        public bool? EnableWorkFlowForAudit { get; set; }
        public bool? EnableWorkFlowForAuditConduct { get; set; }
        public Guid? AuditWorkFlowId { get; set; }
        public Guid? ConductWorkFlowId { get; set; }
        public Guid? AuditVersionId { get; set; }
        public Guid? AuditDefaultWorkflowId { get; set; }
        public Guid? ConductDefaultWorkflowId { get; set; }
        public Guid? QuestionDefaultWorkflowId { get; set; }
        public bool? ToSetDefaultWorkflows { get; set; }
        public List<Guid?> BusinessUnitIds { get; set; } 
        public string BusinessUnitIdsList { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AuditId = " + AuditId);
            stringBuilder.Append("ParentAuditId = " + ParentAuditId);
            stringBuilder.Append("MultipleAuditIds = " + MultipleAuditIds);
            stringBuilder.Append("MultipleAuditIdsXml = " + MultipleAuditIdsXml);
            stringBuilder.Append(", AuditName = " + AuditName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", RecurringAudit = " + RecurringAudit);
            stringBuilder.Append(", AuditDescription = " + AuditDescription);
            stringBuilder.Append(", IsRAG = " + IsRAG);
            stringBuilder.Append(", CanLogTime = " + CanLogTime);
            stringBuilder.Append(", InboundPercent = " + InBoundPercent);
            stringBuilder.Append(", OutboundPercent = " + OutBoundPercent);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", PeriodValue = " + PeriodValue);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", IsSubmitted = " + IsSubmitted);
            return stringBuilder.ToString();
        }
    }
}