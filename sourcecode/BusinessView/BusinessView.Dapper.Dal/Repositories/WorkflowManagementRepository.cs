using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using BTrak.Common;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.WorkflowManagement;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class WorkflowManagementRepository : BaseRepository
    {
        public List<WorkFlowTriggerModel> GetWorkflowTriggersByReferenceTypeId(Guid referenceTypeId,List<ValidationMessage> validationMessageses)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceTypeId", referenceTypeId);
                    return vConn.Query<List<WorkFlowTriggerModel>>(StoredProcedureConstants.SpGetWorkflowTriggersByRefereceTypeId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkflowTriggersByReferenceTypeId", "WorkflowManagementRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessageses, sqlException, ValidationMessages.ExceptionUserStoryUpsert);
                return null;
            }
        }

        public AutomatedWorkFlowModel GetWorkflowDetailsById(Guid workflowId, List<ValidationMessage> validationMessageses)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkflowId", workflowId);
                    return vConn.Query<AutomatedWorkFlowModel>(StoredProcedureConstants.SpGetWorkFlowDetailsById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkflowDetailsById", "WorkflowManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessageses, sqlException, ValidationMessages.ExceptionUserStoryUpsert);
                return null;
            }
        }

        public List<AutomatedWorkFlowModel> GetWorkFlowByTriggerNameAndReferenceId(string triggerName, Guid referenceId, Guid referenceTypeId, LoggedInContext loggedInContext)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", referenceId);
                    vParams.Add("@TriggerName", triggerName);
                    vParams.Add("@ReferenceTypeId", referenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AutomatedWorkFlowModel>(StoredProcedureConstants.SpGetWorkflowDetailsByTriggerNameAndReferenceId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowByTriggerNameAndReferenceId", "WorkflowManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(new List<ValidationMessage>(), sqlException, ValidationMessages.ExceptionUserStoryUpsert);
                return null;
            }
        }
    }
}