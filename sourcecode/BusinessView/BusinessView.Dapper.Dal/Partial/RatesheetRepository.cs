using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;


namespace Btrak.Dapper.Dal.Repositories
{
    public partial class RatesheetRepository : BaseRepository
    {
        public Guid? InsertRatesheetDetails(EmployeeRateSheetDetailsAddInputModel employeeRatesheetDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RateSheetStartDate", employeeRatesheetDetailsAddInputModel.RateSheetStartDate);
                    vParams.Add("@RateSheetEndDate", employeeRatesheetDetailsAddInputModel.RateSheetEndDate);
                    vParams.Add("@RateSheetEmployeeId", employeeRatesheetDetailsAddInputModel.RateSheetEmployeeId);
                    vParams.Add("@RateSheetCurrencyId", employeeRatesheetDetailsAddInputModel.RateSheetCurrencyId);
                    vParams.Add("@RateSheetDetails", employeeRatesheetDetailsAddInputModel.EmployeeRatesheetDetailsString);
                    vParams.Add("@IsArchived", employeeRatesheetDetailsAddInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeRatesheetDetailsAddInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertRatesheetDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertRatesheetDetails", "RatesheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAddEmployeeRatesheetDetails);
                return null;
            }
        }

        public Guid? UpdateRatesheetDetails(EmployeeRatesheetDetailsEditInputModel employeeRatesheetDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeRateSheetId", employeeRatesheetDetailsEditInputModel.EmployeeRateSheetId);
                    vParams.Add("@RateSheetId", employeeRatesheetDetailsEditInputModel.RateSheetId);
                    vParams.Add("@RateSheetCurrencyId", employeeRatesheetDetailsEditInputModel.RateSheetCurrencyId);
                    vParams.Add("@RateSheetForId", employeeRatesheetDetailsEditInputModel.RateSheetForId);
                    vParams.Add("@RateSheetStartDate", employeeRatesheetDetailsEditInputModel.RateSheetStartDate);
                    vParams.Add("@RateSheetEndDate", employeeRatesheetDetailsEditInputModel.RateSheetEndDate);
                    vParams.Add("@RatePerHour", employeeRatesheetDetailsEditInputModel.RatePerHour);
                    vParams.Add("@RatePerHourMon", employeeRatesheetDetailsEditInputModel.RatePerHourMon);
                    vParams.Add("@RatePerHourTue", employeeRatesheetDetailsEditInputModel.RatePerHourTue);
                    vParams.Add("@RatePerHourWed", employeeRatesheetDetailsEditInputModel.RatePerHourWed);
                    vParams.Add("@RatePerHourThu", employeeRatesheetDetailsEditInputModel.RatePerHourThu);
                    vParams.Add("@RatePerHourFri", employeeRatesheetDetailsEditInputModel.RatePerHourFri);
                    vParams.Add("@RatePerHourSat", employeeRatesheetDetailsEditInputModel.RatePerHourSat);
                    vParams.Add("@RatePerHourSun", employeeRatesheetDetailsEditInputModel.RatePerHourSun);
                    vParams.Add("@RateSheetEmployeeId", employeeRatesheetDetailsEditInputModel.RateSheetEmployeeId);
                    vParams.Add("@IsArchived", employeeRatesheetDetailsEditInputModel.IsArchived);
                    vParams.Add("@TimeStamp", employeeRatesheetDetailsEditInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateRatesheetDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateRatesheetDetails", "RatesheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEditEmployeeRatesheetDetails);
                return null;
            }
        }

        public List<EmployeeRateSheetDetailsApiReturnModel> GetEmployeeRateSheetDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeDetailSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeDetailSearchCriteriaInputModel.SearchText);
                    vParams.Add("@PageNo", employeeDetailSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeDetailSearchCriteriaInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsFilter", employeeDetailSearchCriteriaInputModel.EmployeeDetailType);
                    vParams.Add("@SortBy", employeeDetailSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirectionAsc", employeeDetailSearchCriteriaInputModel.SortDirectionAsc);
                    vParams.Add("@BranchId", employeeDetailSearchCriteriaInputModel.BranchId);
                    return vConn.Query<EmployeeRateSheetDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeRateSheetDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRateSheetDetails", "RatesheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRateSheetDetails);
                return new List<EmployeeRateSheetDetailsApiReturnModel>();
            }
        }


        public List<EmployeeRateSheetDetailsApiReturnModel> GetEmployeeRateSheetDetailsById(Btrak.Models.HrManagement.EmployeeRateSheetDetailsInputModel employeeRateSheetDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeRateSheetDetailsInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeRateSheetDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeRateSheetId", employeeRateSheetDetailsInputModel.EmployeeRatesheetId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeRateSheetDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeRateSheetDetailsById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeRateSheetDetailsById", "RatesheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeRateSheetDetails);
                return new List<EmployeeRateSheetDetailsApiReturnModel>();
            }
        }
    }
}
