using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.ConsiderHour;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ConsiderHourRepository
    {
        public Guid? UpsertConsideredHours(ConsiderHourUpsertInputModel considerHourUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConsideredHoursId", considerHourUpsertInputModel.ConsiderHourId);
                    vParams.Add("@ConsiderHourName", considerHourUpsertInputModel.ConsiderHourName);
                    vParams.Add("@IsArchived", considerHourUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", considerHourUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertConsideredHours, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConsideredHours", "ConsiderHourRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionConsiderHourUpsert);
                return null;
            }
        }

        public List<ConsiderHourApiReturnModel> GetAllConsideredHours(ConsiderHourInputModel considerHourInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ConsideredHoursId", considerHourInputModel.ConsiderHourId);
                    vParams.Add("@ConsiderHourName", considerHourInputModel.ConsiderHourName);
                    vParams.Add("@IsArchived", considerHourInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ConsiderHourApiReturnModel>(StoredProcedureConstants.SpGetConsideredHours, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllConsideredHours", "ConsiderHourRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllConsideredHours);
                return new List<ConsiderHourApiReturnModel>();
            }
        }
    }
}
