using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Recruitment;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class RecruitmentMasterDataRepository : BaseRepository
    {
        public Guid? UpsertJobOpeningStatus(JobOpeningStatusUpsertInputModel jobOpeningStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningStatusId", jobOpeningStatusUpsertInputModel.JobOpeningStatusId);
                    vParams.Add("@Status", jobOpeningStatusUpsertInputModel.Status);
                    vParams.Add("@Order", jobOpeningStatusUpsertInputModel.Order);
                    vParams.Add("@IsArchived", jobOpeningStatusUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", jobOpeningStatusUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertJobOpeningStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertJobOpeningStatus", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertJobOpeningStatus);
                return null;
            }
        }

        public List<JobOpeningStatusSearchOutputModel> GetJobOpeningStatus(JobOpeningStatusSearchInputModel jobOpeningSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningStatusId", jobOpeningSearchInputModel.JobOpeningStatusId);
                    vParams.Add("@Order", jobOpeningSearchInputModel.Order);
                    vParams.Add("@Status", jobOpeningSearchInputModel.Status);
                    vParams.Add("@SearchText", jobOpeningSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", jobOpeningSearchInputModel.IsArchived);
                    vParams.Add("@SortBy", jobOpeningSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", jobOpeningSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<JobOpeningStatusSearchOutputModel>(StoredProcedureConstants.SpGetJobOpeningStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get JobOpening Stataus", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetJobOpeningStatus);
                return new List<JobOpeningStatusSearchOutputModel>();
            }
        }

        public Guid? UpsertJobType(JobTypeUpsertInputModel jobTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobTypeId", jobTypeUpsertInputModel.JobTypeId);
                    vParams.Add("@JobTypeName", jobTypeUpsertInputModel.JobTypeName);
                    vParams.Add("@TimeStamp", jobTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertJobType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertJobType", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertJobOpeningStatus);
                return null;
            }
        }

        public List<JobTypeSearchOutputModel> GetJobTypes(JobTypesSearchInputModel jobTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobTypeId", jobTypesSearchInputModel.JobTypeId);
                    vParams.Add("@JobTypeName", jobTypesSearchInputModel.JobTypeName);
                    vParams.Add("@SearchText", jobTypesSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<JobTypeSearchOutputModel>(StoredProcedureConstants.SpGetJobType, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Job Types", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetJobOpeningStatus);
                return new List<JobTypeSearchOutputModel>();
            }
        }

        public Guid? UpsertSource(SourceUpsertInputModel SourceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SourceId", SourceUpsertInputModel.SourceId);
                    vParams.Add("@Name", SourceUpsertInputModel.Name);
                    vParams.Add("@IsReferenceNumberNeeded", SourceUpsertInputModel.IsReferenceNumberNeeded);
                    vParams.Add("@IsArchived", SourceUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", SourceUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSource, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSource", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSource);
                return null;
            }
        }

        public List<SourceSearchOutputModel> GetSources(SourceSearchInputModel jobOpeningSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SourceId", jobOpeningSearchInputModel.SourceId);
                    vParams.Add("@IsReferenceNumberNeeded", jobOpeningSearchInputModel.IsReferenceNumberNeeded);
                    vParams.Add("@Name", jobOpeningSearchInputModel.Name);
                    vParams.Add("@IsArchived", jobOpeningSearchInputModel.IsArchived);
                    vParams.Add("@SearchText", jobOpeningSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SourceSearchOutputModel>(StoredProcedureConstants.SpGetSources, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Job Soource", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSource);
                return new List<SourceSearchOutputModel>();
            }
        }

        public Guid? UpsertDocumentType(DocumentTypeUpsertInputModel documentTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DocumentTypeId", documentTypeUpsertInputModel.DocumentTypeId);
                    vParams.Add("@DocumentTypeName", documentTypeUpsertInputModel.DocumentTypeName);
                    vParams.Add("@IsArchived", documentTypeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", documentTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDocumentType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateDocument", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertDocumentType);
                return null;
            }
        }

        public List<DocumentTypesSearchOutputModel> GetDocumentTypes(DocumentTypesSearchInputModel documentTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DocumentTypeId", documentTypesSearchInputModel.DocumentTypeId);
                    vParams.Add("@DocumentTypeName", documentTypesSearchInputModel.DocumentTypeName);
                    vParams.Add("@IsArchived", documentTypesSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DocumentTypesSearchOutputModel>(StoredProcedureConstants.SpGetDocumentTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateDocuments", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDocumentTypes);
                return new List<DocumentTypesSearchOutputModel>();
            }
        }

        public Guid? UpsertInterviewType(InterviewTypeUpsertInputModel interviewTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewTypeId", interviewTypeUpsertInputModel.InterviewTypeId);
                    vParams.Add("@InterviewTypeName", interviewTypeUpsertInputModel.InterviewTypeName);
                    vParams.Add("@Color", interviewTypeUpsertInputModel.Color);
                    vParams.Add("@IsPhone", interviewTypeUpsertInputModel.IsPhone);
                    vParams.Add("@IsVideo", interviewTypeUpsertInputModel.IsVideo);
                    vParams.Add("@RoleIds", interviewTypeUpsertInputModel.RoleIds);
                    vParams.Add("@InterviewTypeRoleCofigurationId", interviewTypeUpsertInputModel.InterviewTypeRoleCofigurationId);
                    vParams.Add("@IsArchived", interviewTypeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", interviewTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInterviewType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInterviewType", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertInterviewType);
                return null;
            }
        }

        public List<InterviewTypesSearchOutputModel> GetInterviewTypes(InterviewTypesSearchInputModel interviewTypesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewTypeId", interviewTypesSearchInputModel.InterviewTypeId);
                    vParams.Add("@InterviewTypeName", interviewTypesSearchInputModel.InterviewTypeName);
                    vParams.Add("@IsVideo", interviewTypesSearchInputModel.IsVideo);
                    vParams.Add("@IsPhone", interviewTypesSearchInputModel.IsPhone);
                    vParams.Add("@IsArchived", interviewTypesSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<InterviewTypesSearchOutputModel>(StoredProcedureConstants.SpGetInterviewTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInterviewTypes", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInterviewTypes);
                return new List<InterviewTypesSearchOutputModel>();
            }
        }
        
        public Guid? UpsertHiringStatus(HiringStatusUpsertInputModel hiringStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@HiringStatusId", hiringStatusUpsertInputModel.HiringStatusId);
                    vParams.Add("@Status", hiringStatusUpsertInputModel.Status);
                    vParams.Add("@Color", hiringStatusUpsertInputModel.Color);
                    vParams.Add("@Order", hiringStatusUpsertInputModel.Order);
                    vParams.Add("@IsArchived", hiringStatusUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", hiringStatusUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertHiringStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHiringStatus", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertHiringStatus);
                return null;
            }
        }

        public List<HiringStatusSearchOutputModel> GetHiringStatus(HiringStatusSearchInputModel hiringStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@HiringStatusId", hiringStatusSearchInputModel.HiringStatusId);
                    vParams.Add("@Status", hiringStatusSearchInputModel.Status);
                    vParams.Add("@Order", hiringStatusSearchInputModel.Order);
                    vParams.Add("@IsArchived", hiringStatusSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<HiringStatusSearchOutputModel>(StoredProcedureConstants.SpGetHiringStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHiringStatus", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHiringStatus);
                return new List<HiringStatusSearchOutputModel>();
            }
        }

        public Guid? UpsertInterviewRating(InterviewRatingUpsertInputModel interviewRatingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewRatingId", interviewRatingUpsertInputModel.InterviewRatingId);
                    vParams.Add("@InterviewRatingName", interviewRatingUpsertInputModel.InterviewRatingName);
                    vParams.Add("@Value", interviewRatingUpsertInputModel.Value);
                    vParams.Add("@IsArchived", interviewRatingUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", interviewRatingUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInterviewRating, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInterviewRating", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertInterviewRating);
                return null;
            }
        }

        public List<InterviewRatingSearchOutputModel> GetInterviewRatings(InterviewRatingSearchInputModel interviewRatingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewRatingId", interviewRatingSearchInputModel.InterviewRatingId);
                    vParams.Add("@InterviewRatingName", interviewRatingSearchInputModel.InterviewRatingName);
                    vParams.Add("@Value", interviewRatingSearchInputModel.Value);
                    vParams.Add("@IsArchived", interviewRatingSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<InterviewRatingSearchOutputModel>(StoredProcedureConstants.SpGetInterviewRatings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInterviewRatings", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInterviewRatings);
                return new List<InterviewRatingSearchOutputModel>();
            }
        }

        public List<ScheduleStatusSearchOutputModel> GetScheduleStatus(ScheduleStatusSearchInputModel scheduleStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ScheduleStatusId", scheduleStatusSearchInputModel.ScheduleStatusId);
                    vParams.Add("@Status", scheduleStatusSearchInputModel.Status);
                    vParams.Add("@Order", scheduleStatusSearchInputModel.Order);
                    vParams.Add("@IsArchived", scheduleStatusSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ScheduleStatusSearchOutputModel>(StoredProcedureConstants.SpGetScheduleStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScheduleStatus", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetScheduleStatus);
                return new List<ScheduleStatusSearchOutputModel>();
            }
        }

        public LoggedInContext GetCandidateRegistrationDropDown(Guid jobOpeningId, string type, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningId", jobOpeningId);
                    return vConn.Query<LoggedInContext>(StoredProcedureConstants.SpGetCandidateFormUsageDataByJobId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateRegistrationDropDown", "Recruitment MasterData Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetScheduleStatus);
                return new LoggedInContext();
            }
        }
    }
}