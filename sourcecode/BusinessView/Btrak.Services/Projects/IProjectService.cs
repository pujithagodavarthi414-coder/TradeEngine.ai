using Btrak.Models;
using Btrak.Models.Projects;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Projects
{
    public interface IProjectService
    {
        Guid? UpsertProject(ProjectUpsertInputModel projectUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProjectApiReturnModel> SearchProjects(ProjectSearchCriteriaInputModel projectSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProjectApiReturnModel GetProjectById(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProjectOverViewApiReturnModel GetProjectOverViewDetails(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProjectAndChannelApiReturnModel UpsertProjectAndChannel(ProjectUpsertInputModel projectModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveProject(ArchiveProjectInputModel archiveProjectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertProjectTags(ProjectTagUpsertInputModel projectTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProjectTagApiReturnModel> SearchProjectTags(ProjectTagSearchInputModel projectTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProjectDropDownReturnModel> GetProjectsDropDown(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CapacityPlanningReportModel> GetCapacityPlanningReport(CapacityPlanningReportModel capacityPlanningReportModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ResourceUsageReportModel> GetResourceUsageReport(ResourceUsageReportSearchInputModel resourceUsageReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProjectUsageReportModel> GetProjectUsageReport(ProjectUsageReportSearchInputModel ProjectUsageReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CumulativeWorkReportModel> GetCumulativeWorkReport(CumulativeWorkReportSearchInputModel CumulativeWorkReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}