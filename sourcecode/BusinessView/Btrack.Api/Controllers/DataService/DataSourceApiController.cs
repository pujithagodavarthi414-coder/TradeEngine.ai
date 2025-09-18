using Btrak.Models;
using Btrak.Services.FormDataServices;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.DataService
{
    public class DataSourceApiController: AuthTokenApiController
    {
        private readonly IDataSourceService _dataSourceService;

        public DataSourceApiController(IDataSourceService dataSourceService)
        {
            _dataSourceService = dataSourceService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSource)]
        public async Task<JsonResult<BtrakJsonResult>> SearchDataSource(Guid? id, string searchText, bool? isArchived)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSource", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var dataSources = await _dataSourceService.SearchDataSource(id, searchText,null, isArchived, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSource", "DataSourceController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSource", "DataSourceController"));

                return Json(new BtrakJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSource", "DataSourceController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
    }
}