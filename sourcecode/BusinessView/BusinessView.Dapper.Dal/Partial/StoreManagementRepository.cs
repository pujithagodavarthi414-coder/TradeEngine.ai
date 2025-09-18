using System;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.DocumentManagement;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class StoreManagementRepository : BaseRepository
    {
        public List<StoreReturnModel> GetStores(StoreSearchCriteriaInputModel storeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@StoreId", storeSearchCriteriaInputModel.StoreId);
                    vParams.Add("@StoreName", storeSearchCriteriaInputModel.StoreName);
                    vParams.Add("@IsDefault", storeSearchCriteriaInputModel.IsDefault);
                    vParams.Add("@IsCompany", storeSearchCriteriaInputModel.IsCompany);
                    vParams.Add("@IsArchived", storeSearchCriteriaInputModel.IsArchived); 
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<StoreReturnModel>(StoredProcedureConstants.SpGetStores, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStores", "StoreManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetStores);
                return new List<StoreReturnModel>();
            }
        }

        public Guid? UpsertStore(StoreInputModel storeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@StoreId", storeInputModel.StoreId);
                    vParams.Add("@StoreName", storeInputModel.StoreName.Trim());
                    vParams.Add("@IsArchived", storeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", storeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertStore, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertStore", "StoreManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertStore);

                return null;
            }
        }

        public StoreConfigurationOutputModel GetStoreConfiguration(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<StoreConfigurationOutputModel>(StoredProcedureConstants.SpGetStoreConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStoreConfiguration", "StoreManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetStoreConfiguration);
                return new StoreConfigurationOutputModel();
            }
        }

        public Guid? IsUsersStore(string folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@FolderId", folderId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpGetIsUsersStore, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "IsUsersStore", "StoreManagementRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetStoreConfiguration);
                return null;
            }
        }
    }
}
