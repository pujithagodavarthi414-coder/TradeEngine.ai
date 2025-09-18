using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.CompanyLocation;
using Btrak.Services.CompanyLocation;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.CompanyLocation
{
    public class CompanyLocationApiController : AuthTokenApiController
    {
        private readonly ICompanyLocationService _companyLocationService;
        public CompanyLocationApiController(ICompanyLocationService companyLocationService)
        {
            _companyLocationService = companyLocationService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyLocation)]
        public JsonResult<BtrakJsonResult> UpsertCompanyLocation(CompanyLocationInputModel companyLocationInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyLocation", "companyLocationInputModel", companyLocationInputModel, "Company Location Api"));
                BtrakJsonResult btrakJsonResult;
                var companyLocationIdReturned = _companyLocationService.UpsertCompanyLocation(companyLocationInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + companyLocationInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyLocation", "Company Location Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyLocation", "Company Location Api"));
                return Json(new BtrakJsonResult { Data = companyLocationIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionUpsertCompanyLocation)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchCompanyLocation)]
        public JsonResult<BtrakJsonResult> SearchCompanyLocation(CompanyLocationInputSearchCriteriaModel companyLocationInputSearchCriteriaModel)
        {
            var validationMessages = new List<ValidationMessage>();

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCompanyLocation", "companyLocationInputSearchCriteriaModel", companyLocationInputSearchCriteriaModel, "CompanyLocation Api"));
                if (companyLocationInputSearchCriteriaModel == null)
                {
                    companyLocationInputSearchCriteriaModel = new CompanyLocationInputSearchCriteriaModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting CompanyLocation list ");
                List<CompanyLocationOutputModel> companyLocationsList = _companyLocationService.SearchCompanyLocation(companyLocationInputSearchCriteriaModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanyLocation", "CompanyLocation Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanyLocation", "CompanyLocation Api"));
                return Json(new BtrakJsonResult { Data = companyLocationsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCompanyLocation)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyLocationById)]
        public JsonResult<BtrakJsonResult> GetCompanyLocationById(Guid? locationId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyLocationById", "locationId", locationId, "CompanyLocation Api"));
                BtrakJsonResult btrakJsonResult;
                var companyLocationReturned = _companyLocationService.GetCompanyLocationById(locationId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyLocationById", "CompanyLocation Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyLocationById", "CompanyLocation Api"));
                return Json(new BtrakJsonResult { Data = companyLocationReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
           
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionCompanyLocationById)
                });
                return null;
            }
        }
    }
}
