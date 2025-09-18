using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.Widgets;

namespace Btrak.Services.SystemConfiguration
{
    public interface ISystemConfigurationService
    {
        SystemConfigurationModel ExportSystemConfiguration(SystemExportInputModel systemExportInputModel,LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages, string siteAddress);

        string ImportSystemConfiguration(SystemConfigurationModel configuredData, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
    }
}