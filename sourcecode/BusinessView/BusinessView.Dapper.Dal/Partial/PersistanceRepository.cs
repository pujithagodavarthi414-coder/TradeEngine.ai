using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Persistance;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class PersistanceRepository : BaseRepository
    {
        public Guid? UpdatePersistance(PersistanceApiInputModel persistanceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", persistanceApiInputModel.ReferenceId);
                    vParams.Add("@IsUserLevel", persistanceApiInputModel.IsUserLevel);
                    vParams.Add("@PersistanceJson", persistanceApiInputModel.PersistanceJson);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdatePersistance, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePersistance", "PersistanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPersistance);
                return null;
            }
        }

        public PersistanceApiReturnModel GetPersistance(PersistanceApiInputModel persistanceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", persistanceApiInputModel.ReferenceId);
                    vParams.Add("@IsUserLevel", persistanceApiInputModel.IsUserLevel);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PersistanceApiReturnModel>(StoredProcedureConstants.SpGetPersistance, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPersistance", "PersistanceRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPersistance);
                return null;
            }
        }
    }
}
