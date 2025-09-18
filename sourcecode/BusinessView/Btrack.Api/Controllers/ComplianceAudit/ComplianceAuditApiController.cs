using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.MasterData;
using Btrak.Models.UserStory;
using Btrak.Services.ComplianceAudit;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Hangfire;

namespace BTrak.Api.Controllers.ComplianceAudit
{
    public class ComplianceAuditApiController : AuthTokenApiController
    {
        private readonly IComplianceAuditService _complianceAuditService;

        public ComplianceAuditApiController(IComplianceAuditService complianceAuditService)
        {
            _complianceAuditService = complianceAuditService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditConduct)]
        public JsonResult<BtrakJsonResult> UpsertAuditConduct(AuditConductApiInputModel auditConductApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditConduct", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                if (auditConductApiInputModel.DeadlineDate != null && auditConductApiInputModel.DeadlineDate.HasValue)
                {
                    auditConductApiInputModel.DeadlineDate = new DateTime(auditConductApiInputModel.DeadlineDate?.Year ?? DateTime.UtcNow.Year, auditConductApiInputModel.DeadlineDate?.Month ?? DateTime.UtcNow.Month, auditConductApiInputModel.DeadlineDate?.Day ?? DateTime.UtcNow.Day, 23, 59, 59);
                }
                Guid? auditCategoryId = _complianceAuditService.UpsertAuditConduct(auditConductApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditConduct", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditCategory", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditConduct", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReconductAudit)]
        public JsonResult<BtrakJsonResult> ReconductAudit(AuditConductApiInputModel auditConductApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReconductAudit", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditCategoryId = _complianceAuditService.ReconductAudit(auditConductApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReconductAudit", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReconductAudit", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReconductAudit", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditReport)]
        public JsonResult<BtrakJsonResult> UpsertAuditReport(AuditReportApiInputModel auditReportApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditReport", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditCategoryId = _complianceAuditService.UpsertAuditReport(auditReportApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditReport", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditReport", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditReport", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditReports)]
        public JsonResult<BtrakJsonResult> GetAuditReports(AuditReportApiInputModel auditReportApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditReports", "ComplianceAudit Api"));
                
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

               List<AuditReportApiReturnModel> auditReports = _complianceAuditService.GetAuditReports(auditReportApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditReports", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditReports", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditReports, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditReports", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAuditConducts)]
        public JsonResult<BtrakJsonResult> SearchAuditConducts(AuditConductApiInputModel auditConductApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditConduct", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditConductApiReturnModel> auditConductApiReturns = _complianceAuditService.SearchAuditConducts(auditConductApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditConduct", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditCategory", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditConductApiReturns, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditConducts", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetConductsFolderView)]
        public JsonResult<BtrakJsonResult> GetConductsFolderView(AuditConductApiInputModel auditConductApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConductsFolderView", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string auditConductApiReturns = _complianceAuditService.GetConductsFolderView(auditConductApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConductsFolderView", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConductsFolderView", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditConductApiReturns, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductsFolderView", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditCompliance)]
        public JsonResult<BtrakJsonResult> UpsertAuditCompliance(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditCompliance", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                 Guid? auditComplianceId = _complianceAuditService.UpsertAuditCompliance(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditCompliance", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditCompliance", "ComplianceAudit Api"));
                 
                return Json(new BtrakJsonResult { Data = auditComplianceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditCompliance", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditFolder)]
        public JsonResult<BtrakJsonResult> UpsertAuditFolder(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditFolder", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditComplianceId = _complianceAuditService.UpsertAuditFolder(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditFolder", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditFolder", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFolder", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SubmitAuditCompliance)]
        public JsonResult<BtrakJsonResult> SubmitAuditCompliance(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SubmitAuditCompliance", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                _complianceAuditService.SubmitAuditCompliance(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitAuditCompliance", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitAuditCompliance", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SubmitAuditCompliance", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CloneAudit)]
        public JsonResult<BtrakJsonResult> CloneAudit(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CloneAudit", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditComplianceId = _complianceAuditService.CloneAudit(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CloneAudit", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CloneAudit", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CloneAudit", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SubmitAuditConductQuestion)]
        public JsonResult<BtrakJsonResult> SubmitAuditConductQuestion(SubmitAuditConductApiInputModel submitAuditConductApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SubmitAuditConductQuestion", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? submittedId = _complianceAuditService.SubmitAuditConductQuestion(submitAuditConductApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitAuditConductQuestion", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitAuditConductQuestion", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = submittedId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SubmitAuditConductQuestion", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAudits)]
        public JsonResult<BtrakJsonResult> SearchAudits(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAudits", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditComplianceApiReturnModel> auditComplianceApiReturnModels = _complianceAuditService.SearchAudits(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAudits", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAudits", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAudits", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAuditFolders)]
        public JsonResult<BtrakJsonResult> SearchAuditFolders(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditFolders", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditComplianceApiReturnModel> auditComplianceApiReturnModels = _complianceAuditService.SearchAuditFolders(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditFolders", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditFolders", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditFolders", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditsFolderView)]
        public JsonResult<BtrakJsonResult> GetAuditsFolderView(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditsFolderView", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string auditComplianceApiReturnModels = _complianceAuditService.GetAuditsFolderView(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditsFolderView", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditsFolderView", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditsFolderView", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditCategory)]
        public JsonResult<BtrakJsonResult> UpsertAuditCategory(AuditCategoryApiInputModel auditCategoryApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditCategory", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditCategoryId = _complianceAuditService.UpsertAuditCategory(auditCategoryApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditCategory", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditCategory", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditCategory", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAuditCategories)]
        public JsonResult<BtrakJsonResult> GetAuditCategories(AuditCategoryApiInputModel auditCategoryApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditCategories", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditCategoryApiReturnModel> auditCategoryApiReturnModels = _complianceAuditService.SearchAuditCategories(auditCategoryApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditCategories", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditCategories", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditCategoryApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditCategories", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAuditCategoriesForConducts)]
        public JsonResult<BtrakJsonResult> SearchAuditCategoriesForConducts(AuditCategoryApiInputModel auditCategoryApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditCategoriesForConducts", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var auditCategoryApiReturnModels = _complianceAuditService.SearchAuditCategoriesForConducts(auditCategoryApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditCategoriesForConducts", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditCategoriesForConducts", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditCategoryApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditCategoriesForConducts", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCategoriesAndSubcategories)]
        public JsonResult<BtrakJsonResult> GetCategoriesAndSubcategories(AuditCategoryApiInputModel auditCategoryApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCategoriesAndSubcategories", "auditId", auditCategoryApiInputModel.AuditId, "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var categoriesAndSubcategoriesList = _complianceAuditService.GetCategoriesAndSubcategories(auditCategoryApiInputModel.AuditId, auditCategoryApiInputModel.AuditVersionId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCategoriesAndSubcategories", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCategoriesAndSubcategories", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Data = categoriesAndSubcategoriesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCategoriesAndSubcategories", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetQuestionTypes)]
        public JsonResult<BtrakJsonResult> GetQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQuestionTypes", "ComplianceAudit "));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<QuestionTypeApiReturnModel> questionTypes = _complianceAuditService.GetQuestionTypes(questionTypeApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQuestionTypes", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQuestionTypes", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = questionTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQuestionTypes", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMasterQuestionTypes)]
        public JsonResult<BtrakJsonResult> GetMasterQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMasterQuestionTypes", "ComplianceAudit "));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<QuestionTypeApiReturnModel> masterQuestionTypes = _complianceAuditService.GetMasterQuestionTypes(questionTypeApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMasterQuestionTypes", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMasterQuestionTypes", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = masterQuestionTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMasterQuestionTypes", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertQuestionType)]
        public JsonResult<BtrakJsonResult> UpsertQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertQuestionTypes", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? questionTypeId = _complianceAuditService.UpsertQuestionType(questionTypeApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertQuestionTypes", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertQuestionTypes", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = questionTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertQuestionTypes", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAuditRelatedCounts)]
        public JsonResult<BtrakJsonResult> GetAuditRelatedCounts(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditCategories", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                AuditRelatedCountsApiReturnModel auditRelatedCountsApiReturnModel = _complianceAuditService.GetAuditRelatedCounts(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditRelatedCounts", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditRelatedCounts", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditRelatedCountsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditRelatedCounts", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetConductQuestionsForActionLinking)]
        public JsonResult<BtrakJsonResult> GetConductQuestionsForActionLinking(Guid? projectId, string questionName )
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConductQuestionsForActionLinking", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ConductQuestionActions> auditRelatedCountsApiReturnModel = _complianceAuditService.GetConductQuestionsForActionLinking(projectId, questionName, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConductQuestionsForActionLinking", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConductQuestionsForActionLinking", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditRelatedCountsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductQuestionsForActionLinking", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditQuestion)]
        public JsonResult<BtrakJsonResult> UpsertAuditQuestion(AuditQuestionsApiInputModel auditQuestionsApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditQuestion", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? questionId = _complianceAuditService.UpsertAuditQuestion(auditQuestionsApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditQuestion", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditQuestion", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = questionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditQuestion", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditQuestions)]
        public JsonResult<BtrakJsonResult> GetAuditQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditQuestions", "ComplianceAudit "));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditQuestionsApiReturnModel> questionTypes = _complianceAuditService.GetAuditQuestions(auditQuestionsApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditQuestions", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditQuestions", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = questionTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditQuestions", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAuditConductQuestions)]
        public JsonResult<BtrakJsonResult> SearchAuditConductQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditConductQuestions", "ComplianceAudit "));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditQuestionsApiReturnModel> questions = _complianceAuditService.SearchAuditConductQuestions(auditQuestionsApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditConductQuestions", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditConductQuestions", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = questions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditConductQuestions", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetQuestionsByFilters)]
        public JsonResult<BtrakJsonResult> GetQuestionsByFilters(AuditQuestionsApiInputModel auditQuestionsApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQuestionsByFilters", "ComplianceAudit "));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ConductSelectedQuestionModel> questions = _complianceAuditService.GetQuestionsByFilters(auditQuestionsApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQuestionsByFilters", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQuestionsByFilters", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = questions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQuestionsByFilters", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditQuestionHistory)]
        public JsonResult<BtrakJsonResult> GetAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditQuestionHistory", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var questionHistory = _complianceAuditService.GetAuditQuestionHistory(auditQuestionHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditQuestionHistory", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditQuestionHistory", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Data = questionHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditQuestionHistory", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditQuestionHistory)]
        public JsonResult<BtrakJsonResult> UpsertAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditQuestionHistory", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var questionHistory = _complianceAuditService.UpsertAuditQuestionHistory(auditQuestionHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditQuestionHistory", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditQuestionHistory", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Data = questionHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditQuestionHistory", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditOverallHistory)]
        public JsonResult<BtrakJsonResult> GetAuditOverallHistory(AuditQuestionHistoryModel auditQuestionHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditOverallHistory", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var questionHistory = _complianceAuditService.GetAuditOverallHistory(auditQuestionHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditOverallHistory", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditOverallHistory", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Data = questionHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditOverallHistory", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReorderQuestions)]
        public JsonResult<BtrakJsonResult> ReorderQuestions(List<Guid> questionIds)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReorderQuestions", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var questions = _complianceAuditService.ReorderQuestions(questionIds, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderQuestions", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderQuestions", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderQuestions", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReorderCategories)]
        public JsonResult<BtrakJsonResult> ReorderCategories(CategoryModel categoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReorderCategories", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var questions = _complianceAuditService.ReorderCategories(categoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderCategories", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderCategories", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderQuestions", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CopyOrMoveQuestions)]
        public JsonResult<BtrakJsonResult> CopyOrMoveQuestions(CopyMoveQuestionsModel copyMoveQuestionsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CopyOrMoveQuestions", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditId = _complianceAuditService.CopyOrMoveQuestions(copyMoveQuestionsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CopyOrMoveQuestions", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CopyOrMoveQuestions", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Data = auditId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CopyOrMoveQuestions", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.MoveAuditQuestionsToAuditCategory)]
        public JsonResult<BtrakJsonResult> MoveAuditQuestionsToAuditCategory(MoveAuditQuestionsToAuditCategoryApiInputModel moveAuditQuestionsToAuditCategoryApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "MoveAuditQuestionsToAuditCategoryId", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditCategoryId = _complianceAuditService.MoveAuditQuestionsToAuditCategory(moveAuditQuestionsToAuditCategoryApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MoveAuditQuestionsToAuditCategoryId", "ComplianceAudit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MoveAuditQuestionsToAuditCategoryId", "ComplianceAudit Api"));
                return Json(new BtrakJsonResult { Data = auditCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MoveAuditQuestionsToAuditCategory", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SubmitAuditConduct)]
        public JsonResult<BtrakJsonResult> SubmitAuditConduct(AuditConductApiInputModel auditConductApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SubmitAuditConduct", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditConductId = _complianceAuditService.SubmitAuditConduct(auditConductApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitAuditConduct", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SubmitAuditConduct", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditConductId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SubmitAuditConduct", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchConductQuestionActions)]
        public JsonResult<BtrakJsonResult> SearchConductQuestionActions(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchConductQuestionActions", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                if (userStorySearchCriteriaInputModel == null)
                {
                    userStorySearchCriteriaInputModel = new UserStorySearchCriteriaInputModel();
                }

                BtrakJsonResult btrakJsonResult;

                List<GetBugsBasedOnUserStoryApiReturnModel> userStoryBugs = _complianceAuditService.SearchConductQuestionActions(userStorySearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchConductQuestionActions", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchConductQuestionActions", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = userStoryBugs, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchConductQuestionActions", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchSubmittedAudits)]
        public JsonResult<BtrakJsonResult> SearchSubmittedAudits(AuditSearchInputModel auditSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchSubmittedAudits", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<List<AuditSubmittedDetailsReturnModel>> auditComplianceApiReturnModels = _complianceAuditService.SearchSubmittedAudits(auditSearchInputModel,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAudits", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSubmittedAudits", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSubmittedAudits", "ComplianceAuditApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchNonCompalintAudits)]
        public JsonResult<BtrakJsonResult> SearchNonCompalintAudits(AuditSearchInputModel auditSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchNonCompalintAudits", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<List<AuditSubmittedDetailsReturnModel>> auditComplianceApiReturnModels = _complianceAuditService.SearchNonCompalintAudits(auditSearchInputModel,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchNonCompalintAudits", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchNonCompalintAudits", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchNonCompalintAudits", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchCompalintAudits)]
        public JsonResult<BtrakJsonResult> SearchCompalintAudits()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchCompalintAudits", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<List<AuditSubmittedDetailsReturnModel>> auditComplianceApiReturnModels = _complianceAuditService.SearchCompalintAudits(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompalintAudits", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompalintAudits", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditComplianceApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompalintAudits", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GenerateAuditReportAndSendMail)]
        public async Task<JsonResult<BtrakJsonResult>> GenerateAuditReportAndSendMail(AuditReportApiInputModel auditReportApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateAuditReportAndSendMail", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string pdfUrl = await _complianceAuditService.GenerateAuditReportAndSendMail(auditReportApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateAuditReportAndSendMail", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateAuditReportAndSendMail", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = pdfUrl, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateAuditReportAndSendMail", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditTags)]
        public JsonResult<BtrakJsonResult> UpsertAuditTags(AuditComplianceApiInputModel auditComplianceApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditTags", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditId = _complianceAuditService.UpsertAuditTags(auditComplianceApiInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditTags", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditTags", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditTags", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditPriority)]
        public JsonResult<BtrakJsonResult> UpsertAuditPriority(AuditPriorityModel auditPriorityModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditPriority", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditId = _complianceAuditService.UpsertAuditPriority(auditPriorityModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditPriority", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditPriority", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditPriority", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActionCategory)]
        public JsonResult<BtrakJsonResult> UpsertActionCategory(ActionCategoryModel actionCategoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActionCategory", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? ActionCategoryId = _complianceAuditService.UpsertActionCategory(actionCategoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActionCategory", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActionCategory", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = ActionCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActionCategory", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditRating)]
        public JsonResult<BtrakJsonResult> UpsertAuditRating(AuditRatingModel auditRatingModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditRating", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditRatingId = _complianceAuditService.UpsertAuditRating(auditRatingModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditRating", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditRating", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditRatingId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditRating", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditImpact)]
        public JsonResult<BtrakJsonResult> UpsertAuditImpact(AuditImpactModel auditImpactModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditImpact", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditId = _complianceAuditService.UpsertAuditImpact(auditImpactModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditImpact", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditImpact", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditImpact", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditPriority)]
        public JsonResult<BtrakJsonResult> GetAuditPriority(AuditPriorityModel auditPriorityModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAudiPriority", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditPriorityModel> auditPriorities = _complianceAuditService.GetAuditPriority(auditPriorityModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAudiPriority", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAudiPriority", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditPriorities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditPriority", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditRatings)]
        public JsonResult<BtrakJsonResult> GetAuditRatings(AuditRatingModel auditRatingModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditRatings", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditRatingModel> auditRatings = _complianceAuditService.GetAuditRatings(auditRatingModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditRatings", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditRatings", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditRatings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditRatings", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActionCategories)]
        public JsonResult<BtrakJsonResult> GetActionCategories(ActionCategoryModel actionCategoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActionCategories", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActionCategoryModel> actionCategories = _complianceAuditService.GetActionCategories(actionCategoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActionCategories", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActionCategories", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = actionCategories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActionCategories", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAuditRisk)]
        public JsonResult<BtrakJsonResult> UpsertAuditRisk(AuditRiskModel auditRiskModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAuditRisk", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditId = _complianceAuditService.UpsertAuditRisk(auditRiskModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditRisk", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAuditRisk", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditRisk", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditRisk)]
        public JsonResult<BtrakJsonResult> GetAuditRisk(AuditRiskModel auditRiskModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditRisk", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditRiskModel> auditRisks = _complianceAuditService.GetAuditRisk(auditRiskModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditRisk", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditRisk", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditRisks, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditRisk", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditImpact)]
        public JsonResult<BtrakJsonResult> GetAuditImpact(AuditImpactModel auditImpactModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditImpact", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();
                 
                BtrakJsonResult btrakJsonResult;

                List<AuditImpactModel> auditImpacts = _complianceAuditService.GetAuditImpact(auditImpactModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditImpact", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditImpact", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditImpacts, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditImpact", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTags)]
        public JsonResult<BtrakJsonResult> GetTags(string searchText, string selectedIds)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTags", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AuditTagsModel> auditTagsModels = _complianceAuditService.GetTags(searchText, selectedIds, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTags", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTags", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditTagsModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTags", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetConductsUserDropDown)]
        public JsonResult<BtrakJsonResult> GetConductsUserDropDown(string isBranchFilter)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConductsUserDropDown", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<TimeSheetApproveLineManagersOutputModel> userDropDown = _complianceAuditService.GetConductsUserDropDown(isBranchFilter, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTags", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTags", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = userDropDown, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductsUserDropDown", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.TriggerJob)]
        public JsonResult<BtrakJsonResult> TriggerJob([FromUri]int jobId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "TriggerJob", "ComplianceAudit Api"));

                RecurringJob.Trigger(jobId.ToString());

                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadAuditsFromCsv)]
        public JsonResult<BtrakJsonResult> UploadAuditsFromCsv(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upload Audits From Csv", "Compliance Audit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult _btrakJsonResult;

                var testCase = _complianceAuditService.UploadAuditsFromCsv(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload Audits From Csv", "Compliance Audit Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload Audits From Csv", "Compliance Audit Api"));
                return Json(new BtrakJsonResult { Data = testCase, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadAuditsFromCsv", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadAuditsFromExcel)]
        public async Task<JsonResult<BtrakJsonResult>>  UploadAuditsFromExcel(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upload Audits From Excel", "Compliance Audit Api"));

                var validationMessages = new List<ValidationMessage>();
                var provider = new MultipartMemoryStreamProvider();
                await Request.Content.ReadAsMultipartAsync(provider);
                var result = new List<object>();
                BtrakJsonResult _btrakJsonResult;
                foreach (var file in provider.Contents)
                {
                    var dataStream = await file.ReadAsStreamAsync();

                    result = _complianceAuditService.ProcessExcelData(projectId, dataStream, LoggedInContext, new List<ValidationMessage>());
                }
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload Audits From Excel", "Compliance Audit Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload Audits From Excel", "Compliance Audit Api"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadAuditsFromExcel", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadConductsFromCsv)]
        public JsonResult<BtrakJsonResult> UploadConductsFromCsv(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upload TestCases From Csv", "Compliance Audit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult _btrakJsonResult;

                var testCase = _complianceAuditService.UploadConductsFromCsv(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestCases From Csv", "Compliance Audit Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestCases From Csv", "Compliance Audit Api"));
                return Json(new BtrakJsonResult { Data = testCase, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadConductsFromCsv", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditDataForJson)]
        public JsonResult<BtrakJsonResult> GetAuditDataForJson(AuditDownloadModel model)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditDataForJson", "Compliance Audit Api"));

                object result = null;
                var download = !string.IsNullOrEmpty(model.Download) ? model.Download : AppConstants.Json;
                var auditName = !string.IsNullOrEmpty(model.AuditName) ? model.AuditName : null;

                var validationMessages = new List<ValidationMessage>();

                var loggedInContext = LoggedInContext;

                var site = HttpContext.Current.Request.Url.Authority;

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    var auditJson = _complianceAuditService.GetAuditDataForJson(model, loggedInContext, validationMessages);

                    if (download?.ToLower() == AppConstants.Excel)
                    {
                        AuditDownloadModel exportModel = new AuditDownloadModel();
                        exportModel.AuditName = auditName;
                        exportModel.ToMails = model.ToMails;
                        exportModel.Download = download;
                        result = _complianceAuditService.GetAuditDataForExcel(auditJson, exportModel, site, loggedInContext, validationMessages);
                    }
                    else
                    {
                        result = auditJson;
                    }
                });
                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditDataForJson", "Compliance Audit Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditDataForJson", "Compliance Audit Api"));
                return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditDataForJsons", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendConductLinkToMails)]
        public JsonResult<BtrakJsonResult> SendConductLinkToMails(ConductLinkEmailSendModel model)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendConductLinkToMails", "Compliance Audit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult _btrakJsonResult;

                bool testCase = _complianceAuditService.SendConductLinkToMails(model, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendConductLinkToMails", "Compliance Audit Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendConductLinkToMails", "Compliance Audit Api"));
                return Json(new BtrakJsonResult { Data = testCase, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendConductLinkToMails", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ExportAuditConduct)]
        public JsonResult<BtrakJsonResult> ExportAuditConduct(ConductLinkEmailSendModel model)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ExportAuditConduct", "Compliance Audit Api"));
                object result = null;
                var validationMessages = new List<ValidationMessage>();

                var loggedInContext = LoggedInContext;

                var site = HttpContext.Current.Request.Url.Authority;

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    var conductJson = _complianceAuditService.GetConductDataForJson(model, loggedInContext, validationMessages);
                    
                    result = _complianceAuditService.GetConductDataForExcel(conductJson, model, site, loggedInContext, validationMessages);

                });
                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ExportAuditConduct", "Compliance Audit Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ExportAuditConduct", "Compliance Audit Api"));
                return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportAuditConduct", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.DownloadAuditsCsvTemplate)]
        public async Task<HttpResponseMessage> DownloadAuditsCsvTemplate()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadTestCasesCsvTemplate", "Audit Api"));

                var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/SampleAuditImport.csv");

                var result = File.ReadAllBytes(path);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadTestCasesCsvTemplate", "Audit Api"));

                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() =>
                {
                    var response = Request.CreateResponse(HttpStatusCode.OK);

                    response.Content = new ByteArrayContent(result);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/text");
                    response.Content.Headers.Add("content-disposition", "attachment;filename=SampleAuditImport.csv");
                    return response;
                });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadAuditsCsvTemplate", "ComplianceAuditApiController", exception.Message), exception);

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.DownloadConductsCsvTemplate)]
        public async Task<HttpResponseMessage> DownloadConductsCsvTemplate()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadConductsCsvTemplate", "Audit Api"));

                var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/SampleAuditConductImport.csv");

                var result = File.ReadAllBytes(path);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadConductsCsvTemplate", "Audit Api"));

                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() =>
                {
                    var response = Request.CreateResponse(HttpStatusCode.OK);

                    response.Content = new ByteArrayContent(result);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/text");
                    response.Content.Headers.Add("content-disposition", "attachment;filename=SampleAuditConductImport.csv");
                    return response;
                });
            }
            catch (Exception exception)
            {

                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadConductsCsvTemplate", "ComplianceAuditApiController", exception.Message), exception);

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertAuditVersion)]
        public JsonResult<BtrakJsonResult> InsertAuditVersion(InsertAuditVersionInputModel insertAuditVersionInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertAuditVersion", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? auditVersionId = _complianceAuditService.InsertAuditVersion(insertAuditVersionInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertAuditVersion", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertAuditVersion", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditVersionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertAuditVersion", "ComplianceAuditApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAuditVersions)]
        public JsonResult<BtrakJsonResult> GetAuditVersions(Guid? auditId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditVersions", "ComplianceAudit Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GetAuditVersionsOutputModel> auditVersions = _complianceAuditService.GetAuditVersions(auditId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditVersions", "ComplianceAudit Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditVersions", "ComplianceAudit Api"));

                return Json(new BtrakJsonResult { Data = auditVersions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditVersions", "ComplianceAuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}