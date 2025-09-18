using Formio.Helpers;
using Formio.Models;
using formioCommon.Constants;
using formioModels;
using formioModels.Dashboard;
using formioModels.Data;
using formioModels.ProfitAndLoss;
using formioServices.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Formio.Controllers.DataService
{
    [ApiController]
    public class DataSetApiController : AuthTokenApiController
    {
        private readonly IDataSetService _dataSetService;

        public DataSetApiController(IDataSetService iDataSetService)
        {
            _dataSetService = iDataSetService;
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateDataSet)]
        public JsonResult CreateDataSet(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var dataSetId = _dataSetService.CreateDataSet(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDataSetJson)]
        public JsonResult UpdateDataSetJson(UpdateDataSetDataJsonModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetJson", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var dataSetId = _dataSetService.UpdateDataSetJson(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetJson", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetJson", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSetJson", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateMultipleDataSet)]
        public JsonResult CreateMultipleDataSet(List<DataSetInputModel> dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateMultipleDataSet", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                List<RFQReferenceOutputModel> rFQReferenceOutputModels = new List<RFQReferenceOutputModel>();
                var dataSetObj = JsonConvert.DeserializeObject<DataSetConversionOutputModel>(dataSetUpsertInputModel[0].DataJson);
                var rfqId = _dataSetService.GetDataSetLatestRFQId(new Guid(dataSetObj.TemplateTypeId.ToString()), validationMessages);
                rfqId = rfqId + 1;
                foreach (var dataset in dataSetUpsertInputModel)
                {
                    var rFQReferenceOutput = new RFQReferenceOutputModel();
                    var setObj = JsonConvert.DeserializeObject<DataSetConversionOutputModel>(dataset.DataJson);
                    setObj.RFQId = rfqId;
                    dataset.DataJson = JsonConvert.SerializeObject(setObj);
                    var dataSetId = _dataSetService.CreateDataSet(dataset, LoggedInContext, validationMessages);
                    var DataJson = JsonConvert.DeserializeObject<DataSetConversionOutputModel>(dataset.DataJson);

                    rFQReferenceOutput.Id = dataSetId;
                    rFQReferenceOutput.ReferenceId = DataJson.BrokerId != null ? DataJson.BrokerId : DataJson.ClientId;
                    rFQReferenceOutput.IsBroker = DataJson.BrokerId != null ? true : false;
                    rFQReferenceOutput.RFQId = rfqId;
                    rFQReferenceOutput.RFQUniqueId = setObj.RFQUniqueId;
                    rFQReferenceOutputModels.Add(rFQReferenceOutput);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateMultipleDataSet", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateMultipleDataSet", "DataSourceController"));

                return Json(new DataJsonResult { Data = rFQReferenceOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateMultipleDataSet", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateMultipleDataSetSteps)]
        public JsonResult CreateMultipleDataSetSteps(List<DataSetInputModel> dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateMultipleDataSetSteps", "DataSetAPIController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                List<Guid?> guids = new List<Guid?>();
                
                  List<Guid?> dataSetIds = _dataSetService.CreateMultipleDataSetSteps(dataSetUpsertInputModel, LoggedInContext, validationMessages);
                
                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateMultipleDataSetSteps", "DataSetAPIController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateMultipleDataSetSteps", "DataSetAPIController"));

                return Json(new DataJsonResult { Data = dataSetIds, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateMultipleDataSetSteps", "DataSetAPIController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLatestSwitchBlDataSets)]
        public JsonResult GetLatestSwitchBlDataSets(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLatestSwitchBlDetails", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var dataSetObj = JsonConvert.DeserializeObject<DataSetConversionOutputModel>(dataSetUpsertInputModel.DataJson);
                var switchBlDetails = _dataSetService.GetLatestSwitchBlDataSets(dataSetObj.IsSwitchBl, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateMultipleDataSet", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateMultipleDataSet", "DataSourceController"));

                return Json(new DataJsonResult { Data = switchBlDetails, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateMultipleDataSet", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreatePublicDataSet)]
        public JsonResult CreatePublicDataSet(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var dataSetId = _dataSetService.CreatePublicDataSet(dataSetUpsertInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateUserDataSetRelation)]
        public JsonResult CreateUserDataSetRelation(UserDataSetInputModel userDataSetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateUserDataSetRelation", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var dataSetId = _dataSetService.CreateUserDataSetRelation(userDataSetInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateUserDataSetRelation", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateUserDataSetRelation", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateUserDataSetRelation", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDataSetCountBasedOnTodaysCount)]
        public JsonResult GetDataSetCountBasedOnTodaysCount()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var dataSetsCount = _dataSetService.GetDataSetCountBasedOnTodaysCount(validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetsCount, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPublicDataSetCountBasedOnTodaysCount)]
        public JsonResult GetPublicDataSetCountBasedOnTodaysCount()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var dataSetsCount = _dataSetService.GetDataSetCountBasedOnTodaysCount(validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetsCount, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetCountBasedOnTodaysCount", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDataSet)]
        public JsonResult UpdateDataSet(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSetService.UpdateDataSet(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdatePublicDataSet)]
        public JsonResult UpdatePublicDataSet(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSetService.UpdatePublicDataSet(dataSetUpsertInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDataSetJob)]
        [AllowAnonymous]
        public JsonResult UpdateDataSetJob(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetJob", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSetService.UpdateDataSetJob(dataSetUpsertInputModel, validationMessages);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSets)]
        public JsonResult SearchDataSets(Guid? id, Guid? dataSourceId, string searchText,string paramsJsonModel, bool? isArchived,bool? isPagingRequired, int pageNumber, int pageSize, bool? isInnerQuery, bool? forFormFieldValue, string keyName, string keyValue, bool? forRecordValue, string paths = null, string companyIds = null, string dataSourceIds = null, string dataSetIds = null)
        {
            try
            {
                DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel =
                    new DataSetSearchCriteriaInputModel();
                dataSetSearchCriteriaInputModel.Id = id;
                dataSetSearchCriteriaInputModel.DataSourceId = dataSourceId;
                dataSetSearchCriteriaInputModel.SearchText = searchText;
                dataSetSearchCriteriaInputModel.IsArchived = isArchived == null ? false : isArchived;
                dataSetSearchCriteriaInputModel.PageNumber = pageNumber;
                dataSetSearchCriteriaInputModel.PageSize = pageSize;
                dataSetSearchCriteriaInputModel.IsPagingRequired = isPagingRequired;
                dataSetSearchCriteriaInputModel.IsInnerQuery = isInnerQuery;
                dataSetSearchCriteriaInputModel.ForFormFieldValue = forFormFieldValue;
                dataSetSearchCriteriaInputModel.KeyName = keyName;
                dataSetSearchCriteriaInputModel.KeyValue = keyValue;
                dataSetSearchCriteriaInputModel.ForRecordValue = forRecordValue;
                dataSetSearchCriteriaInputModel.Paths = paths;
                if (!string.IsNullOrEmpty(companyIds))
                {
                    string[] ids = companyIds.Split(new[] { ',' });
                    dataSetSearchCriteriaInputModel.CompanyIds = ids.Select(Guid.Parse).ToList();
                }
                if (!string.IsNullOrEmpty(paramsJsonModel))
                {
                    dataSetSearchCriteriaInputModel.DataJsonInputs = JsonConvert.DeserializeObject<List<ParamsJsonModel>>(paramsJsonModel);
                } else
                {
                    dataSetSearchCriteriaInputModel.DataJsonInputs = new List<ParamsJsonModel>();
                }
                if (!string.IsNullOrEmpty(dataSourceIds))
                {
                    string[] ids = dataSourceIds.Split(new[] { ',' });
                    dataSetSearchCriteriaInputModel.DataSourceIds = ids.Select(Guid.Parse).ToList();
                }
                if (!string.IsNullOrEmpty(dataSetIds))
                {
                    string[] ids = dataSetIds.Split(new[] { ',' });
                    dataSetSearchCriteriaInputModel.DataSetIds = ids.Select(Guid.Parse).ToList();
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<DataSetOutputModel> dataSetOutputModelList = _dataSetService.SearchDataSets(dataSetSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDataSetLatestProgramId)]
        public JsonResult GetDataSetLatestProgramId(Guid? countryId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetLatestProgramId", "DataSetController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var id = _dataSetService.GetDataSetLatestProgramId(countryId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetLatestProgramId", "DataSetController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetLatestProgramId", "DataSetController"));

                return Json(new DataJsonResult { Data = id, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetLatestProgramId", "DataSetController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSetsForForms)]
        public JsonResult SearchDataSetsForForms(Guid? id, Guid? dataSourceId, string searchText, string paramsJsonModel, bool? isArchived, bool? isPagingRequired, int pageNumber, int pageSize, bool advancedFilter, string fieldsJson, string keyFilterJson, bool isRecordLevelPermissionEnabled, int ConditionalEnum, string RoleIds, string recordFilterJson)
        {
            try
            {
                DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel =
                    new DataSetSearchCriteriaInputModel();
                dataSetSearchCriteriaInputModel.Id = id;
                dataSetSearchCriteriaInputModel.DataSourceId = dataSourceId;
                dataSetSearchCriteriaInputModel.SearchText = searchText;
                dataSetSearchCriteriaInputModel.IsArchived = isArchived == null ? false : isArchived;
                dataSetSearchCriteriaInputModel.PageNumber = pageNumber;
                dataSetSearchCriteriaInputModel.PageSize = pageSize;
                dataSetSearchCriteriaInputModel.IsPagingRequired = isPagingRequired;
                dataSetSearchCriteriaInputModel.AdvancedFilter = advancedFilter;
                dataSetSearchCriteriaInputModel.IsRecordLevelPermissionEnabled = isRecordLevelPermissionEnabled;
                dataSetSearchCriteriaInputModel.ConditionalEnum = ConditionalEnum;
                dataSetSearchCriteriaInputModel.RoleIds = RoleIds;
                if (!string.IsNullOrWhiteSpace(recordFilterJson))
                {
                    dataSetSearchCriteriaInputModel.RecordFilters = JsonConvert.DeserializeObject<List<RecordLevelPermissionInputModel>>(recordFilterJson);
                }
                if (!string.IsNullOrEmpty(fieldsJson))
                {
                    dataSetSearchCriteriaInputModel.Fields = JsonConvert.DeserializeObject<List<FieldSearchModel>>(fieldsJson);
                }
                else
                {
                    dataSetSearchCriteriaInputModel.Fields = new List<FieldSearchModel>();
                }
                if (!string.IsNullOrEmpty(paramsJsonModel))
                {
                    dataSetSearchCriteriaInputModel.DataJsonInputs = JsonConvert.DeserializeObject<List<ParamsJsonModel>>(paramsJsonModel);
                }
                else
                {
                    dataSetSearchCriteriaInputModel.DataJsonInputs = new List<ParamsJsonModel>();
                }
                if (!string.IsNullOrEmpty(keyFilterJson))
                {
                    dataSetSearchCriteriaInputModel.KeyFilterJson = keyFilterJson.Split(',').ToList<string>();
                }
                else
                {
                    dataSetSearchCriteriaInputModel.KeyFilterJson = new List<string>();
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<DataSetOutputModelForForms> dataSetOutputModelList = _dataSetService.SearchDataSetsForForms(dataSetSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSetsForJob)]
        [AllowAnonymous]
        public JsonResult SearchDataSetForJob(Guid? id, Guid? dataSourceId, string searchText, bool? isArchived)
        {
            try
            {
                DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel =
                    new DataSetSearchCriteriaInputModel();
                dataSetSearchCriteriaInputModel.Id = id;
                dataSetSearchCriteriaInputModel.DataSourceId = dataSourceId;
                dataSetSearchCriteriaInputModel.SearchText = searchText;
                dataSetSearchCriteriaInputModel.IsArchived = isArchived;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSetForJob", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<DataSetOutputModel> dataSetOutputModelList = _dataSetService.SearchDataSetsForJob(dataSetSearchCriteriaInputModel, validationMessages);


                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDataSetById)]

        public JsonResult GetDataSetById(Guid? id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetsById", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<DataSetOutputModel> dataSetOutputModelList = _dataSetService.GetDataSetsById(id, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetsById", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetsById", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDataSetByDataSourceKeyId)]

        public JsonResult GetDataSetByDataSourceKeyId(Guid? id, Guid? keyId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetsById", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                DataSetKeyOutputModel dataSetOutputModelList = _dataSetService.GetDataSetByKeyId(id,keyId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetsById", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetsById", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.DeleteDatasetById)]

        public Task<Object> DeleteDatasetById(Guid? id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteDatasetById", "DataSetService"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var dataSetOutputModelList = _dataSetService.DeleteDatasetById(id, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteDatasetById", "DataSetService"));
                    return dataSetOutputModelList;
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteDatasetById", "DataSetService"));

                return dataSetOutputModelList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteDatasetById", "DataSetApiController", exception.Message), exception);

                return null;
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteMultipleDataSets)]

        public JsonResult DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteMultipleDataSets", "DataSetService"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var response = _dataSetService.DeleteMultipleDataSets(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteMultipleDataSets", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteMultipleDataSets", "DataSourceController"));

                return Json(new DataJsonResult { Data = true, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteMultipleDataSets", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UnArchiveMultipleDataSets)]

        public JsonResult UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UnArchiveMultipleDataSets", "DataSetService"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var response = _dataSetService.UnArchiveMultipleDataSets(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UnArchiveMultipleDataSets", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UnArchiveMultipleDataSets", "DataSourceController"));

                return Json(new DataJsonResult { Data = true, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UnArchiveMultipleDataSets", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        //================================================SGT1 Dashboard API's===================================================\\

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDashboard)]

        public JsonResult GetDashboard(DashboardInputModel salesDashboardInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboard", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                PositionDashboardOutputModel dataSetOutputModelList = _dataSetService.GetDashboard(salesDashboardInput, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboard", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboard", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRealisedPandLDashboard)]

        public JsonResult GetRealisedPandLDashboard(DashboardInputModel DashboardInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRealisedPandLDashboard", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                FinalReliasedOutputModel dataSetOutputModelList = _dataSetService.GetRealisedPandLDashboard(DashboardInput, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRealisedPandLDashboard", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRealisedPandLDashboard", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRealisedPandLDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUnRealisedPandLDashboard)]

        public JsonResult GetUnRealisedPandLDashboard(DashboardInputModel DashboardInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnRealisedPandLDashboard", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                FinalUnReliasedOutputModel dataSetOutputModelList = _dataSetService.GetUnRealisedPandLDashboard(DashboardInput, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnRealisedPandLDashboard", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnRealisedPandLDashboard", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnRealisedPandLDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInstanceLevelDashboard)]

        public JsonResult GetInstanceLevelDashboard(DashboardInputModel salesDashboardInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboard", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                InstanceLevelPositionDashboardOutputModel dataSetOutputModelList = _dataSetService.GetInstanceLevelDashboard(salesDashboardInput, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboard", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboard", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInstanceLevelPandLDashboard)]

        public JsonResult GetInstanceLevelPandLDashboard(DashboardInputModel salesDashboardInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelPandLDashboard", "DataSetApiController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                List<InstanceLevelPofitLossOutputModel> dataSetOutputModelList = _dataSetService.GetInstanceLevelProfitLossDashboard(salesDashboardInput, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInstanceLevelPandLDashboard", "DataSetApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboard", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.RefreshVesselSummary)]
        public JsonResult RefreshVesselSummary(RefreshVesselSummaryInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RefreshVesselSummary", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;

                _dataSetService.RefreshVesselSummary(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RefreshVesselSummary", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RefreshVesselSummary", "DataSourceController"));

                return Json(new DataJsonResult { Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RefreshVesselSummary", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route("DataService/DataSourceApi/GetUniqueValidation")]
        public JsonResult GetUniqueValidation(UniqueValidateModel uvModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUniqueValidation", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var dataSetId = _dataSetService.GetUniqueValidation(uvModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUniqueValidation", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUniqueValidation", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUniqueValidation", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetQueryDashboard)]

        public JsonResult GetQueryDashboard(GetQueryDataInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQueryDashboard", "DataSetService"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var dataSetOutputModelList = _dataSetService.GetQueryData(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQueryDashboard", "DataSetService"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });

                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQueryDashboard", "DataSetService"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQueryDashboard", "DataSetApiController", exception.Message), exception);

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCollections)]

        public JsonResult GetCollections()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCollections", "DataSetService"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var result = _dataSetService.GetCollections(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCollections", "DataSetService"));
                    return Json(new DataJsonResult { Success = false });

                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCollections", "DataSetService"));

                return Json(new DataJsonResult { Data = result, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCollections", "DataSetApiController", exception.Message), exception);

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetVesselDashboardNew)]
        public JsonResult GetVesselDashboard(VesselDashboardInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVesselDashboard", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                VesselDashboardOutputModel result = _dataSetService.GetVesselDashboard(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVesselDashboard", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetVesselDashboard", "DataSourceController"));

                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetVesselDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPositionsDashboard)]
        public JsonResult GetPositionsDashboard(PositionsDashboardInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionsDashboard", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                List<PositionData> result = _dataSetService.GetPositionsDashboard(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionsDashboard", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPositionsDashboard", "DataSourceController"));

                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionsDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UpdateYTDPandLHistory)]
        public JsonResult UpdateYTDPandLHistory(PositionsDashboardInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateYTDPandLHistory", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                _dataSetService.UpdateYTDPandLHistory(inputModel, new LoggedInContext(), validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateYTDPandLHistory", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateYTDPandLHistory", "DataSourceController"));

                return Json(new DataJsonResult { Data = null, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionsDashboard", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCO2EmmisionReport)]
        public JsonResult GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCO2EmmisionReport", "DataSetController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                List<GetCO2EmmisionReportOutputModel> result = _dataSetService.GetCO2EmmisionReport(inputModel, new LoggedInContext(), validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCO2EmmisionReport", "DataSetController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCO2EmmisionReport", "DataSetController"));

                return Json(new DataJsonResult { Data = result, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCO2EmmisionReport", "DataSetController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.FieldUpdateWorkFlow)]
        public JsonResult FieldUpdateWorkFlow(FieldUpdateWorkFlowModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FieldUpdateWorkFlow", "DataSetController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                inputModel.FieldUpdateModel = JsonConvert.DeserializeObject<List<FieldUpdateModel>>(inputModel.FieldUpdateModelJson).ToList();

                _dataSetService.FieldUpdateWorkFlow(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FieldUpdateWorkFlow", "DataSetController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FieldUpdateWorkFlow", "DataSetController"));

                return Json(new DataJsonResult { Data = null, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FieldUpdateWorkFlow", "DataSetController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDataSetWorkFlow)]
        public JsonResult UpdateDataSetWorkFlow(UpdateDataSetWorkFlowModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetWorkFlow", "DataSetController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSetService.UpdateDataSetWorkFlow(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetWorkFlow", "DataSetController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetWorkFlow", "DataSetController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSetWorkFlow", "DataSetController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchDataSetsForFormsUnAuth)]
        public JsonResult SearchDataSetsForFormsUnAuth(Guid? id, Guid? dataSourceId, string searchText, string paramsJsonModel, bool? isArchived, bool? isPagingRequired, int pageNumber, int pageSize, bool advancedFilter, string fieldsJson, string keyFilterJson)
        {
            try
            {
                DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel =
                    new DataSetSearchCriteriaInputModel();
                dataSetSearchCriteriaInputModel.Id = id;
                dataSetSearchCriteriaInputModel.DataSourceId = dataSourceId;
                dataSetSearchCriteriaInputModel.SearchText = searchText;
                dataSetSearchCriteriaInputModel.IsArchived = isArchived == null ? false : isArchived;
                dataSetSearchCriteriaInputModel.PageNumber = pageNumber;
                dataSetSearchCriteriaInputModel.PageSize = pageSize;
                dataSetSearchCriteriaInputModel.IsPagingRequired = isPagingRequired;
                dataSetSearchCriteriaInputModel.AdvancedFilter = advancedFilter;

                if (!string.IsNullOrEmpty(fieldsJson))
                {
                    dataSetSearchCriteriaInputModel.Fields = JsonConvert.DeserializeObject<List<FieldSearchModel>>(fieldsJson);
                }
                else
                {
                    dataSetSearchCriteriaInputModel.Fields = new List<FieldSearchModel>();
                }
                if (!string.IsNullOrEmpty(paramsJsonModel))
                {
                    dataSetSearchCriteriaInputModel.DataJsonInputs = JsonConvert.DeserializeObject<List<ParamsJsonModel>>(paramsJsonModel);
                }
                else
                {
                    dataSetSearchCriteriaInputModel.DataJsonInputs = new List<ParamsJsonModel>();
                }
                if (!string.IsNullOrEmpty(keyFilterJson))
                {
                    dataSetSearchCriteriaInputModel.KeyFilterJson = keyFilterJson.Split(',').ToList<string>();
                }
                else
                {
                    dataSetSearchCriteriaInputModel.KeyFilterJson = new List<string>();
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSetsUnAuth", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<DataSetOutputModelForForms> dataSetOutputModelList = _dataSetService.SearchDataSetsForFormsUnAuth(dataSetSearchCriteriaInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSetsUnAuth", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSetsUnAuth", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetOutputModelList, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSetsUnAuth", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.CreateDataSetUnAuth)]
        public JsonResult CreateDataSetUnAuth(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetUnAuth", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var dataSetId = _dataSetService.CreateDataSetUnAuth(dataSetUpsertInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetUnAuth", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetUnAuth", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSetUnAuth", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UpdateDataSetUnAuth)]
        public JsonResult UpdateDataSetUnAuth(DataSetInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetUnAuth", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSetService.UpdateDataSetUnAuth(dataSetUpsertInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetUnAuth", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetUnAuth", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSetUnAuth", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

    }
}
