using Formio.Helpers;
using Formio.Models;
using formioCommon.Constants;
using formioServices.data;
using formioServices.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System;
using formioModels;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using Models.DeletePDFHTMLDesigner;
using formioModels.PDFDocumentEditorModel;
using Microsoft.AspNetCore.Authorization;

namespace Formio.Controllers.DataService
{
    [ApiController]
    public class PdfDesigerApiController : AuthTokenApiController
    {
        private readonly IPdfDesignerService _pdfDesignerService;

        public PdfDesigerApiController(IPdfDesignerService iPdfDesignerService)
        {
            _pdfDesignerService = iPdfDesignerService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetHTMLDataSetById)]
        public JsonResult GetHTMLDataSetById(Guid Id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetById", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                TemplateOutputModel result = _pdfDesignerService.GetHTMLDataSetById(Id, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetById", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetById", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }
        
        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetHTMLDataSetByIdUnAuth)]
        public JsonResult GetHTMLDataSetByIdUnAuth(Guid Id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetByIdUnAuth", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                TemplateOutputModel result = _pdfDesignerService.GetHTMLDataSetByIdUnAuth(Id, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetByIdUnAuth", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetByIdUnAuth", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetByIdUnAuth", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.RemoveHTMLDataSetById)]
        public JsonResult RemoveHTMLDataSetById(RemoveByIdInputModel removeById)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RemoveHTMLDataSetById", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                Guid? result = _pdfDesignerService.RemoveHTMLDataSetById(removeById, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RemoveHTMLDataSetById", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RemoveHTMLDataSetById", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RemoveHTMLDataSetById", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertHTMLDataSet)]
        public JsonResult InsertHTMLDataSet(HTMLDatasetInputModel htmlDatasetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertHTMLDataSet", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                HTMLDatasetOutputModel result = _pdfDesignerService.InsertHTMLDataSet(htmlDatasetInputModel, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertHTMLDataSet", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertHTMLDataSet", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertHTMLDataSet", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateHTMLDataSetById)]
        public JsonResult UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateHTMLDataSetById", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                string result = _pdfDesignerService.UpdateHTMLDataSetById(inputModel, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateHTMLDataSetById", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateHTMLDataSetById", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateHTMLDataSetById", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllHTMLDataSet)]
        public JsonResult GetAllHTMLDataSet(bool IsArchived, string SearchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllHTMLDataSet", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<TemplateOutputModel> datasetOutputModels = _pdfDesignerService.GetAllHTMLDataSet(IsArchived,SearchText, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllHTMLDataSet", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllHTMLDataSet", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllHTMLDataSet", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllPDFMenuDataSet)]
        public JsonResult GetAllPDFMenuDataSet(string TemplateId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSet", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<PDFDesignerDatasetOutputModel> datasetOutputModels = _pdfDesignerService.GetAllPDFMenuDataSet(TemplateId, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPDFMenuDataSet", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPDFMenuDataSet", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPDFMenuDataSet", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetAllPDFMenuDataSetUnAuth)]
        public JsonResult GetAllPDFMenuDataSetUnAuth(string TemplateId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSetUnAuth", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<PDFDesignerDatasetOutputModel> datasetOutputModels = _pdfDesignerService.GetAllPDFMenuDataSetUnAuth(TemplateId, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPDFMenuDataSetUnAuth", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPDFMenuDataSetUnAuth", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPDFMenuDataSet", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SaveDataSource)]
        public JsonResult SaveDataSource(DataSourceDetailsInputModel dataSourceDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<MenuDatasetInputModel> datasetOutputModels = _pdfDesignerService.SaveDataSource(dataSourceDetailsInputModel, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveDataSource", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveDataSource", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveDataSource", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ValidateAndRunMongoQuery)]
        public JsonResult ValidateAndRunMongoQuery(List<MongoQueryInputModel> mongoQueryInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQuery", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<object> datasetOutputModels = _pdfDesignerService.ValidateAndRunMongoQuery(mongoQueryInputModel, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateAndRunMongoQuery", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateAndRunMongoQuery", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQuery", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ValidateAndRunMongoQueryUnAuth)]
        public JsonResult ValidateAndRunMongoQueryUnAuth(List<MongoQueryInputModel> mongoQueryInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<string> datasetOutputModels = _pdfDesignerService.ValidateAndRunMongoQueryUnAuth(mongoQueryInputModel, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SaveWebPageView)]
        public JsonResult SaveWebPageView(WebPageViewerModel webPageViewerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveWebPageView", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                webPageViewerModel = _pdfDesignerService.SaveWebPageView(webPageViewerModel, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveWebPageView", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveWebPageView", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = webPageViewerModel, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveWebPageView", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWebPageView)]
        public JsonResult GetWebPageView(string path)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebPageView", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<WebPageViewerModel>  webPageViewerModelList = _pdfDesignerService.GetWebPageView(path, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebPageView", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebPageView", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = webPageViewerModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebPageView", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.StoreDownloadedTemplates)]
        public JsonResult StoreDownloadedTemplates(List<GenerateCompleteTemplatesOutputModel> downloadedTemplates)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "StoreDownloadedTemplates", "HTMLDataSetApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<string> downloadTemplateIds = _pdfDesignerService.StoreDownloadedTemplates(downloadedTemplates, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreDownloadedTemplates", "HTMLDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreDownloadedTemplates", "HTMLDataSetApiController"));
                return Json(new DataJsonResult { Data = downloadTemplateIds, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "StoreDownloadedTemplates", "HTMLDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetGeneratedInvoices)]
        public JsonResult GetGeneratedInvoices(Guid GenericFormSubmittedId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGeneratedInvoices", "PdfDesigerApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<GenerateCompleteTemplatesOutputModel> datasetOutputModels = _pdfDesignerService.GetGeneratedInvoices(GenericFormSubmittedId, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGeneratedInvoices", "PdfDesigerApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGeneratedInvoices", "PdfDesigerApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGeneratedInvoices", "PdfDesigerApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }


    }
}
