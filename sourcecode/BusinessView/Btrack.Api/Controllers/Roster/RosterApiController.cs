using Btrak.Models;
using Btrak.Models.Roster;
using Btrak.Services.Roster;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Roster
{
    public class RosterApiController : AuthTokenApiController
    {
        private readonly IRosterService _rosterService;

        public RosterApiController(IRosterService rosterService)
        {
            _rosterService = rosterService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateRosterSolutions)]
        public JsonResult<BtrakJsonResult> CreateRosterSolutions(RosterInputModel rosterInputModel)
        {   
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CreateRosterSolutions", "rosterInputModel", rosterInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object solutions = _rosterService.CreateRosterSolutions(rosterInputModel, LoggedInContext, validationMessages);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRosterSolutions", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRosterSolutions", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionCreateRosterSolutions)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateRosterPlan)]
        public JsonResult<BtrakJsonResult> CreateRosterPlan(RosterPlanInputModel rosterPlanInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CreateRosterPlan", "rosterPlanInputModel", rosterPlanInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;

                string url = Request.RequestUri.GetLeftPart(System.UriPartial.Authority);
                object solutions = _rosterService.CreateRosterPlan(rosterPlanInputModel, LoggedInContext, validationMessages, url);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRosterPlan", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateRosterPlan", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionCreateRosterPlan)
                });

                return null;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRosterPlans)]
        public JsonResult<BtrakJsonResult> GetRosterPlans(RosterSearchInputModel rosterSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRosterPlans", "rosterSearchInputModel", rosterSearchInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object solutions = _rosterService.GetRosterPlans(rosterSearchInputModel, LoggedInContext, validationMessages);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterPlans", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterPlans", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetRosterPlans)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRosterPlanByRequest)]
        public JsonResult<BtrakJsonResult> GetRosterPlanByRequest(RosterSearchInputModel rosterSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRosterPlanByRequest", "rosterSearchInputModel", rosterSearchInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object solutions = _rosterService.GetRosterPlanByRequest(rosterSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterPlanByRequest", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterPlanByRequest", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetRosterPlanByRequest)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRosterSolutionsById)]
        public JsonResult<BtrakJsonResult> GetRosterSolutionsById(RosterInputModel rosterInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRosterSolutionsById", "rosterInputModel", rosterInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object solutions= _rosterService.GetRosterSolutionsById(rosterInputModel, LoggedInContext, validationMessages);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterSolutionsById", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterSolutionsById", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetRosterSolutionsById)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CheckRosterName)]
        public JsonResult<BtrakJsonResult> CheckRosterName(RosterInputModel rosterInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CheckRosterName", "rosterInputModel", rosterInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object solutions = _rosterService.CheckRosterName(rosterInputModel, LoggedInContext, validationMessages);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CheckRosterName", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CheckRosterName", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionCheckRosterName)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRosterTemplatePlanByRequest)]
        public JsonResult<BtrakJsonResult> GetRosterTemplatePlanByRequest(RosterSearchInputModel rosterSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRosterTemplatePlanByRequest", "rosterSearchInputModel", rosterSearchInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object solutions = _rosterService.GetRosterTemplatePlanByRequest(rosterSearchInputModel, LoggedInContext, validationMessages);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterTemplatePlanByRequest", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRosterTemplatePlanByRequest", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetRosterPlans)
                });

                return null;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.LoadShiftwiseEmployeeForRoster)]
        public JsonResult<BtrakJsonResult> LoadShiftwiseEmployeeForRoster(ShiftWiseEmployeeRosterInputModel shiftWiseEmployeeRosterInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "LoadShiftwiseEmployeeForRoster", "shiftWiseEmployeeRosterInputModel", shiftWiseEmployeeRosterInputModel, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object solutions = _rosterService.LoadShiftwiseEmployeeForRoster(shiftWiseEmployeeRosterInputModel, LoggedInContext, validationMessages);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "LoadShiftwiseEmployeeForRoster", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "LoadShiftwiseEmployeeForRoster", "Roster Api"));
                return Json(new BtrakJsonResult { Data = solutions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetRosterPlans)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeRatesFromRateTags)]
        public JsonResult<BtrakJsonResult> GetEmployeeRatesFromRateTags(RosterEmployeeRatesInput rosterEmployeeRatesInput)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeRatesFromRateTags", "rosterEmployeeRatesInput", rosterEmployeeRatesInput, "Roster Api"));
                BtrakJsonResult btrakJsonResult;
                object rates = _rosterService.GetEmployeeRatesFromRateTags(rosterEmployeeRatesInput, LoggedInContext, validationMessages);
                //LoggingManager.Info("Upsert CompanyLocation is completed. Return Guid is " + companyLocationIdReturned + ", source command is " + rosterInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeRatesFromRateTags", "Roster Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeRatesFromRateTags", "Roster Api"));
                return Json(new BtrakJsonResult { Data = rates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetRosterPlans)
                });

                return null;
            }
        }

    }
}