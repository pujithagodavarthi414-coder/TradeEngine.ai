using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class DepartmentRepository
    {
        public Guid? UpsertDepartment(DepartmentUpsertInputModel departmentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DepartmentId", departmentUpsertInputModel.DepartmentId);
                    vParams.Add("@DepartmentName", departmentUpsertInputModel.DepartmentName);
                    vParams.Add("@IsArchived", departmentUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", departmentUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDepartment, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDepartment", "DepartmentRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDepartment);
                return null;
            }
        }

        public List<DepartmentApiReturnModel> GetDepartments(DepartmentSearchInputModel departmentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DepartmentId", departmentSearchInputModel.DepartmentId);
                    vParams.Add("@SearchText", departmentSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", departmentSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DepartmentApiReturnModel>(StoredProcedureConstants.SpGetDepartments, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDepartments", "DepartmentRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDepartments);
                return new List<DepartmentApiReturnModel>();
            }
        }
    }
}
