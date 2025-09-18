using BTrak.Api.Controllers.Api;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.IO;
using System.Net.Http;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Configuration;
using Btrak.Services.ExcelToCustomApplicationRecords;
using BTrak.Api.Helpers;
using System.Web.Http.Results;
using System.Collections.Generic;
using Btrak.Models.DailyUploadExcels;
using Btrak.Models;
using Btrak.Models.GenericForm;

namespace BTrak.Api.Controllers.Expense
{
    public class ExcelApiController : AuthTokenApiController
    {
        private readonly IDailyUploadExcelService _dailyUploadExcelService;
        private BtrakJsonResult _btrakJsonResult;

        public ExcelApiController(IDailyUploadExcelService dailyUploadExcelService)
        {
            _dailyUploadExcelService = dailyUploadExcelService;
            _btrakJsonResult = new BtrakJsonResult();
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ExcelToCustomApplicationRecords)]
        public async Task<JsonResult<BtrakJsonResult>> ExcelToCustomApplicationRecords()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ExcelToCustomApplicationRecords", "ExcelApiController"));
                BtrakJsonResult btrakJsonResult;
                var validationMessages = new List<ValidationMessage>();

                if (!Request.Content.IsMimeMultipartContent())
                {
                    var errorMessages = new List<ApiResponseMessage>();
                    errorMessages.Add(new ApiResponseMessage
                    {
                        FieldName = "Excel",
                        Message = "Excel is not in proper format",
                        MessageTypeEnum = MessageTypeEnum.Error
                    });
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = errorMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                var uploadPath = ConfigurationManager.AppSettings["ExcelToCustomApplicationRecordsPath"];
                Directory.CreateDirectory(uploadPath);
                var provider = new MultipartFormDataStreamProvider(uploadPath);

                await Request.Content.ReadAsMultipartAsync(provider);

                string filename = null;

                foreach (var file in provider.FileData)
                {
                    var fileInfo = new FileInfo(file.LocalFileName);
                    string datetimeSuffix = DateTime.Now.ToString("yyyyMMddHHmmssfff");
                    filename = (provider.FormData["filename"] ?? fileInfo.Name) ;

                    string originalFileName = provider.FormData["filename"] ?? fileInfo.Name;
                    string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(originalFileName);
                    string extension = Path.GetExtension(originalFileName);
                    string newFileName = fileNameWithoutExtension + "_" + datetimeSuffix + extension;

                    var destinationFile = Path.Combine(uploadPath, newFileName);

                    File.Move(file.LocalFileName, destinationFile);

                    var inputModel = new DailyUploadExcelsInputModel
                    {
                        ExcelSheetName = newFileName,
                        CustomApplicationId = null,
                        FormId = null,
                        IsUploaded = false,
                        IsHavingErrors = false,
                        NeedManualCorrection = false,
                        FilePath = Path.Combine(uploadPath, newFileName),
                        AuthToken = LoggedInContext.authorization
                    };
                    var result = _dailyUploadExcelService.UpsertExcelToCustomApplicationDetails(inputModel, false, LoggedInContext, validationMessages);

                    //var ExcelToCustomApplicationsForm1 = ConfigurationManager.AppSettings["ExcelToCustomApplicationsForm1"];
                    //if (ExcelToCustomApplicationsForm1 != null && filename.Contains(ExcelToCustomApplicationsForm1))
                    //{
                    //    inputModel.CustomApplicationId = Guid.Parse(ConfigurationManager.AppSettings["ExcelToCustomApplicationsCustomApplicationId1"]);
                    //    inputModel.FormId = Guid.Parse(ConfigurationManager.AppSettings["ExcelToCustomApplicationsFormId1"]);
                    //    var result = _dailyUploadExcelService.UpsertExcelToCustomApplicationDetails(inputModel, false, LoggedInContext, validationMessages);
                    //}
                    //else
                    //{
                    //    var errorMessages = new List<ApiResponseMessage>();
                    //    errorMessages.Add(new ApiResponseMessage
                    //    {
                    //        FieldName = "Excel",
                    //        Message = "Excel sheet name does not match",
                    //        MessageTypeEnum = MessageTypeEnum.Error
                    //    });
                    //    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = errorMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);

                    //}

                }


                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ExcelToCustomApplicationRecords", "ExcelApiController"));

                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExcelToCustomApplicationRecords", "ExcelApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetExcelToCustomApplicationsDetails)]
        public JsonResult<BtrakJsonResult> GetExcelToCustomApplicationsDetails(ExcelToCustomApplicationsDetailsSearchModel searchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExcelToCustomApplicationsDetails", "ExcelApiController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ExcelToCustomApplicationRecordsDetailsModel> excelDetails =  _dailyUploadExcelService.GetExcelToCustomApplicationsDetails(searchModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExcelToCustomApplicationsDetails", "ExcelApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExcelToCustomApplicationsDetails", "ExcelApiController"));

                return Json(new BtrakJsonResult { Data = excelDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);


            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExcelToCustomApplicationsDetails", "ExcelApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExcelToCustomApplicationDetails)]
        public JsonResult<BtrakJsonResult> UpsertExcelToCustomApplicationDetails(ExcelSheetDetailsInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExcelToCustomApplicationDetails", "ExcelApiController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var excelSheetDetails = new DailyUploadExcelsInputModel
                {
                    ExcelSheetName = inputModel.ExcelSheetName,
                    MailAddress = inputModel.MailAddress,
                    FilePath = inputModel.FilePath,
                    CustomApplicationId = null,
                    FormId = null,
                    IsUploaded = inputModel.IsUploaded,
                    IsHavingErrors = inputModel.IsHavingErrors,
                    NeedManualCorrection = inputModel.NeedManualCorrection,
                    AuthToken = LoggedInContext.authorization
                };
                var result = _dailyUploadExcelService.UpsertExcelToCustomApplicationDetails(excelSheetDetails, inputModel.UpdateRecord, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExcelToCustomApplicationDetails", "ExcelApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExcelToCustomApplicationDetails", "ExcelApiController"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);


            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExcelToCustomApplicationDetails", "ExcelApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDetailsForEmailsReader)]
        public JsonResult<BtrakJsonResult> GetDetailsForEmailsReader()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDetailsForEmailsReader", "ExcelApiController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<EmailsReaderDetailsModel> excelDetails = _dailyUploadExcelService.GetDetailsForEmailsReader(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDetailsForEmailsReader", "ExcelApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDetailsForEmailsReader", "ExcelApiController"));

                return Json(new BtrakJsonResult { Data = excelDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);


            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDetailsForEmailsReader", "ExcelApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }

}
