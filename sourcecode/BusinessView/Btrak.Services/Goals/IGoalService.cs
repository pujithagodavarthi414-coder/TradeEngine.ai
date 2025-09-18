using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.UserStory;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Goals
{
    public interface IGoalService
    {
        Guid? UpsertGoal(GoalUpsertInputModel goalUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalApiReturnModel> SearchGoals(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        GoalApiReturnModel GetGoalById(string goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? isUnique);
        bool ArchiveGoal(ArchiveGoalInputModel archiveGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool ParkGoal(ParkGoalInputModel parkGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalsToArchiveApiReturnModel> GetGoalsToArchive(GoalsToArchiveSearchCriteriaInputModel goalsToArchiveSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        GoalApiReturnModel SearchGoalDetails(SearchGoalDetailsInputModel searchGoalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertGoalTags(GoalTagUpsertInputModel goalTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalTagApiReturnModel> SearchGoalTags(GoalTagSearchInputModel goalTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActivelyRunningTeamLeadOutputModel> GetActivelyRunningTeamLeadGoals(Guid? entityId,Guid? projectId, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<ActivelyRunningProjectOutputModel> GetActivelyRunningProjectGoals(Guid? entityid, Guid? projectId, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<GoalActivityWithUserStoriesOutputModel> GetGoalActivityWithUserStories(GoalActivityWithUserStoriesInputModel goalActivityWithUserStoriesInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserStoryStatusReportSearchOutputModel GetUserStoryStatusReport(UserStoryStatusReportInputModel statusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetGoalCommentsOutputModel> GetGoalComments(GoalCommnetsSearchInputModel getGoalCommnetsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertGoalComment(GoalCommentUpsertInputModel goalCommentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertGoalFilterDetails(UpsertGoalFilterModel goalFilterUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void ArchiveGoalFilter(ArchiveGoalFilterModel archiveGoalFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalFilterApiReturnModel> SearchGoalFilters(GoalFilterSerachCriterisInputModel goalFilterSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
