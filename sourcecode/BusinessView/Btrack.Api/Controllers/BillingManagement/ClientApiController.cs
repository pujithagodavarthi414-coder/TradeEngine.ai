using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Services.BillingManagement;
using System.Web;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Models;

namespace BTrak.Api.Controllers.BillingManagement
{
    public class ClientApiController : AuthTokenApiController
    {
        private readonly IClientService _clientService;

        public ClientApiController(IClientService clientService)
        {
            _clientService = clientService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertClient)]
        public JsonResult<BtrakJsonResult> UpsertClient(UpsertClientInputModel upsertClientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClient", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertClientInputModel == null)
                {
                    upsertClientInputModel = new UpsertClientInputModel();
                }

                upsertClientInputModel.RoleIds = (upsertClientInputModel.RoleId != null && upsertClientInputModel.RoleId.Count > 0) ? string.Join(",", upsertClientInputModel.RoleId) : null;
                upsertClientInputModel.ContractTemplateIds = (upsertClientInputModel.ContractTemplateId != null && upsertClientInputModel.ContractTemplateId.Count > 0) ? string.Join(",", upsertClientInputModel.ContractTemplateId) : null;
                upsertClientInputModel.TradeTemplateIds = (upsertClientInputModel.TradeTemplateId != null && upsertClientInputModel.TradeTemplateId.Count > 0) ? string.Join(",", upsertClientInputModel.TradeTemplateId) : null;
                Guid? clients = null;
                if (upsertClientInputModel.IsSavingContractTemplates == true || upsertClientInputModel.IsSavingTradeTemplates == true)
                {
                    clients = _clientService.UpdateClientContractTemplates(upsertClientInputModel, LoggedInContext, validationMessages);
                } 
                else
                {
                    clients = _clientService.UpsertClient(upsertClientInputModel, LoggedInContext, validationMessages).Result;
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClient", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClient", "Client Api"));
                return Json(new BtrakJsonResult { Data = clients, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClient", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertClient), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReSendKycEmail)]
        public async Task<JsonResult<BtrakJsonResult>> ReSendKycEmailAsync(UpsertClientInputModel upsertClientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReSendKycEmail", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertClientInputModel == null)
                {
                    upsertClientInputModel = new UpsertClientInputModel();
                }

                Guid? clients = null;
                clients = await _clientService.ReSendKycEmail(upsertClientInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReSendKycEmail", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReSendKycEmail", "Client Api"));
                return Json(new BtrakJsonResult { Data = clients, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReSendKycEmail", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertClient), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetClients)]
        public JsonResult<BtrakJsonResult> GetClients(ClientInputModel clientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClients", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ClientOutputModel> clientList = _clientService.GetClients(clientInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClients", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClients", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClients", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UpsertSCOStatus)]
        public JsonResult<BtrakJsonResult> UpsertSCOStatus(LeadSubmissionsDetails leadSubmission)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSCOStatus", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if(leadSubmission == null)
                {
                    leadSubmission = new LeadSubmissionsDetails();
                }

                Guid? LeadFormReturnId = _clientService.UpsertSCOStatus(leadSubmission, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSCOStatus", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSCOStatus", "Client Api"));
                return Json(new BtrakJsonResult { Data = LeadFormReturnId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSCOStatus", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetScoGenerationById)]
        public JsonResult<BtrakJsonResult> GetScoGenerationById(Guid LeadSubmissionId, Guid? ScoId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSCOGenerations", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                SCOGenerationSerachInputModel sCOGenerationSerachInputModel = new SCOGenerationSerachInputModel();
                sCOGenerationSerachInputModel.LeadSubmissionId = LeadSubmissionId;
                sCOGenerationSerachInputModel.ScoId = ScoId;

                List<SCOGenerationsOutputModel> clientList = _clientService.GetScoGenerationById(sCOGenerationSerachInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSCOGenerations", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSCOGenerations", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSCOGenerations", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSCO)]
        public async Task<JsonResult<BtrakJsonResult>> UpsertSCO(UpsertClientInputModel upsertClientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSCO", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertClientInputModel == null)
                {
                    upsertClientInputModel = new UpsertClientInputModel();
                }

                string pdfurl = await _clientService.UpsertSCOMailToClient(upsertClientInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSCO", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSCO", "Client Api"));
                return Json(new BtrakJsonResult { Data = pdfurl, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClient", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertClient), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertClientSecondaryContact)]
        public JsonResult<BtrakJsonResult> UpsertClientSecondaryContact(UpsertClientSecondaryContactModel upsertClientSecondaryContactModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClientSecondaryContact", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertClientSecondaryContactModel == null)
                {
                    upsertClientSecondaryContactModel = new UpsertClientSecondaryContactModel();
                }

                upsertClientSecondaryContactModel.RoleIds = string.Join(",", upsertClientSecondaryContactModel.RoleId);

                Guid? clientSecondaryContacts = _clientService.UpsertClientSecondaryContact(upsertClientSecondaryContactModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientSecondaryContact", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientSecondaryContact", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientSecondaryContacts, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientSecondaryContact", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertClientSecondaryContact), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetClientSecondaryContacts)]
        public JsonResult<BtrakJsonResult> GetClientSecondaryContacts(ClientSecondaryContactsInputModel clientSecondaryContactsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClients", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ClientSecondaryContactOutputModel> clientSecondaryContactList = _clientService.GetClientSecondaryContacts(clientSecondaryContactsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientSecondaryContacts", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientSecondaryContacts", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientSecondaryContactList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientSecondaryContacts", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClientSecondaryContacts), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.MultipleClientDelete)]
        public JsonResult<BtrakJsonResult> MultipleClientDelete(MultipleClientDeleteModel multipleClientDeleteModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "MultipleClientDelete", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<Guid?> multipleClientDeleted = _clientService.MultipleClientDelete(multipleClientDeleteModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MultipleClientDelete", "Client Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MultipleClientDelete", "Client Api"));
                return Json(new BtrakJsonResult { Data = multipleClientDeleted, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MultipleClientDelete", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionMultipleClientDelete), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetClientHistory)]
        public JsonResult<BtrakJsonResult> GetClientHistory(ClientHistoryModel clientHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientHistory", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ClientHistoryModel> clientHistory = _clientService.GetClientHistory(clientHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientHistory", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientHistory", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientHistory", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClientHistory), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertClientProjects)]
        public JsonResult<BtrakJsonResult> UpsertClientProjects(UpsertClientProjectsModel upsertClientProjectsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClientProjects", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertClientProjectsModel == null)
                {
                    upsertClientProjectsModel = new UpsertClientProjectsModel();
                }

                Guid? clientProjects = _clientService.UpsertClientProjects(upsertClientProjectsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientProjects", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientProjects", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientProjects, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientProjects", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertClientProjects), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetClientProjects)]
        public JsonResult<BtrakJsonResult> GetClientProjects(ClientProjectsInputModel clientProjectsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientProjects", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ClientProjectsOutputModel> clientProjects = _clientService.GetClientProjects(clientProjectsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientProjects", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientProjects", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientProjects, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientProjects", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClientProjects), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertClientKycConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertClientKycConfiguration(ClientKycConfiguration kycConfiguration)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClientKycConfiguration", "ClientKyc Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? performanceConfigurationId = _clientService.UpsertClientKycConfiguration(kycConfiguration, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientKycConfiguration", "ClientKyc Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientKycConfiguration", "ClientKyc Api"));

                return Json(new BtrakJsonResult { Data = performanceConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPerformanceConfiguration", "PerformanceApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetClientKycConfiguration)]
        public JsonResult<BtrakJsonResult> GetClientKycConfiguration(ClientKycConfiguration kycConfiguration)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPerformanceConfigurations", "Performance Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<ClientKycConfigurationOutputModel> performanceConfigurations = _clientService.GetClientKycConfiguration(kycConfiguration, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientKycConfiguration", "Kyc Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientKycConfiguration", "Kyc Api"));

                return Json(new BtrakJsonResult { Data = performanceConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientKycConfiguration", "KycApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetClientTypes)]
        public JsonResult<BtrakJsonResult> GetClientTypes(ClientInputModel clientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientTypes", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ClientTypeOutputModel> clientList = _clientService.GetClientTypes(clientInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientTypes", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientTypes", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientTypes", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClientTypes), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetClientTypesBasedOnRoles)]
        public JsonResult<BtrakJsonResult> GetClientTypesBasedOnRoles()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetClientTypesBasedOnRoles", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ClientTypeOutputModel> clientList = _clientService.GetClientTypesBasedOnRoles(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientTypesBasedOnRoles", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetClientTypesBasedOnRoles", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientTypesBasedOnRoles", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClientTypes), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertClientType)]
        public JsonResult<BtrakJsonResult> UpsertClientType(ClientTypeUpsertInputModel clientTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClientType", "ClientApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? clientTypeId = _clientService.UpsertClientType(clientTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientType", "ClientApiController"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientType", "ClientApiController"));

                return Json(new BtrakJsonResult { Data = clientTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientType", "ClientApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReorderClientType)]
        public JsonResult<BtrakJsonResult> ReOrderClientTypes(ClientTypeUpsertInputModel clientTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReorderClientType", "ClientApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? clientTypeId = _clientService.ReOrderClientType(clientTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderClientType", "ClientApiController"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderClientType", "ClientApiController"));

                return Json(new BtrakJsonResult { Data = clientTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderClientType", "ClientApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetShipToAddresses)]
        public JsonResult<BtrakJsonResult> GetShipToAddresses(ShipToAddressSearchInputModel shipToAddressSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipToAddresses", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ShipToAddressSearchOutputModel> shpToAddressList = _clientService.GetShipToAddresses(shipToAddressSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipToAddresses", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipToAddresses", "Client Api"));
                return Json(new BtrakJsonResult { Data = shpToAddressList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipToAddresses", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClientTypes), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertShipToAddress)]
        public JsonResult<BtrakJsonResult> UpsertShipToAddress(ShipToAddressUpsertInputModel shipToAddressUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertShipToAddress", "ClientApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? shipToAddressId = _clientService.UpsertShipToAddress(shipToAddressUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShipToAddress", "ClientApiController"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShipToAddress", "ClientApiController"));

                return Json(new BtrakJsonResult { Data = shipToAddressId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertClientType", "ClientApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPurchaseConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertPurchaseConfiguration(PurchaseConfigInputModel purchaseConfiguration)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertClientKycConfiguration", "ClientKyc Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? performanceConfigurationId = _clientService.UpsertPurchaseConfiguration(purchaseConfiguration, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientKycConfiguration", "ClientKyc Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertClientKycConfiguration", "ClientKyc Api"));

                return Json(new BtrakJsonResult { Data = performanceConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPerformanceConfiguration", "PerformanceApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPurchaseConfiguration)]
        public JsonResult<BtrakJsonResult> GetPurchaseConfiguration(PurchaseConfigInputModel purchaseConfiguration)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPurchaseConfiguration", "Performance Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<PurchaseConfigOutputModel> performanceConfigurations = _clientService.GetPurchaseConfiguration(purchaseConfiguration, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPurchaseConfiguration", "Kyc Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPurchaseConfiguration", "Kyc Api"));

                return Json(new BtrakJsonResult { Data = performanceConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPurchaseConfiguration", "KycApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetContractSubmissions)]
        public JsonResult<BtrakJsonResult> GetContractSubmissions(ContractSubmissionDetails clientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ContractSubmissionDetails", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ContractSubmissionDetails> clientList = _clientService.GetContractSubmissions(clientInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ContractSubmissionDetails", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ContractSubmissionDetails", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ContractSubmissionDetails", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSCOGenerations)]
        public JsonResult<BtrakJsonResult> GetSCOGenerations(SCOGenerationSerachInputModel sCOGenerationSerachInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSCOGenerations", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<SCOGenerationsOutputModel> clientList = _clientService.GetSCOGenerations(sCOGenerationSerachInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSCOGenerations", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSCOGenerations", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSCOGenerations", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSCOGeneration)]
        public JsonResult<BtrakJsonResult> UpsertSCOGeneration(SCOUpsertInputModel sCOUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSCOGeneration", "Client Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? Id = _clientService.UpsertSCOGeneration(sCOUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSCOGeneration", "Client Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSCOGeneration", "Client Api"));

                return Json(new BtrakJsonResult { Data = Id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSCOGeneration", "Client Api ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendSCOAcceptanceMail)]
        public async Task<JsonResult<BtrakJsonResult>> SendSCOAcceptanceMail(List<SendSCOAcceptanceMailInputModel> sendSCOAcceptanceMailInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendSCOAcceptanceMail", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string pdfUrl = await _clientService.SendSCOAcceptanceMail(sendSCOAcceptanceMailInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendSCOAcceptanceMail", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendSCOAcceptanceMail", "Client Api"));

                return Json(new BtrakJsonResult { Data = pdfUrl, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadOrSendPdfInvoice", "Client Api", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProductList)]
        public JsonResult<BtrakJsonResult> UpsertProductList(MasterProduct masterProductModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert master Product", "masterProductModel", masterProductModel, "Upsert master Produc"));

                var validationMessages = new List<ValidationMessage>();

                Guid? id = _clientService.UpsertProductList(masterProductModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert master Product", "UpsertProductList Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Product List", "UpsertProductList Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProductList", "client api  ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProductsList)]
        public JsonResult<BtrakJsonResult> GetProductsList(MasterProduct masterProductSerachInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProductsList", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ProductListOutPutModel> clientList = _clientService.GetProductsList(masterProductSerachInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProductsList", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProductsList", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductsList", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMasterContractDetails)]
        public JsonResult<BtrakJsonResult> GetMasterContractDetails(MasterContractInputModel clientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ContractSubmissionDetails", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<MasterContractOutputModel> clientList = _clientService.GetMasterContractDetails(clientInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ContractSubmissionDetails", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ContractSubmissionDetails", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ContractSubmissionDetails", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMasterContractDetails)]
        public JsonResult<BtrakJsonResult> UpsertMasterContractDetails(MasterContractInputModel masterContractModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert master Product", "masterProductModel", masterContractModel, "Upsert master Produc"));

                var validationMessages = new List<ValidationMessage>();

                Guid? id = _clientService.UpsertMasterContractDetails(masterContractModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert master Product", "UpsertProductList Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Product List", "UpsertProductList Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProductList", "client api  ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertGrades)]
        public JsonResult<BtrakJsonResult> UpsertGrades(GradeInputModel gradeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGrade", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertGrades(gradeInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGrade", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGrade", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGrade", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllGrades)]
        public JsonResult<BtrakJsonResult> GetAllGrades(GradeInputModel gradeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllGrades", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<GradeOutputModel> grades = _clientService.GetAllGrades(gradeInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllGrades", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllGrades", "Client Api"));

                return Json(new BtrakJsonResult { Data = grades, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllGrades", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }        
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllCreditLogs)]
        public JsonResult<BtrakJsonResult> GetAllCreditLogs(CreditLimitLogsModel creditLimitLogsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllCreditLogs", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<CreditLimitLogsModel> grades = _clientService.GetAllCreditLogs(creditLimitLogsModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllCreditLogs", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllCreditLogs", "Client Api"));

                return Json(new BtrakJsonResult { Data = grades, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllCreditLogs", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWareHoseUsers)]
        public JsonResult<BtrakJsonResult> GetWareHoseUsers()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWareHoseUsers", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<UserDbEntity> users = _clientService.GetWareHoseUsers(LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWareHoseUsers", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWareHoseUsers", "Client Api"));

                return Json(new BtrakJsonResult { Data = users, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWareHoseUsers", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPurchaseContract)]
        public JsonResult<BtrakJsonResult> GetPurchaseContract(MasterContractInputModel clientInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPurchaseContract", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<MasterContractOutputModel> purchasesList = _clientService.GetPurchaseContract(clientInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPurchaseContract", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPurchaseContract", "Client Api"));
                return Json(new BtrakJsonResult { Data = purchasesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPurchaseContract", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPurchaseContract)]
        public JsonResult<BtrakJsonResult> UpsertPurchaseContract(MasterContractInputModel masterContractModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPurchaseContract", "masterProductModel", masterContractModel, "UpsertPurchaseContract"));

                var validationMessages = new List<ValidationMessage>();

                Guid? id = _clientService.UpsertPurchaseContract(masterContractModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPurchaseContract", "UpsertProductList Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPurchaseContract", "UpsertProductList Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPurchaseContract", "client api  ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetShipmentExecutions)]
        public JsonResult<BtrakJsonResult> GetShipmentExecutions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipmentExecutions", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<PurchaseShipmentExecutionSearchOutputModel> purchasesList = _clientService.GetShipmentExecutions(purchaseShipmentExecutionSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipmentExecutions", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipmentExecutions", "Client Api"));
                return Json(new BtrakJsonResult { Data = purchasesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipmentExecutions", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertShipmentExecutions)]
        public JsonResult<BtrakJsonResult> UpsertShipmentExecutions(PurchaseShipmentExecutionInputModel purchaseShipmentExecutionInputModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShipmentExecutions", "purchaseShipmentExecutionInputModel", purchaseShipmentExecutionInputModel, "UpsertShipmentExecutions"));

                var validationMessages = new List<ValidationMessage>();

                Guid? id = _clientService.UpsertShipmentExecutions(purchaseShipmentExecutionInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShipmentExecutions", "client Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShipmentExecutions", "client Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShipmentExecutions", "client api  ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetShipmentExecutionBLs)]
        public JsonResult<BtrakJsonResult> GetShipmentExecutionBLs(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipmentExecutionBLs", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<PurchaseShipmentExecutionBLSearchOutputModel> purchaseBLsList = _clientService.GetShipmentExecutionBLs(purchaseShipmentExecutionSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipmentExecutionBLs", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipmentExecutionBLs", "Client Api"));
                return Json(new BtrakJsonResult { Data = purchaseBLsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipmentExecutionBLs", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetShipmentExecutionBLById)]
        public JsonResult<BtrakJsonResult> GetShipmentExecutionBLById(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShipmentExecutionBLById", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                PurchaseShipmentExecutionBLSearchOutputModel purchaseBL = _clientService.GetShipmentExecutionBLById(purchaseShipmentExecutionSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipmentExecutionBLById", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShipmentExecutionBLById", "Client Api"));
                return Json(new BtrakJsonResult { Data = purchaseBL, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShipmentExecutionBLs", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertShipmentExecutionBL)]
        public async Task<JsonResult<BtrakJsonResult>> UpsertShipmentExecutionBL(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShipmentExecutionBL", "purchaseShipmentExecutionBLInputModel", purchaseShipmentExecutionBLInputModel, "UpsertShipmentExecutions"));

                var validationMessages = new List<ValidationMessage>();

                Guid? id = await _clientService.UpsertShipmentExecutionBL(purchaseShipmentExecutionBLInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShipmentExecutionBL", "client Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShipmentExecutionBL", "client Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShipmentExecutionBL", "client api  ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBlDescription)]
        public JsonResult<BtrakJsonResult> UpsertBlDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertBlDescription", "purchaseShipmentExecutionBLInputModel", purchaseShipmentExecutionBLInputModel, "UpsertShipmentExecutions"));

                var validationMessages = new List<ValidationMessage>();

                Guid? id = _clientService.UpsertBlDescription(purchaseShipmentExecutionBLInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBlDescription", "client Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBlDescription", "client Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBlDescription", "client api  ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBlDescriptions)]
        public JsonResult<BtrakJsonResult> GetBlDescriptions(PurchaseShipmentExecutionSearchInputModel purchaseShipmentExecutionSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBlDescriptions", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                PurchaseShipmentExecutionBLSearchOutputModel purchaseBL = _clientService.GetBlDescriptions(purchaseShipmentExecutionSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBlDescriptions", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBlDescriptions", "Client Api"));
                return Json(new BtrakJsonResult { Data = purchaseBL, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBlDescriptions", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDocumentsDescription)]
        public JsonResult<BtrakJsonResult> UpsertDocumentsDescription(PurchaseShipmentExecutionBLInputModel purchaseShipmentExecutionBLInputModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDocumentsDescription", "purchaseShipmentExecutionBLInputModel", purchaseShipmentExecutionBLInputModel, "UpsertShipmentExecutions"));

                var validationMessages = new List<ValidationMessage>();

                Guid? id = _clientService.UpsertDocumentsDescription(purchaseShipmentExecutionBLInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDocumentsDescription", "client Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDocumentsDescription", "client Api"));

                return Json(new BtrakJsonResult { Data = id, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDocumentsDescription", "client api  ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDocumentsDescriptions)]
        public JsonResult<BtrakJsonResult> GetDocumentsDescriptions(Guid referenceTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDocumentsDescriptions", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                PurchaseShipmentExecutionBLSearchOutputModel purchaseBL = _clientService.GetDocumentsDescriptions(referenceTypeId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentsDescriptions", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentsDescriptions", "Client Api"));
                return Json(new BtrakJsonResult { Data = purchaseBL, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDocumentsDescriptions", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertVessels)]
        public JsonResult<BtrakJsonResult> UpsertVessels(VesselModel vesselModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertVessels", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertVessels(vesselModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertVessels", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertVessels", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertVessels", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllVessels)]
        public JsonResult<BtrakJsonResult> GetAllVessels(VesselModel vesselModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllVessels", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<VesselModel> grades = _clientService.GetAllVessels(vesselModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllVessels", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllVessels", "Client Api"));

                return Json(new BtrakJsonResult { Data = grades, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllVessels", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendChaConfirmationMail)]
        public JsonResult<BtrakJsonResult> SendChaConfirmationMail(PurchaseShipmentExecutionBLInputModel PurchaseShipmentExecutionBLInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "PurchaseShipmentExecutionBLInputModel", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? ChaId = _clientService.SendChaConfirmationMail(PurchaseShipmentExecutionBLInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendChaConfirmationMail", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendChaConfirmationMail", "Client Api"));

                return Json(new BtrakJsonResult { Data = ChaId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendChaConfirmationMail", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLegalEntity)]
        public JsonResult<BtrakJsonResult> UpsertLegalEntity(LegalEntityModel legalEntityModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLegalEntity", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertLegalEntity(legalEntityModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLegalEntity", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLegalEntity", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLegalEntity", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllLegalEntities)]
        public JsonResult<BtrakJsonResult> GetAllLegalEntities(LegalEntityModel getAllLegalEntitys)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLegalEntitys", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<LegalEntityModel> LegalEntities = _clientService.GetAllLegalEntities(getAllLegalEntitys, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllLegalEntitys", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllLegalEntitys", "Client Api"));

                return Json(new BtrakJsonResult { Data = LegalEntities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLegalEntitys", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetClientKycDetails)]
        public JsonResult<BtrakJsonResult> GetClientKycDetails(Guid clientId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSCOGenerations", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                ClientInputModel clientInputModel = new ClientInputModel();
                clientInputModel.ClientId = clientId;

                List<ClientOutputModel> clientList = _clientService.GetClientKycDetails(clientInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSCOGenerations", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSCOGenerations", "Client Api"));
                return Json(new BtrakJsonResult { Data = clientList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSCOGenerations", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UpsertKycDetails)]
        public JsonResult<BtrakJsonResult> UpsertKycDetails(ClientKycSubmissionDetails ClientKycSubmissionDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertKycDetails", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                if(ClientKycSubmissionDetails == null)
                {
                    ClientKycSubmissionDetails = new ClientKycSubmissionDetails();
                }

                LoggedInContext LoggedInContexts = new LoggedInContext();

                Guid? ClientId = _clientService.UpsertKycDetails(ClientKycSubmissionDetails, LoggedInContexts, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertKycDetails", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertKycDetails", "Client Api"));
                return Json(new BtrakJsonResult { Data = ClientId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertKycDetails", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCounterPartySettings)]
        public JsonResult<BtrakJsonResult> UpsertCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertKycDetails", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? ClientId = _clientService.UpsertCounterPartySettings(CounterPartySettingsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertKycDetails", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertKycDetails", "Client Api"));
                return Json(new BtrakJsonResult { Data = ClientId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertKycDetails", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCounterPartySettings)]
        public JsonResult<BtrakJsonResult> GetCounterPartySettings(CounterPartySettingsModel CounterPartySettingsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCounterPartySettings", "Client Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CounterPartySettingsModel> CounterPartySettings = _clientService.GetCounterPartySettings(CounterPartySettingsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCounterPartySettings", "Client Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCounterPartySettings", "Client Api"));
                return Json(new BtrakJsonResult { Data = CounterPartySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCounterPartySettings", "ClientApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetClients), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertKycStatus)]
        public JsonResult<BtrakJsonResult> UpsertKycStatus(KycFormStatusModel KycFormStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertKycStatus", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertKycStatus(KycFormStatusModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertKycStatus", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertKycStatus", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertKycStatus", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllkycStatus)]
        public JsonResult<BtrakJsonResult> GetAllkycStatus(KycFormStatusModel KycFormStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllkycStatus", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<KycFormStatusModel> LegalEntities = _clientService.GetAllkycStatus(KycFormStatusModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllkycStatus", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllkycStatus", "Client Api"));

                return Json(new BtrakJsonResult { Data = LegalEntities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllkycStatus", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetClientKycHistory)]
        public JsonResult<BtrakJsonResult> GetClientKycHistory(KycFormHistoryModel KycFormHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetKycFormHistory", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<KycFormHistoryModel> KycFormHistory = _clientService.GetClientKycHistory(KycFormHistoryModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetKycFormHistory", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetKycFormHistory", "Client Api"));

                return Json(new BtrakJsonResult { Data = KycFormHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetKycFormHistory", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTemplateConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertTemplateConfiguration(TemplateConfigurationModel TemplateConfigurationModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTemplateConfiguration", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertTemplateConfiguration(TemplateConfigurationModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTemplateConfiguration", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTemplateConfiguration", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTemplateConfiguration", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTemplateConfigurations)]
        public JsonResult<BtrakJsonResult> GetAllTemplateConfigurations(TemplateConfigurationModel TemplateConfigurationModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllTemplateConfigurations", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<TemplateConfigurationModel> TemplateConfigurations = _clientService.GetAllTemplateConfigurations(TemplateConfigurationModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTemplateConfigurations", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllTemplateConfigurations", "Client Api"));

                return Json(new BtrakJsonResult { Data = TemplateConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTemplateConfigurations", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmailTemplate)]
        public JsonResult<BtrakJsonResult> UpsertEmailTemplate(EmailTemplateModel EmailTemplateModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmailTemplate", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertEmailTemplate(EmailTemplateModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmailTemplate", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmailTemplate", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmailTemplate", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllEmailTemplates)]
        public JsonResult<BtrakJsonResult> GetAllEmailTemplates(EmailTemplateModel EmailTemplateModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllEmailTemplates", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<EmailTemplateModel> TemplateConfigurations = _clientService.GetAllEmailTemplates(EmailTemplateModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEmailTemplates", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEmailTemplates", "Client Api"));

                return Json(new BtrakJsonResult { Data = TemplateConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTemplateConfigurations", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetHtmlTagsById)]
        public JsonResult<BtrakJsonResult> GetHtmlTagsById(EmailTemplateModel EmailTemplateModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHtmlTagsById", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<EmailTemplateModel> TemplateConfigurations = _clientService.GetHtmlTagsById(EmailTemplateModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHtmlTagsById", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHtmlTagsById", "Client Api"));

                return Json(new BtrakJsonResult { Data = TemplateConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHtmlTagsById", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertContractStatus)]
        public JsonResult<BtrakJsonResult> UpsertContractStatus(ContractStatusModel ContractStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertContractStatus", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertContractStatus(ContractStatusModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertContractStatus", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertContractStatus", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertContractStatus", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllContractStatus)]
        public JsonResult<BtrakJsonResult> GetAllContractStatus(ContractStatusModel ContractStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllContractStatus", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ContractStatusModel> LegalEntities = _clientService.GetAllContractStatus(ContractStatusModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllContractStatus", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllContractStatus", "Client Api"));

                return Json(new BtrakJsonResult { Data = LegalEntities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllContractStatus", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInvoiceStatus)]
        public JsonResult<BtrakJsonResult> UpsertInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInvoiceStatus", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _clientService.UpsertInvoiceStatus(ClientInvoiceStatus, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInvoiceStatus", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInvoiceStatus", "Client Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInvoiceStatus", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllInvoiceStatus)]
        public JsonResult<BtrakJsonResult> GetAllInvoiceStatus(ClientInvoiceStatus ClientInvoiceStatus)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoiceStatus", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ClientInvoiceStatus> LegalEntities = _clientService.GetAllInvoiceStatus(ClientInvoiceStatus, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceStatus", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceStatus", "Client Api"));

                return Json(new BtrakJsonResult { Data = LegalEntities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllInvoiceStatus", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllInvoicePaymentStatus)]
        public JsonResult<BtrakJsonResult> GetAllInvoicePaymentStatus(ClientInvoiceStatus ClientInvoiceStatus)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllInvoicePaymentStatus", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ClientInvoiceStatus> LegalEntities = _clientService.GetAllInvoicePaymentStatus(ClientInvoiceStatus, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceStatus", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllInvoiceStatus", "Client Api"));

                return Json(new BtrakJsonResult { Data = LegalEntities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllInvoiceStatus", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTradeContractTypes)]
        public JsonResult<BtrakJsonResult> GetTradeContractTypes(TradeContractTypesModel TradeContractTypesModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTradeContractTypes", "Client Api"));

                var validationMessages = new List<ValidationMessage>();

                List<TradeContractTypesModel> TemplateConfigurations = _clientService.GetTradeContractTypes(TradeContractTypesModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTradeContractTypes", "Client Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTradeContractTypes", "Client Api"));

                return Json(new BtrakJsonResult { Data = TemplateConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTradeContractTypes", "BillingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
