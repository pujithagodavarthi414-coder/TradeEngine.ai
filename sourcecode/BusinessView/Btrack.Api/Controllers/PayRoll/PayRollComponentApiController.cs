using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.PayRoll;
using Btrak.Services.MasterData;
using Btrak.Services.PayRoll;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using Newtonsoft.Json;

namespace BTrak.Api.Controllers.PayRoll
{
    public class PayRollComponentApiController : AuthTokenApiController
    {
        private readonly IMasterDataManagementService _masterDataManagementService;
        private readonly IPayRollService _payRollService;
        private readonly ICompanyStructureService _companyStructureService;
        public PayRollComponentApiController(IMasterDataManagementService masterDataManagementService, IPayRollService payRollService, ICompanyStructureService companyStructureService)
        {
            _masterDataManagementService = masterDataManagementService;
            _payRollService = payRollService;
            _companyStructureService = companyStructureService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProfessionalTaxRanges)]
        public JsonResult<BtrakJsonResult> GetProfessionalTaxRanges()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProfessionalTaxRanges", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Professional Tax Ranges list");
                var taxSlabsRange = _masterDataManagementService.GetProfessionalTaxRanges(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProfessionalTaxRanges", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProfessionalTaxRanges", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetProfessionalTaxRange)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTaxSlabs)]
        public JsonResult<BtrakJsonResult> GetTaxSlabs(TaxSlabs taxSlabs)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));
               
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Licence Types list");
                var taxSlabsRange = _masterDataManagementService.GetTaxSlabs(taxSlabs,LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxSlabs", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxSlabs", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetTaxSlabs)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProfessionalTaxRanges)]
        public JsonResult<BtrakJsonResult> UpsertProfessionalTaxRanges(ProfessionalTaxRange professionalTaxRange)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProfessionalTaxRanges", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _masterDataManagementService.UpsertProfessionalTaxRanges(professionalTaxRange, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProfessionalTaxRanges", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProfessionalTaxRanges", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProfessionalTaxRanges", " PayRollComponentApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTaxSlabs)]
        public JsonResult<BtrakJsonResult> UpsertTaxSlabs(TaxSlabsUpsertInputModel taxSlabs)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTaxSlabs", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _masterDataManagementService.UpsertTaxSlabs(taxSlabs, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTaxSlabs", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTaxSlabs", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTaxSlabs", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeesBonusDetails)]
        public JsonResult<BtrakJsonResult> GetEmployeesBonusDetails(Guid? employeeId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Get Employees Bonus Details list");
                var taxSlabsRange = _payRollService.GetEmployeesBonusDetails(employeeId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesBonusDetails", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesBonusDetails", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEmployeesBonusDetails)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeBonusDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeBonusDetails(EmployeeBonus employeeBonus)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeBonusDetails", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _payRollService.UpsertEmployeeBonusDetails(employeeBonus, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeBonusDetails", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeBonusDetails", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeBonusDetails", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeesForBonus)]
        public JsonResult<BtrakJsonResult> GetEmployees()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Get Employees list");
                var taxSlabsRange = _payRollService.GetEmployees(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployees", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployees", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEmployeesForBonus)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeesPayTemplates)]
        public JsonResult<BtrakJsonResult> GetEmployeesPayTemplates()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetEmployeesPayTemplates");
                var taxSlabsRange = _payRollService.GetEmployeesPayTemplates(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesPayTemplates", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesPayTemplates", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEmployeesPayTemplates)
                });

                return null;
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeePayrollConfiguration)]
        public JsonResult<BtrakJsonResult> GetEmployeePayrollConfiguration()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetEmployeesPayTemplates");
                var taxSlabsRange = _payRollService.GetEmployeePayrollConfiguration(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesPayTemplates", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesPayTemplates", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEmployeePayrollConfiguration)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeePayrollConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertEmployeePayrollConfiguration(EmployeePayRollConfiguration payRollConfig)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeBonusDetails", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _payRollService.UpsertEmployeePayrollConfiguration(payRollConfig, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeBonusDetails", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeBonusDetails", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeePayrollConfiguration", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPayrollStatusList)]
        public JsonResult<BtrakJsonResult> GetPayrollStatusList()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetPayrollStatusList");
                var taxSlabsRange = _payRollService.GetPayrollStatusList(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollStatusList", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollStatusList", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetPayRollStatusList)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayrollStatus)]
        public JsonResult<BtrakJsonResult> UpsertPayrollStatus(PayRollStatus payRollStatus)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayrollStatus", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _payRollService.UpsertPayrollStatus(payRollStatus, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayrollStatus", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayrollStatus", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayrollStatus", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPayrollRunList)]
        public JsonResult<BtrakJsonResult> GetPayrollRunList(bool? isArchived)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetPayrollRunList");
                var taxSlabsRange = _payRollService.GetPayrollRunList(isArchived,LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollRunList", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollRunList", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetPayrollRunList)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPayrollRunemployeeList)]
        public JsonResult<BtrakJsonResult> GetPayrollRunemployeeList(Guid payrollRunId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetPayrollRunemployeeList");
                var result = _payRollService.GetPayrollRunemployeeList(payrollRunId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollRunemployeeList", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollRunemployeeList", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetPayrollRunemployeeList)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPaySlipDetails)]
        public JsonResult<BtrakJsonResult> GetPaySlipDetails(Guid payrollRunId, Guid employeeId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTaxSlabs", "PayRollComponentApiController", "Master Data Management Api"));

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetPaySlipDetails");
                var result = _payRollService.GetPaySlipDetails(payrollRunId, employeeId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPaySlipDetails", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPaySlipDetails", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetPaySlipDetails)
                });

                return null;
            }
        }


        [HttpGet]
        [HttpOptions]
        public async Task<HttpResponseMessage> DownloadPayrollRunTemplate()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadPayrollRunTemplate", "PayRollComponentApiController"));

                // var path = _payRollService.DownloadPayRollRunTemplate();

                var path = "test";

                var result = File.ReadAllBytes(path);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadPayrollRunTemplate", "PayRollComponentApiController"));

                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() =>
                {
                    var response = Request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new ByteArrayContent(result);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/xlsx");
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("inline")
                    {
                        FileName = "PaymentTemplate.xlsx"
                    };
                    return response;
                });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadPayrollRunTemplate", " PayRollComponentApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertPayrollRun)]
        public JsonResult<BtrakJsonResult> InsertPayrollRun(PayrollRun payrollRun)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertPayrollRun", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                if(payrollRun.EmploymentStatusIds != null && payrollRun.EmploymentStatusIds.Count > 0)
                payrollRun.EmploymentStatusIdsList = String.Join(",", payrollRun.EmploymentStatusIds);

                if (payrollRun.EmployeeIds != null && payrollRun.EmployeeIds.Count > 0)
                    payrollRun.EmployeeIdsList = String.Join(",", payrollRun.EmployeeIds);

                List<PayrollRunOutPutModel> result = _payRollService.InsertPayrollRun(payrollRun, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertPayrollRun", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertPayrollRun", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertPayrollRun", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.FinalPayRollRun)]
        public JsonResult<BtrakJsonResult> FinalPayRollRun(PayrollRun payrollRun)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertPayrollRun", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                if (payrollRun.EmploymentStatusIds != null && payrollRun.EmploymentStatusIds.Count > 0)
                    payrollRun.EmploymentStatusIdsList = String.Join(",", payrollRun.EmploymentStatusIds);

                if (payrollRun.EmployeeIds != null && payrollRun.EmployeeIds.Count > 0)
                    payrollRun.EmployeeIdsList = String.Join(",", payrollRun.EmployeeIds);

                if (payrollRun.EmployeeDetailsList != null)
                {
                    payrollRun.EmployeeDetails = JsonConvert.SerializeObject(payrollRun.EmployeeDetailsList);
                }


                Guid? result = _payRollService.FinalPayRollRun(payrollRun, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertPayrollRun", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertPayrollRun", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FinalPayRollRun", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdatePayrollRunEmployeeStatus)]
        public JsonResult<BtrakJsonResult> UpdatePayrollRunEmployeeStatus(PayrollRunEmployee payrollRunEmployee)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePayrollRunEmployeeStatus", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _payRollService.UpdatePayrollRunEmployeeStatus(payrollRunEmployee, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePayrollRunEmployeeStatus", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePayrollRunEmployeeStatus", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePayrollRunEmployeeStatus", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdatePayrollRunStatus)]
        public JsonResult<BtrakJsonResult> UpdatePayrollRunStatus(PayRollStatus payRollStatus)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePayrollRunStatus", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _payRollService.UpdatePayrollRunStatus(payRollStatus, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePayrollRunStatus", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePayrollRunStatus", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePayrollRunStatus", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.RunPaymentForPayRollRun)]
        public JsonResult<BtrakJsonResult> RunPaymentForPayRollRun(Guid payrollRunId, string TemplateType)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RunPaymentForPayRollRun", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _payRollService.RunPaymentForPayRollRun(payrollRunId, TemplateType, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RunPaymentForPayRollRun", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RunPaymentForPayRollRun", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RunPaymentForPayRollRun", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }



        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeePayrollDetailsList)]
        public JsonResult<BtrakJsonResult> GetEmployeePayrollDetailsList(Guid employeeId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
              
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetEmployeePayrollDetailsList");
                var result = _payRollService.GetEmployeePayrollDetailsList(employeeId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePayrollDetailsList", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePayrollDetailsList", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEmployeePayrollDetailsList)
                });

                return null;
            }
        }



        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPayrollRunEmployeeCount)]
        public JsonResult<BtrakJsonResult> GetPayrollRunEmployeeCount(Guid payrollRunId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
            
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetPayrollRunEmployeeCount");
                var result = _payRollService.GetPayrollRunEmployeeCount(payrollRunId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollRunEmployeeCount", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayrollRunEmployeeCount", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetPayrollRunEmployeeCount)
                });

                return null;
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.DownloadPaySlip)]
        public JsonResult<BtrakJsonResult> DownloadPaySlip(Guid payrollRunId, Guid employeeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadPaySlip", "PayRollComponentApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var fileData = _payRollService.DownloadPaySlipPdf(payrollRunId, employeeId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                                { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadPaySlip", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = fileData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadPaySlip", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SendEmailWithPayslip)]
        public JsonResult<BtrakJsonResult> SendEmailWithPayslip(Guid payrollRunId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("SendEmailWithPayslip");
                _payRollService.SendEmailWithPayslip(payrollRunId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendEmailWithPayslip", "PayRollComponentApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendEmailWithPayslip", "PayRollComponentApiController"));
                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetPayrollRunEmployeeCount)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollMonthlyDetails)]
        public JsonResult<BtrakJsonResult> GetPayRollMonthlyDetails(string dateOfMonth)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadPaySlip", "PayRollComponentApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var result = _payRollService.GetPayRollMonthlyDetails(dateOfMonth, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }


                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadPaySlip", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollMonthlyDetails", " PayRollComponentApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}