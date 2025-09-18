using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditComplianceApiReturnModel : InputModelBase
    {
        public AuditComplianceApiReturnModel() : base(InputTypeGuidConstants.AuditComplianceInputModelCommandTypeGuid)
        {
            Children = new List<AuditComplianceApiReturnModel>();
        }
        public Guid? AuditId { get; set; }
        public Guid? ParentAuditId { get; set; }
        public string AuditName { get; set; }
        public bool IsArchived { get; set; }
        public bool IsRAG { get; set; }
        public bool IsAudit { get; set; }
        public bool IsConduct { get; set; }
        public bool CanLogTime { get; set; }
        public float? InBoundPercent { get; set; }
        public float? OutBoundPercent { get; set; }
        public decimal? TotalEstimatedTime { get; set; }
        public decimal? TotalSpentTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public int TotalCount { get; set; }
        public int Auditlevel { get; set; }
        public int ConductsCount { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string AuditDescription { get; set; }
        public string CreatedByUserName { get; set; }
        public string CreatedByProfileImage { get; set; }
        public int? AuditCategoriesCount { get; set; }
        public int? AuditQuestionsCount { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public DateTime? ConductStartDate { get; set; }
        public DateTime? ConductEndDate { get; set; }
        public string AuditTagsModelXml { get; set; }
        public List<AuditTagsModel> AuditTagsModels { get; set; }
        public string SchedulingDetailsString { get; set; }
        public List<AuditComplianceSchedulingModel> SchedulingDetails { get; set; }
        public List<AuditComplianceApiReturnModel> Children { get; set; }
        public string ResponsibleUserName { get; set; }
        public string ResponsibleProfileImage { get; set; }
        public Guid? ResponsibleUserId { get; set; }
        public Guid? ProjectId { get; set; }
        public bool? EnableQuestionLevelWorkFlow { get; set; }
        public byte[] FolderTimeStamp { get; set; }
        public bool? EnableWorkFlowForAudit { get; set; }
        public bool? EnableWorkFlowForAuditConduct { get; set; }
        public string Status { get; set;  }
        public string StatusColor { get; set; }
        public Guid? AuditWorkFlowId { get; set; }
        public Guid? ConductWorkFlowId { get; set; }
        public bool HaveAuditVersions { get; set; }
        public bool HaveCustomFields { get; set; }
        public Guid? AuditVersionId { get; set; }
        public string ProjectName { get; set; }
        public Guid? AuditDefaultWorkflowId { get; set; }
        public Guid? ConductDefaultWorkflowId { get; set; }
        public Guid? QuestionDefaultWorkflowId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AuditId = " + AuditId);
            stringBuilder.Append("Auditlevel = " + Auditlevel);
            stringBuilder.Append("ParentAuditId = " + ParentAuditId);
            stringBuilder.Append(", AuditName = " + AuditName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsRAG = " + IsRAG);
            stringBuilder.Append(", CanLogTime = " + CanLogTime);
            stringBuilder.Append(", InboundPercent = " + InBoundPercent);
            stringBuilder.Append(", OutboundPercent = " + OutBoundPercent);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", HaveCustomFields = " + HaveCustomFields);
            return stringBuilder.ToString();
        }
    }

    public class AuditComplianceSchedulingModel
    {
        public Guid? CronExpressionId { get; set; }
        public string CronExpression { get; set; }
        public int? JobId { get; set; }
        public DateTime ConductStartDate { get; set; }
        public DateTime ConductEndDate { get; set; }
        public int? SpanInYears { get; set; }
        public int? SpanInMonths { get; set; }
        public int? SpanInDays { get; set; }
        public bool? IsPaused { get; set; }
        public Guid? ResponsibleUserId { get; set; }
        public byte[] CronExpressionTimeStamp { get; set; }
        public List<SelectedQuestionModel> SelectedQuestions { get; set; }
    }
}