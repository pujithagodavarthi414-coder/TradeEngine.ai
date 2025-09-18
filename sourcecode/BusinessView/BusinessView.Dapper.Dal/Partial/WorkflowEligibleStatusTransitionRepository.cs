using Btrak.Models.WorkFlow;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class WorkflowEligibleStatusTransitionRepository 
    {
        public Guid? UpsertWorkFlowEligibleStatusTransition(WorkFlowEligibleStatusTransitionUpsertInputModel workFlowEligibleStatusTransitionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WorkflowEligibleStatusTransitionId", workFlowEligibleStatusTransitionUpsertInputModel.WorkflowEligibleStatusTransitionId);
                    vParams.Add("@FromWorkflowUserStoryStatusId", workFlowEligibleStatusTransitionUpsertInputModel.FromWorkflowUserStoryStatusId);
                    vParams.Add("@ToWorkflowUserStoryStatusId", workFlowEligibleStatusTransitionUpsertInputModel.ToWorkflowUserStoryStatusId);
                    //vParams.Add("@TransitionDeadlineId", workFlowEligibleStatusTransitionUpsertInputModel.TransitionDeadlineId);
                    //vParams.Add("@DisplayName", workFlowEligibleStatusTransitionUpsertInputModel.DisplayName);
                    vParams.Add("@WorkflowId", workFlowEligibleStatusTransitionUpsertInputModel.WorkFlowId);
                    vParams.Add("@RoleGuids", workFlowEligibleStatusTransitionUpsertInputModel.RoleIdXml);
                    vParams.Add("@TimeStamp", workFlowEligibleStatusTransitionUpsertInputModel.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWorkflowEligibleStatusTransition, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlowEligibleStatusTransition", "WorkflowEligibleStatusTransitionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWorkFlowEligibleStatusTransitionUpsert);
                return null;
            }
        }

        public Guid? UpdateWorkFlowEligibleStatusTransitionInActive(WorkFlowEligibleStatusTransitionUpsertInputModel workFlowEligibleStatusTransitionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WorkflowEligibleStatusTransitionId", workFlowEligibleStatusTransitionUpsertInputModel.WorkflowEligibleStatusTransitionId);
                    vParams.Add("@WorkflowId", workFlowEligibleStatusTransitionUpsertInputModel.WorkFlowId);
                    vParams.Add("@FromWorkflowUserStoryStatusId", workFlowEligibleStatusTransitionUpsertInputModel.FromWorkflowUserStoryStatusId);
                    vParams.Add("@ToWorkflowUserStoryStatusId", workFlowEligibleStatusTransitionUpsertInputModel.ToWorkflowUserStoryStatusId);
                    vParams.Add("@IsArchived", workFlowEligibleStatusTransitionUpsertInputModel.IsArchived); //TODO: Needs fixing this
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", workFlowEligibleStatusTransitionUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@RoleGuids", null);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWorkflowEligibleStatusTransition, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateWorkFlowEligibleStatusTransitionInActive", "WorkflowEligibleStatusTransitionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateWorkFlowEligibleStatusTransitionInActive);
                return null;
            }
        }

        public List<WorkFlowEligibleStatusTransitionApiReturnModel> GetWorkFlowEligibleStatusTransitions(WorkFlowEligibleStatusTransitionInputModel workFlowEligibleStatusTransitionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@WorkflowEligibleStatusTransitionId", workFlowEligibleStatusTransitionInputModel.WorkflowEligibleStatusTransitionId);
                    vParams.Add("@FromWorkflowUserStoryStatusId", workFlowEligibleStatusTransitionInputModel.FromWorkflowUserStoryStatusId);
                    vParams.Add("@ToWorkflowUserStoryStatusId", workFlowEligibleStatusTransitionInputModel.ToWorkflowUserStoryStatusId);
                    vParams.Add("@WorkflowId", workFlowEligibleStatusTransitionInputModel.WorkFlowId);
                    vParams.Add("@GoalId", workFlowEligibleStatusTransitionInputModel.GoalId);
                    vParams.Add("@SprintId", workFlowEligibleStatusTransitionInputModel.SprintId);
                    vParams.Add("@DisplayName", workFlowEligibleStatusTransitionInputModel.DisplayName);
                    vParams.Add("@ProjectId", workFlowEligibleStatusTransitionInputModel.ProjectId);
                    vParams.Add("@UserId", workFlowEligibleStatusTransitionInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WorkFlowEligibleStatusTransitionApiReturnModel>(StoredProcedureConstants.SpGetWorkflowEligibleStatusTransitions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowEligibleStatusTransitions", "WorkflowEligibleStatusTransitionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllWorkFlowEligibleStatusTransition);
                return new List<WorkFlowEligibleStatusTransitionApiReturnModel>();
            }
        }
    }
}
