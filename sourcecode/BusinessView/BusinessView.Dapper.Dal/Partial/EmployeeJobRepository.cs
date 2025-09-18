
using System;
using System.Data;
using System.Linq;
using Dapper;
using Btrak.Models;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Employee;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeJobRepository : BaseRepository
    {
        public Guid? UpsertEmployeeJob(EmployeeJobInputModel employeeJobInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeJobId", employeeJobInputModel.EmployeeJobDetailId);
                    vParams.Add("@EmployeeId", employeeJobInputModel.EmployeeId);
                    vParams.Add("@DesignationId", employeeJobInputModel.DesignationId);
                    vParams.Add("@EmploymentStatusId", employeeJobInputModel.EmploymentStatusId);
                    vParams.Add("@JobCategoryId", employeeJobInputModel.JobCategoryId);
                    vParams.Add("@JoinedDate", employeeJobInputModel.JoinedDate);
                    vParams.Add("@DepartmentId", employeeJobInputModel.DepartmentId);
                    vParams.Add("@BranchId", employeeJobInputModel.BranchId);
                    vParams.Add("@ActiveFrom", employeeJobInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", employeeJobInputModel.ActiveTo);
                    vParams.Add("@TimeStamp", employeeJobInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeJobInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@NoticePeriodInMonths", employeeJobInputModel.NoticePeriodInMonths);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeJob, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeJob", "EmployeeJobRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeJob);
                return null;
            }
        }

        public List<EmployeeJobDetailsApiReturnModel> GetEmployeeJobDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    vParams.Add("@IsArchived", employeeDetailSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeJobDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeJobDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeJobDetails", "EmployeeJobRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeJobDetails);
                return new List<EmployeeJobDetailsApiReturnModel>();
            }
        }
    }
}