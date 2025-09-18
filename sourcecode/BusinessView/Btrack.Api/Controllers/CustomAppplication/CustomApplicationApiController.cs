using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.GenericForm;
using Btrak.Services.CustomApplication;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using DocumentFormat.OpenXml.Packaging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;
using System.Web;
using System.Xml;
using Btrak.Models.CustomFields;

namespace BTrak.Api.Controllers.CustomAppplication
{
    public class CustomApplicationApiController : AuthTokenApiController
    {
        private readonly ICustomApplicationService _customApplicationService;

        public CustomApplicationApiController(ICustomApplicationService customApplicationService)
        {
            _customApplicationService = customApplicationService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomApplication)]
        public JsonResult<BtrakJsonResult> UpsertCustomApplication(CustomApplicationUpsertInputModel customApplicationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomApplication", "Custom Application Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                //var domainName = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority;

                //customApplicationUpsertInputModel.DomainName = domainName;

                Guid? customApplicationId = _customApplicationService.UpsertCustomApplication(customApplicationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomApplication", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomApplication", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplicationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomApplication", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomApplication)]
        public JsonResult<BtrakJsonResult> GetCustomApplication(CustomApplicationSearchInputModel customApplicationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "Custom Application Api"));

                if(customApplicationSearchInputModel== null)
                {
                    customApplicationSearchInputModel = new CustomApplicationSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CustomApplicationSearchOutputModel> customApplications = _customApplicationService.GetCustomApplication(customApplicationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplications, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplication", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomApplicationKeysSelected)]
        public JsonResult<BtrakJsonResult> GetCustomApplicationKeysSelected(CustomApplicationSearchInputModel customApplicationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "Custom Application Api"));

                if(customApplicationSearchInputModel== null)
                {
                    customApplicationSearchInputModel = new CustomApplicationSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                CustomApplicationSearchOutputModel customApplications = _customApplicationService.GetCustomApplicationKeysSelected(customApplicationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplications, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplication", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCustomAppApplication)]
        public JsonResult<BtrakJsonResult> GetCustomAppApplication(Guid? CustomApplicationId,Guid? CompanyId=null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomAppApplication", "Custom Application Api"));
                CustomApplicationSearchInputModel customApplicationSearchInputModel = new CustomApplicationSearchInputModel();
                customApplicationSearchInputModel.CustomApplicationId = CustomApplicationId;
                customApplicationSearchInputModel.CompanyId = CompanyId;
                if (customApplicationSearchInputModel == null)
                {
                    customApplicationSearchInputModel = new CustomApplicationSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CustomApplicationSearchOutputModel> customApplications = _customApplicationService.GetCustomApplication(customApplicationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomAppApplication", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomAppApplication", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplications, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomAppApplication", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCustomApplicationForForms)]
        public JsonResult<BtrakJsonResult> GetCustomApplicationForForms(Guid? id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "Custom Application Api"));
                var customApplicationSearchInputModel = new CustomApplicationSearchInputModel();
                if (id == null)
                {

                    customApplicationSearchInputModel.IsArchived = false;
                    customApplicationSearchInputModel.SortBy = "customApplicationName";
                    customApplicationSearchInputModel.SortDirectionAsc = true;
                    customApplicationSearchInputModel.PageNumber = 1;
                    customApplicationSearchInputModel.PageSize = 50;
                } else
                {
                    customApplicationSearchInputModel.CustomApplicationId = id;
                }

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CustomApplicationSearchOutputModel> customApplications = _customApplicationService.GetCustomApplication(customApplicationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplications, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplication", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        //[AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPublicCustomApplicationById)]
        public JsonResult<BtrakJsonResult> GetPublicCustomApplicationById(CustomApplicationSearchInputModel customApplication)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPublicCustomApplicationById", "Get Public Custom Application By Id Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                var customApplications = _customApplicationService.GetPublicCustomApplicationById(customApplication, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPublicCustomApplicationById", "Get Public Custom Application By Id Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPublicCustomApplicationById", "Get Public Custom Application By Id Api"));

                return Json(new BtrakJsonResult { Data = customApplications, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPublicCustomApplicationById", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomApplicationKeys)]
        public JsonResult<BtrakJsonResult> UpsertCustomApplicationKeys(CustomApplicationKeyUpsertInputModel customApplicationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomApplicationKeys", "Custom Application Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? customApplicationKeyId = _customApplicationService.UpsertCustomApplicationKeys(customApplicationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomApplicationKeys", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomApplicationKeys", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplicationKeyId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomApplicationKeys", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomApplicationKeys)]
        public JsonResult<BtrakJsonResult> GetCustomApplicationKeys(CustomApplicationKeySearchInputModel customApplicationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplicationKeys", "Custom Application Api"));


                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CustomApplicationKeySearchOutputModel> customApplicationKeys = _customApplicationService.GetCustomApplicationKeys(customApplicationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplicationKeys", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplicationKeys", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplicationKeys, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationKeys", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomApplicationWorkflow)]
        public JsonResult<BtrakJsonResult> UpsertCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationWorkflowUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomApplication", "Custom Application Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? customApplicationWorkflow = _customApplicationService.UpsertCustomApplicationWorkflow(customApplicationWorkflowUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomApplicationWorkflow", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomApplicationWorkflow", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplicationWorkflow, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomApplicationWorkflow", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomApplicationWorkflow)]
        public JsonResult<BtrakJsonResult> GetCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationWorkflowSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "Custom Application Api"));


                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CustomApplicationWorkflowSearchOutputModel> customApplicationWorkflow = _customApplicationService.GetCustomApplicationWorkflow(customApplicationWorkflowSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplication", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplicationWorkflow, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationWorkflow", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCustomApplicationWorkflowTypes)]
        public JsonResult<BtrakJsonResult> GetCustomApplicationWorkflowTypes()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplicationWorkflowTypes", "Custom Application Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CustomApplicationWorkflowTypeReturnModel> customApplicationWorkflowTypes = _customApplicationService.GetCustomApplicationWorkflowTypes(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplicationWorkflowTypes", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplicationWorkflowTypes", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplicationWorkflowTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationWorkflowTypes", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ImportVerifiedApplication)]
        public JsonResult<BtrakJsonResult> ImportVerifiedApplication(ValidatedSheetsImportModel validatedSheets)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FormId", "GenericForm Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                bool isImportCompleted = _customApplicationService.ImportVerifiedApplication(validatedSheets, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericFormKey", "GenericForm Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericFormKey", "GenericForm Api"));

                return Json(new BtrakJsonResult { Data = isImportCompleted, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ImportVerifiedApplication", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ImportFormDataFromExcel)]
        public JsonResult<BtrakJsonResult> ImportFormDataFromExcel(Guid applicationId, string formName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FormId", "GenericForm Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                FormImportsRawModel jsonData = null;

                bool success = false;

                if (HttpContext.Current.Request.Files.Count > 0)
                {
                    var uploadedFile = HttpContext.Current.Request.Files[0];

                    success = true;

                    SpreadsheetDocument spreadSheetDocument = SpreadsheetDocument.Open(uploadedFile.InputStream, false);

                    string fileName = Path.GetFileNameWithoutExtension(uploadedFile.FileName);

                    jsonData = _customApplicationService.ImportCustomApplicationFromExcel(applicationId,formName, spreadSheetDocument, fileName, LoggedInContext, validationMessages);
                }
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericFormKey", "GenericForm Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericFormKey", "GenericForm Api"));

                return Json(new BtrakJsonResult { Data = jsonData, Success = success }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ImportFormDataFromExcel", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCustomApplicationValuesByKeys)]
        public JsonResult<BtrakJsonResult> GetCustomApplicationValuesByKeys(Guid customApplicationId, string key)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FormId", "GenericForm Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<string> jsonData = _customApplicationService.GetCustomApplicationValuesByKeys(customApplicationId, key, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericFormKey", "GenericForm Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGenericFormKey", "GenericForm Api"));

                return Json(new BtrakJsonResult { Data = jsonData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationValuesByKeys", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

      
        [HttpPost]
        [HttpOptions]
        public async Task<HttpResponseMessage> UploadFileAsync()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFile", "File Api"));

                var httpRequest = HttpContext.Current.Request;
            
                if (httpRequest.Files.Count > 0)
                {
                    foreach (string file in httpRequest.Files)
                    {
                        //var result = new FileResult();
                        var postedFile = httpRequest.Files[file];
                        
                        byte[] bytes;
                        using (var stream = new MemoryStream())
                        {
                            postedFile?.InputStream.CopyTo(stream);
                            bytes = stream.ToArray();
                            XmlDocument document = new XmlDocument();
                       
                            using (XmlReader reader = XmlReader.Create(stream))
                            {
                                stream.Position = 0;
                                document.Load(stream);

                                return Request.CreateResponse(HttpStatusCode.OK, document.InnerXml);
                            }
                        }
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFile", "File Api"));

                return Request.CreateResponse(HttpStatusCode.OK, "");


            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileAsync", "CustomApplicationApiController", exception.Message), exception);

                return Request.CreateResponse(HttpStatusCode.ExpectationFailed, exception.Message);
            }
        }

        [HttpGet]
        [HttpOptions]
        public async Task<HttpResponseMessage> GetHumanTaskList([FromUri] string processDefinitionKey)
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHumanTaskList", "Custom Application Api"));
                var result = _customApplicationService.GetHumanTaskList(processDefinitionKey, LoggedInContext, validationMessages);
                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() => Request.CreateResponse(HttpStatusCode.OK, result));
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHumanTaskList", "CustomApplicationApiController", ex.Message), ex);

                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() => Request.CreateResponse(HttpStatusCode.ExpectationFailed, ex.Message));
            }
          
        }

        [HttpPost]
        [HttpOptions]
        public async Task<HttpResponseMessage> CompleteUserTask([FromUri] string taskId, [FromUri] bool isApproved)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CompleteUserTask", "Custom Application Api"));
                _customApplicationService.CompleteUserTask(taskId, isApproved);
                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() => Request.CreateResponse(HttpStatusCode.OK, ""));
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CompleteUserTask", "CustomApplicationApiController", ex.Message), ex);

                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() => Request.CreateResponse(HttpStatusCode.ExpectationFailed, ex.Message));
            }

        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetObservationType)]
        public JsonResult<BtrakJsonResult> GetObservationType(ObservationTypeModel observationTypeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ObservationTypeModel", "GenericForm Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ObservationTypeModel> observations = _customApplicationService.GetObservationType(observationTypeModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetObservationType", "GenericForm Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetObservationType", "GenericForm Api"));

                return Json(new BtrakJsonResult { Data = observations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetObservationType", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertObservationType)]
        public JsonResult<BtrakJsonResult> UpsertObservationType(ObservationTypeModel observationTypeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ObservationTypeModel", "GenericForm Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? observationTypeId = _customApplicationService.UpsertObservationType(observationTypeModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertObservationType", "GenericForm Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertObservationType", "GenericForm Api"));

                return Json(new BtrakJsonResult { Data = observationTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertObservationType", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetResidentObservations)]
        public JsonResult<BtrakJsonResult> GetResidentObservations(CustomFieldSearchCriteriaInputModel customFieldSearchCriteriaModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetResidentObservations", "CustomApplication Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ResidentObservationApiReturnModel> customFieldModel = _customApplicationService.GetResidentObservations(customFieldSearchCriteriaModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetResidentObservations", "CustomApplication Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetResidentObservations", "CustomApplication Api"));

                return Json(new BtrakJsonResult { Data = customFieldModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetResidentObservations", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFormHistory)]
        public JsonResult<BtrakJsonResult> GetFormHistory(FormHistoryModel formHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormHistory", "Custom Application Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<FormHistoryModel> customApplicationKeys = _customApplicationService.GetFormHistory(formHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFormHistory", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFormHistory", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplicationKeys, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormHistory", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLevels)]
        public JsonResult<BtrakJsonResult> GetLevels(GetLevelsKeyConfigurationModel upsertLevelModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLevels", "CustomApplication Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<UpsertDataLevelKeyConfigurationModel> levelsList = _customApplicationService.GetLevels(upsertLevelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLevels", "CustomApplication Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLevels", "CustomApplication Api"));

                return Json(new BtrakJsonResult { Data = levelsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLevels", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLevel)]
        public JsonResult<BtrakJsonResult> UpsertLevel(UpsertLevelModel upsertLevelModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLevel", "Custom Application Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? levelId = _customApplicationService.UpsertLevel(upsertLevelModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLevel", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLevel", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = levelId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLevel", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetCustomApplicationUnAuth)]
        public JsonResult<BtrakJsonResult> GetCustomApplicationUnAuth(CustomApplicationSearchInputModel customApplicationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplicationUnAuth", "Custom Application Api"));

                if (customApplicationSearchInputModel == null)
                {
                    customApplicationSearchInputModel = new CustomApplicationSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CustomApplicationSearchOutputModel> customApplications = _customApplicationService.GetCustomApplicationUnAuth(customApplicationSearchInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplicationUnAuth", "Custom Application Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomApplicationUnAuth", "Custom Application Api"));

                return Json(new BtrakJsonResult { Data = customApplications, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationUnAuth", "CustomApplicationApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

    }
}