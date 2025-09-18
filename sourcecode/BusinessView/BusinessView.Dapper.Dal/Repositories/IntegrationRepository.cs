using Btrak.Models;
using Btrak.Models.Integration;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.HrManagement;
namespace Btrak.Dapper.Dal.Repositories
{
    public class IntegrationRepository : BaseRepository
    {
        public List<UserProjectIntegrationModel> GetUserIntegrations(Guid? integrationTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TypeId", integrationTypeId);
                    return vConn.Query<UserProjectIntegrationModel>(StoredProcedureConstants.SpGetUserProjectIntegration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIntegrationTypes", "IntegrationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetIntegrationTypes);
                return new List<UserProjectIntegrationModel>();
            }
        }
        public List<IntegrationTypesDetailsModel> GetIntegrationTypes(Guid userId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", userId);
                    return vConn.Query<IntegrationTypesDetailsModel>(StoredProcedureConstants.SpGetIntegrationTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIntegrationTypes", "IntegrationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetIntegrationTypes);
                return new List<IntegrationTypesDetailsModel>();
            }
        }
        public List<IntegrationTypesDetailsModel> GetUserIntegrationTypes(Guid userId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", userId);
                    return vConn.Query<IntegrationTypesDetailsModel>(StoredProcedureConstants.SpGetUserIntegrationTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserIntegrationTypes", "IntegrationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserIntegrations);
                return new List<IntegrationTypesDetailsModel>();
            }
        }
        public List<IntegrationTypesDetailsModel> GetCompanyIntegrationTypes(Guid userId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", userId);
                    return vConn.Query<IntegrationTypesDetailsModel>(StoredProcedureConstants.SpGetCompanyIntegrationTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyIntegrationTypes", "IntegrationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanyIntegrations);
                return new List<IntegrationTypesDetailsModel>();
            }
        }
        public List<CompanyOrUserLevelIntegrationDetailsModel> GetCompanyLevelIntrgrations(CompanyLevelIntegrationsInputModel companylevelintegrationInputModel, Guid userId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", userId);
                    vParams.Add("@IsArchived", companylevelintegrationInputModel.IsArchived);
                    return vConn.Query<CompanyOrUserLevelIntegrationDetailsModel>(StoredProcedureConstants.SpGetCompanyLevelIntegrations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyLevelIntrgrations", "IntegrationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanyLevelIntegrationTypes);
                return new List<CompanyOrUserLevelIntegrationDetailsModel>();
            }
        }
        public Guid? AddOrUpdateCompanyLevelIntegration(CompanyOrUserLevelIntegrationDetailsModel companylevelintegrationInputModel, Guid userId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@Id", companylevelintegrationInputModel.Id);
                    vParams.Add("@OperationsPerformedBy", userId);
                    vParams.Add("@IntegrationTypeId", companylevelintegrationInputModel.IntegrationTypeId);
                    vParams.Add("@IntegrationUrl", companylevelintegrationInputModel.IntegrationUrl);
                    vParams.Add("@UserName", companylevelintegrationInputModel.UserName);
                    vParams.Add("@ApiToken", companylevelintegrationInputModel.ApiToken);
                    vParams.Add("@IsArchived", companylevelintegrationInputModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpAddOrUpdateCompanyLevelIntegration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddOrUpdateCompanyLevelIntegration", "IntegrationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAddOrUpdateCompanyLevelIntegration);
                return null;
            }
        }
    }
}
