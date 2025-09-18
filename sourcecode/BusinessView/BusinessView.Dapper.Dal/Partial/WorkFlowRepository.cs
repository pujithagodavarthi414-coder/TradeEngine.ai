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
using Btrak.Models.GenericForm;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class WorkFlowRepository
    {
        public Guid? UpsertWorkFlow(WorkFlowUpsertInputModel workFlowUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkflowId", workFlowUpsertInputModel.WorkFlowId);
                    vParams.Add("@WorkFlowName", workFlowUpsertInputModel.WorkFlowName);
                    vParams.Add("@IsArchived", workFlowUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", workFlowUpsertInputModel.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertWorkflow, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlow", "WorkFlowRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWorkFlowUpsert);
                return null;
            }
        }


        public Guid? UpdateFieldValue(FieldUpdateModel fieldUpdateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages) 
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormId", fieldUpdateModel.FormId);
                    vParams.Add("@FieldName", fieldUpdateModel.FieldName);
                    vParams.Add("@FieldValue", fieldUpdateModel.FieldValue);
                    vParams.Add("@DataSetId", fieldUpdateModel.DataSetId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateFieldValue, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlow", "WorkFlowRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWorkFlowUpsert);
                return null;
            }
        }

        public Guid? UpsertChecklist(CheckListModel checkListModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ChecklistName", checkListModel.ChecklistName);
                    vParams.Add("@DisplayName", checkListModel.DisplayName);
                    vParams.Add("@TaskName", checkListModel.TaskName);
                    vParams.Add("@Description", checkListModel.Description);
                    vParams.Add("@TaskOwner", checkListModel.TaskOwner);
                    vParams.Add("@Priority", checkListModel.Priority);
                    vParams.Add("@DueDate", checkListModel.DueDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertChecklist, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkFlow", "WorkFlowRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionWorkFlowUpsert);
                return null;
            }
        }
        public List<WorkFlowApiReturnModel> GetAllWorkFlows(WorkFlowInputModel workFlowInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@WorkFlowId", workFlowInputModel.WorkFlowId);
                    vParams.Add("@Workflow", workFlowInputModel.WorkFlowName);
                    vParams.Add("@IsArchived", workFlowInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<WorkFlowApiReturnModel>(StoredProcedureConstants.SpGetWorkFlows, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllWorkFlows", "WorkFlowRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllWorkFlows);
                return new List<WorkFlowApiReturnModel>();
            }
        }
    }
}
