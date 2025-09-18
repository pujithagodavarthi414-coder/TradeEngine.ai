using System;
using BTrak.Common;
using System.Text;
using System.Collections.Generic;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditConductApiReturnModel : InputModelBase
    {
        public AuditConductApiReturnModel() : base(InputTypeGuidConstants.AuditCategoryInputModelCommandTypeGuid)
        {
            Children = new List<AuditConductApiReturnModel>();
        }

        public Guid? AuditId { get; set; }
        public Guid? ConductId { get; set; }
        public Guid? AuditRatingId { get; set; }
        public string AuditRatingName { get; set; }
        public Guid? ParentConductId { get; set; }
        public string AuditConductName { get; set; }
        public string AuditConductDescription { get; set; }
        public string AuditDescription { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? DeadlineDate { get; set; }
        public bool? IsConductEditable { get; set; }
        public bool IsArchived { get; set; }
        public bool IsCompleted { get; set; }
        public bool IsRAG { get; set; }
        public bool IsAudit { get; set; }
        public bool IsConduct { get; set; }
        public bool CanLogTime { get; set; }
        public bool HaveCustomFields { get; set; }
        public float? InBoundPercent { get; set; }
        public decimal? TotalEstimatedTime { get; set; }
        public decimal? TotalSpentTime { get; set; }
        public float? OutBoundPercent { get; set; }
        public bool IsIncludeAllQuestions { get; set; }
        public string CreatedByUserName { get; set; }
        public string UpdatedByUserName { get; set; }
        public string CreatedByProfileImage { get; set; }
        public float ConductScore { get; set; }
        public int QuestionsCount { get; set; }
        public int AnsweredCount { get; set; }
        public int UnAnsweredCount { get; set; }
        public int ValidAnswersCount { get; set; }
        public int InValidAnswersCount { get; set; }
        public bool IsConductSubmitted { get; set; }
        public bool CanConductSubmitted { get; set; }
        public bool AreActionsAdded { get; set; }
        public bool AreDocumentsUploaded { get; set; }
        public bool IsFromTags { get; set; }
        public string CreatedUserMail { get; set; }
        public string UpdatedUserMail { get; set; }
        public string AuditTagsModelXml { get; set; }
        public string ConductTagsModelXml { get; set; }
        public List<AuditTagsModel> AuditTagsModels { get; set; }
        public List<AuditTagsModel> ConductTagsModels { get; set; }
        public List<AuditConductApiReturnModel> Children { get; set; }
        public string ResponsibleUserName { get; set; }
        public string ResponsibleProfileImage { get; set; }
        public Guid? ResponsibleUserId { get; set; }
        public Guid? ProjectId { get; set; }
        public string ConductAssigneeMail { get; set; }
        public string AuditResponsibleUserMail { get; set; }
        public byte[] FolderTimeStamp { get; set; }
        public string Status { get; set; }
        public string StatusColor { get; set; }
    }
}
