using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeShiftRepository
    {
        public Guid? UpsertEmployeeShift(EmployeeShiftInputModel employeeShiftInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeShiftId", employeeShiftInputModel.EmployeeShiftId);
                    vParams.Add("@ShiftTimingId", employeeShiftInputModel.ShiftTimingId);
                    vParams.Add("@EmployeeId", employeeShiftInputModel.EmployeeId);
                    vParams.Add("@ActiveFrom", employeeShiftInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", employeeShiftInputModel.ActiveTo);
                    vParams.Add("@IsArchived", employeeShiftInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeShiftInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeShift, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeShift", "EmployeeShiftRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeShiftUpsert);
                return null;
            }
        }

        public List<EmployeeShiftSearchOutputModel> GetEmployeeShift(EmployeeShiftSearchInputModel employeeShiftSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", employeeShiftSearchInputModel.SearchText);
                    vParams.Add("@ShiftTimingId", employeeShiftSearchInputModel.ShiftTimingId);
                    vParams.Add("@EmployeeId", employeeShiftSearchInputModel.EmployeeId);
                    vParams.Add("@IsArchived", employeeShiftSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeShiftSearchOutputModel>(StoredProcedureConstants.SpGetEmployeeShiftTiming, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeShift", "EmployeeShiftRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeShift);
                return new List<EmployeeShiftSearchOutputModel>();
            }
        }
    }
}
