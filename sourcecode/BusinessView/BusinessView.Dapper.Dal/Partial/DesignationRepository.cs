using Dapper;
using System;
using System.Data;
using System.Linq;
using BTrak.Common;
using Btrak.Models.HrManagement;
using Btrak.Models;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Dapper.Dal.Helpers;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class DesignationRepository
    {
        public string GetDesignationName(Guid aId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aId);
                return vConn.Query<string>(StoredProcedureConstants.SpDesignationNameSelect, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public Guid? UpsertDesignation(DesignationUpsertInputModel designationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DesignationId", designationUpsertInputModel.DesignationId);
                    vParams.Add("@DesignationName", designationUpsertInputModel.DesignationName);
                    vParams.Add("@IsArchived", designationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", designationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDesignation, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDesignation", "DesignationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDesignation);
                return null;
            }
        }

        public List<DesignationApiReturnModel> GetDesignations(DesignationSearchInputModel departmentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DesignationId", departmentSearchInputModel.DesignationId);
                    vParams.Add("@SearchText", departmentSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", departmentSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DesignationApiReturnModel>(StoredProcedureConstants.SpGetDesignations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDesignations", "DesignationRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDesignations);
                return new List<DesignationApiReturnModel>();
            }
        }
    }
}
