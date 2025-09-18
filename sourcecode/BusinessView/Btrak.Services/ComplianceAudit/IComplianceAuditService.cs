using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.IO;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.TestRail;
using Btrak.Models.UserStory;
using System.Threading.Tasks;
using Btrak.Models.MasterData;

namespace Btrak.Services.ComplianceAudit
{
    public interface IComplianceAuditService
    {
        List<object> ProcessExcelData(Guid? projectId, Stream fileStream, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditCompliance(AuditComplianceApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditFolder(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CloneAudit(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditComplianceApiReturnModel> SearchAudits(AuditComplianceApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditComplianceApiReturnModel> SearchAuditFolders(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetAuditsFolderView(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<QuestionTypeApiReturnModel> GetQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertQuestionType(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditCategoryApiReturnModel> SearchAuditCategories(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ConductAuditCategoryModel SearchAuditCategoriesForConducts(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetCategoriesAndSubcategories(Guid? auditId, Guid? auditVersionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditCategory(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        AuditRelatedCountsApiReturnModel GetAuditRelatedCounts(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ConductQuestionActions> GetConductQuestionsForActionLinking(Guid? projectId, string questionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditConduct(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditConductApiReturnModel> SearchAuditConducts(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetConductsFolderView(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditReport(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditReportApiReturnModel> GetAuditReports(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<QuestionTypeApiReturnModel> GetMasterQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditQuestion(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditQuestionsApiReturnModel> GetAuditQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ConductSelectedQuestionModel> GetQuestionsByFilters(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditQuestionHistoryModel> GetAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditQuestionHistoryModel> UpsertAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditQuestionHistoryModel> GetAuditOverallHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ReorderQuestions(List<Guid> questionIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ReorderCategories(CategoryModel categoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CopyOrMoveQuestions(CopyMoveQuestionsModel copyMoveQuestionsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? MoveAuditQuestionsToAuditCategory(MoveAuditQuestionsToAuditCategoryApiInputModel moveAuditQuestionsToAuditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditQuestionsApiReturnModel> SearchAuditConductQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? SubmitAuditConductQuestion(SubmitAuditConductApiInputModel submitAuditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? SubmitAuditConduct(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetBugsBasedOnUserStoryApiReturnModel> SearchConductQuestionActions(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<List<AuditSubmittedDetailsReturnModel>> SearchSubmittedAudits(AuditSearchInputModel auditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<List<AuditSubmittedDetailsReturnModel>> SearchNonCompalintAudits(AuditSearchInputModel auditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<List<AuditSubmittedDetailsReturnModel>> SearchCompalintAudits(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> GenerateAuditReportAndSendMail(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditTags(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditTagsModel> GetTags(string searchText, string selectedIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetApproveLineManagersOutputModel> GetConductsUserDropDown(string isBranchFilter, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void AuditConductMailNotification(string procedure);
        void AuditConductStartMailNotification();
        void AuditConductDeadLineMailNotification();
        List<AuditConductMailNotificationModel> GetRecurringAuditsForSendingMails(int days, Guid? userId);
        List<AuditConductMailNotificationModel> GetRecurringAuditsForSendingDeadLineMails(int days, Guid? userId);
        bool UploadAuditsFromCsv(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool UploadConductsFromCsv(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditForExportModel> GetAuditDataForJson(AuditDownloadModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ConductForExportModel> GetConductDataForJson(ConductLinkEmailSendModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        byte[] GetAuditDataForExcel(List<AuditForExportModel> audits, AuditDownloadModel exportModel, string site, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        byte[] GetConductDataForExcel(List<ConductForExportModel> conducts, ConductLinkEmailSendModel exportModel, string site, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool SendConductLinkToMails(ConductLinkEmailSendModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditPriority(AuditPriorityModel auditPriorityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertActionCategory(ActionCategoryModel actionCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditRating(AuditRatingModel auditRatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditImpact(AuditImpactModel auditImpactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditPriorityModel> GetAuditPriority(AuditPriorityModel auditPriorityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditRatingModel> GetAuditRatings(AuditRatingModel auditRatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActionCategoryModel> GetActionCategories(ActionCategoryModel actionCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditImpactModel> GetAuditImpact(AuditImpactModel auditImpactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void SubmitAuditCompliance(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AuditRiskModel> GetAuditRisk(AuditRiskModel auditRiskModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAuditRisk(AuditRiskModel auditRiskModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertAuditVersion(InsertAuditVersionInputModel insertAuditVersionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetAuditVersionsOutputModel> GetAuditVersions(Guid? auditId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ReconductAudit(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}

