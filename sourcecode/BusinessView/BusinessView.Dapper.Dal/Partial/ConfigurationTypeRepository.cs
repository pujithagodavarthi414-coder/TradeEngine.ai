using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.ConfigurationType;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ConfigurationTypeRepository
    {
        public Guid? UpsertConfigurationType(ConfigurationTypeUpsertInputModel configurationTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationTypeId", configurationTypeUpsertInputModel.ConfigurationTypeId);
                    vParams.Add("@ConfigurationTypeName", configurationTypeUpsertInputModel.ConfigurationTypeName);
                    vParams.Add("@TimeStamp", configurationTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", configurationTypeUpsertInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertConfigurationType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConfigurationType", "ConfigurationTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionConfigurationTypeUpsert);
                return null;
            }
        }

        public List<ConfigurationTypeApiReturnModel> GetAllConfigurationTypes(ConfigurationTypeInputModel configurationTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationTypeId", configurationTypeInputModel.ConfigurationTypeId);
                    vParams.Add("@ConfigurationTypeName", configurationTypeInputModel.ConfigurationTypeName);
                    vParams.Add("@IsArchived", configurationTypeInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ConfigurationTypeApiReturnModel>(StoredProcedureConstants.SpGetConfigurationTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllConfigurationTypes", "ConfigurationTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchConfigurationTypes);
                return new List<ConfigurationTypeApiReturnModel>();
            }
        }

        public Guid? UpsertConfigurationSettings(Guid? configurationId, string configurationSettingXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationTypeId", configurationId);
                    vParams.Add("@ConfigurationSettingModel", configurationSettingXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertConfigurationSettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConfigurationSettings", "ConfigurationTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionConfigurationSettingsUpsert);
                return null;
            }
        }

        public List<ConfigurationSettingApiReturnModel> GetAllConfigurationSettings(ConfigurationSettingInputModel configurationSettingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationTypeId", configurationSettingInputModel.ConfigurationTypeId);
                    vParams.Add("@FieldPermissionId", configurationSettingInputModel.FieldPermissionId);
                    vParams.Add("@ProjectId", configurationSettingInputModel.ProjectId);
                    vParams.Add("@UserId", configurationSettingInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ConfigurationSettingApiReturnModel>(StoredProcedureConstants.SpGetConfigurationSettingsByConfigurationId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllConfigurationSettings", "ConfigurationTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchConfigurationSettings);
                return new List<ConfigurationSettingApiReturnModel>();
            }
        }

        public List<ConfigurationTypeApiReturnModel> GetMandatoryFieldsBasedOnConfiguration(Guid? configurationTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConfigurationTypeId", configurationTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ConfigurationTypeApiReturnModel>(StoredProcedureConstants.SpGetMandatoryFieldsBasedOnConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMandatoryFieldsBasedOnConfiguration", "ConfigurationTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchMandatoryFieldsBasedOnConfiguration);
                return new List<ConfigurationTypeApiReturnModel>();
            }
        }
    }
}
