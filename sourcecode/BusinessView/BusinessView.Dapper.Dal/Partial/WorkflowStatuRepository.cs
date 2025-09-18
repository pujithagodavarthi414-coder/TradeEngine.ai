using Dapper;
using Btrak.Models.WorkFlow;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class WorkflowStatuRepository
    {
        public Guid? UpsertWorkFlowStatus(WorkFlowStatusUpsertInputModel workFlowStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WorkflowStatusId", workFlowStatusUpsertInputModel.WorkFlowStatusId);
                    vParams.Add("@WorkFlowId", workFlowStatusUpsertInputModel.WorkFlowId);
                    vParams.Add("@UserStoryStatusIds", workFlowStatusUpsertInputModel.StatusIdXml);
                    vParams.Add("@OrderId", workFlowStatusUpsertInputModel.OrderId);
                    vParams.Add("@CanAdd", workFlowStatusUpsertInputModel.CanAdd);
                    vParams.Add("@CanDelete", workFlowStatusUpsertInputModel.CanDelete);
                    vParams.Add("@IsCompleted", workFlowStatusUpsertInputModel.IsCompleted);
                    vParams.Add("@IsArchived", workFlowStatusUpsertInputModel.IsArchived);
                    vParams.Add("@TimeZone", workFlowStatusUpsertInputModel.TimeZone);
                    vParams.Add("@IsBlocked", workFlowStatusUpsertInputModel.IsBlocked);
                    vParams.Add("@TimeStamp", workFlowStatusUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWorkflowStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlowStatus", "WorkflowStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWorkFlowStatusUpsert);
                return null;
            }
        }

        public List<WorkFlowStatusApiReturnModel> GetAllWorkFlowStatus(WorkFlowStatusInputModel workFlowStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WorkflowStatusId", workFlowStatusInputModel.WorkFlowStatusId);
                    vParams.Add("@WorkflowId", workFlowStatusInputModel.WorkFlowId);
                    vParams.Add("@UserStoryStatusId", workFlowStatusInputModel.UserStoryStatusId);
                    vParams.Add("@OrderId", workFlowStatusInputModel.OrderId);
                    vParams.Add("@IsCompleted", workFlowStatusInputModel.IsCompleted);
                    vParams.Add("@IsArchived", workFlowStatusInputModel.IsArchived); //TODO: Needs fixing this
                    vParams.Add("@IsBlocked", workFlowStatusInputModel.IsBlocked);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WorkFlowStatusApiReturnModel>(StoredProcedureConstants.SpGetWorkflowStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllWorkFlowStatus", "WorkflowStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllWorkFlowStatuses);
                return new List<WorkFlowStatusApiReturnModel>();
            }
        }

        public Guid? UpsertWorkFlowStatusInActive(WorkFlowStatusUpsertInputModel workFlowStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();

                    vParams.Add("@WorkflowId", workFlowStatusInputModel.WorkFlowId);
                    vParams.Add("@ExistedUserStoryStatusId", workFlowStatusInputModel.ExistingUserStoryStatusId);
                    vParams.Add("@CurrentUserStoryStatusId", workFlowStatusInputModel.CurrentUserStoryStatusId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateWorkflowStatusToInActive, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlowStatusInActive", "WorkflowStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertWorkFlowStatusInActive);
                return null;
            }
        }
    }
}
