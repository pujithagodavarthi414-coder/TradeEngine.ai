using Formio.Helpers;
using Formio.Models;
using formioCommon.Constants;
using formioModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using formioModels.Data;
using formioServices.Data;
using Microsoft.AspNetCore.Authorization;
using System.Linq;
using Newtonsoft.Json;

namespace Formio.Controllers.DataService
{
    [ApiController]
    public class DataSourceApiController : AuthTokenApiController
    {
        private readonly IDataSourceService _dataService;

        public DataSourceApiController(IDataSourceService dataService)
        {
            _dataService = dataService;
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateDataSource)]
        public JsonResult CreateDataSource(DataSourceFakeInputModel dataSourceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSource", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var dataSourceId = _dataService.CreateDataSource(dataSourceInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSource", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSource", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSourceId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDataSource)]
        public JsonResult UpdateDataSource(DataSourceFakeInputModel dataSourceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSource", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var dataSourceId = _dataService.UpdateDataSource(dataSourceInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSource", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSource", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSourceId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSource)]
        public JsonResult SearchDataSource(Guid? id, Guid? key, Guid? companyModuleId, string formIds, string paramsJsonModel, string searchText, bool? isArchived, string validCompanies,bool isCompanyBased, string dataSourceType, bool? isIncludedAllForms)
        {
            try
            {
                DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel =
                    new DataSourceSearchCriteriaInputModel();
                dataSourceSearchCriteriaInputModel.Id = id;
                dataSourceSearchCriteriaInputModel.Key = key;
                dataSourceSearchCriteriaInputModel.CompanyModuleId = companyModuleId;
                dataSourceSearchCriteriaInputModel.SearchText = searchText;
                dataSourceSearchCriteriaInputModel.IsArchived = isArchived;
                dataSourceSearchCriteriaInputModel.IsCompanyBased = isCompanyBased;
                dataSourceSearchCriteriaInputModel.IsIncludedAllForms = isIncludedAllForms;
                if (!string.IsNullOrEmpty(validCompanies))
                {
                    string[] ids = validCompanies.Split(new[] { ',' });
                    dataSourceSearchCriteriaInputModel.UserCompanyIds = ids.Select(Guid.Parse).ToList();
                }
                if (!string.IsNullOrEmpty(formIds))
                {
                    string[] formIdsList = formIds.Split(new[] { ',' });

                    List<Guid> allFormIds = formIdsList.Select(Guid.Parse).ToList();
                    dataSourceSearchCriteriaInputModel.FormIds = allFormIds;
                    dataSourceSearchCriteriaInputModel.FormIdsList = formIds;

                } 
                else
                {
                    dataSourceSearchCriteriaInputModel.FormIds = new List<Guid>();
                }

                if(!string.IsNullOrEmpty(paramsJsonModel))
                {
                    dataSourceSearchCriteriaInputModel.ParamsJson = JsonConvert.DeserializeObject<List<ParamsJsonModel>>(paramsJsonModel);
                } else
                {
                    dataSourceSearchCriteriaInputModel.ParamsJson = new List<ParamsJsonModel>();
                }

                if(!string.IsNullOrEmpty(dataSourceType))
                {
                    string[] dataSouceTypes = dataSourceType.Split(new[] { ',' });
                    dataSourceSearchCriteriaInputModel.DataSourceType = dataSouceTypes.Select(x => x.ToString()).ToList();
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSource", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<DataSourceOutputModel> dataSources = _dataService.SearchDataSource(dataSourceSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSource", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSource", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSource", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSourceForJob)]
        [AllowAnonymous]
        public JsonResult SearchDataSourceForJob(Guid? id, Guid? key,  string searchText, bool? isArchived)
        {
            try
            {
                DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel =
                    new DataSourceSearchCriteriaInputModel();
                dataSourceSearchCriteriaInputModel.Id = id;
                dataSourceSearchCriteriaInputModel.Key = key;
                dataSourceSearchCriteriaInputModel.SearchText = searchText;
                dataSourceSearchCriteriaInputModel.IsArchived = isArchived;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceForJob", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                //DataJsonResult dataJsonResult;
                List<DataSourceOutputModel> dataSources = _dataService.SearchDataSourceForJob(dataSourceSearchCriteriaInputModel, validationMessages);

                //if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                //{
                //    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                //    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceForJob", "DataSourceController"));
                //    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                //}

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceForJob", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceForJob", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAllDataSources)]
        public JsonResult SearchAllDataSources(SearchDataSourceInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAllDataSources", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<SearchDataSourceOutputModel> dataSources = _dataService.SearchAllDataSources(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAllDataSources", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAllDataSources", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAllDataSources", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDataSourcesById)]
        public JsonResult GetDataSourcesById(GetDataSourcesByIdInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSourcesById", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<GetDataSourcesByIdOutputModel> dataSources = _dataService.GetDataSourcesById(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSourcesById", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSourcesById", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSourcesById", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GenericQueryApi)]
        public JsonResult GenericQueryApi(string inputQuery)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenericQueryApi", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                string dataSources = _dataService.GenericQueryApi(inputQuery, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenericQueryApi", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenericQueryApi", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenericQueryApi", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFormFieldValues)]
        public JsonResult GetFormFieldValues(GetFormFieldValuesInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormFieldValues", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                GetFormFieldValuesOutputModel dataSources = _dataService.GetFormFieldValues(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFormFieldValues", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFormFieldValues", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFormRecordValues)]
        public JsonResult GetFormRecordValues(GetFormRecordValuesInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormRecordValues", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                var dataSources = _dataService.GetFormRecordValues(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFormRecordValues", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFormRecordValues", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormRecordValues", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route("DataService/DataSourceApi/BackgroundLookupLink")]
        public string BackgroundLookupLink(LookupLinkModel llmodel)
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();
                return _dataService.BackgroundLookupLink(llmodel.CustomApplicationId, llmodel.FormId, llmodel.CompanyIds, LoggedInContext, validationMessages);
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "BackgroundLookupLink", "DataSourceController", e.Message), e);
                return null;
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route("DataService/DataSourceApi/UpdateLookupChildDataWithNewVar")]
        public void UpdateLookupChildDataWithNewVar()
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();
                _dataService.UpdateLookupChildDataWithNewVar(null, validationMessages);
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateLookupChildDataWithNewVar", "DataSourceController", e.Message), e);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route("DataService/DataSourceApi/GetNotifications")]
        public List<NotificationModel> GetNotifications()
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();
                return _dataService.GetNotifications(LoggedInContext, validationMessages);
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNotifications", "DataSourceController", e.Message), e);
                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route("DataService/DataSourceApi/UpsertReadNewNotifications")]
        public List<Guid?> UpsertReadNewNotifications(NotificationReadModel model)
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();
                return _dataService.UpsertReadNewNotifications(model, LoggedInContext, validationMessages);
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReadNewNotifications", "DataSourceController", e.Message), e);
                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchDataSourceUnAuth)]
        public JsonResult SearchDataSourceUnAuth(Guid? id, Guid? key, Guid? companyModuleId, string formIds, string paramsJsonModel, string searchText, bool? isArchived, string validCompanies, bool isCompanyBased, string dataSourceType)
        {
            try
            {
                DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel =
                    new DataSourceSearchCriteriaInputModel();
                dataSourceSearchCriteriaInputModel.Id = id;
                dataSourceSearchCriteriaInputModel.Key = key;
                dataSourceSearchCriteriaInputModel.CompanyModuleId = companyModuleId;
                dataSourceSearchCriteriaInputModel.SearchText = searchText;
                dataSourceSearchCriteriaInputModel.IsArchived = isArchived;
                dataSourceSearchCriteriaInputModel.IsCompanyBased = isCompanyBased;
                if (!string.IsNullOrEmpty(validCompanies))
                {
                    string[] ids = validCompanies.Split(new[] { ',' });
                    dataSourceSearchCriteriaInputModel.UserCompanyIds = ids.Select(Guid.Parse).ToList();
                }
                if (!string.IsNullOrEmpty(formIds))
                {
                    string[] formIdsList = formIds.Split(new[] { ',' });

                    List<Guid> allFormIds = formIdsList.Select(Guid.Parse).ToList();
                    dataSourceSearchCriteriaInputModel.FormIds = allFormIds;
                    dataSourceSearchCriteriaInputModel.FormIdsList = formIds;

                }
                else
                {
                    dataSourceSearchCriteriaInputModel.FormIds = new List<Guid>();
                }

                if (!string.IsNullOrEmpty(paramsJsonModel))
                {
                    dataSourceSearchCriteriaInputModel.ParamsJson = JsonConvert.DeserializeObject<List<ParamsJsonModel>>(paramsJsonModel);
                }
                else
                {
                    dataSourceSearchCriteriaInputModel.ParamsJson = new List<ParamsJsonModel>();
                }

                if (!string.IsNullOrEmpty(dataSourceType))
                {
                    string[] dataSouceTypes = dataSourceType.Split(new[] { ',' });
                    dataSourceSearchCriteriaInputModel.DataSourceType = dataSouceTypes.Select(x => x.ToString()).ToList();
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceUnAuth", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult dataJsonResult;
                List<DataSourceOutputModel> dataSources = _dataService.SearchDataSourceUnAuth(dataSourceSearchCriteriaInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out dataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceUnAuth", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = dataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceUnAuth", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSources, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceUnAuth", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

       

    }
}
