using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.ProjectType;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ProjectTypeRepository
    {
        public Guid? UpsertProjectType(ProjectTypeUpsertInputModel projectTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectTypeId", projectTypeUpsertInputModel.ProjectTypeId);
                    vParams.Add("@ProjectTypeName", projectTypeUpsertInputModel.ProjectTypeName);
                    vParams.Add("@IsArchived", projectTypeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeZone", projectTypeUpsertInputModel.TimeZone);
                    vParams.Add("@TimeStamp", projectTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProjectType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectType", "ProjectTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProjectTypeUpsert);
                return null;
            }
        }

        public List<ProjectTypeApiReturnModel> GetAllProjectTypes(ProjectTypeInputModel projectTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectTypeId", projectTypeInputModel.ProjectTypeId);
                    vParams.Add("@ProjectTypeName", projectTypeInputModel.ProjectTypeName);
                    vParams.Add("@IsArchived", projectTypeInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProjectTypeApiReturnModel>(StoredProcedureConstants.SpGetProjectTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProjectTypes", "ProjectTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllProjectTypes);
                return new List<ProjectTypeApiReturnModel>();
            }
        }
    }
}
