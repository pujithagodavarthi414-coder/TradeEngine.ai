using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Services.Goals;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Goals
{
    public class GoalReplanTypeApiController : AuthTokenApiController
    {
        private readonly IGoalReplanTypeService _goalReplanTypeService;

        public GoalReplanTypeApiController(IGoalReplanTypeService goalReplanTypeService)
        {
            _goalReplanTypeService = goalReplanTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertGoalReplanType)]
        public JsonResult<BtrakJsonResult> UpsertGoalReplanType(GoalReplanTypeUpsertInputModel goalReplanTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGoalReplanType", "GoalReplanType Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? goalReplanTypeIdReturned = _goalReplanTypeService.UpsertGoalReplanType(goalReplanTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGoalReplanType", "GoalReplanType Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGoalReplanType", "GoalReplanType Api"));

                return Json(new BtrakJsonResult { Data = goalReplanTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGoalReplanType", "GoalReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllGoalReplanTypes)]
        public JsonResult<BtrakJsonResult> GetAllGoalReplanTypes(GoalReplanTypeInputModel goalReplanTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllGoalReplanTypes", "GoalReplanType Api"));

                if (goalReplanTypeInputModel == null)
                {
                    goalReplanTypeInputModel= new GoalReplanTypeInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GoalReplanTypeApiReturnModel> goalReplanTypes = _goalReplanTypeService.GetAllGoalReplanTypes(goalReplanTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllGoalReplanTypes", "GoalReplanType Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllGoalReplanTypes", "GoalReplanType Api"));

                return Json(new BtrakJsonResult { Data = goalReplanTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllGoalReplanTypes", "GoalReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetGoalReplanTypeById)]
        public JsonResult<BtrakJsonResult> GetGoalReplanTypeId(Guid? goalReplanTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGoalReplanTypeId", "GoalReplanType Api"));

                var validationMessages = new List<ValidationMessage>();

                GoalReplanTypeApiReturnModel goalReplanTypeApiReturnModel = _goalReplanTypeService.GetGoalReplanTypeById(goalReplanTypeId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGoalReplanTypeId", "GoalReplanType Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGoalReplanTypeId", "GoalReplanType Api"));

                return Json(new BtrakJsonResult { Data = goalReplanTypeApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalReplanTypeId", "GoalReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
