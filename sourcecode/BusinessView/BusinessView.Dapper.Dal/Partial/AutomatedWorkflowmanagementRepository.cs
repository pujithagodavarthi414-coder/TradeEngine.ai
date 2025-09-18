using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.WorkflowManagement;
using BTrak.Common;
using Dapper;
namespace Btrak.Dapper.Dal.Partial
{
    public class AutomatedWorkflowmanagementRepository : BaseRepository
    {
        public List<WorkFlowTriggerModel> GetTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TriggerId", workFlowTriggerModel.TriggerId);
                    vParams.Add("@TriggerName", workFlowTriggerModel.TriggerName);
                    vParams.Add("@IsArchived", workFlowTriggerModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WorkFlowTriggerModel>(StoredProcedureConstants.SpGetTriggers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTriggers", " AutomatedWorkflowmanagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }
        }

        public List<WorkFlowTriggerModel> GetWorkFlowTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TriggerId", workFlowTriggerModel.TriggerId);
                    vParams.Add("@WorkflowId", workFlowTriggerModel.WorkflowId);
                    vParams.Add("@ReferenceId", workFlowTriggerModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", workFlowTriggerModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WorkFlowTriggerModel>(StoredProcedureConstants.SpGetWorkflowTriggers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowTriggers", " AutomatedWorkflowmanagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }

        }

        public List<WorkFlowTriggerModel> GetWorkFlowTriggers(WorkFlowTriggerModel workFlowTriggerModel, Guid? CompanyId, Guid UserId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TriggerId", workFlowTriggerModel.TriggerId);
                    vParams.Add("@WorkflowId", workFlowTriggerModel.WorkflowId);
                    vParams.Add("@ReferenceId", workFlowTriggerModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", workFlowTriggerModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", UserId);
                    vParams.Add("@CompanyIdForWorkflow", CompanyId);
                    return vConn.Query<WorkFlowTriggerModel>(StoredProcedureConstants.SpGetWorkflowTriggers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkFlowTriggers", " AutomatedWorkflowmanagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }

        }

        public List<WorkFlowTriggerModel> GetWorkflowsForTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkflowId", workFlowTriggerModel.WorkflowId);
                    vParams.Add("@WorkflowName", workFlowTriggerModel.WorkflowName);
                    vParams.Add("@IsArchived", workFlowTriggerModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WorkFlowTriggerModel>(StoredProcedureConstants.SpGetWorkflowsForTriggers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkflowsForTriggers", " AutomatedWorkflowmanagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }

        }

        public Guid? UpsertWorkflowTrigger(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkFlowId", workFlowTriggerModel.WorkflowId);
                    vParams.Add("@WorkFlowTypeId", workFlowTriggerModel.WorkFlowTypeId);
                    vParams.Add("@WorkflowName", workFlowTriggerModel.WorkflowName);
                    vParams.Add("@WorkflowXml", workFlowTriggerModel.WorkflowXml);
                    vParams.Add("@WorkflowTriggerId", workFlowTriggerModel.WorkflowTriggerId);
                    vParams.Add("@TriggerId", workFlowTriggerModel.TriggerId);
                    vParams.Add("@ReferenceId", workFlowTriggerModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", workFlowTriggerModel.ReferenceTypeId);
                    vParams.Add("@IsArchived", workFlowTriggerModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAutomatedWorkflow, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkflowTrigger", " AutomatedWorkflowmanagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }
        }

        public Guid? UpsertGenericStatus(GenericStatusModel workFlowStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkFlowId", workFlowStatusModel.WorkFlowId);
                    vParams.Add("@GenericStatusId", workFlowStatusModel.GenericStatusId);
                    vParams.Add("@Status", workFlowStatusModel.Status);
                    vParams.Add("@ReferenceId", workFlowStatusModel.ReferenceId);
                    vParams.Add("@StatusColor", workFlowStatusModel.StatusColor);
                    vParams.Add("@ReferenceTypeId", workFlowStatusModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGenericStatusReference, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Upsert Generic Status", "AutomatedWorkflowmanagement Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }
        }

        public List<GenericStatusModel> GetGenericStatus(GenericStatusModel workFlowStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkFlowId", workFlowStatusModel.WorkFlowId);
                    vParams.Add("@GenericStatusId", workFlowStatusModel.GenericStatusId);
                    vParams.Add("@ReferenceId", workFlowStatusModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", workFlowStatusModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GenericStatusModel>(StoredProcedureConstants.SpGetGenericStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Generic Status", "AutomatedWorkflowmanagement Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }
        }

        public Guid? UpsertDefaultWorkFlow(DefaultWorkflowModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AuditDefaultWorkflowId", model.AuditDefaultWorkflowId);
                    vParams.Add("@ConductDefaultWorkflowId", model.ConductDefaultWorkflowId);
                    vParams.Add("@QuestionDefaultWorkflowId", model.QuestionDefaultWorkflowId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDefaultWorkflow, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDeafultWorkFlow", "AutomatedWorkflowmanagement Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }
        }

        public List<DefaultWorkflowModel> GetDefaultWorkFlows(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DefaultWorkflowModel>(StoredProcedureConstants.SpGetDefaultWorkflows, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDefaultWorkFlows", "AutomatedWorkflowmanagement Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWorkflowTriggers);
                return null;
            }
        }
    }
}
