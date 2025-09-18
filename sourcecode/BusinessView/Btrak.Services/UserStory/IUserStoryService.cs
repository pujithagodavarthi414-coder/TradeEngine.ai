using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.Sprints;
using Btrak.Models.TestRail;
using Btrak.Models.UserStory;
using Btrak.Models.Widgets;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.UserStory
{
    public interface IUserStoryService
    {
        Guid? UpsertUserStory(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryApiReturnModel> SearchUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryApiReturnModel> SearchWorkItemsByLoggedInId(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserStoryApiReturnModel GetUserStoryById(Guid? userStoryId, string userStoryUniqueName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalApiReturnModel> GetUserStoriesByGoals(List<Guid> goalIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertMultipleUserStoriesUsingFile(Guid? goalId, string filePath, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid> UpdateMultipleUserStories(UserStoryInputModel userStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid> UpdateMultipleUserStoriesDeadlineConfigurations(DeadlineConfigurationInputModel deadlineConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ReorderUserStories(List<Guid> userStoryIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ReOrderWorkflowStatuses(ReOrderWorkflowStatusesInputModel reOrderWorkflowStatuses, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertUserStoryLogTime(UserStorySpentTimeUpsertInputModel userStorySpentTimeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserStoryAutoLogByTimeSheetModel UpsertUserstoryLogTimeBasedOnPunchCard(bool? breakStarted, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStorySpentTimeApiReturnModel> SearchUserStoryLogTime(UserStorySpentTimeSearchCriteriaInputModel userStoryLogTimeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStorySpentTimeReportApiOutputModel> SearchSpentTimeReport(SpentTimeReportSearchInputModel spentTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> UpsertMultipleUserStories(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserStoryCountModel GetCommentsCountByUserStoryId(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetBugsCountForUserStory(GetBugsCountBasedOnUserStoryInputModel getBugsCountBasedOnUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveUserStory(ArchiveUserStoryInputModel archiveUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ParkUserStory(ParkUserStoryInputModel parkUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateUserStoryGoal(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateUserStoryLink(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LogTimeOptionApiReturnModel> GetAllLogTimeOptions(GetLogTimeOptionsSearchCriteriaInputModel getLogTimeOptionsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryHistoryModel> GetUserStoryHistory(Guid userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoriesForAllGoalsOutputModel> GetUserStoriesForAllGoals(UserStoriesForAllGoalsSearchCriteriaInputModel userStoriesForAllGoalsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid> AmendUserStoriesDeadline(UserStoryAmendInputModel userStoryAmmendInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryApiReturnModel> SearchUserStoryDetails(UserStoryDetailsSearchInputModel userStoryDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertUserStoryTags(UserStoryTagUpsertInputModel userStoryTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryTagApiReturnModel> SearchUserStoryTags(UserStoryTagSearchInputModel userStoryTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetBugsBasedOnUserStoryApiReturnModel> GetBugsBasedOnUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveCompletedUserStories(ArchiveCompletedUserStoryInputModel archiveCompletedUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateMultipleUserStoriesGoal(UpdateMultipleUserStoriesGoalInputModel updateMultipleUserStoriesGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetUserStoriesOverviewReturnModel> GetUserStoriesOverview(
            UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        PdfGenerationOutputModel DownloadUserstories(
            UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        List<AdhocWorkApiReturnModel> GetReportsForAdhocWork(
            UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        void BuildingDescription(List<UserStoryHistoryModel> userStoryHistoryList);

        List<TemplateSearchoutputmodel> GetTemplateUserStories(TemplateSearchInputmodel templateSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        TemplateSearchoutputmodel GetTemplateUserStoryById(string templateUserStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertGoalByTemplateId(Guid? templateId, bool? isFromTemplate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string tag);
        Guid? GetTemplateIdByName(string templateName, Guid companyId);

        List<DelayedTaskDetailsModel> GetDelayedTaskDetails(string companyName, LoggedInContext loggedInContext);

        List<DelayedTaskDetailsModel> GetDelayedTaskDetailsByDelayedMinutes(string companyName, int minutes,
            LoggedInContext loggedInContext);
        List<DelayedTaskDetailsModel> GetDelayedTaskDetailsByDelayedDays(string companyName, int days,
            LoggedInContext loggedInContext);

        UserStoryTypeModel GetUserStoryTypeDetails(string companyName, string userStoryTypeName);
        void UploadworkItem(List<UserStoryUpsertInputModel> userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SprintSearchOutPutModel> GetSprintUserStories(SprintSearchInputModel sprintSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PdfGenerationOutputModel DownloadSprintUserstories(SprintSearchInputModel sprintSearchInputmodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SprintSearchOutPutModel GetSprintUserStoryById(Guid? sprintUserStoryId, string sprintUniqueName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryApiReturnModel> GetAllUserStories(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? MoveGoalUserStoryToSprint(Guid? sprintId, Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BugReportOutPutModel> GetSprintsBugReport(BugReportSearchInputModel bugReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        UpsertCronExpressionApiReturnModel UpsertRecurringUserStory(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool DeleteLinkedBug(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
