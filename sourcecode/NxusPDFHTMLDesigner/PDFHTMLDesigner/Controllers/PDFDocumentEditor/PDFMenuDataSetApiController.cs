using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PDFHTMLDesigner.Helpers;
using PDFHTMLDesigner.Models;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using PDFHTMLDesigner.Controllers;
using PDFHTMLDesignerServices.DocumentEditor;
using PDFHTMLDesignerModels.DocumentModel;
using MongoDB.Bson;
using PDFHTMLDesignerModels.DocumentOutputModel;
using Microsoft.AspNetCore.Cors;
using PDFHTMLDesignerModels.SFDTParameterModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;

namespace PDFHTMLDesignerServices.DocumentEditor.Controllers
{
    [ApiController]
    public class PDFMenuDataSetApiController : AuthTokenApiController
    {
        private readonly IPDFMenuDataSetService _pDFMenuDataSetService;
        public PDFMenuDataSetApiController(IPDFMenuDataSetService iPDFMenuDataSetService)
        {
            _pDFMenuDataSetService = iPDFMenuDataSetService;
        }

        [HttpGet]
        [Route(RouteConstants.AllMenuDataSet)]
        
        public async Task<JsonResult> GetAllPDFMenuDataSet(string TemplateId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                PDFDatasetInputModel datasetInputModels = new PDFDatasetInputModel();
                DataJsonResult dataJsonResult;
                List<PDFDesignerDatasetOutputModel> datasetOutputModels = await _pDFMenuDataSetService.GetAllPDFMenuDataSet(TemplateId,LoggedInContext, validationMessages: validationMessages);
               
                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetApiController"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        //[HttpGet]
        //[Route(RouteConstants.GetSelectedMenu)]
        //
        //public JsonResult GetSelectedMenu(string GetSelectedMenu)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSelectedMenu", "PDFMenuDataSetApi"));
        //        List<ValidationMessage> validationMessages = new List<ValidationMessage>();
        //        PDFDatasetInputModel datasetInputModels = new PDFDatasetInputModel();
        //        DataJsonResult dataJsonResult;
        //        List<DataSetMenuModel> datasetOutputModels = _pDFMenuDataSetService.GetSelectedMenu(GetSelectedMenu,LoggedInContext, validationMessages: validationMessages);

        //        if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
        //        {
        //            validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
        //            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSelectedMenu", "PDFMenuDataSetApiController"));
        //            return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
        //        }
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSelectedMenu", "PDFMenuDataSetApiController"));
        //        return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSelectedMenu", "PDFMenuDataSetApiController", exception.Message), exception);
        //        return Json(new DataJsonResult(exception.Message));
        //    }
        //}
    }
}
