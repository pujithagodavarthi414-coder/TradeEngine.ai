using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.User;
using AuthenticationServices.Repositories.Helpers;
using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace AuthenticationServices.Repositories.Repositories.MasterDataManagement
{
    public class MasterDataManagementRepository : IMasterDataManagementRepository
    {
        IConfiguration _iconfiguration;
        public MasterDataManagementRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }

        public Guid? UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanySettingsId", companySettingsUpsertInputModel.CompanySettingsId);
                    vParams.Add("@Key", companySettingsUpsertInputModel.Key);
                    vParams.Add("@Value", companySettingsUpsertInputModel.Value);
                    vParams.Add("@Description", companySettingsUpsertInputModel.Description);
                    vParams.Add("@IsArchived", companySettingsUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", companySettingsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsVisible", companySettingsUpsertInputModel.IsVisible);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCompanySettings, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanySettings", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompanySettings);
                return null;
            }
        }

        public List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanySettingsId", companySettingsSearchInputModel.CompanySettingsId);
                    vParams.Add("@Key", companySettingsSearchInputModel.Key);
                    vParams.Add("@Description", companySettingsSearchInputModel.Description);
                    vParams.Add("@Value", companySettingsSearchInputModel.Value);
                    vParams.Add("@SearchText", companySettingsSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", companySettingsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId);
                    vParams.Add("@IsSystemApp", companySettingsSearchInputModel.IsSystemApp);
                    vParams.Add("@IsFromExport", companySettingsSearchInputModel.IsFromExport);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<CompanySettingsSearchOutputModel>(StoredProcedureConstants.SpGetCompanySettings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanySettings", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanySettings);
                return new List<CompanySettingsSearchOutputModel>();
            }
        }

        public string UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LogoData", uploadProfileImageInputModel.ProfileImage);
                    vParams.Add("@LogoType", uploadProfileImageInputModel.LogoType);
                    vParams.Add("@TimeStamp", uploadProfileImageInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<string>(StoredProcedureConstants.SpUpsertCompanyLogo, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyLogo", "MasterDataManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompanySettings);
                return null;
            }
        }

        protected IDbConnection OpenConnectionAuthentication()
        {
            IDbConnection connection = new SqlConnection(_iconfiguration.GetConnectionString("AuthConnectionString"));
            connection.Open();
            return connection;
        }
    }
}
