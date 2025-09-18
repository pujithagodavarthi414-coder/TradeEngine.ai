using System;
using System.Data;
using Dapper;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Models;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeSkillRepository : BaseRepository
    {
        public Guid? UpsertEmployeeSkills(EmployeeSkillsInputModel employeeSkillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeSkillId", employeeSkillsInputModel.EmployeeSkillId);
                    vParams.Add("@EmployeeId", employeeSkillsInputModel.EmployeeId);
                    vParams.Add("@SkillId", employeeSkillsInputModel.SkillId);
                    vParams.Add("@YearsOfExperience", employeeSkillsInputModel.YearsOfExperience);
                    vParams.Add("@DateFrom", employeeSkillsInputModel.DateFrom);
                    vParams.Add("@DateTo", employeeSkillsInputModel.DateTo);
                    vParams.Add("@Comments", employeeSkillsInputModel.Comments);
                    vParams.Add("@TimeStamp", employeeSkillsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeSkillsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeSkills, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeSkills", "EmployeeSkillRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeSkills);
                return null;
            }
        }

        public List<EmployeeSkillDetailsApiReturnModel> GetEmployeeSkillDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                    vParams.Add("@SortBy", employeeDetailSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeDetailSearchCriteriaInputModel.SortDirection);
					vParams.Add("@IsArchived", employeeDetailSearchCriteriaInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeSkillDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeSkillDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeSkillDetails", "EmployeeSkillRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeSkillDetails);
                return new List<EmployeeSkillDetailsApiReturnModel>();
            }
        }
        public List<EmployeeSkillDetailsApiReturnModel> SearchEmployeeSkillDetails(EmployeeSkillDetailsInputModel getEmployeeSkillDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeSkillDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeSkillDetailsInputModel.EmployeeId);
                    vParams.Add("@EmployeeSkillId", getEmployeeSkillDetailsInputModel.EmployeeSkillId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeSkillDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeSkillDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeSkillDetails", "EmployeeSkillRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeSkill);
                return new List<EmployeeSkillDetailsApiReturnModel>();
            }
        }
    }
}
