using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Services.Leaves;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models.LeaveManagement;
using System.Threading.Tasks;

namespace BTrak.Api.Controllers.Leaves
{
    public class LeavesManagementApiController : AuthTokenApiController
    {
        private readonly ILeavesManagementService _leavesManagementService;

        public LeavesManagementApiController(ILeavesManagementService leavesManagementService)
        {
            _leavesManagementService = leavesManagementService;
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaves)]
        public JsonResult<BtrakJsonResult> UpsertLeaves(LeaveManagementInputModel leaveManagementInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaves", "leaveManagementInputModel", leaveManagementInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? leaveIdReturned = _leavesManagementService.UpsertLeaves(leaveManagementInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaves", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaves", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaves", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchLeaves)]
        public JsonResult<BtrakJsonResult> SearchLeaves(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchLeaves", "leavesSearchCriteriaInputModel", leavesSearchCriteriaInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                if (leavesSearchCriteriaInputModel == null)
                    leavesSearchCriteriaInputModel = new LeavesSearchCriteriaInputModel();

                BtrakJsonResult btrakJsonResult;
                List<LeaveManagementOutputModel> leaves = _leavesManagementService.SearchLeaves(leavesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchLeaves", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchLeaves", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaves, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLeaves", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveStatusSetHistory)]
        public JsonResult<BtrakJsonResult> GetLeaveStatusSetHistory(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeaveStatusSetHistory", "leavesSearchCriteriaInputModel", leavesSearchCriteriaInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;
                List<LeaveStatusSetHistorySearchReturnModel> leaves = _leavesManagementService.GetLeaveStatusSetHistory(leavesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveStatusSetHistory", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveStatusSetHistory", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaves, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveStatusSetHistory", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLeavesById)]
        public JsonResult<BtrakJsonResult> GetLeavesById(Guid? leaveApplicationId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeavesById", "leaveApplicationId", leaveApplicationId, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                LeaveManagementOutputModel leaveDetails = _leavesManagementService.GetLeaveDetailById(leaveApplicationId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeavesById", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeavesById", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeavesById", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaveApplicabilty)]
        public JsonResult<BtrakJsonResult> UpsertLeaveApplicability(LeaveApplicabilityUpsertInputModel leaveApplicabilityUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaveApplicability", "leaveApplicabilityUpsertInputModel", leaveApplicabilityUpsertInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? leaveApplicabiltyId = _leavesManagementService.UpsertLeaveApplicability(leaveApplicabilityUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveApplicability", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveApplicability", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveApplicabiltyId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveApplicability", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveApplicabilty)]
        public JsonResult<BtrakJsonResult> GetLeaveApplicability(Guid? leaveTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeaveApplicability", "leaveTypeId", leaveTypeId, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<LeaveApplicabilitySearchOutputModel> leaveApplicabilitySearchOutputModel = _leavesManagementService.GetLeaveApplicability(leaveTypeId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveApplicability", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveApplicability", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveApplicabilitySearchOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveApplicability", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTotalOffLeave)]
        public JsonResult<BtrakJsonResult> UpsertTotalOffLeave(TotalOffLeaveUpsertInputModel totalOffLeaveUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTotalOffLeave", totalOffLeaveUpsertInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? totalOffLeaveId = _leavesManagementService.UpsertTotalOffLeave(totalOffLeaveUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTotalOffLeave", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTotalOffLeave", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = totalOffLeaveId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTotalOffLeave", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ApproveOrRejectLeave)]
        public JsonResult<BtrakJsonResult> ApproveOrRejectleave(ApproveOrRejectLeaveInputModel approveOrRejectLeaveInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ApproveOrRejectLeave", approveOrRejectLeaveInputModel, "ApproveOrRejectLeaveInputModel", "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? leaveStatusId = _leavesManagementService.ApproveOrRejectLeave(approveOrRejectLeaveInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApproveOrRejectLeave", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApproveOrRejectLeave", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApproveOrRejectleave", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMonthlyLeavesReport)]
        public JsonResult<BtrakJsonResult> GetMonthlyLeavesReport(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMonthlyLeavesReport", leavesSearchCriteriaInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                MontlyLeaveOutputModel monthLyLeaveReportOutputModel = _leavesManagementService.GetMonthlyLeavesReport(leavesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMonthlyLeavesReport", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMonthlyLeavesReport", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = monthLyLeaveReportOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMonthlyLeavesReport", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveDetails)]
        public JsonResult<BtrakJsonResult> GetLeaveDetails(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeaveDetails", "leavesSearchCriteriaInputModel", leavesSearchCriteriaInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<LeaveDetails> leaveDetails = _leavesManagementService.GetLeaveDetails(leavesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveDetails", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveDetails", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveDetails", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadMonthlyLeavesReport)]
        public JsonResult<BtrakJsonResult> DownloadMonthlyLeavesReport(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DownloadMonthlyLeavesReport", leavesSearchCriteriaInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Task<MontlyLeaveOutputModel> monthLyLeaveReportOutputModel = _leavesManagementService.DownloadMonthlyLeavesReport(leavesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadMonthlyLeavesReport", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadMonthlyLeavesReport", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = monthLyLeaveReportOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadMonthlyLeavesReport", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeAbsence)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeAbsence(EmployeeLeaveModel employeeLeaveModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeAbsence", "employeeLeaveModel", employeeLeaveModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                LeaveManagementInputModel leaveManagementModel = new LeaveManagementInputModel
                {
                    UserId = employeeLeaveModel.UserId,
                    LeaveTypeId =  employeeLeaveModel.LeaveTypeId,
                    FromLeaveSessionId = employeeLeaveModel.LeaveSessionId,
                    LeaveDateFrom = employeeLeaveModel.Date,
                    LeaveDateTo = employeeLeaveModel.Date,
                    LeaveReason = employeeLeaveModel.ReasonForAbsent
                };
                BtrakJsonResult btrakJsonResult;
                Guid? leaveApplicationIdReturned = _leavesManagementService.UpsertEmployeeAbsence(leaveManagementModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeAbsence", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeAbsence", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveApplicationIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeAbsence", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeletePermission)]
        public JsonResult<BtrakJsonResult> DeletePermission(DeleteLeavePermissionModel deletePermissionModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeletePermission", "deletePermissionModel", deletePermissionModel, "Leaves Management Api"));
                BtrakJsonResult btrakJsonResult;
                var permissionId = _leavesManagementService.DeleteLeavePermission(deletePermissionModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Delete Leave Permission is completed. Return Guid is " + permissionId + ", source command is " + deletePermissionModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Permission", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Permission", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = permissionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionDeleteLeavePermission)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteLeave)]
        public JsonResult<BtrakJsonResult> DeleteLeave(DeleteLeaveModel deleteLeaveModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Leave", "deleteLeaveModel", deleteLeaveModel, "Leaves Management Api"));
                BtrakJsonResult btrakJsonResult;
                var leaveId = _leavesManagementService.DeleteLeave(deleteLeaveModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Delete Leave is completed. Return Guid is " + leaveId + ", source command is " + deleteLeaveModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Leave", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Leave", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionDeleteLeave)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveOverViewReport)]
        public JsonResult<BtrakJsonResult> GetLeaveOverViewRepport(LeaveOverViewReportGetInputModel leaveOverViewReportGetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLeaveOverViewRepport", "leaveOverViewReportGetInputModel", leaveOverViewReportGetInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<LeaveOverViewReportGetOutputModel> leaveReportOutputModel = _leavesManagementService.GetLeaveOverViewRepport(leaveOverViewReportGetInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveOverViewRepport", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveOverViewRepport", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = leaveReportOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveOverViewRepport", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadLeaveOverViewRepport)]
        public JsonResult<BtrakJsonResult> DownloadLeaveOverViewRepport(LeaveOverViewReportGetInputModel leaveOverViewReportGetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DownloadLeaveOverViewRepport", leaveOverViewReportGetInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Task<LeaveOverViewReportGetOutputModel> monthLyLeaveReportOutputModel = _leavesManagementService.DownloadLeaveOverViewRepport(leaveOverViewReportGetInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadLeaveOverViewRepport", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadLeaveOverViewRepport", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = monthLyLeaveReportOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadLeaveOverViewRepport", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyOverViewLeaveReport)]
        public JsonResult<BtrakJsonResult> GetCompanyOverViewLeaveReport(CompanyOverViewLeaveReportInputModel companyOverViewLeaveReportInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyOverViewLeaveRepport", companyOverViewLeaveReportInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                CompanyOverViewLeaveReportOutputModel monthLyLeaveReportOutputModel = _leavesManagementService.GetCompanyOverViewLeaveReport(companyOverViewLeaveReportInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyOverViewLeaveRepport", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyOverViewLeaveRepport", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = monthLyLeaveReportOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyOverViewLeaveReport", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadCompanyOverViewLeaveReport)]
        public JsonResult<BtrakJsonResult> DownloadCompanyOverViewLeaveReport(CompanyOverViewLeaveReportInputModel companyOverViewLeaveReportInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DownloadCompanyOverViewLeaveReport", companyOverViewLeaveReportInputModel, "Leaves Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Task<CompanyOverViewLeaveReportOutputModel> monthLyLeaveReportOutputModel = _leavesManagementService.DownloadCompanyOverViewLeaveReport(companyOverViewLeaveReportInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadCompanyOverViewLeaveReport", "Leaves Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadCompanyOverViewLeaveReport", "Leaves Management Api"));
                return Json(new BtrakJsonResult { Data = monthLyLeaveReportOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyOverViewLeaveReport", "LeavesManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
