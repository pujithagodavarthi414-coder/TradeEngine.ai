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
using Btrak.Models.Widgets;
using Btrak.Models.CustomApplication;
using Btrak.Models.WorkFlow;

namespace Btrak.Dapper.Dal.Partial
{
    public class GenericFormRepository : BaseRepository
    {
        public Guid? Insert(GenericFormUpsertInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenericFormId", genericFormModel.Id);
                    vParams.Add("@FormTypeId", genericFormModel.FormTypeId);
                    vParams.Add("@DataSourceId", genericFormModel.DataSourceId);
                    vParams.Add("@FormName", genericFormModel.FormName);
                    vParams.Add("@WorkflowTrigger", genericFormModel.WorkflowTrigger);
                    vParams.Add("@FormJson", genericFormModel.FormJson);
                    vParams.Add("@CompanyModuleId", genericFormModel.CompanyModuleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", genericFormModel.IsArchived);
                    vParams.Add("@FormKeys",genericFormModel.FormKeys);
                    vParams.Add("@TimeStamp", genericFormModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsAbleToLogin", genericFormModel.IsAbleToLogin);
                    vParams.Add("@IsAbleToComment", genericFormModel.IsAbleToComment);
                    vParams.Add("@IsAbleToPay", genericFormModel.IsAbleToPay);
                    vParams.Add("@IsAbleToCall", genericFormModel.IsAbleToCall);
                    vParams.Add("@RoleForCall", genericFormModel.RoleForCall == null ? null : String.Join(",", genericFormModel.RoleForCall));
                    vParams.Add("@RoleForComment", genericFormModel.RoleForComment == null ? null : String.Join(",", genericFormModel.RoleForComment));
                    vParams.Add("@RoleForPay", genericFormModel.RoleForPay == null ? null : String.Join(",", genericFormModel.RoleForPay));
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGenericForm, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Insert", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormInsert);
                return null;
            }
        }

        public Guid? UpsertWorkflow(FormWorkflowModel formWorkflowModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormTypeId", formWorkflowModel.FormTypeId);
                    vParams.Add("@WorkflowName", formWorkflowModel.WorkflowName);
                    //vParams.Add("@FormJson", genericFormSubmittedUpsertInputModel.FormJson);
                    //vParams.Add("@FormId", genericFormSubmittedUpsertInputModel.FormId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    //vParams.Add("@IsArchived", genericFormSubmittedUpsertInputModel.IsArchived);
                    //vParams.Add("@TimeStamp", genericFormSubmittedUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFormWorkflow, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericFormSubmitted", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return new Guid();
            }
        }

        public Guid? UpsertWorkflowCronExpression(WorkflowCronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CronExpression", cronExpressionInputModel.CronExpression);
                    vParams.Add("@IsArchived", cronExpressionInputModel.IsArchived);
                    vParams.Add("@WorkflowId", cronExpressionInputModel.WorkflowId); 
                    vParams.Add("@ResponsibleUserId", cronExpressionInputModel.ResponsibleUserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.WorkflowUpsertCronExpression, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCronExpression", "WidgetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCronExpression);
                return null;
            }
        }

        public List<GenericFormApiReturnModel> GetForms(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GenericFormApiReturnModel>(StoredProcedureConstants.SpGetForms, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return new List<GenericFormApiReturnModel>();
            }
        }

        public List<dynamic> GetFormRecordValues(GetFormRecordValuesInputModel getFormRecordValues, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", getFormRecordValues.CustomApplicationId);
                    vParams.Add("@FormId", getFormRecordValues.FormId);
                    vParams.Add("@CustomApplicationName", getFormRecordValues.CustomApplicationName);
                    vParams.Add("@FormName", getFormRecordValues.FormName);
                    vParams.Add("@KeyName", getFormRecordValues.KeyName);
                    vParams.Add("@KeyValue", getFormRecordValues.KeyValue);
                    vParams.Add("@FieldNames", getFormRecordValues.FieldsXML);
                    vParams.Add("@FormIdsXml", getFormRecordValues.FormIdsXML);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<dynamic>(StoredProcedureConstants.SpGetFormRecordValues, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormRecordValues", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormFieldData);
                return null;
            }
        }


        public List<FormFieldModel> GetFormsFields(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
      {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@FormId", genericFormModel.Id);
                    return vConn.Query<FormFieldModel>(StoredProcedureConstants.SpGetFormFields, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return new List<FormFieldModel>();
            }
        }


        public List<FormFieldModel> GetFormsFields(FormfieldWorkFlowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@FormId", genericFormModel.Id);
                    vParams.Add("@FormIdsXml", genericFormModel.FormIdsXml);
                    return vConn.Query<FormFieldModel>(StoredProcedureConstants.SpGetFormFields, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return new List<FormFieldModel>();
            }
        }

        public List<GenericFormApiReturnModel> Get(GenericFormSearchCriteriaInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenericFormId", genericFormModel.Id);
                    vParams.Add("@FormName", genericFormModel.FormName);
                    vParams.Add("@CompanyModuleId", genericFormModel.CompanyModuleId);
                    vParams.Add("@FormTypeId", genericFormModel.FormTypeId);
                    vParams.Add("@SearchText", genericFormModel.SearchText);
                    vParams.Add("@FormIdsXml", genericFormModel.FormIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", genericFormModel.IsArchived);
                    vParams.Add("@Pagesize", genericFormModel.Pagesize);
                    vParams.Add("@Pagenumber", genericFormModel.Pagenumber);
                    return vConn.Query<GenericFormApiReturnModel>(StoredProcedureConstants.SpGetGenericForms, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return new List<GenericFormApiReturnModel>();
            }
        }

        public List<GenericFormSubmittedUpsertInputModel> GetGenericFormRecords(Guid? formId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages) {

            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormId", formId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", false);
                   return vConn.Query<GenericFormSubmittedUpsertInputModel>(StoredProcedureConstants.SpGetGenericFormRecords, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericFormSubmitted", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return new List<GenericFormSubmittedUpsertInputModel>();
            }
        }

        public Guid? UpsertGenericFormSubmitted(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenericFormSubmittedId", genericFormSubmittedUpsertInputModel.GenericFormSubmittedId);
                    vParams.Add("@CustomApplicationId", genericFormSubmittedUpsertInputModel.CustomApplicationId);
                    vParams.Add("@DataSetId", genericFormSubmittedUpsertInputModel.DataSetId);
                    vParams.Add("@DataSourceId", genericFormSubmittedUpsertInputModel.DataSourceId);
                    vParams.Add("@FormJson", genericFormSubmittedUpsertInputModel.FormJson);
                    vParams.Add("@FormId", genericFormSubmittedUpsertInputModel.FormId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", genericFormSubmittedUpsertInputModel.IsArchived);
                    vParams.Add("@IsApproved", genericFormSubmittedUpsertInputModel.IsApproved);
                    vParams.Add("@TimeStamp", genericFormSubmittedUpsertInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGenericFormSubmitted, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericFormSubmitted", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return new Guid();
            }
        }

        public string UpsertPublicGenericFormSubmitted(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenericFormSubmittedId", genericFormSubmittedUpsertInputModel.GenericFormSubmittedId);
                    vParams.Add("@CustomApplicationId", genericFormSubmittedUpsertInputModel.CustomApplicationId);
                    vParams.Add("@FormId", genericFormSubmittedUpsertInputModel.FormId);
                    vParams.Add("@FormJson", genericFormSubmittedUpsertInputModel.FormJson);
                    vParams.Add("@IsArchived", genericFormSubmittedUpsertInputModel.IsArchived);
                    vParams.Add("@IsFinalSubmit", genericFormSubmittedUpsertInputModel.IsFinalSubmit);
                    vParams.Add("@PublicFormId", genericFormSubmittedUpsertInputModel.PublicFormId);
                    vParams.Add("@IsFinalSubmit", genericFormSubmittedUpsertInputModel.IsFinalSubmit);
                    if(genericFormSubmittedUpsertInputModel.IsFinalSubmit.Value == true)
                    {
                        return vConn.Query<string>(StoredProcedureConstants.SpUpsertGenericFormSubmitted, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    } else
                    {
                        var result =  vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGenericFormSubmitted, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                        return result.ToString();
                    }
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPublicGenericFormSubmitted", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return null;
            }
        }

        public List<string> GetFormFieldValues(GenericFormSubmittedSearchInputModel searchInputModel , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", searchInputModel.CustomApplicationId);
                    vParams.Add("@FormId", searchInputModel.FormId);
                    vParams.Add("@CustomApplicationName", searchInputModel.CustomApplicationName);
                    vParams.Add("@FormName", searchInputModel.FormName);
                    vParams.Add("@KeyName", searchInputModel.Key);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<string>(StoredProcedureConstants.SpGetFormFieldValues, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormFieldData);
                return null;
            }
        }

        public List<GenericFormApiReturnModel> GetFormsWithField(GetFormRecordValuesInputModel getFormRecord, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@KeyName", getFormRecord?.KeyName);
                    vParams.Add("@FormId", getFormRecord?.FormId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GenericFormApiReturnModel>(StoredProcedureConstants.SpGetFormsWithField, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormsWithField", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormFieldData);
                return null;
            }
        }

        public List<GenericFormApiReturnModel> GetGenericFormsByTypeId(Guid formTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormTypeId", formTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GenericFormApiReturnModel>(StoredProcedureConstants.SpGetGenericFormsByTypeId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFormsByTypeId", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGenericFormsByTypeId);
                return new List<GenericFormApiReturnModel>();
            }
        }


        public Guid? UpsertGenericFormKey(GenericFormKeyUpsertInputModel genericFormKeyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenericFormId", genericFormKeyUpsertInputModel.GenericFormId);
                    vParams.Add("@Key", genericFormKeyUpsertInputModel.Key);
                    vParams.Add("@GenericFormKeyId", genericFormKeyUpsertInputModel.GenericFormKeyId);
                    vParams.Add("@IsDefault", genericFormKeyUpsertInputModel.IsDefault);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", genericFormKeyUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", genericFormKeyUpsertInputModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGenericFormKey, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericFormKey", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormInsert);
                return null;
            }
        }

        public Guid? UpsertFormWorkflow(FormWorkflowInputModel formWorkflowInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormTypeId", formWorkflowInputModel.FormTypeId);


                    vParams.Add("@WorkflowName", formWorkflowInputModel.WorkflowName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFormWorkflow, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericFormKey", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormInsert);
                return null;
            }
        }

        public List<FormTypeApiReturnModel> GetFormTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FormTypeApiReturnModel>(StoredProcedureConstants.SpGetFormTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormTypes", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormTypes);
                return new List<FormTypeApiReturnModel>();
            }
        }

        public List<GenericFormKeySearchOutputModel> GetGenericFormKey(GenericFormKeySearchInputModel genericFormKeySearchInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Key", genericFormKeySearchInputModel.Key);
                    vParams.Add("@GenericFormId", genericFormKeySearchInputModel.GenericFormId);
                    vParams.Add("@GenericFormKeyId", genericFormKeySearchInputModel.GenericId);
                    vParams.Add("@IsArchived", genericFormKeySearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GenericFormKeySearchOutputModel>(StoredProcedureConstants.SpGetGenericFormKeys, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFormKey", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormTypes);
                return new List<GenericFormKeySearchOutputModel>();
            }
        }
        public List<GenericFormKeySearchOutputModel> GetEmployeeGenericFormKey(GenericFormKeySearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Key", genericFormKeySearchInputModel.Key);
                    vParams.Add("@GenericFormId", genericFormKeySearchInputModel.GenericFormId);
                    vParams.Add("@GenericFormKeyId", genericFormKeySearchInputModel.GenericId);
                    vParams.Add("@IsArchived", genericFormKeySearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GenericFormKeySearchOutputModel>(StoredProcedureConstants.SpGetEmployeeGenericFormKeys, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeGenericFormKey", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormTypes);
                return new List<GenericFormKeySearchOutputModel>();
            }
        }

        public List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmitted(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", genericFormKeySearchInputModel.CustomApplicationId);
                    vParams.Add("@UserId", genericFormKeySearchInputModel.UserId);
                    vParams.Add("@FormId", genericFormKeySearchInputModel.FormId);
                    vParams.Add("@GenericFormSubmittedId", genericFormKeySearchInputModel.GenericFormSubmittedId);
                    vParams.Add("@IsArchived", genericFormKeySearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@KeyName", genericFormKeySearchInputModel.Key);
                    vParams.Add("@QuerytoFilter", genericFormKeySearchInputModel.QuerytoFilter);
                    vParams.Add("@IsPagingRequired", genericFormKeySearchInputModel.IsPagingRequired);
                    vParams.Add("@PageSize", genericFormKeySearchInputModel.PageSize);
                    vParams.Add("@PageNumber", genericFormKeySearchInputModel.PageNumber);
                    return vConn.Query<GenericFormSubmittedSearchOutputModel>(StoredProcedureConstants.SpGetGenericFormSubmitted, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFormSubmitted", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormTypes);
                return new List<GenericFormSubmittedSearchOutputModel>();
            }
        }

        public List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmittedDataByKeyName(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel,List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", genericFormKeySearchInputModel.CustomApplicationId);
                    vParams.Add("@UserId", genericFormKeySearchInputModel.UserId);
                    vParams.Add("@FormId", genericFormKeySearchInputModel.FormId);
                    vParams.Add("@GenericFormSubmittedId", genericFormKeySearchInputModel.GenericFormSubmittedId);
                    vParams.Add("@IsArchived", genericFormKeySearchInputModel.IsArchived);
                    vParams.Add("@KeyName", genericFormKeySearchInputModel.Key);
                    vParams.Add("@IsLatest", genericFormKeySearchInputModel.IsLatest);
                    vParams.Add("@CustomApplicationName", genericFormKeySearchInputModel.CustomApplicationName);
                    vParams.Add("@FormName", genericFormKeySearchInputModel.FormName);
                    return vConn.Query<GenericFormSubmittedSearchOutputModel>(StoredProcedureConstants.SpGetGenericFormSubmittedByKeyName, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFormSubmittedDataByKeyName", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFormTypes);
                return new List<GenericFormSubmittedSearchOutputModel>();
            }
        }


        public int CheckFormType(Guid? applicationId)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CustomApplicationId", applicationId);
                   
                    return vConn.Query<int>(StoredProcedureConstants.SpCheckFormType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckFormType", "GenericFormRepository", sqlException));

                return new int();
            }
        }

        public List<GetCustomeApplicationTagOutputModel> GetCustomApplicationTag(GetCustomApplicationTagInpuModel getCustomApplicationTagInpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@customApplicationTagId", getCustomApplicationTagInpuModel.CustomApplicationTagId);
                    vParams.Add("@searchTagText", getCustomApplicationTagInpuModel.SearchTagText);
                    vParams.Add("@GenericFormKeyId", getCustomApplicationTagInpuModel.GenericFormKeyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetCustomeApplicationTagOutputModel>(StoredProcedureConstants.SpGetCustomApplicationTag, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationTag", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationTag);
                return new List<GetCustomeApplicationTagOutputModel>();
            }
        }

        public Guid? UpsertCustomApplicationTag(CustomApplicationTagInputModel getCustomApplicationTagInpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", getCustomApplicationTagInpuModel.Id);
                    vParams.Add("@GenericFormSubmittedId", getCustomApplicationTagInpuModel.GenericFormSubmittedId);
                    vParams.Add("@CustomApplicationId", getCustomApplicationTagInpuModel.CustomApplicationId);
                    vParams.Add("@KeyValue", getCustomApplicationTagInpuModel.KeyValue);
                    vParams.Add("@GenericFormKeyId", getCustomApplicationTagInpuModel.GenericFormKeyId);
                    vParams.Add("@IsTag", getCustomApplicationTagInpuModel.IsTag);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomApplicationTag, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomApplicationTag", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationTag);
                return null;
            }
        }

        public List<FilterKeyValuePair> GetCustomApplicationTagKeys(GetCustomApplicationTagInpuModel getCustomApplicationTagInpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GenericFormLabel", getCustomApplicationTagInpuModel.GenericFormLabel);
                    vParams.Add("@GenericFormKeyId", getCustomApplicationTagInpuModel.GenericFormKeyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FilterKeyValuePair>(StoredProcedureConstants.SpGetCustomApplicationTagKeys, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomApplicationTagKeys", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationTag);
                return new List<FilterKeyValuePair>();
            }
        }

        public List<ExcelSheetDetailsOutputModel> GetExcelSheetDetailsForProcessing(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExcelSheetDetailsOutputModel>(StoredProcedureConstants.SpGetExcelSheetDetailsForProcessing, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExcelSheetDetailsForProcessing", "GenericFormRepository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomApplicationTag);
                return new List<ExcelSheetDetailsOutputModel>();
            }
        }
        public List<GetTrendsOutputModel> GetTrends(GetTrendsInputModel getTrendsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TrendId", getTrendsInputModel.TrendId);
                    vParams.Add("@SearchTrendValue", getTrendsInputModel.SearchTrendValue);
                    vParams.Add("@UniqueNumber", getTrendsInputModel.UniqueNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetTrendsOutputModel>(StoredProcedureConstants.SpGetTrends, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrends", "GenericFormRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTrends);
                return new List<GetTrendsOutputModel>();
            }
        }

        public void InsertFormHistory(string historyJson,Guid? genericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@HistoryXml", historyJson);
                    vParams.Add("@GenericFormSubmittedId", genericFormSubmittedId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query(StoredProcedureConstants.SpInsertFormHistory, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertFormHistory", "GenericFormRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
            }
        }
        public List<Btrak.Models.Employee.UserListApiOutputModel> GetUsersBasedonRole(string roles, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RoleIds", roles);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Btrak.Models.Employee.UserListApiOutputModel>(StoredProcedureConstants.SpGetUsersByRoleId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesByRoleId", "EmployeeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAnnouncements);
                return null;
            }
        }

        public Guid? UpsertActivity(ActivityModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Id", model.Id);
                    vParams.Add("@ActivityName", model.ActivityName);
                    vParams.Add("@Description", model.Description);
                    vParams.Add("@Inputs", model.Inputs);
                    vParams.Add("@IsArchived", model.IsArchive);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertActivity, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivity", "GenericFormRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, sqlException.Message);
                return null;
            }
        }

        public List<ActivityModel> GetActivity(ActivityModel auditImpactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", auditImpactModel.IsArchive);
                    return vConn.Query<ActivityModel>(StoredProcedureConstants.SpGetActivity, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivity", "GenericFormRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, sqlException.Message);

                return new List<ActivityModel>();
            }
        }

    }
}
