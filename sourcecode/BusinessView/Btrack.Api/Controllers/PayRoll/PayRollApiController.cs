using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.PayRoll;
using Btrak.Services.PayRoll;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using System.Web.Hosting;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models.TestRail;
using Btrak.Services.FileUploadDownload;
using Document = Spire.Doc.Document;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net;
using System.Net.Http.Headers;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Linq;
using DocumentFormat.OpenXml;
using Btrak.Models.MasterData;
using Btrak.Services.MasterData;
using Spire.Doc;
using System.Data.SqlClient;
using System.Drawing;
using Spire.Doc.Fields;
using Spire.Doc.Documents;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using HeaderFooter = Spire.Doc.HeaderFooter;

namespace BTrak.Api.Controllers.PayRoll
{
    public class PayRollApiController : AuthTokenApiController
    {
        private readonly GoalRepository _goalrepository;
        private readonly IPayRollService _payRollService;
        private readonly IFileStoreService _fileStoreService;
        private readonly IMasterDataManagementService _masterDataManagementService;
        private readonly ICompanyStructureService _companyStructureService;
        public PayRollApiController(IPayRollService payRollComponentService, GoalRepository goalrepository, IFileStoreService fileStoreService,
            IMasterDataManagementService masterDataManagementService, ICompanyStructureService companyStructureService)
        {
            _payRollService = payRollComponentService;
            _goalrepository = goalrepository;
            _fileStoreService = fileStoreService;
            _masterDataManagementService = masterDataManagementService;
            _companyStructureService = companyStructureService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollComponents)]
        public JsonResult<BtrakJsonResult> GetPayRollComponents(PayRollComponentSearchInputModel PayRollComponentSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollComponent", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollComponentSearchOutputModel> PayRollComponent = _payRollService.GetPayRollComponents(PayRollComponentSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollComponent", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollComponent", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollComponent, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollComponents", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollComponent)]
        public JsonResult<BtrakJsonResult> UpsertPayRollComponent(PayRollComponentUpsertInputModel PayRollComponentUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollComponent", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollComponentId = _payRollService.UpsertPayRollComponent(PayRollComponentUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollComponent", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollComponent", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollComponentId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollComponent", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollTemplates)]
        public JsonResult<BtrakJsonResult> GetPayRollTemplates(PayRollTemplateSearchInputModel PayRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollTemplate", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollTemplateSearchOutputModel> PayRollTemplate = _payRollService.GetPayRollTemplates(PayRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollTemplate", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollTemplate", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollTemplate, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollTemplates", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetComponents)]
        public JsonResult<BtrakJsonResult> GetComponents(PayRollTemplateSearchInputModel PayRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetComponents", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ComponentSearchOutPutModel> components = _payRollService.GetComponents(PayRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetComponents", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetComponents", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetComponents", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollTemplate)]
        public JsonResult<BtrakJsonResult> UpsertPayRollTemplate(PayRollTemplateUpsertInputModel PayRollTemplateUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollTemplate", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _payRollService.UpsertPayRollTemplate(PayRollTemplateUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollTemplate", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollTemplate", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = result.PayRollTemplateId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollTemplate", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollTemplateConfigurations)]
        public JsonResult<BtrakJsonResult> GetPayRollTemplateConfigurations(PayRollTemplateConfigurationSearchInputModel PayRollTemplateConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollTemplateConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollTemplateConfigurationSearchOutputModel> PayRollTemplateConfiguration = _payRollService.GetPayRollTemplateConfigurations(PayRollTemplateConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollTemplateConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollTemplateConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollTemplateConfiguration, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollTemplateConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollTemplateConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertPayRollTemplateConfiguration(PayRollTemplateConfigurationUpsertInputModel PayRollTemplateConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollTemplateConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollTemplateConfigurationId = _payRollService.UpsertPayRollTemplateConfiguration(PayRollTemplateConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollTemplateConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollTemplateConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollTemplateConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollTemplateConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollRoleConfigurations)]
        public JsonResult<BtrakJsonResult> GetPayRollRoleConfigurations(PayRollRoleConfigurationSearchInputModel PayRollRoleConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollRoleConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollRoleConfigurationSearchOutputModel> PayRollRoleConfiguration = _payRollService.GetPayRollRoleConfigurations(PayRollRoleConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollRoleConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollRoleConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollRoleConfiguration, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollRoleConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollRoleConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertPayRollRoleConfiguration(PayRollRoleConfigurationUpsertInputModel PayRollRoleConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollRoleConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollRoleConfigurationId = _payRollService.UpsertPayRollRoleConfiguration(PayRollRoleConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollRoleConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollRoleConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollRoleConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollRoleConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollBranchConfigurations)]
        public JsonResult<BtrakJsonResult> GetPayRollBranchConfigurations(PayRollBranchConfigurationSearchInputModel PayRollBranchConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollBranchConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollBranchConfigurationSearchOutputModel> PayRollBranchConfiguration = _payRollService.GetPayRollBranchConfigurations(PayRollBranchConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollBranchConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollBranchConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollBranchConfiguration, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollBranchConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollBranchConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertPayRollBranchConfiguration(PayRollBranchConfigurationUpsertInputModel PayRollBranchConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollBranchConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollBranchConfigurationId = _payRollService.UpsertPayRollBranchConfiguration(PayRollBranchConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollBranchConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollBranchConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollBranchConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollBranchConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollGenderConfigurations)]
        public JsonResult<BtrakJsonResult> GetPayRollGenderConfigurations(PayRollGenderConfigurationSearchInputModel PayRollGenderConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollGenderConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollGenderConfigurationSearchOutputModel> PayRollGenderConfiguration = _payRollService.GetPayRollGenderConfigurations(PayRollGenderConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollGenderConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollGenderConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollGenderConfiguration, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollGenderConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollGenderConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertPayRollGenderConfiguration(PayRollGenderConfigurationUpsertInputModel PayRollGenderConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollGenderConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollGenderConfigurationId = _payRollService.UpsertPayRollGenderConfiguration(PayRollGenderConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollGenderConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollGenderConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollGenderConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollGenderConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollMaritalStatusConfigurations)]
        public JsonResult<BtrakJsonResult> GetPayRollMaritalStatusConfigurations(PayRollMaritalStatusConfigurationSearchInputModel PayRollMaritalStatusConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollMaritalStatusConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollMaritalStatusConfigurationSearchOutputModel> PayRollMaritalStatusConfiguration = _payRollService.GetPayRollMaritalStatusConfigurations(PayRollMaritalStatusConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollMaritalStatusConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollMaritalStatusConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollMaritalStatusConfiguration, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollMaritalStatusConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollMaritalStatusConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertPayRollMaritalStatusConfiguration(PayRollMaritalStatusConfigurationUpsertInputModel PayRollMaritalStatusConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollMaritalStatusConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollMaritalStatusConfigurationId = _payRollService.UpsertPayRollMaritalStatusConfiguration(PayRollMaritalStatusConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollMaritalStatusConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollMaritalStatusConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollMaritalStatusConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollMaritalStatusConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetResignationStatus)]
        public JsonResult<BtrakJsonResult> GetResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetResignationStatus", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ResignationstausSearchOutputModel> resignationStatus = _payRollService.GetResignationStatus(resignationStatusSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetResignationStatus", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetResignationStatus", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = resignationStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetResignationStatus", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertResignationStatus)]
        public JsonResult<BtrakJsonResult> UpsertResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertResignationStatus", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? resignationStatusId = _payRollService.UpsertResignationStatus(resignationStatusSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertResignationStatus", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertResignationStatus", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = resignationStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertResignationStatus", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeesResignation)]
        public JsonResult<BtrakJsonResult> GetEmployeesResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeesResignation", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeResignationSearchOutputModel> resignationStatus = _payRollService.GetEmployeesResignation(employeeResignationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesResignation", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesResignation", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = resignationStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesResignation", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeResignation)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeResignation", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? resignationStatusId = _payRollService.UpsertEmployeeResignation(employeeResignationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeResignation", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeResignation", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = resignationStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeResignation", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTaxAllowances)]
        public JsonResult<BtrakJsonResult> GetTaxAllowances(TaxAllowanceSearchInputModel TaxAllowanceSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTaxAllowance", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<TaxAllowanceSearchOutputModel> TaxAllowance = _payRollService.GetTaxAllowances(TaxAllowanceSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxAllowance", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxAllowance", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = TaxAllowance, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTaxAllowances", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTaxAllowance)]
        public JsonResult<BtrakJsonResult> UpsertTaxAllowance(TaxAllowanceUpsertInputModel TaxAllowanceUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTaxAllowance", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? TaxAllowanceId = _payRollService.UpsertTaxAllowance(TaxAllowanceUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTaxAllowance", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTaxAllowance", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = TaxAllowanceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTaxAllowance", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTaxAllowanceTypes)]
        public JsonResult<BtrakJsonResult> GetTaxAllowanceTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTaxAllowanceTypes", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<TaxAllowanceTypeModel> components = _payRollService.GetTaxAllowanceTypes(payRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxAllowanceTypes", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxAllowanceTypes", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTaxAllowanceTypes", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeTaxAllowanceDetails)]
        public JsonResult<BtrakJsonResult> GetEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsSearchInputModel EmployeeTaxAllowanceDetailsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeTaxAllowanceDetails", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeTaxAllowanceDetailsSearchOutputModel> EmployeeTaxAllowanceDetails = _payRollService.GetEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeTaxAllowanceDetails", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeTaxAllowanceDetails", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeTaxAllowanceDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeTaxAllowanceDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeTaxAllowanceDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsUpsertInputModel EmployeeTaxAllowanceDetailsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeTaxAllowanceDetails", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? EmployeeTaxAllowanceDetailsId = _payRollService.UpsertEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeTaxAllowanceDetails", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeTaxAllowanceDetails", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeTaxAllowanceDetailsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeTaxAllowanceDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveEncashmentSettings)]
        public JsonResult<BtrakJsonResult> GetLeaveEncashmentSettings(LeaveEncashmentSettingsSearchInputModel LeaveEncashmentSettingsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveEncashmentSettings", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<LeaveEncashmentSettingsSearchOutputModel> LeaveEncashmentSettings = _payRollService.GetLeaveEncashmentSettings(LeaveEncashmentSettingsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveEncashmentSettings", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveEncashmentSettings", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = LeaveEncashmentSettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveEncashmentSettings", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaveEncashmentSettings)]
        public JsonResult<BtrakJsonResult> UpsertLeaveEncashmentSettings(LeaveEncashmentSettingsUpsertInputModel LeaveEncashmentSettingsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLeaveEncashmentSettings", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? LeaveEncashmentSettingsId = _payRollService.UpsertLeaveEncashmentSettings(LeaveEncashmentSettingsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveEncashmentSettings", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveEncashmentSettings", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = LeaveEncashmentSettingsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveEncashmentSettings", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeAccountDetails)]
        public JsonResult<BtrakJsonResult> GetEmployeeAccountDetails(EmployeeAccountDetailsSearchInputModel EmployeeAccountDetailsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeAccountDetails", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeAccountDetailsSearchOutputModel> EmployeeAccountDetails = _payRollService.GetEmployeeAccountDetails(EmployeeAccountDetailsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeAccountDetails", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeAccountDetails", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeAccountDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeAccountDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeAccountDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeAccountDetails(EmployeeAccountDetailsUpsertInputModel EmployeeAccountDetailsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeAccountDetails", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? EmployeeAccountDetailsId = _payRollService.UpsertEmployeeAccountDetails(EmployeeAccountDetailsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeAccountDetails", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeAccountDetails", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeAccountDetailsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeAccountDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFinancialYearConfigurations)]
        public JsonResult<BtrakJsonResult> GetFinancialYearConfigurations(FinancialYearConfigurationsSearchInputModel FinancialYearConfigurationsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFinancialYearConfigurations", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<FinancialYearConfigurationsSearchOutputModel> FinancialYearConfigurations = _payRollService.GetFinancialYearConfigurations(FinancialYearConfigurationsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFinancialYearConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFinancialYearConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = FinancialYearConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFinancialYearConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertFinancialYearConfigurations)]
        public JsonResult<BtrakJsonResult> UpsertFinancialYearConfigurations(FinancialYearConfigurationsUpsertInputModel FinancialYearConfigurationsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFinancialYearConfigurations", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? FinancialYearConfigurationsId = _payRollService.UpsertFinancialYearConfigurations(FinancialYearConfigurationsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFinancialYearConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFinancialYearConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = FinancialYearConfigurationsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFinancialYearConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeCreditorDetails)]
        public JsonResult<BtrakJsonResult> GetEmployeeCreditorDetails(EmployeeCreditorDetailsSearchInputModel EmployeeCreditorDetailsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeCreditorDetails", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeCreditorDetailsSearchOutputModel> EmployeeCreditorDetails = _payRollService.GetEmployeeCreditorDetails(EmployeeCreditorDetailsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeCreditorDetails", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeCreditorDetails", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeCreditorDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeCreditorDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeCreditorDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeCreditorDetails(EmployeeCreditorDetailsUpsertInputModel EmployeeCreditorDetailsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeCreditorDetails", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? EmployeeCreditorDetailsId = _payRollService.UpsertEmployeeCreditorDetails(EmployeeCreditorDetailsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeCreditorDetails", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeCreditorDetails", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeCreditorDetailsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeCreditorDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollCalculationConfigurations)]
        public JsonResult<BtrakJsonResult> GetPayRollCalculationConfigurations(PayRollCalculationConfigurationsSearchInputModel PayRollCalculationConfigurationsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollCalculationConfigurations", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollCalculationConfigurationsSearchOutputModel> PayRollCalculationConfigurations = _payRollService.GetPayRollCalculationConfigurations(PayRollCalculationConfigurationsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollCalculationConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollCalculationConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollCalculationConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollCalculationConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollCalculationConfigurations)]
        public JsonResult<BtrakJsonResult> UpsertPayRollCalculationConfigurations(PayRollCalculationConfigurationsUpsertInputModel PayRollCalculationConfigurationsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollCalculationConfigurations", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollCalculationConfigurationsId = _payRollService.UpsertPayRollCalculationConfigurations(PayRollCalculationConfigurationsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollCalculationConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollCalculationConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollCalculationConfigurationsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollCalculationConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPeriodTypes)]
        public JsonResult<BtrakJsonResult> GetPeriodTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPeriodTypes", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PeriodTypeModel> components = _payRollService.GetPeriodTypes(payRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPeriodTypes", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPeriodTypes", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPeriodTypes", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollCalculationTypes)]
        public JsonResult<BtrakJsonResult> GetPayRollCalculationTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollCalculationTypes", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayRollCalculationTypeModel> components = _payRollService.GetPayRollCalculationTypes(payRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollCalculationTypes", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollCalculationTypes", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollCalculationTypes", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadEmployeeSalaryCertificate)]
        public async Task<byte[]> DownloadEmployeeSalaryCertificate([FromBody]string employeeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollCalculationTypes", "PayRoll Api"));

                //var validationMessages = new List<ValidationMessage>();

                var result = CreateWordDocument(new Guid(employeeId), LoggedInContext);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadEmployeeSalaryCertificate", "PayRoll Api"));

                return result.ByteStream;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadEmployeeSalaryCertificate", "PayRollApiController ", exception.Message), exception);

                return null;
            }
        }


        private PdfGenerationOutputModel CreateWordDocument(Guid employeeId, LoggedInContext loggedInContext)
        {
            var validationMessages = new List<ValidationMessage>();

            EmployeeSalaryCertificateModel info = _payRollService.GetEmployeeSalaryCertificate(employeeId, loggedInContext, validationMessages);

            if (info == null)
            {
                info = new EmployeeSalaryCertificateModel();
            }
            else
            {

                if (info.Branches != null)
                    info.BranchesList = JsonConvert.DeserializeObject<List<BranchModel>>(info.Branches);

                if (info.Designations != null)
                    info.DesignationsList = JsonConvert.DeserializeObject<List<DesignationsModel>>(info.Designations);

                if (info.Roles != null)
                    info.RolesList = JsonConvert.DeserializeObject<List<RoleModel>>(info.Roles);

                if (info.Bonuses != null)
                    info.BonusesList = JsonConvert.DeserializeObject<List<BonusModel>>(info.Bonuses);

                if (info.PaySlips != null)
                    info.PaySlipsList = JsonConvert.DeserializeObject<List<PaySlipModel>>(info.PaySlips);

                if (info.SalaryBreakDownRecords != null)
                    info.SalaryBreakDownRecordsList = JsonConvert.DeserializeObject<List<SalaryBreakDownModel>>(info.SalaryBreakDownRecords);

                if (info.SalaryHikes != null)
                    info.SalaryHikesList = JsonConvert.DeserializeObject<List<SalaryHikesModel>>(info.SalaryHikes);
            }

            if (info.SalaryBreakDownRecordsList.Count > 0)
            {
                info.SalaryBreakDownDate = info.SalaryBreakDownRecordsList[0].PayrollEndDate?.ToString("dd MMM yyyy") + " ";
                info.NetPayAmount = info.SalaryBreakDownRecordsList[0].ActualNetPayAmount;
            }
            else
            {
                info.SalaryBreakDownDate = "";
            }

            CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);

            info.CompanyLogo = companyTheme.PayslipLogo != null ? companyTheme.PayslipLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";

            var path = HostingEnvironment.MapPath(@"~\Resources\WordTemplates\SalaryCertificate.docx");
            var path1 = HostingEnvironment.MapPath(@"~\Resources\WordTemplates");
            var guid = Guid.NewGuid();
            if (path1 != null)
            {
                //string blobUrl;
                var destinationPath = System.IO.Path.Combine(path1, guid.ToString());
                string docName = System.IO.Path.Combine(destinationPath, "SalaryCertificate.docx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null) System.IO.File.Copy(path, docName, true);

                    LoggingManager.Info("Created a directory to save temp file");
                }

                Document document = new Document(path);
                
                //get original image

                WebClient webClient = new WebClient();
                using (MemoryStream ms = new MemoryStream(webClient.DownloadData(info.CompanyLogo)))
                {
                    Bitmap pimp = new Bitmap(Image.FromStream(ms));

                    HeaderFooter header = document.Sections[0].HeadersFooters.Header;

                    header.Paragraphs[0].Text = "";
                    header.Paragraphs[0].Format.HorizontalAlignment = HorizontalAlignment.Right;
                    DocPicture picture = header.Paragraphs[0].AppendPicture(pimp);
                    picture.VerticalAlignment = ShapeVerticalAlignment.Bottom;


                    //set image's position
                    picture.HorizontalPosition = 80.0F;

                    picture.VerticalPosition = 80.0F;

                    //set image's size
                    picture.Width = 180;

                    picture.Height = 50;
                }

                document.Replace("##CompanyName##", info.CompanyName ?? String.Empty, false, true);
                document.Replace("##CompanySiteAddress##", info.CompanySiteAddress ?? String.Empty, false, true);
                document.Replace("##HeadofficeAddress##", info.HeadOfficeAddress ?? String.Empty, false, true);
                document.Replace("##EmployeeName##", info.EmployeeName ?? String.Empty, false, true);
                document.Replace("##JoiningDate##", info.JoiningDate?.ToString("dd MMM yyyy"), false, true);
                document.Replace("##NetPay##", info.NetPayAmount.ToString() ?? string.Empty, false, true);
                document.Replace("##CurrencySymbol##", info.CurrencySymbol ?? String.Empty, false, true);
                document.Replace("##StartingSalary##", info.StartingSalary?.ToString() ?? String.Empty, false, true);
                document.Replace("##TodaysDate##", DateTime.Now.ToString("dd MMM yyyy"), false, true);
                document.Replace("##SalaryMonthAndYear##", info.SalaryBreakDownDate, false,
                    true);
                document.Replace("##Date##", DateTime.Now.ToString("dd MMM yyyy") ?? String.Empty, false, true);

                document.Replace("##HRName##", info.HRManagerName ?? String.Empty, false, true);
                document.Replace("##HREmail##", info.HRManagerEmail ?? String.Empty, false, true);
                document.Replace("##HRPhoneNumber##", info.HRManagerMobileNo ?? String.Empty, false, true);
                document.Replace("##CompanyWebsite##", info.CompanySiteAddress ?? String.Empty, false, true);
                document.Replace("##CompanyPhoneNumber##", info.CompanyPhoneNumber ?? String.Empty, false, true);

                Spire.Doc.Table branchTable = document.Sections[0].Tables[0] as Spire.Doc.Table;
                Spire.Doc.Table designationTable = document.Sections[0].Tables[1] as Spire.Doc.Table;
                Spire.Doc.Table rolesTable = document.Sections[0].Tables[2] as Spire.Doc.Table;
                Spire.Doc.Table bonusTable = document.Sections[0].Tables[3] as Spire.Doc.Table;
                Spire.Doc.Table payslipsTable = document.Sections[0].Tables[4] as Spire.Doc.Table;
                Spire.Doc.Table hikeTable = document.Sections[0].Tables[5] as Spire.Doc.Table;
                Spire.Doc.Table breakDownTable = document.Sections[0].Tables[6] as Spire.Doc.Table;                           

                if (branchTable != null)
                {
                    int branchIndex = 1;
                    foreach (var branch in info.BranchesList)
                    {
                        if (branch.ActiveTo?.ToString("dd MMM yyyy").Contains("1900") == true)
                        {
                            branch.ActiveTo = null;
                        }

                        Spire.Doc.TableRow row = branchTable.AddRow();
                        branchTable.Rows.Insert(branchIndex, row);
                        Spire.Doc.TableRow dataRow = branchTable.Rows[branchIndex];

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        Spire.Doc.Documents.Paragraph p2 = dataRow.Cells[1].AddParagraph();
                        Spire.Doc.Documents.Paragraph p3 = dataRow.Cells[2].AddParagraph();
                        p1.AppendText(branch.BranchName ?? String.Empty);
                        p2.AppendText(branch.ActiveFrom?.ToString("dd MMM yyyy"));
                        if (branch.ActiveTo != null)
                        {
                            p3.AppendText(branch.ActiveTo?.ToString("dd MMM yyyy"));
                        }
                        else
                        {
                            p3.AppendText("");
                        }
                       
                        branchIndex++;
                    }
                }

                if (designationTable != null)
                {
                    int designationIndex = 1;
                    foreach (var designation in info.DesignationsList)
                    {
                        Spire.Doc.TableRow row = designationTable.AddRow();
                        designationTable.Rows.Insert(designationIndex, row);
                        Spire.Doc.TableRow dataRow = designationTable.Rows[designationIndex];

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        p1.AppendText(designation.DesignationName ?? String.Empty);
                        designationIndex++;
                    }
                }

                if (rolesTable != null)
                {
                    int roleIndex = 1;
                    foreach (var role in info.RolesList)
                    {
                        Spire.Doc.TableRow row = rolesTable.AddRow();
                        rolesTable.Rows.Insert(roleIndex, row);
                        Spire.Doc.TableRow dataRow = rolesTable.Rows[roleIndex];

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        p1.AppendText(role.RoleName ?? String.Empty);
                        roleIndex++;
                    }
                }

                if (bonusTable != null)
                {
                    int bonusIndex = 1;
                    foreach (var bonus in info.BonusesList)
                    {
                        Spire.Doc.TableRow row = bonusTable.AddRow();
                        bonusTable.Rows.Insert(bonusIndex, row);
                        Spire.Doc.TableRow dataRow = bonusTable.Rows[bonusIndex];

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        Spire.Doc.Documents.Paragraph p2 = dataRow.Cells[1].AddParagraph();
                        p1.AppendText(bonus.PayRollMonth ?? String.Empty);
                        p2.AppendText(bonus.Bonus ?? String.Empty);
                        bonusIndex++;
                    }
                }


                if (payslipsTable != null)
                {
                    int payslipIndex = 1;
                    foreach (var payslip in info.PaySlipsList)
                    {
                        Spire.Doc.TableRow row = payslipsTable.AddRow();
                        payslipsTable.Rows.Insert(payslipIndex, row);
                        Spire.Doc.TableRow dataRow = payslipsTable.Rows[payslipIndex];

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        Spire.Doc.Documents.Paragraph p2 = dataRow.Cells[1].AddParagraph();
                        Spire.Doc.Documents.Paragraph p3 = dataRow.Cells[2].AddParagraph();
                        Spire.Doc.Documents.Paragraph p4 = dataRow.Cells[3].AddParagraph();
                        p1.AppendText(payslip.PayRollMonth ?? String.Empty);
                        p2.AppendText(payslip.PayRollStartDate?.ToString("dd MMM yyyy"));
                        p3.AppendText(payslip.PayRollEndDate?.ToString("dd MMM yyyy"));
                        p4.AppendText(payslip.NetAmount ?? String.Empty);
                        payslipIndex++;
                    }
                }

                if (hikeTable != null)
                {
                    int hikeIndex = 1;
                    foreach (var hike in info.SalaryHikesList)
                    {
                        Spire.Doc.TableRow row = hikeTable.AddRow();
                        hikeTable.Rows.Insert(hikeIndex, row);
                        Spire.Doc.TableRow dataRow = hikeTable.Rows[hikeIndex];

                        if (hike.ActiveTo?.ToString("dd MMM yyyy").Contains("1900") == true)
                        {
                            hike.ActiveTo = null ;
                        }

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        Spire.Doc.Documents.Paragraph p2 = dataRow.Cells[1].AddParagraph();
                        Spire.Doc.Documents.Paragraph p3 = dataRow.Cells[2].AddParagraph();
                        Spire.Doc.Documents.Paragraph p4 = dataRow.Cells[3].AddParagraph();
                        p1.AppendText(hike.CTC ?? String.Empty);
                        p2.AppendText(hike.VariablePay ?? String.Empty);
                        p3.AppendText(hike.ActiveFrom?.ToString("dd MMM yyyy"));
                        if (hike.ActiveTo != null)
                        {
                            p4.AppendText(hike.ActiveTo?.ToString("dd MMM yyyy"));
                        }
                        else
                        {
                            p4.AppendText("");
                        }
                        
                        hikeIndex++;
                    }
                }

                if (breakDownTable != null)
                {
                    int breakdownIndex = 1;
                    foreach (var breakDown in info.SalaryBreakDownRecordsList)
                    {
                        Spire.Doc.TableRow row = breakDownTable.AddRow();
                        breakDownTable.Rows.Insert(breakdownIndex, row);
                        Spire.Doc.TableRow dataRow = breakDownTable.Rows[breakdownIndex];

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        //Spire.Doc.Documents.Paragraph p2 = dataRow.Cells[1].AddParagraph();

                        p1.AppendText(breakDown.ComponentName ?? String.Empty);

                        //TextRange tr3 = p1.AppendText(breakDown.?.ToString() ?? String.Empty);
                        if (breakDown.IsDeduction)
                        {
                            Spire.Doc.Documents.Paragraph p3 = dataRow.Cells[2].AddParagraph();
                            p3.AppendText(breakDown.ActualComponentAmount?.ToString() ?? String.Empty);
                        }
                        else
                        {
                            Spire.Doc.Documents.Paragraph p2 = dataRow.Cells[1].AddParagraph();
                            p2.AppendText(breakDown.ActualComponentAmount?.ToString() ?? String.Empty);
                        }

                        breakdownIndex++;
                    }
                    Spire.Doc.TableRow row1 = breakDownTable.AddRow();
                    breakDownTable.Rows.Insert(breakdownIndex, row1);
                    Spire.Doc.TableRow dataRow1 = breakDownTable.Rows[breakdownIndex];

                    Spire.Doc.Documents.Paragraph p = dataRow1.Cells[0].AddParagraph();
                    p.AppendText("Net Pay Amount");
                    Spire.Doc.Documents.Paragraph p4 = dataRow1.Cells[1].AddParagraph();
                    p4.AppendText(info.NetPayAmount.ToString() ?? String.Empty);
                }


                document.SaveToFile(docName);
                var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                {
                    MemoryStream = System.IO.File.ReadAllBytes(docName),
                    FileName = "SalaryDetails.docx",
                    LoggedInUserId = loggedInContext.LoggedInUserId
                });

                var pdfOutputModel = new PdfGenerationOutputModel()
                {
                    ByteStream = System.IO.File.ReadAllBytes(docName),
                    BlobUrl = blobUrl
                };

                if (Directory.Exists(destinationPath))
                {
                    System.IO.File.Delete(docName);
                    Directory.Delete(destinationPath);

                    LoggingManager.Info("Deleting the temp folder");
                }
                return pdfOutputModel;
            }
            
            return new PdfGenerationOutputModel();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeLoanStatementDocument)]
        public async Task<byte[]> GetEmployeeLoanStatementDocument(EmployeeLoanInstallmentInputModel employeeLoanInstallmentInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollCalculationTypes", "PayRoll Api"));

                var result = GetLoanStatementDocument(employeeLoanInstallmentInputModel.EmployeeId, employeeLoanInstallmentInputModel.EmployeeLoanId, LoggedInContext);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadEmployeeSalaryCertificate", "PayRoll Api"));

                return result.ByteStream;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLoanStatementDocument", "PayRollApiController ", exception.Message), exception);

                return null;
            }
        }

        private PdfGenerationOutputModel GetLoanStatementDocument(Guid? userId, Guid? employeeLoanId, LoggedInContext loggedInContext)
        {
            var validationMessages = new List<ValidationMessage>();

            List<EmployeeLoanInstallmentOutputModel> list = _payRollService.GetEmployeeLoanStatementDetails(userId, employeeLoanId, loggedInContext, validationMessages);

            var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
            companySettingsSearchInputModel.Key = "LoanTermsDocument";
            List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementService.GetCompanySettings(companySettingsSearchInputModel, LoggedInContext, validationMessages);

            var path = HostingEnvironment.MapPath(@"~\Resources\WordTemplates\EmployeeLoanStatement.doc");
            var path1 = HostingEnvironment.MapPath(@"~\Resources\WordTemplates");
            var guid = Guid.NewGuid();


            Document doc = new Document();
            WebClient webClient = new WebClient();
            using (MemoryStream ms = new MemoryStream(webClient.DownloadData(companySettings[0].Value)))
            {
                doc.LoadFromStream(ms, FileFormat.Doc);
            }
            
             doc.SaveToFile(path, FileFormat.Doc);


            if (path1 != null)
            {
                var destinationPath1 = System.IO.Path.Combine(path1, guid.ToString());
                string docName1 = System.IO.Path.Combine(destinationPath1, "EmployeeLoanStatement.doc");
                if (!Directory.Exists(destinationPath1))
                {
                    Directory.CreateDirectory(destinationPath1);

                    if (path1 != null) System.IO.File.Copy(path, docName1, true);

                    LoggingManager.Info("Created a directory to save temp file");
                }

                Document document = new Document(path);
                document.Replace("#EmployeeName", list[0].EmployeeName ?? String.Empty, false, true);
                document.Replace("#LoanAmount", list[0].ModifiedLoanAmount ?? String.Empty, false, true);
                document.Replace("#LoanTakenOn", list[0].LoanTakenOn?.ToString("dd MMM yyyy") ?? String.Empty, false, true);
                document.Replace("#LoanEffectiveDate", list[0].LoanPaymentStartDate?.ToString("dd MMM yyyy") ?? String.Empty, false, true);
                document.Replace("#LoanDescription", list[0].LoanDescription ?? String.Empty, false, true);
                document.Replace("#TodaysDate", DateTime.Now.ToString("dd MMM yyyy"), false, true);
                document.Replace("#EmployeeAddress", list[0].EmployeeAddress ?? String.Empty, false, true);
                document.Replace("#LoanInterestPercentage", list[0].LoanInterestPercentagePerMonth.ToString() ?? String.Empty, false, true);


                Spire.Doc.Table table1 = document.Sections[0].Tables[0] as Spire.Doc.Table;

                if (table1 != null)
                {
                    int tableIndex = 1;
                    foreach (var hike in list)
                    {

                        Spire.Doc.TableRow row = table1.AddRow();
                        table1.Rows.Insert(tableIndex, row);
                        Spire.Doc.TableRow dataRow = table1.Rows[tableIndex];

                        Spire.Doc.Documents.Paragraph p1 = dataRow.Cells[0].AddParagraph();
                        Spire.Doc.Documents.Paragraph p2 = dataRow.Cells[1].AddParagraph();
                        Spire.Doc.Documents.Paragraph p3 = dataRow.Cells[2].AddParagraph();
                        Spire.Doc.Documents.Paragraph p4 = dataRow.Cells[3].AddParagraph();
                        p1.AppendText(hike.ModifiedPrincipalAmount);
                        p2.AppendText(hike.InstallmentDate?.ToString("dd MMM yyyy"));
                        p3.AppendText(hike.ModifiedInstallmentAmount);
                        p4.AppendText(hike.IsTobePaid == null ? "Paid": hike.IsTobePaid == true? "Not paid": "Paid");
                        tableIndex++;
                    }
                }

                document.SaveToFile(docName1);

                var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                {
                    MemoryStream = System.IO.File.ReadAllBytes(docName1),
                    FileName = "EmployeeLoanStatement.docx",
                    LoggedInUserId = loggedInContext.LoggedInUserId
                });

                var pdfOutputModel = new PdfGenerationOutputModel()
                {
                    ByteStream = System.IO.File.ReadAllBytes(docName1),
                    BlobUrl = blobUrl
                };

                if (Directory.Exists(destinationPath1))
                {
                    System.IO.File.Delete(docName1);
                    Directory.Delete(destinationPath1);

                    LoggingManager.Info("Deleting the temp folder");
                }

                return pdfOutputModel;
            }

            return new PdfGenerationOutputModel();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFinancialYearTypes)]
        public JsonResult<BtrakJsonResult> GetFinancialYearTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFinancialYearTypes", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<FinancialYearTypeModel> components = _payRollService.GetFinancialYearTypes(payRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFinancialYearTypes", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFinancialYearTypes", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFinancialYearTypes", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTdsSettings)]
        public JsonResult<BtrakJsonResult> GetTdsSettings(TdsSettingsSearchInputModel TdsSettingsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTdsSettings", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<TdsSettingsSearchOutputModel> TdsSettings = _payRollService.GetTdsSettings(TdsSettingsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTdsSettings", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTdsSettings", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = TdsSettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTdsSettings", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetESIMonthlyStatement)]
        public JsonResult<BtrakJsonResult> GetESIMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get ESI Monthly Statement", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ESIMonthlyStatementOutputModel> esiMonthlyStatementDetails = _payRollService.GetESIMonthlyStatement(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get ESI Monthly Statement", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get ESI Monthly Statement", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = esiMonthlyStatementDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetESIMonthlyStatement", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSalaryRegister)]
        public JsonResult<BtrakJsonResult> GetSalaryRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSalaryRegister", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SalaryRegisterOutputModel> salaryRegisterDetails = _payRollService.GetSalaryRegister(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSalaryRegister", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSalaryRegister", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = salaryRegisterDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSalaryRegister", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetIncomeSalaryStatement)]
        public JsonResult<BtrakJsonResult> GetIncomeSalaryStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIncomeSalaryStatement", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<IncomeSalaryStatementOutputModel> incomeSalaryStatement = _payRollService.GetIncomeSalaryStatement(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIncomeSalaryStatement", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIncomeSalaryStatement", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = incomeSalaryStatement, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIncomeSalaryStatement", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProfessionTaxMonthlyStatement)]
        public JsonResult<BtrakJsonResult> GetProfessionTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProfessionTaxMonthlyStatement", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProfessionTaxMonthlyStatementOutputModel> professionTaxMonthlyStatement = _payRollService.GetProfessionTaxMonthlyStatement(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProfessionTaxMonthlyStatement", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProfessionTaxMonthlyStatement", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = professionTaxMonthlyStatement, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProfessionTaxMonthlyStatement", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProfessionTaxReturns)]
        public JsonResult<BtrakJsonResult> GetProfessionTaxReturns(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProfessionTaxReturns", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProfessionTaxReturnsOutputModel> professionTaxReturns = _payRollService.GetProfessionTaxReturns(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProfessionTaxReturns", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProfessionTaxReturns", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = professionTaxReturns, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProfessionTaxReturns", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSalaryBillRegister)]
        public JsonResult<BtrakJsonResult> GetSalaryBillRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSalaryBillRegister", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SalaryBillRegisterOutputModel> salaryBillRegister = _payRollService.GetSalaryBillRegister(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSalaryBillRegister", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSalaryBillRegister", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = salaryBillRegister, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSalaryBillRegister", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetIncomeSalaryStatementDetails)]
        public JsonResult<BtrakJsonResult> GetIncomeSalaryStatementDetails(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIncomeSalaryStatementDetails", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<IncomeSalaryStatementDetailsOutputModel> incomeSalaryStatementDetails = _payRollService.GetIncomeSalaryStatementDetails(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIncomeSalaryStatementDetails", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIncomeSalaryStatementDetails", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = incomeSalaryStatementDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIncomeSalaryStatementDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetITSavingsReport)]
        public JsonResult<BtrakJsonResult> GetITSavingsReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetITSavingsReport", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ITSavingsReportOutputModel> itSavingsReport = _payRollService.GetITSavingsReport(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetITSavingsReport", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetITSavingsReport", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = itSavingsReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetITSavingsReport", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetIncomeTaxMonthlyStatement)]
        public JsonResult<BtrakJsonResult> GetIncomeTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIncomeTaxMonthlyStatement", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<IncomeTaxMonthlyStatementOutputModel> incomeTaxMonthlyStatement = _payRollService.GetIncomeTaxMonthlyStatement(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIncomeTaxMonthlyStatement", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIncomeTaxMonthlyStatement", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = incomeTaxMonthlyStatement, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIncomeTaxMonthlyStatement", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSalaryforITOfAnEmployee)]
        public JsonResult<BtrakJsonResult> GetSalaryforITOfAnEmployee(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSalaryforITOfAnEmployee", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SalaryForITOutputModel> salaryforITOfAnEmployee = _payRollService.GetSalaryforITOfAnEmployee(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSalaryforITOfAnEmployee", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSalaryforITOfAnEmployee", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = salaryforITOfAnEmployee, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSalaryforITOfAnEmployee", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFormvPdf)]
        public async Task<JsonResult<BtrakJsonResult>> printFormv(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "PayRollReportsSearchInputModel", "payRollReportsSearchInputModel", payRollReportsSearchInputModel, "Payroll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                byte[] byteArray = await _payRollService.PrintFormv(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PayRollReportsSearchInputModel", "Payroll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PayRollReportsSearchInputModel", "Payroll Api"));

                return Json(new BtrakJsonResult { Data = byteArray, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "printFormv", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTdsSettings)]
        public JsonResult<BtrakJsonResult> UpsertTdsSettings(TdsSettingsUpsertInputModel TdsSettingsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTdsSettings", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? TdsSettingsId = _payRollService.UpsertTdsSettings(TdsSettingsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTdsSettings", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTdsSettings", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = TdsSettingsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTdsSettings", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetHourlyTdsConfiguration)]
        public JsonResult<BtrakJsonResult> GetHourlyTdsConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHourlyTdsConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var hourlyList = _payRollService.GetHourlyTdsConfiguration(hourlyTdsConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHourlyTdsConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHourlyTdsConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = hourlyList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHourlyTdsConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertHourlyTdsConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertHourlyTdsConfiguration(HourlyTdsConfigurationUpsertInputModel hourlyTdsConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHourlyTdsConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var hourlyList = _payRollService.UpsertHourlyTdsConfiguration(hourlyTdsConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHourlyTdsConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHourlyTdsConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = hourlyList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHourlyTdsConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDaysOfWeekConfiguration)]
        public JsonResult<BtrakJsonResult> GetDaysOfWeekConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHourlyTdsConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var DaysOfWeekList = _payRollService.GetDaysOfWeekConfiguration(hourlyTdsConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDaysOfWeekConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDaysOfWeekConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = DaysOfWeekList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDaysOfWeekConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDaysOfWeekConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertDaysOfWeekConfiguration(UpsertDaysOfWeekConfigurationInputModel upsertDaysOfWeekConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHourlyTdsConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var DayOfWeek = _payRollService.UpsertDaysOfWeekConfiguration(upsertDaysOfWeekConfigurationInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHourlyTdsConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHourlyTdsConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = DayOfWeek, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDaysOfWeekConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllowanceTime)]
        public JsonResult<BtrakJsonResult> GetAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllowanceTime", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var allowanceList = _payRollService.GetAllowanceTime(hourlyTdsConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllowanceTime", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllowanceTime", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = allowanceList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllowanceTime", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAllowanceTime)]
        public JsonResult<BtrakJsonResult> UpsertAllowanceTime(UpsertAllowanceTimeInputModel upsertAllowanceTimeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAllowanceTime", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var allowanceTime = _payRollService.UpsertAllowanceTime(upsertAllowanceTimeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAllowanceTime", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAllowanceTime", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = allowanceTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAllowanceTime", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetContractPayTypes)]
        public JsonResult<BtrakJsonResult> GetContractPayTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetContractPayTypes", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ContractPayTypeModel> components = _payRollService.GetContractPayTypes(payRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractPayTypes", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractPayTypes", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractPayTypes", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetContractPaySettings)]
        public JsonResult<BtrakJsonResult> GetContractPaySettings(ContractPaySettingsSearchInputModel ContractPaySettingsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetContractPaySettings", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ContractPaySettingsSearchOutputModel> ContractPaySettings = _payRollService.GetContractPaySettings(ContractPaySettingsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractPaySettings", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractPaySettings", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = ContractPaySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractPaySettings", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertContractPaySettings)]
        public JsonResult<BtrakJsonResult> UpsertContractPaySettings(ContractPaySettingsUpsertInputModel ContractPaySettingsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertContractPaySettings", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? ContractPaySettingsId = _payRollService.UpsertContractPaySettings(ContractPaySettingsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertContractPaySettings", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertContractPaySettings", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = ContractPaySettingsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertContractPaySettings", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPartsOfDay)]
        public JsonResult<BtrakJsonResult> UpsertPartsOfDay(PartsOfDayUpsertInputModel PartsOfDaysUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPartsOfDays", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PartsOfDaysId = _payRollService.UpsertPartsOfDay(PartsOfDaysUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPartsOfDay", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPartsOfDay", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PartsOfDaysId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPartsOfDay", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPartsOfDays)]
        public JsonResult<BtrakJsonResult> GetPartsOfDays(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPartsOfDays", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PartsOfDayModel> components = _payRollService.GetPartsOfDays(payRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPartsOfDays", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPartsOfDays", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPartsOfDays", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeLoans)]
        public JsonResult<BtrakJsonResult> GetEmployeeLoans(EmployeeLoanSearchInputModel EmployeeLoanSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeLoans", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeLoanSearchOutputModel> EmployeeLoans = _payRollService.GetEmployeeLoans(EmployeeLoanSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLoans", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLoans", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeLoans, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLoans", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeLoan)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeLoan(EmployeeLoanUpsertInputModel EmployeeLoanUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeLoan", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? EmployeeLoanId = _payRollService.UpsertEmployeeLoan(EmployeeLoanUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeLoan", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeLoan", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeeLoanId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLoan", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLoanTypes)]
        public JsonResult<BtrakJsonResult> GetLoanTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLoanTypes", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<LoanTypeModel> loanTypes = _payRollService.GetLoanTypes(payRollTemplateSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLoanTypes", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLoanTypes", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = loanTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLoanTypes", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeLoanInstallment)]
        public JsonResult<BtrakJsonResult> GetEmployeeLoanInstallment(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeLoanInstallment", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var components = _payRollService.GetEmployeeLoanInstallment(hourlyTdsConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLoanInstallment", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLoanInstallment", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeLoanInstallment", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeLoanInstallment)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeLoanInstallment(EmployeeLoanInstallmentInputModel employeeLoanInstallmentInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeLoanInstallment", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _payRollService.UpsertEmployeeLoanInstallment(employeeLoanInstallmentInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeLoanInstallment", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeLoanInstallment", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLoanInstallment", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollRunEmployeeLeaveDetailsList)]
        public JsonResult<BtrakJsonResult> GetPayRollRunEmployeeLeaveDetailsList(Guid? payRollRunId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeLoanInstallment", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;
                    
                var result = _payRollService.GetPayRollRunEmployeeLeaveDetailsList(payRollRunId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollRunEmployeeLeaveDetailsList", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollRunEmployeeLeaveDetailsList", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollRunEmployeeLeaveDetailsList", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollRunTemplate)]
        public JsonResult<BtrakJsonResult> GetPayRollRunTemplate(PayrollRunOutPutModel payrollRunOutPutModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeUploadTemplate", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var path = GeneratePayRollExcelTemplate(payrollRunOutPutModel);

                //var result = File.ReadAllBytes(path);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeUploadTemplate", "HrManagement Api"));


                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RunPaymentForPayRollRun", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RunPaymentForPayRollRun", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = path, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollRunTemplate", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        public string GeneratePayRollExcelTemplate(PayrollRunOutPutModel payrollRunOutPutModel)
        {
            var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/PayRollExcelTemplate.xlsx");
            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            var guid = Guid.NewGuid();
            if (path1 != null)
            {
                string blobUrl;
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "PayRollRunTemplate.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null) System.IO.File.Copy(path, docName, true);

                    LoggingManager.Info("Created a directory to save temp file");
                }
            

                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {

                    uint rowIndex = 1;

                   
                    foreach (var payroll in payrollRunOutPutModel.PayrollRunOutPutModelList)
                    {

                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "A", payroll.EmployeeNumber);
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "B", payroll.EmployeeName);
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "C", payroll.LossOfPay.ToString());
                        AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "D", payroll.EncashedLeaves.ToString());

                        rowIndex++;
                    }

                    spreadSheet.Close();

                    blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                    {
                        MemoryStream = System.IO.File.ReadAllBytes(docName),
                        FileName = "PayRollRunTemplate"+ DateTime.Now.ToString("yyyy-MM-dd")  + ".xlsx",
                        ContentType = "application/xlsx",
                        LoggedInUserId = LoggedInContext.LoggedInUserId
                    });
                }

            if (Directory.Exists(destinationPath))
            {
                System.IO.File.Delete(docName);
                Directory.Delete(destinationPath);



                LoggingManager.Info("Deleting the temp folder");
            }
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateWorkItemTemplate", "UserStoryApiController"));
            return blobUrl;
            }
            return null;
        }

        public void AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname,
         uint rowIndex, string columnName, string text)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);
                //cell datatype     
                if (columnName == "C" || columnName == "D")
                {
                    cell.DataType =
                 new EnumValue<CellValues>(CellValues.Number);
                }
                else
                {
                    cell.DataType =
                 new EnumValue<CellValues>(CellValues.String);
                }
                
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }

        //retrieve sheetpart            
        public WorksheetPart RetrieveSheetPartByName(SpreadsheetDocument document,
         string sheetName)
        {
            IEnumerable<Sheet> sheets =
             document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
            Elements<Sheet>().Where(s => s.Name == sheetName);
            if (sheets.Count() == 0)
                return null;

            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)
            document.WorkbookPart.GetPartById(relationshipId);
            return worksheetPart;
        }

        //insert cell in sheet based on column and row index            
        public Cell InsertCellInSheet(string columnName, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;
            Row row;
            //check whether row exist or not            
            //if row exist            
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            //if row does not exist then it will create new row            
            else
            {
                row = new Row()
                {
                    RowIndex = rowIndex
                };
                sheetData.Append(row);
            }
            //check whether cell exist or not            
            //if cell exist            
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            //if cell does not exist            
            else
            {
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                row.InsertBefore(newCell, refCell);
                worksheet.Save();
                return newCell;
            }
        }

        private static WorksheetPart GetWorksheetPartByName(SpreadsheetDocument document, string sheetName, string newName)
        {
            //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoServiceValue, "GetWorksheetPartByName", "CourseReport"));

            IEnumerable<Sheet> sheets =
                document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
                    Elements<Sheet>().Where(s => s.Name == sheetName).ToList();

            if (sheets.Count() == 0)
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            if (!String.IsNullOrEmpty(newName)) sheets.First().Name = newName;
            WorksheetPart worksheetPart = (WorksheetPart)document.WorkbookPart.GetPartById(relationshipId);

            //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoServiceExitingValue, "GetWorksheetPartByName", "CourseReport"));

            return worksheetPart;

        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollRunEmployeeComponent)]
        public JsonResult<BtrakJsonResult> UpsertPayRollRunEmployeeComponent(PayRollRunEmployeeComponentUpsertInputModel PayRollRunEmployeeComponentUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollRunEmployeeComponent", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollRunEmployeeComponentId = _payRollService.UpsertPayRollRunEmployeeComponent(PayRollRunEmployeeComponentUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollRunEmployeeComponent", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollRunEmployeeComponent", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollRunEmployeeComponentId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollRunEmployeeComponent", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRegisterOfWages)]
        public JsonResult<BtrakJsonResult> GetRegisterOfWages(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRegisterOfWages", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<RegisterOfWagesOutputModel> registerOfWages = _payRollService.GetRegisterOfWages(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRegisterOfWages", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRegisterOfWages", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = registerOfWages, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRegisterOfWages", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeESIReport)]
        public JsonResult<BtrakJsonResult> GetEmployeeESIReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeESIReport", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeESIReportOutputModel> employeeESIReport = _payRollService.GetEmployeeESIReport(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeESIReport", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeESIReport", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = employeeESIReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeESIReport", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeePFReport)]
        public JsonResult<BtrakJsonResult> GetEmployeePFReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePFReport", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeePFReportOutputModel> employeePFReport = _payRollService.GetEmployeePFReport(payRollReportsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePFReport", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePFReport", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = employeePFReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePFReport", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTakeHomeAmount)]
        public JsonResult<BtrakJsonResult> GetTakeHomeAmount(Guid? employeesalaryId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTakeHomeAmount", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var takeHomeAmount = _payRollService.GetTakeHomeAmount(employeesalaryId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTakeHomeAmount", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePFReport", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = takeHomeAmount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTakeHomeAmount", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserCountry)]
        public JsonResult<BtrakJsonResult> GetUserCountry()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserCountry", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var country = _payRollService.GetUserCountry(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserCountry", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserCountry", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = country, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserCountry", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRateTags)]
        public JsonResult<BtrakJsonResult> GetRateTags(RateTagSearchCriteriaInputModel rateSheetSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheet", "rateSheetSearchCriteriaInputModel", rateSheetSearchCriteriaInputModel, "Master Data Management Api"));
                if (rateSheetSearchCriteriaInputModel == null)
                {
                    rateSheetSearchCriteriaInputModel = new RateTagSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting rate sheet list");
                List<RateTagOutputModel> rateSheetList = _payRollService.GetRateTags(rateSheetSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = rateSheetList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetRateTags)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRateTagForNames)]
        public JsonResult<BtrakJsonResult> GetRateTagForNames(RateTagForSearchCriteriaInputModel rateSheetForSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheet", "rateSheetSearchCriteriaInputModel", rateSheetForSearchCriteriaInputModel, "Master Data Management Api"));
                if (rateSheetForSearchCriteriaInputModel == null)
                {
                    rateSheetForSearchCriteriaInputModel = new RateTagForSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting rate sheet list");
                List<RateTagForOutputModel> rateSheetForList = _payRollService.GetRateTagForNames(rateSheetForSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet For", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet For", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = rateSheetForList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetRateTagForNames)
                });

                return null;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRateTag)]
        public JsonResult<BtrakJsonResult> UpsertRateTag(RateTagInputModel rateSheetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert rate sheet", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? rateSheetIdReturned = _payRollService.UpsertRateTag(rateSheetInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert rate sheet", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert rate sheet", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = rateSheetIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateTag", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertEmployeeRateTagDetails)]
        public JsonResult<BtrakJsonResult> InsertEmployeeRateTagDetails(EmployeeRateTagDetailsAddInputModel employeeRateTagDetailsAddInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee RateTag Details", "employeeRateTagDetailsAddInputModel", employeeRateTagDetailsAddInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeRateTagDetailsIdReturned = _payRollService.InsertEmployeeRateTagDetails(employeeRateTagDetailsAddInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeRateTagDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertEmployeeRateTagDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateEmployeeRateTagDetails)]
        public JsonResult<BtrakJsonResult> UpdateEmployeeRateTagDetails(EmployeeRateTagDetailsEditInputModel employeeRateTagDetailsAddInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee RateTag Details", "employeeRateTagDetailsAddInputModel", employeeRateTagDetailsAddInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeRateTagDetailsIdReturned = _payRollService.UpdateEmployeeRateTagDetails(employeeRateTagDetailsAddInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeRateTagDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateEmployeeRateTagDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeRateTagDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeRateTagDetails(EmployeeRateTagDetailsInputModel employeeRateTagDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeRateTagDetailsInputModel", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeRateTagDetailsApiReturnModel employeeRateTagDetailsApiReturnModel = _payRollService.SearchEmployeeRateTagDetails(employeeRateTagDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmployeeRateTagDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmployeeRateTagDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeRateTagDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeRateTagDetails", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRateTagAllowanceTime)]
        public JsonResult<BtrakJsonResult> GetRateTagAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRateTagAllowanceTime", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var allowanceList = _payRollService.GetRateTagAllowanceTime(hourlyTdsConfigurationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRateTagAllowanceTime", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRateTagAllowanceTime", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = allowanceList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTagAllowanceTime", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRateTagAllowanceTime)]
        public JsonResult<BtrakJsonResult> UpsertRateTagAllowanceTime(UpsertRateTagAllowanceTimeInputModel upsertRateTagAllowanceTimeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertRateTagAllowanceTime", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var RateTagAllowanceTime = _payRollService.UpsertRateTagAllowanceTime(upsertRateTagAllowanceTimeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRateTagAllowanceTime", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRateTagAllowanceTime", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = RateTagAllowanceTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateTagAllowanceTime", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBanks)]
        public JsonResult<BtrakJsonResult> GetBanks(BankSearchInputModel bankSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBanks", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BankModel> components = _payRollService.GetBanks(bankSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBanks", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBanks", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBanks", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertRateTagConfigurations)]
        public JsonResult<BtrakJsonResult> InsertRateTagConfiguration(RateTagConfigurationAddInputModel rateTagConfigurationAddInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee RateTag Details", "employeeRateTagDetailsAddInputModel", rateTagConfigurationAddInputModel, "PayRoll Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeRateTagDetailsIdReturned = _payRollService.InsertRateTagConfigurations(rateTagConfigurationAddInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "PayRoll Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "PayRoll Api"));
                return Json(new BtrakJsonResult { Data = employeeRateTagDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertRateTagConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateRateTagConfiguration)]
        public JsonResult<BtrakJsonResult> UpdateRateTagConfiguration(RateTagConfigurationEditInputModel rateTagConfigurationEditInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee RateTag Details", "employeeRateTagDetailsAddInputModel", rateTagConfigurationEditInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeRateTagDetailsIdReturned = _payRollService.UpdateRateTagConfiguration(rateTagConfigurationEditInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "PayRoll Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee RateTag Details", "PayRoll Api"));
                return Json(new BtrakJsonResult { Data = employeeRateTagDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateRateTagConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRateTagConfigurations)]
        public JsonResult<BtrakJsonResult> GetRateTagConfigurations(RateTagConfigurationsInputModel rateTagConfigurationsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RateTagConfigurationsInputModel", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                List<RateTagConfigurationsApiReturnModel> employeeRateTagDetailsApiReturnModel = _payRollService.GetRateTagConfigurations(rateTagConfigurationsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRateTagConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRateTagConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = employeeRateTagDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTagConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ArchivePayRoll)]
        public JsonResult<BtrakJsonResult> ArchivePayRoll(PayRollRunArchiveInputModel payRollRunArchiveInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchivePayRoll", "PayRollApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var result = _payRollService.ArchivePayRoll(payRollRunArchiveInputModel, LoggedInContext, validationMessages);

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


                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchivePayRoll", "PayRollApiController"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchivePayRoll", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRateTagRoleBranchConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertRateTagRoleBranchConfiguration(RateTagRoleBranchConfigurationUpsertInputModel RateTagRoleBranchConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertRateTagRoleBranchConfiguration", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? RateTagRoleBranchConfigurationId = _payRollService.UpsertRateTagRoleBranchConfiguration(RateTagRoleBranchConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRateTagRoleBranchConfiguration", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRateTagRoleBranchConfiguration", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = RateTagRoleBranchConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateTagRoleBranchConfiguration", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRateTagRoleBranchConfigurations)]
        public JsonResult<BtrakJsonResult> GetRateTagRoleBranchConfigurations(RateTagRoleBranchConfigurationInputModel rateTagRoleBranchConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RateTagRoleBranchConfigurationsInputModel", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                List<RateTagRoleBranchConfigurationApiReturnModel> rateTagConfigurationsApiReturnModel = _payRollService.GetRateTagRoleBranchConfigurations(rateTagRoleBranchConfigurationInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRateTagRoleBranchConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRateTagRoleBranchConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = rateTagConfigurationsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRateTagRoleBranchConfigurations", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBank)]
        public JsonResult<BtrakJsonResult> UpsertBank(BankUpsertInputModel BankUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBank", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? BankId = _payRollService.UpsertBank(BankUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBank", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBank", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = BankId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBank", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollBands)]
        public JsonResult<BtrakJsonResult> UpsertPayRollBands(PayRollBandsUpsertInputModel payRollBandsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollBands", "PayRollComponentApiController"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _payRollService.UpsertPayRollBands(payRollBandsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollBands", "PayRollComponentApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollBands", "PayRollComponentApiController"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollBands", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayRollBands)]
        public JsonResult<BtrakJsonResult> GetPayRollBands(PayRollBandsSearchInputModel payRollBandsSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Get Payroll bands list");
                var taxSlabsRange = _payRollService.GetPayRollBands(payRollBandsSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollBands", "PayRollApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayRollBands", "PayRollApiController"));
                return Json(new BtrakJsonResult { Data = taxSlabsRange, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayRollBands", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeePreviousCompanyTaxes)]
        public JsonResult<BtrakJsonResult> GetEmployeePreviousCompanyTaxes(EmployeePreviousCompanyTaxSearchInputModel EmployeePreviousCompanyTaxSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePreviousCompanyTax", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeePreviousCompanyTaxSearchOutputModel> EmployeePreviousCompanyTax = _payRollService.GetEmployeePreviousCompanyTaxes(EmployeePreviousCompanyTaxSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePreviousCompanyTax", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeePreviousCompanyTax", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeePreviousCompanyTax, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePreviousCompanyTaxes", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeePreviousCompanyTax)]
        public JsonResult<BtrakJsonResult> UpsertEmployeePreviousCompanyTax(EmployeePreviousCompanyTaxUpsertInputModel EmployeePreviousCompanyTaxUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeePreviousCompanyTax", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? EmployeePreviousCompanyTaxId = _payRollService.UpsertEmployeePreviousCompanyTax(EmployeePreviousCompanyTaxUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeePreviousCompanyTax", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeePreviousCompanyTax", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = EmployeePreviousCompanyTaxId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeePreviousCompanyTax", "PayRollApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTaxCalculationTypes)]
        public JsonResult<BtrakJsonResult> GetTaxCalculationTypes(TaxCalculationTypeModel taxCalculationTypeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTaxCalculationTypes", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<TaxCalculationTypeModel> components = _payRollService.GetTaxCalculationTypes(taxCalculationTypeModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxCalculationTypes", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTaxCalculationTypes", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = components, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetPayRollTemplates, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayRollRunEmployeeComponentYTD)]
        public JsonResult<BtrakJsonResult> UpsertPayRollRunEmployeeComponentYTD(PayRollRunEmployeeComponentYTDUpsertInputModel PayRollRunEmployeeComponentYTDUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollRunEmployeeComponentYTD", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? PayRollRunEmployeeComponentYTDId = null;// _payRollService.UpsertPayRollRunEmployeeComponentYTD(PayRollRunEmployeeComponentYTDUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollRunEmployeeComponentYTD", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayRollRunEmployeeComponentYTD", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = PayRollRunEmployeeComponentYTDId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertPayRollRunEmployeeComponentYTD, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeRateTagConfigurations)]
        public JsonResult<BtrakJsonResult> GetEmployeeRateTagConfigurations(EmployeeRateTagConfigurationInputModel employeeRateTagConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeRateTagConfigurationsInputModel", "PayRoll Api"));

                var validationMessages = new List<ValidationMessage>();

                List<EmployeeRateTagConfigurationApiReturnModel> rateTagConfigurationsApiReturnModel = _payRollService.GetEmployeeRateTagConfigurations(employeeRateTagConfigurationInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeRateTagConfigurations", "PayRoll Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeRateTagConfigurations", "PayRoll Api"));

                return Json(new BtrakJsonResult { Data = rateTagConfigurationsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetEmployeeRateTagConfigurations, exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}