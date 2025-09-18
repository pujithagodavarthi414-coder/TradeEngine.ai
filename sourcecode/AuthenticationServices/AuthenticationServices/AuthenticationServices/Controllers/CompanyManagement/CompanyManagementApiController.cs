using AuthenticationServices.Api.Controllers.Api;
using AuthenticationServices.Api.Helpers;
using AuthenticationServices.Api.Models;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.Modules;
using AuthenticationServices.Services.CompanyManagement;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;


namespace AuthenticationServices.Api.Controllers.CompanyManagement
{
    [ApiController]
    public class CompanyManagementApiController : AuthTokenApiController
    {
        private readonly ICompanyManagementService _companyManagementService;
        IConfiguration _iconfiguration;
        public CompanyManagementApiController(ICompanyManagementService companyManagementService, IConfiguration iconfiguration)
        {
            _companyManagementService = companyManagementService;
            _iconfiguration = iconfiguration;
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompany)]
        public JsonResult UpsertCompany(CompanyInputModel companyInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompany", "companyInputModel", companyInputModel, "CompanyManagementApi"));

                BtrakJsonResult btrakJsonResult;

                if (companyInputModel != null)
                {
                    companyInputModel.MainPassword = companyInputModel.Password;
                }

                _companyManagementService.CheckUpsertCompanyValidations(companyInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompany", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                companyInputModel.IdentityServerCallback = _iconfiguration["IdentityServerUrl"];

                UpsertCompanyOutputModel companyDetails = _companyManagementService.UpsertCompany(new LoggedInContext(), companyInputModel, new List<ValidationMessage>());
               
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompany", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = companyDetails, Success = true });
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage =
                        string.Format(sqlEx.Message, ValidationMessages.ExceptionUpsertCompany)
                });

                return null;
            }
        }

        [HttpPut]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyDetails)]
        public JsonResult UpsertCompanyDetails(CompanyInputModel companyInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyDetails", "companyInputModel", LoggedInContext, "CompanyManagementApi"));
                if(companyInputModel.IsDemoDataCleared == true)
                {
                    Guid? companyId = _companyManagementService.DeleteCompanyTestData(LoggedInContext, validationMessages);
                    return Json(new BtrakJsonResult { Data = companyId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                else {
                    if (companyInputModel.Key == null)
                    {
                        if (companyInputModel != null)
                        {
                            companyInputModel.MainPassword = companyInputModel.Password;
                        }
                        Guid? companyId = _companyManagementService.UpsertCompanyDetails(companyInputModel, LoggedInContext, validationMessages);
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyDetails", "CompanyManagementApi"));
                        return Json(new BtrakJsonResult { Data = companyId, Success = true });
                    }
                    else
                    {
                        var companyId = _companyManagementService.UpdateCompanyDetails(companyInputModel, LoggedInContext, validationMessages);
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateCompanyDetails", "CompanyManagementApi"));
                        return Json(new BtrakJsonResult { Data = companyId, Success = true });
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyDetails", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchCompanies)]
        public JsonResult SearchCompanies(Guid? CompanyId, Guid? TimeZoneId, Guid? MainUseCaseId, Guid? IndustryId, Guid? CountryId, Guid? CurrencyId, Guid? NumberFormatId, Guid? DateFormatId, Guid? TimeFormatId, int? TeamSize, string PhoneNumber, string SearchText,int PageNumber = 1,int PageSize = 10)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                CompanySearchCriteriaInputModel companySearchCriteriaInputModel = new CompanySearchCriteriaInputModel()
                {
                    CompanyId = CompanyId,
                    TimeZoneId = TimeZoneId,
                    MainUseCaseId = MainUseCaseId,
                    IndustryId = IndustryId,
                    CountryId = CountryId,
                    CurrencyId = CurrencyId,
                    NumberFormatId = NumberFormatId,
                    DateFormatId = DateFormatId,
                    TimeFormatId = TimeFormatId,
                    TeamSize = TeamSize,
                    PhoneNumber = PhoneNumber,
                    SearchText = SearchText,
                    PageNumber = PageNumber,
                    PageSize = PageSize

                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCompanies", "companySearchCriteriaInputModel", companySearchCriteriaInputModel, "CompanyManagementApi"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Companies list ");
                List<CompanyOutputModel> companiesList = _companyManagementService.SearchCompanies(companySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanies", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanies", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = companiesList, Success = true });
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCompany)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyModules)]
        public JsonResult GetCompanyModules(Guid? companyId, string searchText = null, int pageNumber = 1, int pageSize = 10)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                CompanyModuleSearchInputModel companySearchCriteriaInputModel = new CompanyModuleSearchInputModel()
                {
                    CompanyId = companyId,
                    SearchText = searchText,
                    PageNumber = pageNumber,
                    PageSize = pageSize

                };
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyModules", "companySearchCriteriaInputModel", companySearchCriteriaInputModel, "CompanyManagementApi"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting CompanyModules list ");
                List<CompanyModuleOutputModel> companiesList = _companyManagementService.GetCompanyModules(companySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyModules", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyModules", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = companiesList, Success = true });
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCompany)
                });

                return null;
            }
        }
      

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyById)]
        public JsonResult GetCompanyById(Guid? companyId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyById", "companyId", companyId, "CompanyManagementApi"));
                BtrakJsonResult btrakJsonResult;
                CompanyOutputModel companyDetails = _companyManagementService.GetCompanyById(companyId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyById", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyById", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = companyDetails, Success = true });
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionCompanyById)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.CompanyDetails)]
        public JsonResult GetCompanyDetails()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyDetails", "GetCompanyDetailsModel", LoggedInContext, "CompanyManagementApi"));
                BtrakJsonResult btrakJsonResult;
                var companyDetails = _companyManagementService.GetCompanyDetails(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyDetails", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyDetails", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = companyDetails, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyDetails", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpDelete]
        [HttpOptions]
        [Route(RouteConstants.DeleteCompanyModule)]
        public JsonResult DeleteCompanyModule(string deleteCompanyModuleModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                var archiveInputModel = JsonConvert.DeserializeObject<DeleteCompanyModuleModel>(deleteCompanyModuleModel);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyModule", "deleteCompanyModuleModel", deleteCompanyModuleModel, "CompanyManagementApi"));
                BtrakJsonResult btrakJsonResult;
                var companyModuleId = _companyManagementService.DeleteCompanyModule(archiveInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Delete Company Module is completed. Return Guid is " + companyModuleId + ", source command is " + deleteCompanyModuleModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyModule", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyModule", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = companyModuleId, Success = true });
            }
            catch (SqlException sqlException)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlException.Message, ValidationMessages.ExceptionDeleteCompanyModule)
                });

                return null;
            }
        }

        [HttpDelete]
        [HttpOptions]
        [Route(RouteConstants.ArchiveCompany)]
        public JsonResult ArchiveCompany(string archiveCompanyInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                var archiveInputModel = JsonConvert.DeserializeObject<ArchiveCompanyInputModel>(archiveCompanyInputModel);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchiveCompany", "ArchiveCompanyInputModel", archiveCompanyInputModel, "CompanyManagementApi"));
                BtrakJsonResult btrakJsonResult;
                
                var companyId = _companyManagementService.ArchiveCompany(archiveInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveCompany", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveCompany", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = companyId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveCompany", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchIndustries)]
        public JsonResult SearchIndustries(CompanyStructureSearchCriteriaInputModel companyStructureModel)  
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIndustries", "companyStructureModel", companyStructureModel, "CompanyManagement Api"));
                if (companyStructureModel == null)
                {
                    companyStructureModel = new CompanyStructureSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Industries list ");
                List<CompanyStructureOutputModel> companyStructureList = _companyManagementService.SearchIndustries(companyStructureModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchIndustries", "CompanyManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchIndustries", "CompanyManagement Api"));
                return Json(new BtrakJsonResult { Data = companyStructureList, Success = true });
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCompanyStructure)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertModule)]
        public JsonResult UpsertModule(ModuleUpsertInputModel moduleUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                  LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertModule", "moduleUpsertInputModel", LoggedInContext, "CompanyManagementApi"));
                  BtrakJsonResult btrakJsonResult;
                   var companyId = _companyManagementService.UpsertModule(moduleUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertModule", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertModule", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Data = companyId, Success = true });
                
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertModule", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertModulePage)]
        public JsonResult UpsertModulePage(ModulePageUpsertInputModel moduleUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertModule", "moduleUpsertInputModel", LoggedInContext, "CompanyManagementApi"));
                BtrakJsonResult btrakJsonResult;
                var modulePageId = _companyManagementService.UpsertModulePage(moduleUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveCompany", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertModule", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = modulePageId, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertModule", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetModulePage)]
        public JsonResult GetModulePages(Guid? moduleId, Guid? modulePageId, string searchText = null)
        {

            var validationMessages = new List<ValidationMessage>();
            var modulePageSearchInputModel = new ModulePageSearchInputModel();
            modulePageSearchInputModel.ModuleId = moduleId;
            modulePageSearchInputModel.ModulePageId = modulePageId;
            modulePageSearchInputModel.SearchText = searchText;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetModulePages", "moduleUpsertInputModel", LoggedInContext, "CompanyManagementApi"));

                List<ModulePageOutputReturnModel> modulePagesList = _companyManagementService.GetModulePages(modulePageSearchInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetModulePages", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = modulePagesList, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModulePages", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertModuleLayout)]
        public JsonResult UpsertModuleLayout(ModuleLayoutUpsertInputModel moduleUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertModuleLayout", "moduleUpsertInputModel", LoggedInContext, "CompanyManagementApi"));
                BtrakJsonResult btrakJsonResult;
                var modulePageId = _companyManagementService.UpsertModuleLayout(moduleUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveCompany", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertModuleLayout", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = modulePageId, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertModuleLayout", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetModuleLayout)]
        public JsonResult GetModuleLayout(Guid? moduleLayoutId, Guid? modulePageId, string searchText = null, int pageNumber = 1, int pageSize = 10)
        {

            var validationMessages = new List<ValidationMessage>();
            var modulePageSearchInputModel = new ModulePageSearchInputModel();
            modulePageSearchInputModel.ModuleLayoutId = moduleLayoutId;
            modulePageSearchInputModel.ModulePageId = modulePageId;
            modulePageSearchInputModel.SearchText = searchText;
            modulePageSearchInputModel.PageNumber = pageNumber;
            modulePageSearchInputModel.PageSize = pageSize;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetModuleLayout", "moduleUpsertInputModel", LoggedInContext, "CompanyManagementApi"));

                List<ModuleLayoutOutputReturnModel> modulePagesList = _companyManagementService.GetModuleLayouts(modulePageSearchInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetModuleLayout", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = modulePagesList, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModuleLayout", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetModules)]
        public JsonResult GetModules(Guid? moduleId, string searchText = null)
        {

            var validationMessages = new List<ValidationMessage>();
            var modulePageSearchInputModel = new ModuleSearchInputModel();
            modulePageSearchInputModel.ModuleId = moduleId;
            modulePageSearchInputModel.SearchText = searchText;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetModules", "modulePageSearchInputModel", LoggedInContext, "CompanyManagementApi"));

                List<ModuleOutputModel> modulesList = _companyManagementService.GetModules(modulePageSearchInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetModules", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = modulesList, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModules", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyModule)]
        public JsonResult UpsertCompanyModule(CompanyModuleUpsertModel moduleUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyModule", "moduleUpsertInputModel", LoggedInContext, "CompanyManagementApi"));
                BtrakJsonResult btrakJsonResult;
                var modulePageId = _companyManagementService.UpsertCompanyModule(moduleUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyModule", "CompanyManagementApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyModule", "CompanyManagementApi"));
                return Json(new BtrakJsonResult { Data = modulePageId, Success = true });

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyModule", "CompanyManagementApi", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
    }
}
