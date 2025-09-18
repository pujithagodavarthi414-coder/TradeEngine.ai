using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditReportApiInputModel : InputModelBase
    {
        public AuditReportApiInputModel() : base(InputTypeGuidConstants.AuditCategoryInputModelCommandTypeGuid)
        {
        }

        public Guid? AuditReportId { get; set; }
        public string AuditReportName { get; set; }
        public string AuditRatingName { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? ConductId { get; set; }
        public string AuditReportDescription { get; set; }
        public string SearchText { get; set; }
        public List<AuditQuestionsApiReturnModel> QuestionsForReport { get; set; }
        public string CreatedByUserName { get; set; }
        public string CreatedByProfileImage { get; set; }
        public int QuestionsCount { get; set; }
        public int AnsweredCount { get; set; }
        public int UnAnsweredCount { get; set; }
        public float ConductScore { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public bool IsToSendMail { get; set; }
        public bool IsForMail { get; set; }
        public bool IsForPdf { get; set; }
        public string TO { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public Guid? ProjectId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ConductId = " + ConductId);
            stringBuilder.Append(", AuditReportName = " + AuditReportName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", AuditReportId = " + AuditReportId);
            stringBuilder.Append(", AuditReportDescription = " + AuditReportDescription);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", CreatedByProfileImage = " + CreatedByProfileImage);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedByUserName = " + CreatedByUserName);
            stringBuilder.Append(", ConductScore = " + ConductScore);
            stringBuilder.Append(", QuestionsCount = " + QuestionsCount);
            stringBuilder.Append(", AnsweredCount = " + AnsweredCount);
            stringBuilder.Append(", UnAnsweredCount = " + UnAnsweredCount);
            stringBuilder.Append(", IsToSendMail = " + IsToSendMail);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", QuestionsForReport = " + QuestionsForReport?.ToString());
            return stringBuilder.ToString();
        }
    }
}


