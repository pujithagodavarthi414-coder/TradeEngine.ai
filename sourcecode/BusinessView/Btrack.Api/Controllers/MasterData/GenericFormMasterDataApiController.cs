using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Models.Performance;
using Btrak.Services.MasterData;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.MasterData
{
    public class GenericFormMasterDataApiController : AuthTokenApiController
    {
        private readonly IGenericFormMasterDataService _genericFormMasterDataService;

        public GenericFormMasterDataApiController(IGenericFormMasterDataService genericFormMasterDataService)
        {
            _genericFormMasterDataService = genericFormMasterDataService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertGenericFormType)]
        public JsonResult<BtrakJsonResult> UpsertGenericFormType(GenericFormTypeUpsertModel genericFormTypeUpsertModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Generic Form Tyep", "genericFormTypeUpsertModel", genericFormTypeUpsertModel, "GenericFormMasterData Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? formTypeIdReturned = _genericFormMasterDataService.UpsertGenericFormType(genericFormTypeUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Generic Form Type", "GenericFormMasterData Api "));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Generic Form Type", "GenericFormMasterData Api"));

                return Json(new BtrakJsonResult { Data = formTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericFormType", "GenericFormMasterDataApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetGenericFormTypes)]
        public JsonResult<BtrakJsonResult> GetGenericFormTypes(GetGenericFormTypesSearchCriteriaInputModel getFormTypesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGenericFormTypes", "getFormTypesSearchCriteriaInputModel", getFormTypesSearchCriteriaInputModel, "GenericFormMasterData Api"));
                if (getFormTypesSearchCriteriaInputModel == null)
                {
                    getFormTypesSearchCriteriaInputModel = new GetGenericFormTypesSearchCriteriaInputModel();
                }
                LoggingManager.Info("Getting Generic Form Type list");
                List<GetGenericFormTypesOutputModel> genericFormTypesList = _genericFormMasterDataService.GetGenericFormTypes(getFormTypesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Generic Form Type", "GenericFormMasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Generic Form Type", "GenericFormMasterData Api"));
                return Json(new BtrakJsonResult { Data = genericFormTypesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetFormTypes)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomFormSubmission)]
        public JsonResult<BtrakJsonResult> UpsertCustomFormSubmission(CustomFormSubmissionUpsertModel customFormTypeUpsertModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Custom Form", "customFormTypeUpsertModel", customFormTypeUpsertModel, "GenericFormMasterData Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? formTypeIdReturned = _genericFormMasterDataService.UpsertCustomFormSubmission(customFormTypeUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Custom Form", "GenericFormMasterData Api "));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Custom Form", "GenericFormMasterData Api"));

                return Json(new BtrakJsonResult { Data = formTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomFormSubmission", "GenericFormMasterDataApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomFormSubmissions)]
        public JsonResult<BtrakJsonResult> GetCustomFormSubmissions(CustomFormSubmissionSearchCriteriaInputModel customFormTypeSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCustomFormTypes", "customFormTypeSearchCriteriaInputModel", customFormTypeSearchCriteriaInputModel, "GenericFormMasterData Api"));
                if (customFormTypeSearchCriteriaInputModel == null)
                {
                    customFormTypeSearchCriteriaInputModel = new CustomFormSubmissionSearchCriteriaInputModel();
                }
                LoggingManager.Info("Getting Custom Form Type list");
                List<GetCustomFormSubmissionOutputModel> customFormList = _genericFormMasterDataService.GetCustomFormSubmissions(customFormTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Custom Form", "GenericFormMasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Custom Form", "GenericFormMasterData Api"));
                return Json(new BtrakJsonResult { Data = customFormList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetCustomFormSubmissions)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInductionConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertInductionConfiguration(InductionModel inductionModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertInductionConfiguration", "inductionModel", inductionModel, "GenericFormMasterData Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? formTypeIdReturned = _genericFormMasterDataService.UpsertInductionConfiguration(inductionModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInductionConfiguration", "GenericFormMasterData Api "));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInductionConfiguration", "GenericFormMasterData Api"));

                return Json(new BtrakJsonResult { Data = formTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInductionConfiguration", "GenericFormMasterDataApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInductionConfigurations)]
        public JsonResult<BtrakJsonResult> GetInductionConfigurations(InductionModel inductionModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetInductionConfigurations", "inductionModel", inductionModel, "GenericFormMasterData Api"));

                List<InductionModel> inductionList = _genericFormMasterDataService.GetInductionConfigurations(inductionModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInductionConfigurations", "GenericFormMasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInductionConfigurations", "GenericFormMasterData Api"));
                return Json(new BtrakJsonResult { Data = inductionList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetInductionConfigurations)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeInductions)]
        public JsonResult<BtrakJsonResult> GetEmployeeInductions(EmployeeInductionModel inductionModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeInductions", "inductionModel", inductionModel, "GenericFormMasterData Api"));

                List<EmployeeInductionModel> inductionList = _genericFormMasterDataService.GetEmployeeInductions(inductionModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeInductions", "GenericFormMasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeInductions", "GenericFormMasterData Api"));
                return Json(new BtrakJsonResult { Data = inductionList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetInductionConfigurations)
                });


                return null;
            }
        }


       
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExitConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertExitConfiguration(ExitModel exitModel)
        {
            if (exitModel != null)
            {
                BtrakJsonResult btrakJsonResult;
                try
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertExitConfiguration", "exitModel", exitModel, "GenericFormMasterData Api"));

                    var validationMessages = new List<ValidationMessage>();

                    Guid? formTypeIdReturned = _genericFormMasterDataService.UpsertExitConfiguration(exitModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExitConfiguration", "GenericFormMasterData Api "));
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExitConfiguration", "GenericFormMasterData Api"));

                    return Json(new BtrakJsonResult { Data = formTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExitConfiguration", "GenericFormMasterDataApiController ", exception.Message), exception);


                    return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
                }
            }
            return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }
       
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetExitConfigurations)]
        public JsonResult<BtrakJsonResult> GetExitConfigurations(ExitModel exitModel)
        {
            if (exitModel != null)
            {
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                try
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetExitConfigurations", "inductionModel", exitModel, "GenericFormMasterData Api"));

                    List<ExitModel> exitList = _genericFormMasterDataService.GetExitConfigurations(exitModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExitConfigurations", "GenericFormMasterData Api"));
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExitConfigurations", "GenericFormMasterData Api"));
                    return Json(new BtrakJsonResult { Data = exitList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                catch (SqlException sqlEx)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetInductionConfigurations)
                    });

                    return null;
                }
            }
            return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeExits)]
        public JsonResult<BtrakJsonResult> GetEmployeeExits(EmployeeExitModel exitModel)
        {
            if (exitModel != null)
            {
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                try
                {
                    
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeExits", "inductionModel", exitModel, "GenericFormMasterData Api"));

                    List<EmployeeExitModel> exitList = _genericFormMasterDataService.GetEmployeeExits(exitModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeExits", "GenericFormMasterData Api"));
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeExits", "GenericFormMasterData Api"));
                    return Json(new BtrakJsonResult { Data = exitList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                catch (SqlException sqlEx)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetInductionConfigurations)
                    });

                    return null;
                }
            }
            return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }

       
    }
}