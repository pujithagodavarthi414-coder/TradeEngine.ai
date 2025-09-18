using Btrak.Models;
using Btrak.Services.LeaveType;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models.LeaveType;
using Btrak.Models.LeaveManagement;
using Btrak.Models.MasterData;

namespace BTrak.Api.Controllers.LeaveType
{
    public class LeaveTypeApiController : AuthTokenApiController
    {
        private readonly ILeaveTypeService _leaveTypeService;
        public LeaveTypeApiController(ILeaveTypeService leaveTypeService)
        {
            _leaveTypeService = leaveTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaveType)]
        public JsonResult<BtrakJsonResult> UpsertLeaveType(LeaveTypeInputModel leaveTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLeaveType", "LeaveType Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? leaveTypeIdReturned = _leaveTypeService.UpsertLeaveType(leaveTypeInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("LeaveType Upsert is completed. Return Guid is " + leaveTypeIdReturned + ", source command is " + leaveTypeInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveType", "LeaveTypeApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveType", "LeaveTypeApiController"));
                return Json(new BtrakJsonResult { Data = leaveTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveType", "LeaveTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllLeaveTypes)]
        public JsonResult<BtrakJsonResult> GetAllLeaveTypes(LeaveTypeSearchCriteriaInputModel leaveTypeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLeaveTypes", "LeaveType Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<LeaveFrequencySearchOutputModel> leaveTypeModels = _leaveTypeService.GetAllLeaveTypes(leaveTypeSearchCriteriaInputModel,LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllLeaveTypes Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = leaveTypeModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLeaveTypes", "LeaveTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveTypeById)]
        public JsonResult<BtrakJsonResult> GetLeaveTypeById(Guid? leaveTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveTypeById", "LeaveType Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                LeaveFrequencySearchOutputModel leaveTypeModel = _leaveTypeService.GetLeaveTypeById(leaveTypeId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveTypeById Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = leaveTypeModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveTypeById", "LeaveTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMasterLeaveTypes)]
        public JsonResult<BtrakJsonResult> GetMasterLeaveTypes()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMasterLeaveTypes", "LeaveType Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<MasterLeaveTypeSearchOutputModel> masterLeaveTypeModel = _leaveTypeService.GetMasterLeaveTypes(LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveTypeById Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = masterLeaveTypeModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMasterLeaveTypes", "LeaveTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
