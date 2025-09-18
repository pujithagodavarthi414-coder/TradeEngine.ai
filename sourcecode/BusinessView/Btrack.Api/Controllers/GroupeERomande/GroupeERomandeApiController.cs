using Btrak.Models;
using Btrak.Models.EntryForm;
using Btrak.Models.GrERomande;
using Btrak.Models.MessageFieldType;
using Btrak.Models.TVA;
using Btrak.Services.GroupeERomande;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.GroupeERomande
{
    public class GroupeERomandeApiController : AuthTokenApiController
    {
        private readonly IGroupeERomandeService _groupeService;
        public GroupeERomandeApiController(IGroupeERomandeService groupeService)
        {
            _groupeService = groupeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertGroupeERomande)]
        public async Task<JsonResult<BtrakJsonResult>> UpsertGroupeERomande(GrERomandeInputModel grERomandeInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGroupeERomande", "grERomandeInput", grERomandeInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? grEId = await _groupeService.UpsertGroupe(grERomandeInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Groupe Upsert is completed. Return Guid is " + grEId + ", source command is ");

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGroupeERomande", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGroupeERomande", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = grEId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGroupeERomande", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetGroupeERomande)]
        public JsonResult<BtrakJsonResult> GetGroupeERomande(GrERomandeSearchInputModel grERomandeSearchInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGroupeERomande", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<GrERomandeSearchOutputModel> greRomandeList=_groupeService.GetGroupe(grERomandeSearchInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGroupeERomande", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGroupeERomande", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = greRomandeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGroupeERomande", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetGroupeERomandeHistory)]
        public JsonResult<BtrakJsonResult> GetGroupeERomandeHistory(GrERomandeSearchInputModel grERomandeSearchInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGroupeERomandeHistory", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<GreRomandeHistoryOutputModel> greRomandeList = _groupeService.GetGroupeRomandeHistory(grERomandeSearchInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGroupeERomandeHistory", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGroupeERomandeHistory", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = greRomandeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGroupeERomandeHistory", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadOrSendRomandDInvoice)]
        public async Task<JsonResult<BtrakJsonResult>> DownloadOrSendRomandDInvoice(GrERomandeInputModel romandeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadOrSendRomandDInvoice", "GroupeERomande Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string pdfUrl = await _groupeService.DownloadOrSendRomandDInvoice(romandeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendRomandDInvoice", "GroupeERomande Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendRomandDInvoice", "GroupeERomande Api"));

                return Json(new BtrakJsonResult { Data = pdfUrl, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadOrSendRomandDInvoice", "GroupeERomandeApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendRomandDInvoiceEmail)]
        public JsonResult<BtrakJsonResult> SendRomandDInvoiceEmail(GrERomandeSearchInputModel romandeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadOrSendRomandDInvoice", "GroupeERomande Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                _groupeService.SendRomandDInvoiceEmail(romandeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendRomandDInvoice", "GroupeERomande Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendRomandDInvoice", "GroupeERomande Api"));

                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadOrSendRomandDInvoice", "GroupeERomandeApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTVA)]
        public JsonResult<BtrakJsonResult> UpsertTVA(TVAInputModel tvaInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTVA", "tvaInput", tvaInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? grEId = _groupeService.UpsertTVA(tvaInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("TVA Upsert is completed. Return Guid is " + grEId + ", source command is ");

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTVA", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTVA", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = grEId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTVA", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTVA)]
        public JsonResult<BtrakJsonResult> GetTVA(GrERomandeSearchInputModel grERomandeSearchInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTVA", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<TVASearchOutputModel> greRomandeList = _groupeService.GetTVA(grERomandeSearchInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTVA", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTVA", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = greRomandeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTVA", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEntryFormField)]
        public JsonResult<BtrakJsonResult> UpsertEntryFormField(EntryFormUpsertInputModel entryFormInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEntryFormField", "entryFormInput", entryFormInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? grEId = _groupeService.UpsertEntryFormField(entryFormInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Entry form field Upsert is completed. Return Guid is " + grEId + ", source command is ");

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntryFormField", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntryFormField", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = grEId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTVA", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEntryFormField)]
        public JsonResult<BtrakJsonResult> GetEntryFormField(EntryFormFieldSearchInputModel grERomandeSearchInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTVA", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<EntryFormFieldReturnOutputModel> greRomandeList = _groupeService.GetEntryFormField(grERomandeSearchInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTVA", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTVA", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = greRomandeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTVA", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMessageFieldType)]
        public JsonResult<BtrakJsonResult> UpsertMessageFieldType(MessageFieldTypeOutputModel entryFormInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEntryFormField", "entryFormInput", entryFormInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? grEId = _groupeService.UpsertMessageFieldType(entryFormInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Entry form field Upsert is completed. Return Guid is " + grEId + ", source command is ");

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntryFormField", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntryFormField", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = grEId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTVA", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMessageFieldType)]
        public JsonResult<BtrakJsonResult> GetMessageFieldType(MessageFieldSearchInputModel grERomandeSearchInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMessageFieldType", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<MessageFieldTypeOutputModel> greRomandeList = _groupeService.GetMessageFieldType(grERomandeSearchInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMessageFieldType", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMessageFieldType", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = greRomandeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMessageFieldType", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEntryFormFieldType)]
        public JsonResult<BtrakJsonResult> UpsertEntryFormFieldType(FieldTypeSearchModel entryFormInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEntryFormField", "entryFormInput", entryFormInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? grEId = _groupeService.UpsertEntryFormFieldType(entryFormInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Entry form field type Upsert is completed. Return Guid is " + grEId + ", source command is ");

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntryFormField", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntryFormField", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = grEId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTVA", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEntryFormFieldType)]
        public JsonResult<BtrakJsonResult> GetEntryFormFieldType(FieldTypeSearchModel grERomandeSearchInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTVA", "grERomandeSearchInput", grERomandeSearchInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<FieldTypeSearchModel> greRomandeList = _groupeService.GetEntryFormFieldType(grERomandeSearchInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTVA", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTVA", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = greRomandeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTVA", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateGreRomandeHistory)]
        public JsonResult<BtrakJsonResult> UpdateGreRomandeHistory(GrERomandeInputModel grERomandeInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateGreRomandeHistory", "grERomandeInput", grERomandeInput, "GroupeERomande Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? grEId =  _groupeService.UpdateGreRomonadeHistory(grERomandeInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Groupe Upsert is completed. Return Guid is " + grEId + ", source command is ");

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateGreRomandeHistory", "GroupeERomande Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateGreRomandeHistory", "GroupeERomande Api"));
                return Json(new BtrakJsonResult { Data = grEId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateGreRomandeHistory", "GroupeERomandeApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }

}
