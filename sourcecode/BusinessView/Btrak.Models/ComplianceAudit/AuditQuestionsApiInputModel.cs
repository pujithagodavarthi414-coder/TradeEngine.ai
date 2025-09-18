using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

public class AuditQuestionsApiInputModel : InputModelBase
{
    public AuditQuestionsApiInputModel() : base(InputTypeGuidConstants.AuditCategoryInputModelCommandTypeGuid)
    {
    }

    public Guid? QuestionId { get; set; }
    public Guid? ConductId { get; set; }
    public Guid? AuditId { get; set; }
    public Guid? AuditReportId { get; set; }
    public Guid? AuditCategoryId { get; set; }
    public Guid? QuestionTypeId { get; set; }
    public string QuestionName { get; set; }
    public Guid? AuditVersionId { get; set; }
    public string QuestionDescription { get; set; }
    public bool IsArchived { get; set; }
    public decimal? EstimatedTime { get; set; }
    public bool IsOriginalQuestionTypeScore { get; set; }
    public bool IsQuestionMandatory { get; set; }
    public bool IsForViewHistory { get; set; }
    public bool ClearFilter { get; set; }
    public string AuditAnswersModel { get; set; }
    public bool IsHierarchical { get; set; }
    public string SearchText { get; set; }
    public List<AuditQuestionOptions> QuestionOptions { get; set; }
    public List<DocumentModel> Documents { get; set; }
    public string DocumentsModel { get; set; }
    public string CreatedOn { get; set; }
    public string UpdatedOn { get; set; }
    public string SortBy { get; set; }
    public string QuestionTypeFilterXml { get; set; }
    public string QuestionIdsXml { get; set; }
    public List<Guid?> QuestionTypeFilter { get; set; }
    public List<Guid?> QuestionIds { get; set; }
    public string QuestionHint { get; set; }
    public bool?  IsMailPdf { get; set; }
    public Guid? ImpactId { get; set; }
    public Guid? PriorityId { get; set; }
    public Guid? RiskId { get; set; }
    public Guid? QuestionDashboardId { get; set; }
    public string SelectedRoleIds { get; set; }
    public string RoleIdsXml { get; set; }
    public bool? CanView { get; set; }
    public bool? CanEdit { get; set; }
    public bool? CanDelete { get; set; }
    public bool? CanAddAction { get; set; }
    public bool? NoPermission { get; set; }    
    public string SelectedEmployees { get; set; }
    public Guid? WorkFlowId { get; set; }
    public Guid? AuditConductQuestionId { get; set; }
    public Guid? QuestionResponsiblePersonId { get; set; }
    public override string ToString()
    {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.Append("QuestionId = " + QuestionId);
        stringBuilder.Append(", AuditId = " + AuditId);
        stringBuilder.Append(", ConductId = " + ConductId);
        stringBuilder.Append(", AuditCategoryId = " + AuditCategoryId);
        stringBuilder.Append(", QuestionTypeId = " + QuestionTypeId);
        stringBuilder.Append(", QuestionDescription = " + QuestionDescription);
        stringBuilder.Append(", QuestionName = " + QuestionName);
        stringBuilder.Append(", IsOriginalQuestionTypeScore = " + IsOriginalQuestionTypeScore);
        stringBuilder.Append(", IsQuestionMandatory = " + IsQuestionMandatory);
        stringBuilder.Append(", IsForViewHistory = " + IsForViewHistory);
        stringBuilder.Append(", ClearFilter = " + ClearFilter);
        stringBuilder.Append(", CreatedOn = " + CreatedOn);
        stringBuilder.Append(", UpdatedOn = " + UpdatedOn);
        stringBuilder.Append(", SortBy = " + SortBy);
        stringBuilder.Append(", QuestionTypeFilter = " + QuestionTypeFilter);
        stringBuilder.Append(", QuestionTypeFilterXml = " + QuestionTypeFilterXml);
        stringBuilder.Append(", QuestionIds = " + QuestionIds);
        stringBuilder.Append(", QuestionIdsXml = " + QuestionIdsXml);
        stringBuilder.Append(", QuestionHint = " + QuestionHint);
        stringBuilder.Append(", QuestionResponsiblePersonId = " + QuestionResponsiblePersonId);
        stringBuilder.Append(", TimeStamp = " + TimeStamp);
        return stringBuilder.ToString();
    }
}