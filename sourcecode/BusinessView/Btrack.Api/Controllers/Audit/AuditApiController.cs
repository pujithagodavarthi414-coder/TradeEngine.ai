using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Audit;
using Btrak.Services.Audit;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Audit
{
    public class AuditApiController : AuthTokenApiController
    {
        private readonly IAuditService _auditService;

        public AuditApiController()
        {
            _auditService = new AuditService();
        }
     
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAuditHistory)]
        public JsonResult<BtrakJsonResult> SearchAuditHistory(AuditSearchCriteriaInputModel auditSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditHistory", "Audit Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<AuditHistoryModel> audits = _auditService.SearchAuditHistory(auditSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditHistory", "Audit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchAuditHistory", "Audit Api"));
                return Json(new BtrakJsonResult { Success = true, Data = audits }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditHistory", "AuditApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditByBranch)]
        public JsonResult<BtrakJsonResult> GetAuditByBranch(AuditTimelineInputModel auditTimelineInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditByBranch", "Audit Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                object audits = _auditService.GetAuditByBranch(auditTimelineInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "t", "Audit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditByBranch", "Audit Api"));
                return Json(new BtrakJsonResult { Success = true, Data = audits }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditByBranch", "AuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAuditConductTimeline)]
        public JsonResult<BtrakJsonResult> GetAuditConductTimeline(AuditTimelineInputModel auditTimelineInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAuditConductTimeline", "Audit Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                object audits = _auditService.GetAuditConductTimeline(auditTimelineInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "t", "Audit Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAuditConductTimeline", "Audit Api"));
                return Json(new BtrakJsonResult { Success = true, Data = audits }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditConductTimeline", "AuditApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
