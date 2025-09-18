using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;

namespace Btrak.Services.TestRail
{
    public interface IMilestoneService
    {
        Guid? UpsertMilestone(MilestoneInputModel milestoneInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        MilestoneApiReturnModel GetMilestoneById(Guid? milestoneId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MilestoneApiReturnModel> SearchMilestones(MilestoneSearchCriteriaInputModel milestoneSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetOpenMilestoneCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetCompletedMilestoneCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetMilestoneDropdownList(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ReportModel GetMilestoneReport(Guid milestoneId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteMilestone(MilestoneInputModel milestoneInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}