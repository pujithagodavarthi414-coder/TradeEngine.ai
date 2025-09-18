using Btrak.Models;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.File;
using System;
using System.Collections.Generic;


public class AuditQuestionsApiReturnModel
{
    public AuditQuestionsApiReturnModel()
    {
        Questions = new List<AuditQuestionsApiReturnModel>();
    }
    public Guid? AuditConductQuestionId { get; set; }
    public Guid? QuestionId { get; set; }
    public Guid? ConductId { get; set; }
    public Guid? AuditReportId { get; set; }
    public string QuestionName { get; set; }
    public string ConductName { get; set; }
    public string QuestionHint { get; set; }
    public string QuestionDescription { get; set; }
    public decimal? EstimatedTime { get; set; }
    public bool IsQuestionMandatory { get; set; }
    public bool IsConductArchived { get; set; }
    public bool IsOriginalQuestionTypeScore { get; set; }
    public Guid? QuestionTypeId { get; set; }
    public bool? IsArchived { get; set; }
    public Guid? CreatedByUserId { get; set; }
    public DateTime? CreatedDateTime { get; set; }
    public Guid? UpdatedByUserId { get; set; }
    public DateTime? UpdatedDateTime { get; set; }
    public string CreatedByUserName { get; set; }
    public string UpdatedByUserName { get; set; }
    public string CreatedByProfileImage { get; set; }
    public Guid? AuditCategoryId { get; set; }
    public string AuditCategoryName { get; set; }
    public Guid? ParentAuditCategoryId { get; set; }
    public Guid? AuditId { get; set; }
    public string UpdatedByUserProfileImage { get; set; }
    public string QuestionTypeName { get; set; }
    public byte[] QuestionTypeTimestamp { get; set; }
    public string QuestionResult { get; set; }
    public string QuestionResultText { get; set; }
    public DateTime? QuestionResultDate { get; set; }
    public float? QuestionResultNumeric { get; set; }
    public TimeSpan? QuestionResultTime { get; set; }
    public bool QuestionResultBoolean { get; set; }
    public string QuestionScore { get; set; }
    public Guid? MasterQuestionTypeId { get; set; }
    public string MasterQuestionTypeName { get; set; }
    public bool? IsMasterQuestionType { get; set; }
    public string QuestionsXml { get; set; }
    public List<AuditQuestionOptions> QuestionOptions { get; set; }
    public string QuestionIdentity { get; set; }
    public byte[] TimeStamp { get; set; }
    public bool IsAnswerValid { get; set; }
    public Guid? AuditAnswerId { get; set; }
    public Guid? ConductAnswerSubmittedId { get; set; }
    public bool IsQuestionAnswered { get; set; }
    public string AnswerComment { get; set; }
    public int ActionsCount { get; set; }
    public string CategoriesXml { get; set; }
    public string QuestionFilesXml { get; set; }
    public string ConductQuestionFilesXml { get; set; }
    public int FilesCount { get; set; }
    public List<AuditQuestionsApiReturnModel> Questions { get; set; }
    public List<FileApiReturnModel> QuestionFiles { get; set; }
    public List<AuditQuestionsApiReturnModel> QuestionsForReport { get; set; }
    public List<AuditCategoryApiReturnModel> HierarchyTree { get; set; }
    public int? QuestionsCount { get; set; }
    public Guid? NextQuestion { get; set; }
    public Guid? PreviousQuestion { get; set; }
    public Guid? SubmittedByUserId { get; set; }
    public string SubmittedByUserName { get; set; }
    public string ImpactName { get; set; }
    public string PriorityName { get; set; }
    public Guid? ImpactId { get; set; }
    public string RiskName { get; set; }
    public Guid? RiskId { get; set; }
    public Guid? PriorityId { get; set; }
    public Guid? QuestionDashboardId { get; set; }
    public string SelectedRoleIds { get; set; }
    public string RoleIds { get; set; }
    public string SelectedEmployees { get; set; }
    public string RoleIdsXml { get; set; }
    public bool? CanView { get; set; }
    public bool? CanEdit { get; set; }
    public bool? CanDelete { get; set; }
    public bool? CanAddAction { get; set; }
    public bool? NoPermission { get; set; }
    public string Status { get; set; }
    public string StatusColor { get; set; }
    public Guid? AuditVersionId { get; set; }
    public Guid? QuestionResponsiblePersonId { get; set; }
    public string QuestionResponsiblePersonName { get; set; }
    public string QuestionResponsiblePersonProfileImage { get; set; }
    public bool? EnableQuestionLevelWorkFlow { get; set; }
    public bool? EnableQuestionLevelWorkFlowInAudit { get; set; }
    public Guid? QuestionWorkflowId { get; set; }
    public List<DocumentModel> Documents { get; set; }
    public string DocumentsXml { get; set; }
}
