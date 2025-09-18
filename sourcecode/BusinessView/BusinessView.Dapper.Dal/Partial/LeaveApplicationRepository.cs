using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.Models;
using Btrak.Models;
using Btrak.Models.LeaveManagement;
using Btrak.Models.LeaveSessions;
using Btrak.Models.LeaveType;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class LeaveApplicationRepository
    {
        /* New code */
        public List<LeaveApplicationOutputModel> UpsertLeave(LeaveManagementInputModel leaveApplicationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveApplicationId", leaveApplicationInputModel.LeaveApplicationId);
                    vParams.Add("@UserId", leaveApplicationInputModel.UserId);
                    vParams.Add("@LeaveReason", leaveApplicationInputModel.LeaveReason);
                    vParams.Add("@LeaveTypeId", leaveApplicationInputModel.LeaveTypeId);
                    vParams.Add("@LeaveDateFrom", leaveApplicationInputModel.LeaveDateFrom);
                    vParams.Add("@LeaveDateTo", leaveApplicationInputModel.LeaveDateTo);
                    vParams.Add("@FromLeaveSessionId", leaveApplicationInputModel.FromLeaveSessionId);
                    vParams.Add("@ToLeaveSessionId", leaveApplicationInputModel.ToLeaveSessionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", leaveApplicationInputModel.IsArchived);
                    vParams.Add("@TimeStamp", leaveApplicationInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<LeaveApplicationOutputModel>(StoredProcedureConstants.SpUpsertLeaves, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeave", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveUpsert);

                return new List<LeaveApplicationOutputModel>();
            }
        }

        public List<LeaveManagementOutputModel> SearchLeaves(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveApplicationId", leavesSearchCriteriaInputModel.LeaveApplicationId);
                    vParams.Add("@UserId", leavesSearchCriteriaInputModel.UserId);
                    vParams.Add("@LeaveReason", leavesSearchCriteriaInputModel.LeaveReason);
                    vParams.Add("@LeaveTypeId", leavesSearchCriteriaInputModel.LeaveTypeId);
                    vParams.Add("@BranchId", leavesSearchCriteriaInputModel.BranchId);
                    vParams.Add("@LeaveAppliedDate", leavesSearchCriteriaInputModel.LeaveAppliedDate);
                    vParams.Add("@LeaveDateFrom", leavesSearchCriteriaInputModel.LeaveDateFrom);
                    vParams.Add("@LeaveDateTo", leavesSearchCriteriaInputModel.LeaveDateTo);
                    vParams.Add("@Date", leavesSearchCriteriaInputModel.Date);
                    vParams.Add("@IsDeleted", leavesSearchCriteriaInputModel.IsDeleted);
                    vParams.Add("@OverallLeaveStatusId", leavesSearchCriteriaInputModel.OverallLeaveStatusId);
                    vParams.Add("@FromLeaveSessionId", leavesSearchCriteriaInputModel.FromLeaveSessionId);
                    vParams.Add("@ToLeaveSessionId", leavesSearchCriteriaInputModel.ToLeaveSessionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", leavesSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", leavesSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", leavesSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", leavesSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@SearchText", leavesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", leavesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@EntityId", leavesSearchCriteriaInputModel.EntityId);
                    vParams.Add("@IsWaitingForApproval", leavesSearchCriteriaInputModel.IsWaitingForApproval);
                    vParams.Add("@LeaveApplicationIdsXml", leavesSearchCriteriaInputModel.LeaveApplicationIdsXml);
                    return vConn.Query<LeaveManagementOutputModel>(StoredProcedureConstants.SpSearchLeavesNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLeaves", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveSearch);

                return new List<LeaveManagementOutputModel>();
            }
        }

        public List<LeaveStatusSetHistorySearchReturnModel> GetLeaveStatusSetHistory(LeavesSearchCriteriaInputModel leaveManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveApplicationId", leaveManagementInputModel.LeaveApplicationId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeaveStatusSetHistorySearchReturnModel>(StoredProcedureConstants.SPGetLeaveStatusSetHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveStatusSetHistory", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveUpsertMail);

                return new List<LeaveStatusSetHistorySearchReturnModel>();
            }
        }

        public List<LeaveApplicationMailSendingOutputModel> LeaveApplicationMailSending (LeaveManagementInputModel leaveManagementInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
               using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", leaveManagementInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeaveApplicationMailSendingOutputModel>(StoredProcedureConstants.SpGetEmployeeReportToMembers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "LeaveApplicationMailSending", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveUpsertMail);

                return new List<LeaveApplicationMailSendingOutputModel>();
            }
        }


        public List<MonthLyLeaveReportOutputModel> GetMonthlyLeavesReport(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", leavesSearchCriteriaInputModel.UserId);
                    vParams.Add("@LeaveTypeId", leavesSearchCriteriaInputModel.LeaveTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MonthLyLeaveReportOutputModel>(StoredProcedureConstants.SpGetMonthlyLeavesReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMonthlyLeavesReport", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMonthlyLeavesReport);

                return new List<MonthLyLeaveReportOutputModel>();
            }
        }

        public List<LeaveDetails> GetLeaveDetails(LeavesSearchCriteriaInputModel leavesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveTypeId", leavesSearchCriteriaInputModel.LeaveTypeId);
                    vParams.Add("@DateFrom", leavesSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", leavesSearchCriteriaInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", leavesSearchCriteriaInputModel.UserId);
                    return vConn.Query<LeaveDetails>(StoredProcedureConstants.SpGetLeaveDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveDetails", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMonthlyLeavesReport);

                return new List<LeaveDetails>();
            }
        }

        public Guid? UpsertEmployeeAbsence(LeaveManagementInputModel leaveApplicationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveApplicationId", leaveApplicationInputModel.LeaveApplicationId);
                    vParams.Add("@UserId", leaveApplicationInputModel.UserId);
                    vParams.Add("@LeaveReason", leaveApplicationInputModel.LeaveReason);
                    vParams.Add("@LeaveTypeId", leaveApplicationInputModel.LeaveTypeId);
                    vParams.Add("@LeaveDateFrom", leaveApplicationInputModel.LeaveDateFrom);
                    vParams.Add("@LeaveDateTo", leaveApplicationInputModel.LeaveDateTo);
                    vParams.Add("@IsDeleted", leaveApplicationInputModel.IsDeleted);
                    vParams.Add("@FromLeaveSessionId", leaveApplicationInputModel.FromLeaveSessionId);
                    vParams.Add("@ToLeaveSessionId", leaveApplicationInputModel.ToLeaveSessionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", leaveApplicationInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaves, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeAbsence", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeAbsenceUpsert);

                return null;
            }
        }

        public Guid? DeleteLeave(DeleteLeaveModel deleteLeaveModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveId", deleteLeaveModel.LeaveId);
                    vParams.Add("@TimeStamp", deleteLeaveModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteLeave, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteLeave", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteLeave);
                return null;
            }
        }

        public ApproveOrRejectLeaveDetails ApproveOrRejectLeave(ApproveOrRejectLeaveInputModel approveOrRejectLeaveInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveApplicationid", approveOrRejectLeaveInputModel.LeaveApplicationid);
                    vParams.Add("@IsApproved", approveOrRejectLeaveInputModel.IsApproved);
                    vParams.Add("@Reason", approveOrRejectLeaveInputModel.LeaveReason);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ApproveOrRejectLeaveDetails>(StoredProcedureConstants.SpApproveOrRejectLeave, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApproveOrRejectLeave", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionApproveOrRejectLeave);
                return null;
            }
        }

        public ApproveOrRejectLeaveDetails ApproveLeaveByAdmin(ApproveOrRejectLeaveInputModel approveOrRejectLeaveInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveApplicationId", approveOrRejectLeaveInputModel.LeaveApplicationid);
                    vParams.Add("@IsApproved", approveOrRejectLeaveInputModel.IsApproved);
                    vParams.Add("Reason", approveOrRejectLeaveInputModel.LeaveReason);
                    vParams.Add("@TimeStamp", approveOrRejectLeaveInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ApproveOrRejectLeaveDetails>(StoredProcedureConstants.SPApproveLeaveByAdmin, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApproveLeaveByAdmin", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionApproveOrRejectLeave);
                return null;
            }
        }

        public Guid? DeleteLeavePermission(DeleteLeavePermissionModel deleteLeavePermissionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PermissionId", deleteLeavePermissionModel.PermissionId);
                    vParams.Add("@TimeStamp", deleteLeavePermissionModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeletePermission, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteLeavePermission", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteLeavePermission);
                return null;
            }
        }

        public Guid? UpsertLeaveApplicability(LeaveApplicabilityUpsertInputModel leaveApplicabilityUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveApplicabiltyId", leaveApplicabilityUpsertInputModel.LeaveApplicabilityId);
                    vParams.Add("@LeaveTypeId", leaveApplicabilityUpsertInputModel.LeaveTypeId);
                    vParams.Add("@MaxLeaves", leaveApplicabilityUpsertInputModel.MaxLeaves);
                    vParams.Add("@MaxExperienceInMonths", leaveApplicabilityUpsertInputModel.MaxExperienceInMonths);
                    vParams.Add("@MinExperienceInMonths", leaveApplicabilityUpsertInputModel.MinExperienceInMonths);
                    vParams.Add("@EmployeeTypeId", leaveApplicabilityUpsertInputModel.EmployeeTypeId);
                    vParams.Add("@RoleIdXml", leaveApplicabilityUpsertInputModel.RoleIdXml);
                    vParams.Add("@BranchIdXml", leaveApplicabilityUpsertInputModel.BranchIdXml);
                    vParams.Add("@GenderIdXml", leaveApplicabilityUpsertInputModel.GenderIdXml);
                    vParams.Add("@MaritalStatusIdXml", leaveApplicabilityUpsertInputModel.MaritalStatusIdXml);
                    vParams.Add("@EmployeeIdXml", leaveApplicabilityUpsertInputModel.EmployeeIdXml);
                    vParams.Add("@TimeStamp", leaveApplicabilityUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaveApplicability, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveApplicability", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeaveApplicability);
                return null;
            }
        }

        public Guid? UpsertTotalOffLeave(TotalOffLeaveUpsertInputModel totalOffLeaveUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TotalOffLeaveId", totalOffLeaveUpsertInputModel.TotalOffLeaveId);
                    vParams.Add("@TotalHoursPerMonth", totalOffLeaveUpsertInputModel.TotalHoursPerMonth);
                    vParams.Add("@NoOfLeavesToBeAdded", totalOffLeaveUpsertInputModel.NoOfLeavesToBeAdded);
                    vParams.Add("@MinProductivity", totalOffLeaveUpsertInputModel.MinProductivity);
                    vParams.Add("@LeaveApplicabilityId", totalOffLeaveUpsertInputModel.LeaveApplicabilityId);
                    vParams.Add("@IsArchived", totalOffLeaveUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", totalOffLeaveUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTotalOffLeave, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTotalOffLeave", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeaveApplicability);
                return null;
            }
        }  
        
        /* Old Code */
        public Guid UpsertLeave(LeaveApplicationModel leaveApplicationModel)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@LeaveApplicationId", leaveApplicationModel.LeaveApplicationId);
                vParams.Add("@UserId", leaveApplicationModel.UserId);
                vParams.Add("@LeaveReason", leaveApplicationModel.LeaveReason);
                vParams.Add("@LeaveTypeId", leaveApplicationModel.LeaveTypeId);
                vParams.Add("@LeaveDateFrom", leaveApplicationModel.LeaveDateFrom);
                vParams.Add("@LeaveDateTo", leaveApplicationModel.LeaveDateTo);
                vParams.Add("@IsDeleted", leaveApplicationModel.IsDeleted);
                vParams.Add("@OverallLeaveStatusId", leaveApplicationModel.OverallLeaveStatusId);
                vParams.Add("@FromLeaveSessionId", leaveApplicationModel.FromLeaveSessionId);
                vParams.Add("@ToLeaveSessionId", leaveApplicationModel.ToLeaveSessionId);
                vParams.Add("@OperationPerformedBy", leaveApplicationModel.OperationPerformedBy);
                return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertLeaves, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public LeavesModel GetLeavesById(Guid leaveApplicationId, Guid operationPerformedBy)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@LeaveApplicationId", leaveApplicationId);
                vParams.Add("@OperationPerformedBy", operationPerformedBy);
                return vConn.Query<LeavesModel>(StoredProcedureConstants.SpGetLeavesById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<LeavesModel> GetAllLeaves(int pagesize, int pagenumber, Guid operationPerformedBy)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@OperationPerformedBy", operationPerformedBy);
                vParams.Add("@Pagesize", pagesize);
                vParams.Add("@Pagenumber", pagenumber);
                return vConn.Query<LeavesModel>(StoredProcedureConstants.SpSearchLeaves, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public LeaveApplicationDbEntity GetLeaveDetails(Guid userId, DateTime date)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@Date", date);

                return vConn.Query<LeaveApplicationDbEntity>("USP_GetLeaveDetails", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public int GetLeaveAllowancee(Guid employeeId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                return vConn.Query<int>("usp_GetLeaveAllowance", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public bool DeleteLeave(Guid leaveApplicationId)
        {
            int result;
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@Id", leaveApplicationId);
                result = vConn.Execute("usp_DeleteLeave", vParams, commandType: CommandType.StoredProcedure);
                if (result == -1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public string GetOverAllLeaveStatus(Guid leaveApplicationId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@Id", leaveApplicationId);
                return vConn.Query<string>("usp_GetOverAllLeaveStatus", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<LeaveApplicationDbEntity> GetLeaves(Guid employeeId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                return vConn.Query<LeaveApplicationDbEntity>("USP_SelectLeaves", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public string GetStatus(Guid userId, Guid leaveApplicationId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@LeaveApplicationId", leaveApplicationId);
                vParams.Add("@LeaveStuatusSetByUserId", userId);
                return vConn.Query<string>("USP_GetStatus", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<LeaveCommentDbEntity> GetLeaveComments(Guid leaveApplicationId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@LeaveApplicationId", leaveApplicationId);
                return vConn.Query<LeaveCommentDbEntity>("usp_GetLeaveComments", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<LeaveSessionsInputModel> GetLeaveSessions(Guid companyId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@CompanyId", companyId);
                return vConn.Query<LeaveSessionsInputModel>("usp_GetLeaveSessions", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<LeaveStatusModel> GetLeaveStatus(Guid companyId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@CompanyId", companyId);
                return vConn.Query<LeaveStatusModel>("usp_GetLeaveStatus", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<LeaveTypeInputModel> GetLeaveTypes(Guid companyId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@CompanyId", companyId);
                return vConn.Query<LeaveTypeInputModel>("usp_GetLeaveTypes", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public Guid GetMaxApprovedDesignationId(Guid appliedDesignationId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@AppliedDesignationId", appliedDesignationId);
                return vConn.Query<Guid>("usp_GetMaxApprovedDesignationId", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
        public Guid GetMinApprovedDesignationId(Guid appliedDesignationId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@AppliedDesignationId", appliedDesignationId);
                return vConn.Query<Guid>("usp_GetMinApprovedDesignationId", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
        public List<Guid> GetApprovedDesignationIds(Guid appliedDesignationId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@AppliedDesignationId", appliedDesignationId);
                return vConn.Query<Guid>("usp_GetApprovedDesignationIds", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public decimal GetLeaveCount(Guid userId, string type, Guid companyId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@userId", userId);
                vParams.Add("@Type", type);
                vParams.Add("@CompanyId", companyId);
                return vConn.Query<decimal>("USP_GetOriginalLeavesCount", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<LeaveApplicabilitySearchOutputModel> GetLeaveApplicability(Guid? leaveTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeavetypeId", leaveTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeaveApplicabilitySearchOutputModel>(StoredProcedureConstants.SpGetLeaveApplicability, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveApplicability", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveSearch);

                return new List<LeaveApplicabilitySearchOutputModel>();
            }
        }

        public List<LeaveOverViewReportGetOutputModel> GetLeaveOverViewRepport(LeaveOverViewReportGetInputModel leaveOverViewReportGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BranchId", leaveOverViewReportGetInputModel.BranchId);
                    vParams.Add("@UserId", leaveOverViewReportGetInputModel.UserId);
                    vParams.Add("@LeaveApplicationId", leaveOverViewReportGetInputModel.LeaveApplicationId);
                    vParams.Add("@DateTo", leaveOverViewReportGetInputModel.DateTo);
                    vParams.Add("@DateFrom", leaveOverViewReportGetInputModel.DateFrom);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeaveOverViewReportGetOutputModel>(StoredProcedureConstants.SpGetLeaveOverviewReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveOverViewRepport", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveSearch);

                return new List<LeaveOverViewReportGetOutputModel>();
            }
        }

        public CompanyOverViewLeaveReportOutputModel GetCompanyOverViewLeaveReport(CompanyOverViewLeaveReportInputModel companyOverViewLeaveReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BranchId", companyOverViewLeaveReportInputModel.BranchId);
                    vParams.Add("@DateTo", companyOverViewLeaveReportInputModel.DateTo);
                    vParams.Add("@DateFrom", companyOverViewLeaveReportInputModel.DateFrom);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompanyOverViewLeaveReportOutputModel>(StoredProcedureConstants.SpGetCompanyOverViewLeaveReport, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyOverViewLeaveReport", "LeaveApplicationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveSearch);

                return new CompanyOverViewLeaveReportOutputModel();
            }
        }
    }
}