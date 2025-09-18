using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.FormTypes;
using Btrak.Models.GenericForm;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;
using Btrak.Models.CustomApplication;
using Newtonsoft.Json;

namespace Btrak.Dapper.Dal.Partial
{
    public class CustomApplicationRepository : BaseRepository
    {
        public Guid? UpsertCustomApplication(CustomApplicationUpsertInputModel customApplicationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                string ConditionsJson = customApplicationUpsertInputModel.Conditions == null ? null :JsonConvert.SerializeObject(customApplicationUpsertInputModel.Conditions);
                string StageScenariosJson = customApplicationUpsertInputModel.StagesScenarios == null ? null :JsonConvert.SerializeObject(customApplicationUpsertInputModel.StagesScenarios);
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", customApplicationUpsertInputModel.CustomApplicationId);
                    vParams.Add("@CustomApplicationName", customApplicationUpsertInputModel.CustomApplicationName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vParams.Add("@IsArchived", customApplicationUpsertInputModel.IsArchived);
                    vParams.Add("@RoleIds", customApplicationUpsertInputModel.RoleIds);
                    vParams.Add("@GenericFormId", customApplicationUpsertInputModel.FormId);
                    vParams.Add("@SelectedKeyIds", customApplicationUpsertInputModel.SelectedKeyIds);
                    vParams.Add("@SelectedPrivateKeyIds", customApplicationUpsertInputModel.SelectedPrivateKeyIds);
                    vParams.Add("@SelectedEnableTrendsKeyIds", customApplicationUpsertInputModel.SelectedEnableTrendsKeys);
                    vParams.Add("@SelectedTagKeyIds", customApplicationUpsertInputModel.SelectedTagKeyIds);
                    vParams.Add("@SelectedFormsXml", customApplicationUpsertInputModel.SelectedFormsXml);
                    vParams.Add("@ModuleIds", customApplicationUpsertInputModel.ModuleIds);
                    vParams.Add("@DomainName", customApplicationUpsertInputModel.DomainName);
                    vParams.Add("@PublicMessage", customApplicationUpsertInputModel.PublicMessage);
                    vParams.Add("@Description", customApplicationUpsertInputModel.Description);
                    vParams.Add("@TimeStamp", customApplicationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsPublished", customApplicationUpsertInputModel.IsPublished);
                    vParams.Add("@UsersXML", customApplicationUpsertInputModel.UsersXML);
                    vParams.Add("@IsApproveNeeded", customApplicationUpsertInputModel.IsApproveNeeded); 
                    vParams.Add("@IsPdfRequired", customApplicationUpsertInputModel.IsPdfRequired);
                    vParams.Add("@AllowAnnonymous", customApplicationUpsertInputModel.AllowAnnonymous);
                    vParams.Add("@IsRedirectToEmails", customApplicationUpsertInputModel.IsRedirectToEmails);
                    vParams.Add("@WorkflowIds", customApplicationUpsertInputModel.WorkflowIds);
                    vParams.Add("@ToRoleIds", customApplicationUpsertInputModel.ToRoleIds);
                    vParams.Add("@ToEmails", customApplicationUpsertInputModel.ToEmails);
                    vParams.Add("@Message", customApplicationUpsertInputModel.Message);
                    vParams.Add("@Subject", customApplicationUpsertInputModel.Subject);
                    vParams.Add("@IsRecordLevelPermissionEnabled", customApplicationUpsertInputModel.IsRecordLevelPermissionEnabled);
                    vParams.Add("@RecordLevelPermissionFieldName", customApplicationUpsertInputModel.RecordLevelPermissionFieldName);
                    vParams.Add("@ConditionalEnum", customApplicationUpsertInputModel.ConditionalEnum);
                    vParams.Add("@ConditionsJson", ConditionsJson);
                    vParams.Add("@StageScenariosJson", StageScenariosJson);
                    vParams.Add("@ApproveMessage", customApplicationUpsertInputModel.ApproveMessage);
                    vParams.Add("@ApproveSubject", customApplicationUpsertInputModel.ApproveSubject);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomApplication, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomApplication", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomApplication);
                return new Guid();
            }
        }

        public string GetCustomApplication(CustomApplicationSearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", customApplicationSearchInputModel.CustomApplicationId);
                    vParams.Add("@GenericFormId", customApplicationSearchInputModel.FormId);
                    vParams.Add("@GenericFormName", customApplicationSearchInputModel.FormName);
                    vParams.Add("@CustomApplicationName", customApplicationSearchInputModel.CustomApplicationName);
                    vParams.Add("@IsArchived", customApplicationSearchInputModel.IsArchived);
                    vParams.Add("@SearchText", customApplicationSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", customApplicationSearchInputModel.CompanyId);
                    vParams.Add("@PageSize", customApplicationSearchInputModel.PageSize);
                    vParams.Add("@PageNumber", customApplicationSearchInputModel.PageNumber);
                    var value = vConn.Query<string>(StoredProcedureConstants.SpGetCustomApplication, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    return value != null ? value.ToString() : "";
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplication", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplication);
                return null;
            }
        }

        public string GetCustomApplicationUnAuth(CustomApplicationSearchInputModel customApplicationSearchInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", customApplicationSearchInputModel.CustomApplicationId);
                    vParams.Add("@GenericFormId", customApplicationSearchInputModel.FormId);
                    vParams.Add("@GenericFormName", customApplicationSearchInputModel.FormName);
                    vParams.Add("@CustomApplicationName", customApplicationSearchInputModel.CustomApplicationName);
                    vParams.Add("@IsArchived", customApplicationSearchInputModel.IsArchived);
                    vParams.Add("@SearchText", customApplicationSearchInputModel.SearchText);
                    vParams.Add("@PageSize", customApplicationSearchInputModel.PageSize);
                    vParams.Add("@PageNumber", customApplicationSearchInputModel.PageNumber);
                    var value = vConn.Query<string>(StoredProcedureConstants.SpGetCustomApplicationUnAuth, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    return value != null ? value.ToString() : "";
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationUnAuth", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplication);
                return null;
            }
        }

        public CustomApplicationSearchOutputModel GetPublicCustomApplicationById(CustomApplicationSearchInputModel customApplication, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    //vParams.Add("@CustomApplicationId", customApplication.CustomApplicationId);
                    vParams.Add("@CustomApplicationName", customApplication.CustomApplicationName);
                    vParams.Add("@GenericFormName", customApplication.GenericFormName);
                    return vConn.Query<CustomApplicationSearchOutputModel>(StoredProcedureConstants.SpGetPublicCustomApplicationById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPublicCustomApplicationById", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplication);
                return null;
            }
        }

        public Guid? UpsertCustomApplicationKeys(CustomApplicationKeyUpsertInputModel customApplicationKeyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", customApplicationKeyUpsertInputModel.CustomApplicationId);
                    vParams.Add("@CustomApplicationName", customApplicationKeyUpsertInputModel.GenericFormKeyId);
                    vParams.Add("@TimeStamp", customApplicationKeyUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomApplicationKey, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomApplicationKeys", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomApplicationKeys);
                return new Guid();
            }
        }

        public List<CustomApplicationKeySearchOutputModel> GetCustomApplicationKeys(CustomApplicationKeySearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", customApplicationSearchInputModel.CustomApplicationId);
                    vParams.Add("@IsArchived", customApplicationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomApplicationKeySearchOutputModel>(StoredProcedureConstants.SpGetCustomApplicationKey, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationKeys", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationKeys);
                return new List<CustomApplicationKeySearchOutputModel>();
            }
        }

        public Guid? UpsertCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationWorkflowUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", customApplicationWorkflowUpsertInputModel.CustomApplicationId);
                    vParams.Add("@CustomApplicationFormId", customApplicationWorkflowUpsertInputModel.CustomApplicationFormId);
                    vParams.Add("@CustomApplicationWorkflowId", customApplicationWorkflowUpsertInputModel.CustomApplicationWorkflowId);
                    vParams.Add("@CustomApplicationWorkflowTypeId", customApplicationWorkflowUpsertInputModel.CustomApplicationWorkflowTypeId);
                    vParams.Add("@WorkflowXml", customApplicationWorkflowUpsertInputModel.WorkflowXml);
                    vParams.Add("@WorkflowName", customApplicationWorkflowUpsertInputModel.WorkflowName);
                    vParams.Add("@WorkflowTrigger", customApplicationWorkflowUpsertInputModel.WorkflowTrigger);
                    vParams.Add("@RuleJson", customApplicationWorkflowUpsertInputModel.RuleJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomApplicationWorkflow, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomApplicationWorkflow", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomApplicationKeys);
                return new Guid();
            }
        }

        public List<CustomApplicationWorkflowSearchOutputModel> GetCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", customApplicationSearchInputModel.CustomApplicationId);
                    vParams.Add("@CustomApplicationWorkflowId", customApplicationSearchInputModel.CustomApplicationWorkflowId);
                    vParams.Add("@WorkflowTrigger", customApplicationSearchInputModel.WorkflowTrigger);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomApplicationWorkflowSearchOutputModel>(StoredProcedureConstants.SpGetCustomApplicationWorkflow, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationWorkflow", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationKeys);
                return new List<CustomApplicationWorkflowSearchOutputModel>();
            }
        }

        public List<CustomApplicationWorkflowSearchOutputModel> GetCustomApplicationWorkflowByCustomApplicationNameAndWorkflowName(CustomApplicationWorkflowUpsertInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationName", customApplicationSearchInputModel.CustomApplicationName);
                    vParams.Add("@CustomApplicationWorkflowName", customApplicationSearchInputModel.WorkflowName);
                    vParams.Add("@CustomApplicationWorkflowTrigger", customApplicationSearchInputModel.WorkflowTrigger);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomApplicationWorkflowSearchOutputModel>(StoredProcedureConstants.SpGetCustomApplicationWorkflowByWorkflowName, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationWorkflowByCustomApplicationNameAndWorkflowName", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationKeys);
                return new List<CustomApplicationWorkflowSearchOutputModel>();
            }
        }

        public List<string> GetCustomApplicationValuesByKeys(Guid customApplicationId, string key, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomAPplicationId", customApplicationId);
                    vParams.Add("@Key", key);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetCustomAppValuesByKeys, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationKeys);
                return new List<string>();
            }
        }

        public List<CustomApplicationWorkflowTypeReturnModel> GetCustomApplicationWorkflowTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomApplicationWorkflowTypeReturnModel>(StoredProcedureConstants.SpGetCustomApplicationWorkflowTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationWorkflowTypes", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationKeys);
                return new List<CustomApplicationWorkflowTypeReturnModel>();
            }
        }

        public Guid? UpsertCustomFieldMapping(CustomFieldMappingInputModel fieldMappingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MappingId", fieldMappingInputModel.MappingId);
                    vParams.Add("@CustomApplicationId", fieldMappingInputModel.CustomApplicationId);
                    vParams.Add("@MappingName", fieldMappingInputModel.MappingName);
                    vParams.Add("@MappingJson", fieldMappingInputModel.MappingJson);
                    vParams.Add("@TimeStamp", fieldMappingInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomFieldMapping, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomFieldMapping", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomFieldMapping);
                return null;
            }
        }

        public List<CustomFieldMappingApiOutputModel> GetCustomFieldMapping(CustomFieldMappingInputModel fieldMappingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@MappingId", fieldMappingInputModel.MappingId);
                    vParams.Add("@MappingName", fieldMappingInputModel.MappingName);
                    vParams.Add("@CustomApplicationId", fieldMappingInputModel.CustomApplicationId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CustomFieldMappingApiOutputModel>(StoredProcedureConstants.SpGetCustomFieldMapping, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomFieldMapping", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomFieldMapping);
                return new List<CustomFieldMappingApiOutputModel>();
            }
        }
        public Guid? GetCustomFormIdByName(string formName, Guid companyId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormName", formName);
                    vParams.Add("@CompanyId", companyId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpGetCustomFormIdByName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomFormIdByName", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationKeys);
                return null;
            }
        }

        public Guid? UpsertObservationType(ObservationTypeModel observationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ObservationTypeId", observationTypeModel.ObservationTypeId);
                    vParams.Add("@ObservationTypeName", observationTypeModel.ObservationTypeName);
                    vParams.Add("@IsArchived", observationTypeModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", observationTypeModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertObservationType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertObservationType", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertObservationType);
                return null;
            }
        }

        public List<ObservationTypeModel> GetObservationType(ObservationTypeModel observationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ObservationTypeId", observationTypeModel.ObservationTypeId);
                    vParams.Add("@ObservationTypeName", observationTypeModel.ObservationTypeName);
                    vParams.Add("@IsArchived", observationTypeModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ObservationTypeModel>(StoredProcedureConstants.SpGetObservationType, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetObservationType", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetObservationType);
                return new List<ObservationTypeModel>();
            }
        }

        public List<FormHistoryModel> GetFormHistory(FormHistoryModel formHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenericFormSubmittedId", formHistoryModel.GenericFormSubmittedId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageSize", formHistoryModel.PageSize);
                    vParams.Add("@PageNumber", formHistoryModel.PageNumber);
                    vParams.Add("@SortBy", formHistoryModel.SortBy);
                    vParams.Add("@SortDirection", formHistoryModel.SortDirection);
                    return vConn.Query<FormHistoryModel>(StoredProcedureConstants.SpGetFormHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormHistory", "CustomApplicationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormHistory);
                return new List<FormHistoryModel>();
            }
        }

    }
}
