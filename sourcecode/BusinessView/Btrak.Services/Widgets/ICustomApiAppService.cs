using Btrak.Models;
using Btrak.Models.Widgets;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Btrak.Services.Widgets
{
    public interface ICustomApiAppService
    {
        Task<ApiOutputDataModel> GetApiData(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        CustomApiAppInputModel GetCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<bool> SendWidgetReportEmail(SendWidgetReportModel sendWidgetReportModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
