using Btrak.Models;
using Btrak.Models.StatusReportingConfiguration;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.StatusReporting
{
    public interface IStatusReportingService
    {
        List<StatusReportingOptionsApiReturnModel> GetStatusConfigurationOptions(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertReportSeenStatus(StatusReportSeenUpsertInputModel reportSeenUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        StatusReportingConfigurationApiReturnModel UpsertStatusReportingConfiguration(StatusReportingConfigurationUpsertInputModel statusReportingConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StatusReportingConfigurationApiReturnModel> GetStatusReportingConfigurations(StatusReportingConfigurationSearchCriteriaInputModel statusReportingConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StatusReportingConfigurationFormApiReturnModel> GetStatusReportingConfigurationForms(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        StatusReportApiReturnModel CreateStatusReport(StatusReportUpsertInputModel statusReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StatusReportApiReturnModel> GetStatusReportings(StatusReportSearchCriteriaInputModel statusReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
