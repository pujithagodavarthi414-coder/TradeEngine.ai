using System;
using System.Text;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditQuestionHistoryModel
    {
        public Guid? QuestionId { get; set; }
        public Guid? ConductId { get; set; }
        public Guid? AuditId { get; set; }
        public string AuditName { get; set; }
        public string ConductName { get; set; }
        public string QuestionName { get; set; }
        public string Field { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Description { get; set; }
        public string AuditIds { get; set; }
        public string AuditsXml { get; set; }
        public string UserIds { get; set; }
        public string UserIdsXml { get; set; }
        public string BranchIds { get; set; }
        public string BranchIdsXml { get; set; }
        public string PerformedByUserName { get; set; }
        public string PerformedByUserProfileImage { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? ConductCreatedDateTime { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; }
        public string UserStoryName { get; set; }
        public bool IsActionInculde { get; set; }
        public bool IsFromAuditQuestion { get; set; }
        public Guid? ProjectId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("QuestionId" + QuestionId);
            stringBuilder.Append("ConductId" + ConductId);
            stringBuilder.Append("AuditId" + AuditId);
            stringBuilder.Append("AuditName" + AuditName);
            stringBuilder.Append("ConductName" + ConductName);
            stringBuilder.Append("QuestionName" + QuestionName);
            stringBuilder.Append("Field" + Field);
            stringBuilder.Append("OldValue" + OldValue);
            stringBuilder.Append("NewValue" + NewValue);
            stringBuilder.Append("Description" + Description);
            stringBuilder.Append("AuditIds" + AuditIds);
            stringBuilder.Append("UserIds" + UserIds);
            stringBuilder.Append("BranchIds" + BranchIds);
            stringBuilder.Append("DateFrom" + DateFrom);
            stringBuilder.Append("DateTo" + DateTo);
            stringBuilder.Append("TotalCount" + TotalCount);
            stringBuilder.Append("PerformedByUserName" + PerformedByUserName);
            stringBuilder.Append("PerformedByUserProfileImage" + PerformedByUserProfileImage);
            stringBuilder.Append("CreatedDateTime" + CreatedDateTime);
            stringBuilder.Append("ConductCreatedDateTime" + ConductCreatedDateTime);
            stringBuilder.Append("IsFromAuditQuestion" + IsFromAuditQuestion);
            stringBuilder.Append("ProjectId" + ProjectId);
            return base.ToString();
        }
    }
}
