using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.TestRail;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.TestRailValidationHelpers;
using BTrak.Common;

namespace Btrak.Services.TestRail
{
    public class MilestoneService : IMilestoneService
    {
        private readonly TestRailPartialRepository _testRailPartialRepository;
        private readonly IAuditService _auditService;
        private readonly IOverviewService _overviewService;
        private readonly TestRailValidationHelper _testRailValidationHelper;
        private readonly TestSuiteValidationHelper _testSuiteValidationHelper;

        public MilestoneService(IAuditService auditService, TestRailPartialRepository testRailPartialRepository, IOverviewService overviewService, TestRailValidationHelper testRailValidationHelper, TestSuiteValidationHelper testSuiteValidationHelper)
        {
            _auditService = auditService;
            _testRailPartialRepository = testRailPartialRepository;
            _overviewService = overviewService;
            _testRailValidationHelper = testRailValidationHelper;
            _testSuiteValidationHelper = testSuiteValidationHelper;
        }

        public Guid? UpsertMilestone(MilestoneInputModel milestoneInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Milestone", "MilestoneInputModel", milestoneInputModel, "Milestone Service"));

            _testRailValidationHelper.UpsertMilestoneValidation(loggedInContext, validationMessages, milestoneInputModel);

            if (validationMessages.Any()) return null;

            var milestoneId = _testRailPartialRepository.UpsertMilestone(milestoneInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (milestoneId != null && milestoneId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert milestone audit saving", "Milestone Service"));

                var testRailAuditJsonModel = new TestRailAuditJsonModel
                {
                    Title = milestoneInputModel.MilestoneTitle,
                    TitleId = milestoneId,
                    Action = milestoneInputModel.MilestoneId == null ? "Created" : milestoneInputModel.IsArchived ? "Deleted"
                                                                            : milestoneInputModel.IsCompleted ? "Completed" : "Updated",
                    TabName = "Milestone",
                    ColorCode = "#bcc03f"
                };

                _overviewService.SaveTestRailAudit(testRailAuditJsonModel, loggedInContext, validationMessages);

                _auditService.SaveAudit(AppCommandConstants.UpsertMilestoneCommandId, milestoneInputModel, loggedInContext);

                LoggingManager.Debug("Milestone is created/updated successfully with the Id:" + milestoneId + " on  " + DateTime.Now.ToString());

                return milestoneId;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Milestone Failed", "Milestone Service"));

            return null;
        }

        public MilestoneApiReturnModel GetMilestoneById(Guid? milestoneId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Milestone By Id", "milestoneId", milestoneId, "Milestone Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetMilestoneByIdCommandId, milestoneId, loggedInContext);

            MilestoneSearchCriteriaInputModel milestoneSearchCriteriaInputModel = new MilestoneSearchCriteriaInputModel
            {
                MilestoneId = milestoneId
            };

            List<MilestoneApiReturnModel> milestones = _testRailPartialRepository.SearchMilestones(milestoneSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (milestones.Count > 0)
            {
                milestones[0].StartDateString = milestones[0].StartDate?.ToString("dd/MM/yyyy");

                milestones[0].EndDateString = milestones[0].EndDate?.ToString("dd/MM/yyyy");

                var milestone = milestones[0];

                if (milestone.SubMilestonesXml != null)
                {
                    milestone.SubMilestones = Utilities.GetObjectFromXml<MilestoneApiReturnModel>(milestone.SubMilestonesXml, "SubMilestones");
                }

                if (milestone.TestRunsXml != null)
                {
                    milestone.TestRuns = Utilities.GetObjectFromXml<TestRunAndPlansOverviewModel>(milestone.TestRunsXml, "TestRuns");
                }

                return milestone;
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundMilestoneWithTheId, milestoneId)
            });

            return null;
        }

        public List<MilestoneApiReturnModel> SearchMilestones(MilestoneSearchCriteriaInputModel milestoneSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Milestones", "milestoneSearchCriteriaInputModel", milestoneSearchCriteriaInputModel, "Milestone Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchMilestonesCommandId, milestoneSearchCriteriaInputModel, loggedInContext);

            List<MilestoneApiReturnModel> milestoneList = _testRailPartialRepository.SearchMilestones(milestoneSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return milestoneList;
        }

        public int? GetOpenMilestoneCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Open Milestone Count", "ProjectId", projectId, "Milestone Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetOpenMilestoneCountCommandId, projectId, loggedInContext);

            return GetMilestoneCount(projectId, loggedInContext, false, validationMessages);

        }

        public int? GetCompletedMilestoneCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Completed Milestone Count", "projectId", projectId, "Milestone Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCompletedMilestoneCountCommandId, projectId, loggedInContext);

            return GetMilestoneCount(projectId, loggedInContext, true, validationMessages);
        }

        private int? GetMilestoneCount(Guid projectId, LoggedInContext loggedInContext, bool isCompleted, List<ValidationMessage> validationMessages)
        {
            var milestoneSearchInputCriteriaModel = new MilestoneSearchCriteriaInputModel
            {
                PageSize = 10,
                PageNumber = 1,
                IsCompleted = isCompleted,
                ProjectId = projectId
            };

            var milestones = _testRailPartialRepository.SearchMilestones(milestoneSearchInputCriteriaModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (milestones.Count > 0)
                return milestones[0].TotalCount;

            return 0;
        }

        public ReportModel GetMilestoneReport(Guid milestoneId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Milestone Report", "MilestoneId", milestoneId, "Milestone Service"));

            _testRailValidationHelper.ValidateMilestoneId(loggedInContext, validationMessages, milestoneId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetMilestoneReportByIdCommandId, milestoneId, loggedInContext);

            ReportModel milestoneReport = _testRailPartialRepository.GetMilestoneReport(milestoneId, loggedInContext, validationMessages);

            milestoneReport.PassedPercent = milestoneReport.PassedCount / milestoneReport.TotalCount * 100;
            milestoneReport.FailedPercent = milestoneReport.FailedCount / milestoneReport.TotalCount * 100;
            milestoneReport.BlockedPercent = milestoneReport.BlockedCount / milestoneReport.TotalCount * 100;
            milestoneReport.UntestedPercent = milestoneReport.UntestedCount / milestoneReport.TotalCount * 100;
            milestoneReport.RetestPercent = milestoneReport.RetestCount / milestoneReport.TotalCount * 100;

            return milestoneReport;
        }

        public List<DropdownModel> GetMilestoneDropdownList(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Milestone Dropdown List", "ProjectId", projectId, "Milestone Service"));


            _auditService.SaveAudit(AppCommandConstants.GetMilestoneDropdownListCommandId, projectId, loggedInContext);

            MilestoneSearchCriteriaInputModel milestoneSearchCriteriaInputModel = new MilestoneSearchCriteriaInputModel
            {
                ProjectId = projectId,
                IsArchived = false,
                IsCompleted = false,
                IsForDropdown = true
            };

            List<DropdownModel> milestones = _testRailPartialRepository.GetMilestoneDropdownList(milestoneSearchCriteriaInputModel, loggedInContext, validationMessages);

            //List<MilestoneApiReturnModel> milestoneDropdown = milestones.Where(x => x.ParentMileStoneId == null).ToList();

            //List<DropdownModel> milestoneDropdownList = milestones.Select(x => new DropdownModel { Id = x.MilestoneId, Value = x.MilestoneTitle }).ToList();

            return milestones;
        }

        public Guid? DeleteMilestone(MilestoneInputModel milestoneInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Milestone", "MilestoneInputModel", milestoneInputModel, "Milestone Service"));

            _testSuiteValidationHelper.MilestoneIdValidation(milestoneInputModel.MilestoneId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.DeleteMilestoneCommandId, milestoneInputModel.MilestoneId, loggedInContext);

            var returnMilestoneId = _testRailPartialRepository.DeleteMilestone(milestoneInputModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : returnMilestoneId;
        }
    }
}
