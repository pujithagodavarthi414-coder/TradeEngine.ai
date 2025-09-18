using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Models;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using BTrak.Common;
using Btrak.Dapper.Dal.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeReportToRepository
    {
        public Guid? UpsertEmployeeReportTo(EmployeeReportToInputModel employeeReportToInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeReportToId", employeeReportToInputModel.EmployeeReportToId);
                    vParams.Add("@EmployeeId", employeeReportToInputModel.EmployeeId);
                    vParams.Add("@ReportToEmployeeId", employeeReportToInputModel.ReportToEmployeeId);
                    vParams.Add("@ReportingMethodId", employeeReportToInputModel.ReportingMethodId);
                    vParams.Add("@ActiveFrom", employeeReportToInputModel.ReportingFrom);
                    vParams.Add("@Comments", employeeReportToInputModel.Comments);
                    vParams.Add("@TimeStamp", employeeReportToInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeReportToInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeReportTo, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeReportTo", "EmployeeReportToRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeReportTo);
                return null;
            }
        }

        public List<EmployeeReportToDetailsApiReturnModel> GetEmployeeReportToDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeReportToId", employeeDetailSearchCriteriaInputModel.EmployeeReportToId);
                    vParams.Add("@EmployeeId", employeeDetailSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeDetailSearchCriteriaInputModel.SearchText);
                    vParams.Add("@PageNo", employeeDetailSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeDetailSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", employeeDetailSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeDetailSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@EmployeeReportToId", employeeDetailSearchCriteriaInputModel.EmployeeReportToId);
                    vParams.Add("@IsArchived", employeeDetailSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeReportToDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeReportToDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeReportToDetails", "EmployeeReportToRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeReportToDetails);
                return new List<EmployeeReportToDetailsApiReturnModel>();
            }
        }

        public List<EmployeeReportToDbEntity> GetDependentEmployees(Guid reportToEmployeeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@ReportToEmployeeId", reportToEmployeeId);
                return vConn.Query<EmployeeReportToDbEntity>(StoredProcedureConstants.SpGetDepenedentEmployees, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<EmployeeReportToDetailsApiReturnModel> SearchEmployeeReportToDetails(EmployeeReportToDetailsInputModel getEmployeeReportToDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeReportToDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeReportToDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeReportToId", getEmployeeReportToDetailsInputModel.EmployeeReportToId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeReportToDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeReportToDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeReportToDetails", "EmployeeReportToRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeReportTo);
                return new List<EmployeeReportToDetailsApiReturnModel>();
            }
        }

        public Guid? UpsertEmployeeReportToChannel(Guid? reportToEmployeeId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())  
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReportToEmployeeId", reportToEmployeeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeReportToChannel, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeReportToChannel", "EmployeeReportToRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertEmployeechannel);
                return null;
            }
        }
    }
}
