using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Training;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class TrainingCourseRepository : BaseRepository
    {
        public List<TrainingCourse> SearchTrainingCourses(TrainingCourseSearchModel trainingCourseSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", trainingCourseSearchModel.SearchText);
                    vParams.Add("@SortBy", trainingCourseSearchModel.SortBy);
                    vParams.Add("@SortDirection", trainingCourseSearchModel.SortDirection == null ? "ASC" : trainingCourseSearchModel.SortDirection.ToUpper());
                    vParams.Add("@PageSize", trainingCourseSearchModel.PageSize);
                    vParams.Add("@IsArchived", trainingCourseSearchModel.IsArchived);
                    vParams.Add("@PageNumber", trainingCourseSearchModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TrainingCourse>(StoredProcedureConstants.SpSearchTrainingCourse, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTrainingCourses", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTrainingCourse);
                return new List<TrainingCourse>();
            }
        }

        public bool ArchiveOrUnArchiveTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CourseId", trainingCourse.Id);
                    vParams.Add("@IsArchived", trainingCourse.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query<TrainingCourse>(StoredProcedureConstants.SpArchiveOrUnArchiveTrainingCourse, vParams, commandType: CommandType.StoredProcedure);
                    return true;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveOrUnArchiveTrainingCourse", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTrainingCourse);
                return false;
            }
        }

        public void AssignOrUnAssignTrainingCourse(AssignmentsInputModel assignments, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CourseIds", string.Join(",", assignments.CourseIds));
                    vParams.Add("@UserIds", string.Join(",", assignments.UserIds));
                    vParams.Add("@Assign", assignments.Assign);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query<TrainingCourse>(StoredProcedureConstants.SpAssignOrUnAssignTrainingCourse, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AssignOrUnAssignTrainingCourse", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAssignOrUnAssignTrainingCourse);
            }
        }

        public bool CheckActiveAssignmentsExists(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CourseId", trainingCourse.Id);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpCheckActiveAssignmentsExists, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckActiveAssignmentsExists", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCheckSameCourseExists);
                return false;
            }
        }

        public bool CheckSameCourseExists(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CourseId", trainingCourse.Id);
                    vParams.Add("@CourseName", trainingCourse.CourseName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpCheckSameCourseExists, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckSameCourseExists", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCheckSameCourseExists);
                return false;
            }
        }

        public List<TrainingAssignmentOutPutModel> SearchTrainingAssignments(TrainingAssignmentSearchModel trainingAssignmentSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                CheckAndUpdateExpiredAssignments(loggedInContext, validationMessages);

                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortBy", trainingAssignmentSearchModel.SortBy);
                    vParams.Add("@SortDirection", trainingAssignmentSearchModel.SortDirection);
                    vParams.Add("@PageSize", trainingAssignmentSearchModel.PageSize);
                    vParams.Add("@PageNumber", trainingAssignmentSearchModel.PageNumber);
                    vParams.Add("@SearchText", trainingAssignmentSearchModel.SearchText);
                    vParams.Add("@UserIds", trainingAssignmentSearchModel.UserIds != null ? string.Join(",", trainingAssignmentSearchModel.UserIds) : string.Empty);
                    vParams.Add("@TimeZoneOffset", loggedInContext.TimeZoneOffset);
                    vParams.Add("@CourseIds", trainingAssignmentSearchModel.TrainingCourseIds != null ? string.Join(",", trainingAssignmentSearchModel.TrainingCourseIds) : string.Empty);

                    return vConn.Query<TrainingAssignmentOutPutModel>(StoredProcedureConstants.SpSearchTrainingAssignments, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTrainingAssignments", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTrainingAssignments);
                return new List<TrainingAssignmentOutPutModel>();
            }
        }

        public List<TrainingWorkflow> GetAssignmentWorkflow(Guid assignmentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AssignmentId", assignmentId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TrainingWorkflow>(StoredProcedureConstants.SpGetAssignmentWorkflow, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssignmentWorkflow", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAssignmentWorkflow);
                return new List<TrainingWorkflow>();
            }
        }

        public void AddOrUpdateAssignmentStatus(TrainingAssignment assignment, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@AssignmentId", string.Join(",", assignment.Id));
                    vParams.Add("@StatusId", string.Join(",", assignment.StatusId));
                    vParams.Add("@StatusGivenDate", string.Join(",", assignment.StatusGivenDate));
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query(StoredProcedureConstants.SpAddOrUpdateAssignmentStatus, vParams, commandType: CommandType.StoredProcedure);
                }

                CheckAndUpdateExpiredAssignments(loggedInContext, validationMessages);
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddOrUpdateAssignmentStatus", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAddOrUpdateAssignmentStatus);
            }
        }

        public void CheckAndUpdateExpiredAssignments(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query(StoredProcedureConstants.SpCheckAndUpdateExpiredAssignments, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckAndUpdateExpiredAssignments", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCheckAndUpdateExpiredAssignments);
            }
        }

        public List<AssignmentStatus> GetAssignmentStatuses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AssignmentStatus>(StoredProcedureConstants.SpGetAssignmentStatuses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssignmentStatuses", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAssignmentStatuses);
                return new List<AssignmentStatus>();
            }
        }

        public List<TrainingCourse> GetTrainingCourses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TrainingCourse>(StoredProcedureConstants.SpGetTrainingCourses, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrainingCourses", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTrainingCourse);
                return new List<TrainingCourse>();
            }
        }

        public Guid? UpsertTrainingCourse(TrainingCourse trainingCourse, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", trainingCourse.Id);
                    vParams.Add("@CourseName", trainingCourse.CourseName);
                    vParams.Add("@CourseDescription", trainingCourse.CourseDescription);
                    vParams.Add("@ValidityInMonths", trainingCourse.ValidityInMonths);
                    vParams.Add("@CompanyId", trainingCourse.CompanyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTrainingCourse, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTrainingCourse", "TrainingCourseRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertTrainingCourse);
                return null;
            }
        }
    }
}
