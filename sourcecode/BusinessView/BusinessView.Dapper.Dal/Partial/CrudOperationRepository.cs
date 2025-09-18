using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.CrudOperation;
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
    public partial class CrudOperationRepository
    {
        public Guid? UpsertPermission(CrudOperationInputModel crudOperationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CrudOperationId", crudOperationInputModel.CrudOperationId);
                    vParams.Add("@OperationName", crudOperationInputModel.OperationName);
					vParams.Add("@TimeStamp", crudOperationInputModel.TimeStamp, DbType.Binary);
					vParams.Add("@IsArchived", crudOperationInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCrudOperation, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPermission", "CrudOperationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPermissionUpsert);
                return null;
            }
        }

        public List<CrudOperationApiReturnModel> GetAllCrudOperations(CrudOperationInputModel crudOperationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CrudOperationId", crudOperationInputModel.CrudOperationId);
                    vParams.Add("@OperationName", crudOperationInputModel.OperationName);
					vParams.Add("@IsArchived", crudOperationInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CrudOperationApiReturnModel>(StoredProcedureConstants.SpGetCrudOperations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllCrudOperations", "CrudOperationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllPermissions);
                return new List<CrudOperationApiReturnModel>();
            }
        }
    }
}
