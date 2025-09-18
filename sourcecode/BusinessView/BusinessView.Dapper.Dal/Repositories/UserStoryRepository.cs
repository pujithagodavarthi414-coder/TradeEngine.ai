using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserStoryRepository : BaseRepository
    {

        /// <summary>
        /// Saves a record to the UserStory table.
        /// returns True if value saved successfullyelse false
        /// Throw exception with message value 'EXISTS' if the data is duplicate
        /// </summary>
        public bool Insert(UserStoryDbEntity aUserStory)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aUserStory.Id);
                vParams.Add("@GoalId", aUserStory.GoalId);
                vParams.Add("@UserStoryName", aUserStory.UserStoryName);
                vParams.Add("@EstimatedTime", aUserStory.EstimatedTime);
                vParams.Add("@DeadLineDate", aUserStory.DeadLineDate);
                vParams.Add("@OwnerUserId", aUserStory.OwnerUserId);
                vParams.Add("@DependencyUserId", aUserStory.DependencyUserId);
                vParams.Add("@Order", aUserStory.Order);
                vParams.Add("@UserStoryStatusId", aUserStory.UserStoryStatusId);
                vParams.Add("@CreatedDateTime", aUserStory.CreatedDateTime);
                vParams.Add("@CreatedByUserId", aUserStory.CreatedByUserId);
                vParams.Add("@UpdatedDateTime", aUserStory.UpdatedDateTime);
                vParams.Add("@UpdatedByUserId", aUserStory.UpdatedByUserId);
                vParams.Add("@ActualDeadLineDate", aUserStory.ActualDeadLineDate);
                vParams.Add("@ArchivedDateTime", aUserStory.ArchivedDateTime);
                vParams.Add("@BugPriorityId", aUserStory.BugPriorityId);
                vParams.Add("@UserStoryTypeId", aUserStory.UserStoryTypeId);
                vParams.Add("@ProjectFeatureId", aUserStory.ProjectFeatureId);
                vParams.Add("@ParkedDateTime", aUserStory.ParkedDateTime);
                int iResult = vConn.Execute("USP_UserStoryInsert", vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        /// <summary>
        /// Updates record to the UserStory table.
        /// returns True if value saved successfullyelse false
        /// Throw exception with message value 'EXISTS' if the data is duplicate
        /// </summary>
        public bool Update(UserStoryDbEntity aUserStory)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aUserStory.Id);
                vParams.Add("@GoalId", aUserStory.GoalId);
                vParams.Add("@UserStoryName", aUserStory.UserStoryName);
                vParams.Add("@EstimatedTime", aUserStory.EstimatedTime);
                vParams.Add("@DeadLineDate", aUserStory.DeadLineDate);
                vParams.Add("@OwnerUserId", aUserStory.OwnerUserId);
                vParams.Add("@DependencyUserId", aUserStory.DependencyUserId);
                vParams.Add("@Order", aUserStory.Order);
                vParams.Add("@UserStoryStatusId", aUserStory.UserStoryStatusId);
                vParams.Add("@CreatedDateTime", aUserStory.CreatedDateTime);
                vParams.Add("@CreatedByUserId", aUserStory.CreatedByUserId);
                vParams.Add("@UpdatedDateTime", aUserStory.UpdatedDateTime);
                vParams.Add("@UpdatedByUserId", aUserStory.UpdatedByUserId);
                vParams.Add("@ActualDeadLineDate", aUserStory.ActualDeadLineDate);
                vParams.Add("@ArchivedDateTime", aUserStory.ArchivedDateTime);
                vParams.Add("@BugPriorityId", aUserStory.BugPriorityId);
                vParams.Add("@UserStoryTypeId", aUserStory.UserStoryTypeId);
                vParams.Add("@ProjectFeatureId", aUserStory.ProjectFeatureId);
                vParams.Add("@ParkedDateTime", aUserStory.ParkedDateTime);
                int iResult = vConn.Execute("USP_UserStoryUpdate", vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        /// <summary>
        /// Selects the Single object of UserStory table.
        /// </summary>
        public UserStoryDbEntity GetUserStory(Guid aId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aId);
                return vConn.Query<UserStoryDbEntity>("USP_UserStorySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        /// <summary>
        /// Selects all records from the UserStory table.
        /// </summary>
        public IEnumerable<UserStoryDbEntity> SelectAll()
        {
            using (var vConn = OpenConnection())
            {
                return vConn.Query<UserStoryDbEntity>("USP_UserStorySelectAll", commandType: CommandType.StoredProcedure).ToList();
            }
        }
        /// <summary>
        /// Selects all records from the UserStory table by a foreign key.
        /// </summary>
        public List<UserStoryDbEntity> SelectAllByGoalId(Guid goalId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@GoalId", goalId);
                return vConn.Query<UserStoryDbEntity>("USP_UserStorySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public Guid? GetTemplateIdByName(string templateName, Guid companyId)
        {
            using (var conn = OpenConnection())
            {
                var parameters = new DynamicParameters();
                parameters.Add("@TemplateName", templateName);
                parameters.Add("@CompanyId", companyId);
                var result = conn.Query<Guid?>("USP_GetTemplateIdByName", parameters, commandType: CommandType.StoredProcedure).FirstOrDefault();
                return result;
            }
        }


    }
}
