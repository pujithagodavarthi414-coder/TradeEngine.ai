using Btrak.Models;
using Btrak.Models.Performance;
using Btrak.Models.Probation;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Performance
{
    public interface IPerformanceService
    {
        Guid? UpsertPerformanceConfiguration(PerformanceConfigurationModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertProbationConfiguration(ProbationConfigurationModel probationConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PerformanceConfigurationOutputModel> GetPerformanceConfigurations(PerformanceConfigurationModel performanceConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProbationConfigurationOutputModel> GetProbationConfigurations(ProbationConfigurationModel probationConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPerformance(PerformanceModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PerformanceOutputModel> GetPerformances(PerformanceModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPerformanceSubmission(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isFormPdfGeneration);
        Guid? UpsertProbationSubmission(ProbationSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isFormPdfGeneration);
        Guid? UpsertPerformanceSubmissionDetails(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertProbationSubmissionDetails(ProbationSubmissionModel probationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PerformanceSubmissionOutputModel> GetPerformanceSubmissions(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProbationSubmissionOutputModel> GetProbationSubmissions(ProbationSubmissionModel probationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PerformanceSubmissionOutputModel> GetPerformanceSubmissionDetails(PerformanceSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProbationSubmissionOutputModel> GetProbationSubmissionDetails(ProbationSubmissionModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PerformanceReportModel> GetPerformanceReports(PerformanceReportModel performanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
