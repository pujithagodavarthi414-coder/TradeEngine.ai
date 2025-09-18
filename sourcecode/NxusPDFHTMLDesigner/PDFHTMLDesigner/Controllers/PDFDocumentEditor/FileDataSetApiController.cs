using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PDFHTMLDesigner.Helpers;
using PDFHTMLDesigner.Models;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using Microsoft.AspNetCore.Mvc;
using PDFHTMLDesigner.Controllers;
using PDFHTMLDesignerModels.DocumentModel;
using PDFHTMLDesignerServices.PDFDocumentEditor;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using PDFHTMLDesignerModels.DocumentModel.file;
using System.IO;
using Syncfusion.HtmlConverter;
using Syncfusion.Pdf;

namespace PDFHTMLDesignerServices.DocumentEditor.Controllers
{
    [ApiController]
    public class FileDataSetApiController : AuthTokenApiController
    {
        private readonly IFileDatasetService _fileDatasetService;
        DataJsonResult dataJsonResult;
        public FileDataSetApiController(IFileDatasetService iFileDatasetService)
        {
            _fileDatasetService = iFileDatasetService;
        }

        [HttpGet]
        [Route(RouteConstants.AllFileDataSet)]
        public JsonResult GetAllFileDataSet()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AllPDFMenuDataSet", "FileDataSetApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                PDFDatasetInputModel datasetInputModels = new PDFDatasetInputModel();

                List<FileDatasetOutputModel> datasetOutputModels = _fileDatasetService.GetAllFileDataSet(LoggedInContext, validationMessages: validationMessages);
               
                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AllPDFMenuDataSet", "FileDataSetApi"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AllPDFMenuDataSet", "FileDataSetApi"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AllPDFMenuDataSet", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [Route(RouteConstants.FileDataSetById)]
        public JsonResult GetFileDataSetById(string id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FileDataSetById", "FileDataSetApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                
                FileDatasetInputModel fileDatasetInput = new FileDatasetInputModel();
                List<FileDatasetOutputModel> datasetOutputModels = _fileDatasetService.GetFileDataSetById(id,LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FileDataSetById", "FileDataSetApi"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FileDataSetById", "FileDataSetApi"));
                return Json(new DataJsonResult { Data = datasetOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FileDataSetById", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [Route(RouteConstants.InsertFileDataSet)]
        public JsonResult InsertFileDataSet(FileDatasetInputModel fileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,"InsertFileDataSet", "FileDataSetApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
               
                var doc  = _fileDatasetService.InsertFileDataSet(fileInputModel, LoggedInContext, validationMessages: validationMessages);
                
                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AllPDFMenuDataSet", "FileDataSetApi"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,"InsertFileDataSet", "FileDataSetApi"));
                return Json(new DataJsonResult { Data = doc, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue,"InsertFileDataSet", "FileDataSetApi", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPut]
        [Route(RouteConstants.UpdateFileDataSet)]
        public JsonResult UpdateFileDataSet(FileDatasetInputModel fileInputModel, string id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFileDataSet", "FileDataSetApi"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var doc = _fileDatasetService.UpdateFileDataSet(id, fileInputModel, LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FileDataSetById", "FileDataSetApi"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFileDataSet", "FileDataSetApi"));
                return Json(new DataJsonResult { Data = doc, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFileDataSet", "FileDataSetApi", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [Route(RouteConstants.DeleteFileById)]
        public JsonResult ArchiveFileById(string id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFile", "File Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                DataJsonResult dataJsonResult;
                List<FileDatasetOutputModel> files = new List<FileDatasetOutputModel>();

                string fileId = _fileDatasetService.ArchiveFileById(id, LoggedInContext, validationMessages);
                FileDatasetInputModel fileDatasetInput = new FileDatasetInputModel();
                fileDatasetInput.IsArchived = true;

                if (fileId != null && validationMessages.Count == 0)
                {
                    files = _fileDatasetService.GetFileDataSetById(id, LoggedInContext, validationMessages: validationMessages);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    if (dataJsonResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages, Data = fileId });
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFile", "File Api"));
                return Json(new DataJsonResult { Data = files, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFile", "FileApiController", exception.Message), exception);
                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [Route(RouteConstants.DeleteFileDatasetById)]
        public Task<Object> DeleteFileDatasetById(string id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFileDatasetById", "FileApiController"));
                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var dataSetOutputModelList = _fileDatasetService.DeleteFileDatasetById(id, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFileDatasetById", "FileApiController"));
                    return dataSetOutputModelList;
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFileDatasetById", "FileApiController"));
                return dataSetOutputModelList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFileDatasetById", "FileApiController", exception.Message), exception);
                return null;
            }
        }
    }
}
