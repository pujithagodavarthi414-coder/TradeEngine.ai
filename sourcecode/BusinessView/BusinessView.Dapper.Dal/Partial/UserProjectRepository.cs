using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Projects;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserProjectRepository
    {
        public List<Guid> UpsertProjectMember(ProjectMemberUpsertInputModel projectMemberUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectMemberId", projectMemberUpsertInputModel.ProjectMemberId);
                    vParams.Add("@ProjectId", projectMemberUpsertInputModel.ProjectId);
                    vParams.Add("@GoalId", projectMemberUpsertInputModel.GoalId);
                    vParams.Add("@UserIds", projectMemberUpsertInputModel.UserXml);
                    vParams.Add("@TimeZone", projectMemberUpsertInputModel.TimeZone);
                    vParams.Add("@RoleIds", projectMemberUpsertInputModel.RoleXml);
                   // vParams.Add("@UserId", projectMemberUpsertInputModel.UserId);
                    //vParams.Add("@RoleId", projectMemberUpsertInputModel.RoleId);
                    vParams.Add("@IsArchived", projectMemberUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", projectMemberUpsertInputModel.TimeStamp , DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpsertProjectMember, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectMember", "UserProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertProjectMember);
                return null;
            }
        }

        public List<ProjectMemberSpReturnModel> GetAllProjectMembers(ProjectMemberSearchCriteriaInputModel projectMemberSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectMemberId", projectMemberSearchCriteriaInputModel.ProjectMemberId);
                    vParams.Add("@ProjectId", projectMemberSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@UserId", projectMemberSearchCriteriaInputModel.UserId);
                    vParams.Add("@RoleId", projectMemberSearchCriteriaInputModel.RoleId);
                    vParams.Add("@IsArchived", projectMemberSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@ProjectMemberIdsXML", projectMemberSearchCriteriaInputModel.ProjectMemberIdsXML);
                    vParams.Add("@PageNo", projectMemberSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", projectMemberSearchCriteriaInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProjectMemberSpReturnModel>(StoredProcedureConstants.SpGetAllProjectMembers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProjectMembers", "UserProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllProjectMembers);
                return new List<ProjectMemberSpReturnModel>();
            }
        }

        public DeleteProjectMemberOutputModel DeleteProjectMember(DeleteProjectMemberModel deleteProjectMemberModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectId", deleteProjectMemberModel.ProjectId);
                    vParams.Add("@TimeZone", deleteProjectMemberModel.TimeZone);
                    vParams.Add("@UserId", deleteProjectMemberModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DeleteProjectMemberOutputModel>(StoredProcedureConstants.SpDeleteProjectMember, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteProjectMember", "UserProjectRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteProjectMember);
                return new DeleteProjectMemberOutputModel();
            }
        }
    }
}
