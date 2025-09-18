using System;
using System.Collections.Generic;
using PDFHTMLDesigner.Helpers;
using PDFHTMLDesigner.Models;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using Microsoft.AspNetCore.Mvc;
using PDFHTMLDesigner.Controllers;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using Microsoft.AspNetCore.Cors;
using Models.DeletePDFHTMLDesigner;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using MongoDB.Bson;
using System.Threading.Tasks;
using Syncfusion.DocIO.DLS;
using Newtonsoft.Json;
using Microsoft.Extensions.Azure;
using PDFHTMLDesignerModels.DocumentModel.file;
using Microsoft.AspNetCore.Authorization;
using System.Linq;

namespace PDFHTMLDesignerServices.DocumentEditor.Controllers
{
    [ApiController]
    public class HTMLDataSetApiController : AuthTokenApiController
    {
        private readonly IHTMLDataSetService _hTMLDataSetService;
        private readonly IPDFMenuDataSetService _pDFMenuDataSetService;

        public HTMLDataSetApiController(IHTMLDataSetService iHTMLDataSetService , IPDFMenuDataSetService iPDFMenuDataSetService)
        {
            _hTMLDataSetService = iHTMLDataSetService;
            _pDFMenuDataSetService = iPDFMenuDataSetService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertHTMLDataSet)]
        public async Task<JsonResult> InsertHTMLDataSet(HTMLDatasetsaveModel datasetsaveModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertHTMLDataSet", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var doc = await _hTMLDataSetService.InsertHTMLDataSet(datasetsaveModel, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertHTMLDataSet", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertHTMLDataSet", "HTML DataSet Api Controller"));
                return Json(new DataJsonResult { Data = doc, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertHTMLDataSet", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateHTMLDataSetById)]
        public async Task<JsonResult> UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateHTMLDataSetById", "HTML DataSet Api Controller"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                DataJsonResult dataJsonResult;
                string dataSetId =await _hTMLDataSetService.UpdateHTMLDataSetById(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateHTMLDataSetById", "HTML DataSet Api Controller"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateHTMLDataSetById", "HTML DataSet Api Controller"));
                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateHTMLDataSetById", "HTML DataSet Api Controller", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.RemoveHTMLDataSetById)]
        public async Task<JsonResult> RemoveHTMLDataSetById(RemoveByIdInputModel removeById)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RemoveHTMLDataSetById", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                DataJsonResult dataJsonResult;
                TemplateOutputModel files = new TemplateOutputModel();

                Guid? fileId = await _hTMLDataSetService.RemoveHTMLDataSetById(removeById, LoggedInContext, validationMessages);
                HTMLDatasetInputModel fileDatasetInput = new HTMLDatasetInputModel();
                fileDatasetInput.IsArchived = true;

                if (fileId != null && validationMessages.Count == 0)
                {
                    files =await _hTMLDataSetService.GetHTMLDataSetById(removeById._id, LoggedInContext, validationMessages: validationMessages);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    if (dataJsonResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new DataJsonResult{ Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages, Data = fileId });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RemoveHTMLDataSetById", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = files, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RemoveHTMLDataSetById", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetHTMLDataSetById)]
        public async Task<JsonResult> GetHTMLDataSetById(Guid id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetById", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                TemplateOutputModel datasetOutputModels =await _hTMLDataSetService.GetHTMLDataSetById(id, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetById", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetById", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllHTMLDataSet)]
        public async Task<JsonResult> GetAllHTMLDataSet(bool IsArchived,string SearchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllHTMLDataSet", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                 List<TemplateOutputModel> datasetOutputModels =await _hTMLDataSetService.GetAllHTMLDataSet(IsArchived, SearchText,LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllHTMLDataSet", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllHTMLDataSet", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllHTMLDataSet", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SaveDataSource)]
        public async Task<JsonResult> SaveDataSource(DataSourceDetailsInputModel dataSourceDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTML DataSet Api Controller"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                DataJsonResult dataJsonResult;
                List <MenuDatasetInputModel> result = await _hTMLDataSetService.SaveDataSource(dataSourceDetailsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveDataSource", "HTML DataSet Api Controller"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveDataSource", "HTML DataSet Api Controller"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveDataSource", "HTML DataSet Api Controller", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ValidateAndRunMongoQuery)]
        public async Task<JsonResult> ValidateAndRunMongoQuery(List<MongoQueryInputModel> mongoQueryInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQuery", "HTML DataSet Api Controller"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                DataJsonResult dataJsonResult;
                List<object> result = await _hTMLDataSetService.ValidateAndRunMongoQuery(mongoQueryInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateAndRunMongoQuery", "HTML DataSet Api Controller"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateAndRunMongoQuery", "HTML DataSet Api Controller"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQuery", "HTML DataSet Api Controller", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ConversionFromHtmltoSfdt)]
        public JsonResult ConversionFromHtmltoSfdt(HtmlToSfdtConversionModel HtmlFile )
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConversionFromHtmltoSfdt", "HTML DataSet Api Controller"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                DataJsonResult dataJsonResult;
                string result = _hTMLDataSetService.ConversionFromHtmltoSfdt(HtmlFile, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ConversionFromHtmltoSfdt", "HTML DataSet Api Controller"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ConversionFromHtmltoSfdt", "HTML DataSet Api Controller"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConversionFromHtmltoSfdt", "HTML DataSet Api Controller", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTemplateByIdWithDataSources)]
        public async Task<JsonResult> GetTemplateByIdWithDataSources(Guid id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTemplateByIdWithDataSources", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                TemplateOutputModel templateData = await _hTMLDataSetService.GetHTMLDataSetById(id, LoggedInContext, validationMessages: validationMessages);
                TemplateWithDataSourcesOutputModel templateWithDataSources = new TemplateWithDataSourcesOutputModel();
                List<PDFDesignerDatasetOutputModel> dataSources = new List<PDFDesignerDatasetOutputModel>();
                if (templateData!=null)
                {
                    dataSources  = await _pDFMenuDataSetService.GetAllPDFMenuDataSet(id.ToString(), LoggedInContext, validationMessages: validationMessages);
                    templateWithDataSources.Template = templateData;
                    templateWithDataSources.DataSources = dataSources;
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTemplateByIdWithDataSources", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTemplateByIdWithDataSources", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = templateWithDataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplateByIdWithDataSources", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GenerateCompleteTemplates)]
        public async Task<JsonResult> GenerateCompleteTemplates(List <GenerateCompleteTemplatesInputModel> generateCompleteTemplatesInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateCompleteTemplates", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                Guid? genericFormSubmittedId = generateCompleteTemplatesInputModel[0].GenericFormSubmittedId;

                //To get template details
                TemplateOutputModel templateData = await _hTMLDataSetService.GetHTMLDataSetById(generateCompleteTemplatesInputModel[0].TemplateId, LoggedInContext, validationMessages: validationMessages);

                TemplateWithDataSourcesOutputModel templateWithDataSources = new TemplateWithDataSourcesOutputModel();
                List < GenerateCompleteTemplatesOutputModel> generateCompleteTemplates = new List<GenerateCompleteTemplatesOutputModel>();
                if (templateData != null)
                {
                    //To get datasources of the template 
                    List<PDFDesignerDatasetOutputModel> dataSources = await _pDFMenuDataSetService.GetAllPDFMenuDataSet(generateCompleteTemplatesInputModel[0].TemplateId.ToString(), LoggedInContext, validationMessages: validationMessages);

                    templateWithDataSources.Template = templateData;
                    templateWithDataSources.DataSources = dataSources;
                    if (templateWithDataSources.Template != null && templateWithDataSources.DataSources != null)
                    {
                        var SelectedFormData = new List<object>();
                        foreach (var template in generateCompleteTemplatesInputModel)
                        {
                            var deserializedResult = JsonConvert.DeserializeObject(template.SelectedFormDataJson);
                            SelectedFormData.Add(deserializedResult);
                        }

                        //To get the sfdt template with replaced values
                        List<string> templatesToDownload = await _pDFMenuDataSetService.GenerateCompleteTemplate(generateCompleteTemplatesInputModel[0].GenericFormSubmittedId,
                            templateWithDataSources.DataSources, SelectedFormData, templateWithDataSources.Template.SfdtJson, templateWithDataSources.Template.TemplateTagStyles, LoggedInContext, validationMessages);
                        
                            if (templatesToDownload != null)
                            {
                                for (var i = 0; i < templatesToDownload.Count; i++)
                                {
                                    generateCompleteTemplates.Add(new GenerateCompleteTemplatesOutputModel { InvoiceDowloadId = generateCompleteTemplatesInputModel[i].InvoiceDowloadId, GenericFormSubmittedId = generateCompleteTemplatesInputModel[i].GenericFormSubmittedId, SfdtTemplatesToDownload = templatesToDownload[i] });
                                }

                            await Task.Run(async () =>
                            {
                                var downloadedTemplates =  _pDFMenuDataSetService.StoreDownloadedTemplates(generateCompleteTemplates, LoggedInContext, validationMessages);
                            }).ConfigureAwait(false);

                        }
                    }
                }

                await Task.Run(async () =>
                {
                   _pDFMenuDataSetService.TriggerWorkFlow(genericFormSubmittedId, LoggedInContext, validationMessages);
                }).ConfigureAwait(false);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateCompleteTemplates", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateCompleteTemplates", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = generateCompleteTemplates, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateCompleteTemplates", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetGeneratedInvoices)]
        public async Task<JsonResult> GetGeneratedInvoices(Guid GenericFormSubmittedId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGeneratedInvoices", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<GenerateCompleteTemplatesOutputModel> generatedInvoices = await _hTMLDataSetService.GetGeneratedInvoices(GenericFormSubmittedId, LoggedInContext, validationMessages: validationMessages);
                

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGeneratedInvoices", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGeneratedInvoices", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = generatedInvoices, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGeneratedInvoices", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GenerateWebTemplate)]
        public async Task<JsonResult> GenerateWebTemplate(WebTemplateInputModel WebTemplateInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateWebTemplates", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                WebTemplateOutputModel webTemplateOutput = new WebTemplateOutputModel();

                //To get the template 
                TemplateOutputModel templateData = await _hTMLDataSetService.GetHTMLDataSetById(WebTemplateInput.TemplateId, LoggedInContext, validationMessages: validationMessages);
                
                if (templateData != null && templateData.TemplateType=="html" && (templateData.TemplatePermissions == null || templateData.TemplatePermissions.Count == 0))
                {
                    //To get the mongo queries associated with template
                    List<PDFDesignerDatasetOutputModel>  dataSources = await _pDFMenuDataSetService.GetAllPDFMenuDataSet(WebTemplateInput.TemplateId.ToString(), LoggedInContext, validationMessages: validationMessages);
                    
                    TemplateWithDataSourcesOutputModel templateWithDataSources = new TemplateWithDataSourcesOutputModel();
                    templateWithDataSources.Template = templateData;
                    templateWithDataSources.DataSources = dataSources;
                    templateWithDataSources.GenericFormSubmittedId = WebTemplateInput.GenericFormSubmittedId;

                    //To generate the web template with replacing the proper values
                    var webTemplateToDownload = await _pDFMenuDataSetService.GenerateCompleteWebTemplate(templateWithDataSources, LoggedInContext, validationMessages);
                    if(webTemplateToDownload != null)
                    {
                        webTemplateOutput.TemplateId = templateData._id;
                        webTemplateOutput.HtmlFiles = webTemplateToDownload;
                        webTemplateOutput.TemplateType = templateData.TemplateType;
                        webTemplateOutput.TemplateTagStyles = templateData.TemplateTagStyles;
                        webTemplateOutput.AllowAnonymous = templateData.AllowAnonymous;

                    }
                }
                else if (templateData != null && templateData.TemplateType == "html" && templateData.TemplatePermissions != null && templateData.TemplatePermissions.Count > 0)
                {

                    List<string> roles = string.IsNullOrEmpty(WebTemplateInput.RoleId) ? null : WebTemplateInput.RoleId.Split(',').ToList();
                    var foundRole = roles != null ? (templateData.TemplatePermissions.Find(role =>
                     role.RoleId != null && (roles != null && roles.Any(r => r.ToLower() == role.RoleId.ToString().ToLower())))) : null;

                    //var foundRole = templateData.TemplatePermissions.Find(Role => Role.RoleId != null && Role.RoleId == WebTemplateInput.RoleId);
                    var founduser = templateData.TemplatePermissions.Find(User => User.UserId!=null && User.UserId == LoggedInContext.LoggedInUserId);
                    if(foundRole!=null || founduser!=null)
                    {
                        //To get the mongo queries associated with template
                        List<PDFDesignerDatasetOutputModel> dataSources = await _pDFMenuDataSetService.GetAllPDFMenuDataSet(WebTemplateInput.TemplateId.ToString(), LoggedInContext, validationMessages: validationMessages);

                        TemplateWithDataSourcesOutputModel templateWithDataSources = new TemplateWithDataSourcesOutputModel();
                        templateWithDataSources.Template = templateData;
                        templateWithDataSources.DataSources = dataSources;
                        templateWithDataSources.GenericFormSubmittedId = WebTemplateInput.GenericFormSubmittedId;

                        //To generate the web template with replacing the proper values
                        var webTemplateToDownload = await _pDFMenuDataSetService.GenerateCompleteWebTemplate(templateWithDataSources, LoggedInContext, validationMessages);
                        if (webTemplateToDownload != null)
                        {
                            webTemplateOutput.TemplateId = templateData._id;
                            webTemplateOutput.HtmlFiles = webTemplateToDownload;
                            webTemplateOutput.TemplateType = templateData.TemplateType;
                            webTemplateOutput.TemplateTagStyles = templateData.TemplateTagStyles;
                            webTemplateOutput.AllowAnonymous = templateData.AllowAnonymous;

                        }
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = PDFHTMLDesignerModels.MessageTypeEnum.Error,
                            ValidationMessaage = "User has no access to this web template"
                        });

                    }


                }
                else if(templateData != null)
                {
                    webTemplateOutput.TemplateId = templateData._id;
                    webTemplateOutput.SfdtFile = templateData.SfdtFile;
                    webTemplateOutput.TemplateType = templateData.TemplateType;
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateWebTemplates", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateWebTemplates", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = webTemplateOutput, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateWebTemplates", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GenerateWebTemplateUnAuth)]
        public async Task<JsonResult> GenerateWebTemplateUnAuth(WebTemplateInputModel WebTemplateInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateWebTemplateUnAuth", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                TemplateOutputModel templateData = await _hTMLDataSetService.GetHTMLDataSetByIdUnAuth(WebTemplateInput.TemplateId, validationMessages: validationMessages);
                TemplateWithDataSourcesOutputModel templateWithDataSources = new TemplateWithDataSourcesOutputModel();
                WebTemplateOutputModel webTemplateOutput = new WebTemplateOutputModel();

                if (templateData != null && templateData.TemplateType=="html")
                {
                    List<PDFDesignerDatasetOutputModel>  dataSources = await _pDFMenuDataSetService.GetAllPDFMenuDataSetUnAuth(WebTemplateInput.TemplateId.ToString(), validationMessages: validationMessages);
                    templateWithDataSources.Template = templateData;
                    templateWithDataSources.DataSources = dataSources;                    
                    var webTemplateToDownload = await _pDFMenuDataSetService.GenerateCompleteWebTemplateUnAuth(templateWithDataSources, validationMessages);
                    if(webTemplateToDownload != null)
                    {
                        webTemplateOutput.TemplateId = templateData._id;
                        webTemplateOutput.HtmlFiles =  webTemplateToDownload ;
                        webTemplateOutput.TemplateType = templateData.TemplateType;
                        webTemplateOutput.TemplateTagStyles = templateData.TemplateTagStyles;
                        webTemplateOutput.AllowAnonymous = templateData.AllowAnonymous;
                    }
                }
                else if(templateData != null)
                {
                    webTemplateOutput.TemplateId = templateData._id;
                    webTemplateOutput.SfdtFile = templateData.SfdtFile;
                    webTemplateOutput.TemplateType = templateData.TemplateType;
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateWebTemplateUnAuth", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateWebTemplateUnAuth", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = webTemplateOutput, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateWebTemplateUnAuth", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.FileConvertion)]
        public async Task<JsonResult> FileConvertion(List<FileConvertionInputModel> inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FileConvertion", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<FileConvertionOutputModel> result = _hTMLDataSetService.FileConvertion(inputModel, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FileConvertion", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FileConvertion", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FileConvertion", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.ReplaceImages)]
        public async Task<JsonResult> ReplaceImages()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTemplateByIdWithDataSources", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                 await _pDFMenuDataSetService.ReplaceImages();
                
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTemplateByIdWithDataSources", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = true, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTemplateByIdWithDataSources", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ByteArrayToPDFConvertion)]
        public JsonResult ByteArrayToPDFConvertion(ByteArrayToPDFConvertion inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ByteArrayToPDFConvertion", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                string result = _hTMLDataSetService.ByteArrayToPDFConvertion(inputModel, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ByteArrayToPDFConvertion", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ByteArrayToPDFConvertion", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ByteArrayToPDFConvertion", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }
    }
}
