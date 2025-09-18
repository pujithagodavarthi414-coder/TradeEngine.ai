using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using BTrak.Common;
using Dapper;
using Btrak.Models.Branch;
using Btrak.Models.Employee;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BranchRepository
    {
        public Guid? UpsertBranch(BranchUpsertInputModel branchUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@BranchId", branchUpsertInputModel.BranchId);
                    vParams.Add("@BranchName", branchUpsertInputModel.BranchName);
                    vParams.Add("@IsArchived", branchUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", branchUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsHeadOffice", branchUpsertInputModel.IsHeadOffice);
                    vParams.Add("@Address", branchUpsertInputModel.AddressJSON);
                    vParams.Add("@TimeZoneId", branchUpsertInputModel.TimeZoneId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBranch, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBranch", " BranchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertBranch);
                return null;
            }
        }

        public List<BranchApiReturnModel> GetAllBranches(BranchSearchInputModel branchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@BranchId", branchInputModel.BranchId);
                    vParams.Add("@SearchText", branchInputModel.SearchText);
                    vParams.Add("@IsArchived", branchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BranchApiReturnModel>(StoredProcedureConstants.SpGetBranchesNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBranches", " BranchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBranches);
                return new List<BranchApiReturnModel>();
            }
        }

        public List<BranchApiDropdownReturnModel> GetAllBranchesDropdown(BranchSearchInputModel branchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@BranchId", branchInputModel.BranchId);
                    vParams.Add("@SearchText", branchInputModel.SearchText);
                    vParams.Add("@IsArchived", branchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BranchApiDropdownReturnModel>(StoredProcedureConstants.SpGetBranchesNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBranchesDropdown", " BranchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBranches);
                return new List<BranchApiDropdownReturnModel>();
            }
        }

        public EmployeeOutputModel GetUserBranchDetails(EmployeeInputModel userInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeOutputModel>(StoredProcedureConstants.SpGetUserBranchDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserBranchDetails", " BranchRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetUserBranchDetails);
                return new EmployeeOutputModel();
            }
        }
    }
}
