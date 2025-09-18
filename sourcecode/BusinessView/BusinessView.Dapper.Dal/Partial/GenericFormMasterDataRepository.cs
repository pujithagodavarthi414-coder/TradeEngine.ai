using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Models.Performance;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Partial
{
    public class GenericFormMasterDataRepository : BaseRepository
    {

        public Guid? UpsertGenericFormType(GenericFormTypeUpsertModel genericFormTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormTypeId", genericFormTypeUpsertModel.FormTypeId);
                    vParams.Add("@FormTypeName", genericFormTypeUpsertModel.FormTypeName);
                    vParams.Add("@IsArchived", genericFormTypeUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", genericFormTypeUpsertModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFormType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenericFormType", "GenericFormMasterDataRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericForm);
                return null;
            }
        }

        public List<GetGenericFormTypesOutputModel> GetGenericFormType(GetGenericFormTypesSearchCriteriaInputModel getFormTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@FormTypeId", getFormTypesSearchCriteriaInputModel.FormTypeId);
                    vParams.Add("@FormTypeName", getFormTypesSearchCriteriaInputModel.FormTypeName);
                    vParams.Add("@SearchText", getFormTypesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getFormTypesSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetGenericFormTypesOutputModel>(StoredProcedureConstants.SpGetFormTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFormType", "GenericFormMasterDataRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGenericFormType);
                return new List<GetGenericFormTypesOutputModel>();
            }
        }

        public List<GetGenericFormTypesOutputModel> GetGenericFormTypesAnonymous(GetGenericFormTypesSearchCriteriaInputModel getFormTypesSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@FormTypeId", getFormTypesSearchCriteriaInputModel.FormTypeId);
                    vParams.Add("@FormTypeName", getFormTypesSearchCriteriaInputModel.FormTypeName);
                    vParams.Add("@SearchText", getFormTypesSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getFormTypesSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<GetGenericFormTypesOutputModel>(StoredProcedureConstants.SpGetFormTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFormType", "GenericFormMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetGenericFormType);
                return new List<GetGenericFormTypesOutputModel>();
            }
        }

        public Guid? UpsertCustomFormSubmission(CustomFormSubmissionUpsertModel customFormSubmissionUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FormSubmissionId", customFormSubmissionUpsertModel.FormSubmissionId);
                    vParams.Add("@AssignedToUserId", customFormSubmissionUpsertModel.AssignedToUserId);
                    vParams.Add("@AssignedByUserId", customFormSubmissionUpsertModel.AssignedByUserId);
                    vParams.Add("@GenericFormId", customFormSubmissionUpsertModel.GenericFormId);
                    vParams.Add("@FormData", customFormSubmissionUpsertModel.FormData);
                    vParams.Add("@Status", customFormSubmissionUpsertModel.Status);
                    vParams.Add("@IsArchived", customFormSubmissionUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomFormSubmission, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomFormSubmission", "GenericFormMasterDataRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomFormSubmission);
                return null;
            }
        }

        public List<GetCustomFormSubmissionOutputModel> GetCustomFormSubmissions(CustomFormSubmissionSearchCriteriaInputModel customFormSubmissionSearchCriteria, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@FormSubmissionId", customFormSubmissionSearchCriteria.FormSubmissionId);
                    vParams.Add("@AssignedByYou", customFormSubmissionSearchCriteria.AssignedByYou);
                    vParams.Add("@PageNumber", customFormSubmissionSearchCriteria.PageNumber);
                    vParams.Add("@PageSize", customFormSubmissionSearchCriteria.PageSize);
                    vParams.Add("@SearchText", customFormSubmissionSearchCriteria.SearchText);
                    vParams.Add("@SortBy", customFormSubmissionSearchCriteria.SortBy);
                    vParams.Add("@SortDirection", customFormSubmissionSearchCriteria.SortDirection);
                    vParams.Add("@IsArchived", customFormSubmissionSearchCriteria.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetCustomFormSubmissionOutputModel>(StoredProcedureConstants.SpGetCustomFormSubmissions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomFormSubmissions", "GenericFormMasterDataRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCustomFormSubmissions);
                return new List<GetCustomFormSubmissionOutputModel>();
            }
        }


        public Guid? UpsertInductionConfiguration(InductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InductionId", inductionModel.InductionId);
                    vParams.Add("@InductionName", inductionModel.InductionName);
                    vParams.Add("@IsShow", inductionModel.IsShow);
                    vParams.Add("@IsArchived", inductionModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInductionConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInductionConfiguration", "GenericFormMasterDataRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertInductionConfiguration);
                return null;
            }
        }

        public List<InductionModel> GetInductionConfigurations(InductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try 
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<InductionModel>(StoredProcedureConstants.SpGetInductionConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInductionConfigurations", "GenericFormMasterDataRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInductionConfigurations);
                return new List<InductionModel>();
            }
        }

        public List<EmployeeInductionModel> GetEmployeeInductions(EmployeeInductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try 
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", inductionModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeInductionModel>(StoredProcedureConstants.SpGetEmployeeInductions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeInductions", "GenericFormMasterDataRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInductionConfigurations);
                return new List<EmployeeInductionModel>();
            }
        }


        //Exit functionality
        public Guid? UpsertExitConfiguration(ExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ExitId", exitModel.ExitId);
                    vParams.Add("@ExitName", exitModel.ExitName);
                    vParams.Add("@IsShow", exitModel.IsShow);
                    vParams.Add("@IsArchived", exitModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", exitModel.UserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertExitConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExitConfiguration", "GenericFormMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertExitConfiguration); 
                return null;
            }
        }

        public List<ExitModel> GetExitConfigurations(ExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", exitModel.UserId);
                    return vConn.Query<ExitModel>(StoredProcedureConstants.SpGetExitConfigurations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExitConfigurations", "GenericFormMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetExitConfigurations);
                return new List<ExitModel>();
            }
        }

        public List<EmployeeExitModel> GetEmployeeExits(EmployeeExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", exitModel.UserId);
                    vParams.Add("@OperationsPerformedBy", exitModel.UserId);
                    return vConn.Query<EmployeeExitModel>(StoredProcedureConstants.SpGetEmployeeExits, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeExits", "GenericFormMasterDataRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetExitConfigurations);
                return new List<EmployeeExitModel>();
            }
        }


    }
}
