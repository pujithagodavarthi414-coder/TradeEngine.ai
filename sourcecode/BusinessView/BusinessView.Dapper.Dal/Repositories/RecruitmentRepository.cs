using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.GenericForm;
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
    public class RecruitmentRepository : BaseRepository
    {
        
        public Guid? UpsertCandidate(CandidateUpsertInputModel candidateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateId", candidateUpsertInputModel.CandidateId);
                    vParams.Add("@FirstName", candidateUpsertInputModel.FirstName);
                    vParams.Add("@LastName", candidateUpsertInputModel.LastName);
                    vParams.Add("@FatherName", candidateUpsertInputModel.FatherName);
                    vParams.Add("@Email", candidateUpsertInputModel.Email);
                    vParams.Add("@ProfileImage", candidateUpsertInputModel.Profile);
                    vParams.Add("@SecondaryEmail", candidateUpsertInputModel.SecondaryEmail);
                    vParams.Add("@Mobile", candidateUpsertInputModel.Mobile);
                    vParams.Add("@Phone", candidateUpsertInputModel.Phone);
                    vParams.Add("@Fax", candidateUpsertInputModel.Fax);
                    vParams.Add("@Website", candidateUpsertInputModel.Website);
                    vParams.Add("@TwitterId", candidateUpsertInputModel.TwitterId);
                    vParams.Add("@AddressJson", candidateUpsertInputModel.AddressJson);
                    vParams.Add("@CurrentSalary", candidateUpsertInputModel.CurrentSalary);
                    vParams.Add("@ExpectedSalary", candidateUpsertInputModel.ExpectedSalary);
                    vParams.Add("@ExperienceInYears", candidateUpsertInputModel.ExperienceInYears);
                    vParams.Add("@SkypeId", candidateUpsertInputModel.SkypeId);
                    vParams.Add("@Description", candidateUpsertInputModel.Description);
                    vParams.Add("@AssignedToManagerId", candidateUpsertInputModel.AssignedToManagerId);
                    vParams.Add("@HiringStatusId", candidateUpsertInputModel.HiringStatusId);
                    vParams.Add("@CountryId", candidateUpsertInputModel.CountryId);
                    vParams.Add("@CurrentDesignation", candidateUpsertInputModel.CurrentDesignation);
                    vParams.Add("@SourceId", candidateUpsertInputModel.SourceId);
                    vParams.Add("@SourcePersonId", candidateUpsertInputModel.SourcePersonId);
                    vParams.Add("@ClosedById", candidateUpsertInputModel.ClosedById);
                    vParams.Add("@JobOpeningId", candidateUpsertInputModel.JobOpeningId);
                    vParams.Add("@CandidateJobOpeningId", candidateUpsertInputModel.CandidateJobOpeningId);
                    vParams.Add("@IsArchived", candidateUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", candidateUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                   
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidate", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidate);
                return null;
            }
        }

        public string UpsertCandidateFormSubmitted(CandidateFormInputModel candidateFormInputModel,GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FirstName", candidateFormInputModel.FirstName);
                    vParams.Add("@LastName", candidateFormInputModel.LastName);
                    vParams.Add("@Email", candidateFormInputModel.Email);
                    vParams.Add("@SecondaryEmail", candidateFormInputModel.SecondaryEmail);
                    vParams.Add("@Phone", candidateFormInputModel.PhoneNumber);
                    vParams.Add("@AddressStreet1", candidateFormInputModel.AddressStreet1);
                    vParams.Add("@AddressStreet2", candidateFormInputModel.AddressStreet2);
                    vParams.Add("@ZipCode", candidateFormInputModel.ZipCode);
                    vParams.Add("@ReferenceEmployeeId", candidateFormInputModel.ReferenceEmployeeId);
                    vParams.Add("@State", candidateFormInputModel.State);
                    vParams.Add("@CurrentSalary", candidateFormInputModel.CurrentSalary);
                    vParams.Add("@ExpectedSalary", candidateFormInputModel.ExpectedSalary);
                    vParams.Add("@ExperienceInYears", candidateFormInputModel.ExperienceInYears);
                    vParams.Add("@Country", candidateFormInputModel.Country);
                    vParams.Add("@CurrentDesignation", candidateFormInputModel.CurrentDesignation);
                    vParams.Add("@FatherName", candidateFormInputModel.FatherName);
                    vParams.Add("@SkypeId", candidateFormInputModel.SkypeId);
                    vParams.Add("@JobOpeningId", candidateFormInputModel.JobOpeningId);
                    vParams.Add("@EducationDetailsXml", candidateFormInputModel.EducationDetailsXml);
                    vParams.Add("@ExperienceXml", candidateFormInputModel.ExperienceXml);
                    vParams.Add("@SkillsXml", candidateFormInputModel.SkillsXml);
                    vParams.Add("@DocumentsXml", candidateFormInputModel.DocumentsXml);
                    vParams.Add("@UploadedDocumentsXml", candidateFormInputModel.UploadedDocumentsXml);
                    vParams.Add("@UploadedResumeXml", candidateFormInputModel.UploadedResumeXml);
                    vParams.Add("@ResumeXml", candidateFormInputModel.ResumeXml);
                    var result = vConn.Query<string>(StoredProcedureConstants.SpUpsertCandidateFormSubmitted, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                    return result.ToString();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateFormSubmitted", "Recruitment Repository", sqlException));

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGenericFormGet);
                return null;
            }
        }


        public Guid? UpsertCandidateJob(CandidateUpsertInputModel candidateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateId", candidateUpsertInputModel.CandidateId);
                    vParams.Add("@JobOpeningId", candidateUpsertInputModel.JobOpeningId);
                    vParams.Add("@CandidateJson", candidateUpsertInputModel.CandidateJson);
                    vParams.Add("@CandidateJobOpeningId", candidateUpsertInputModel.CandidateJobOpeningId);
                    vParams.Add("@IsArchived", candidateUpsertInputModel.IsArchived);
                    vParams.Add("@IsJob", candidateUpsertInputModel.IsJob);
                    vParams.Add("@TimeStamp", candidateUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateJob, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateJob", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidate);
                return null;
            }
        }

        public List<CandidatesSearchOutputModel> GetCandidates(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateId", candidatesSearchInputModel.CandidateId);
                    vParams.Add("@JobOpeningId", candidatesSearchInputModel.JobOpeningId);
                    vParams.Add("@FirstName", candidatesSearchInputModel.FirstName);
                    vParams.Add("@LastName", candidatesSearchInputModel.LastName);
                    vParams.Add("@Email", candidatesSearchInputModel.Email);
                    vParams.Add("@SecondaryEmail", candidatesSearchInputModel.SecondaryEmail);
                    vParams.Add("@Mobile", candidatesSearchInputModel.Mobile);
                    vParams.Add("@Phone", candidatesSearchInputModel.Phone);
                    vParams.Add("@Fax", candidatesSearchInputModel.Fax);
                    vParams.Add("@Website", candidatesSearchInputModel.Website);
                    vParams.Add("@SkypeId", candidatesSearchInputModel.SkypeId);
                    vParams.Add("@TwitterId", candidatesSearchInputModel.TwitterId);
                    vParams.Add("@AddressJson", candidatesSearchInputModel.AddressJson);
                    vParams.Add("@CountryId", candidatesSearchInputModel.CountryId);
                    vParams.Add("@ExperienceInYears", candidatesSearchInputModel.ExperienceInYears);
                    vParams.Add("@CurrentDesignation", candidatesSearchInputModel.CurrentDesignation);
                    vParams.Add("@CurrentSalary", candidatesSearchInputModel.CurrentSalary);
                    vParams.Add("@ExpectedSalary", candidatesSearchInputModel.ExpectedSalary);
                    vParams.Add("@SourceId", candidatesSearchInputModel.SourceId);
                    vParams.Add("@SourcePersonId", candidatesSearchInputModel.SourcePersonId);
                    vParams.Add("@HiringStatusId", candidatesSearchInputModel.HiringStatusId);
                    vParams.Add("@AssignedToManagerId", candidatesSearchInputModel.AssignedToManagerId);
                    vParams.Add("@InterviewerId", candidatesSearchInputModel.InterviewerId);
                    vParams.Add("@ClosedById", candidatesSearchInputModel.ClosedById);
                    vParams.Add("@CanJobById", candidatesSearchInputModel.CanJobById);
                    vParams.Add("@SearchText", candidatesSearchInputModel.SearchText);
                    vParams.Add("@PageNumber", candidatesSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", candidatesSearchInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidatesSearchOutputModel>(StoredProcedureConstants.SpSearchCandidates, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Candidates", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidates);
                return new List<CandidatesSearchOutputModel>();
            }
        }

        public List<CandidatesSearchOutputModel> GetCandidatesBySkill(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SkillId", candidatesSearchInputModel.SkillId);
                    vParams.Add("@PageNumber", candidatesSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", candidatesSearchInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidatesSearchOutputModel>(StoredProcedureConstants.SpSearchCandidatesBySkill, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidatesBySkill", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidates);
                return new List<CandidatesSearchOutputModel>();
            }
        }
        public List<CandidateSkillsSearchOutputModel> GetSkillsByCandidates(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    //vParams.Add("@CandidateId", candidateSkillsSearchInputModel.CandidateId);
                    //vParams.Add("@SkillId",candidateSkillsSearchInputModel.SkillId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", candidateSkillsSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", candidateSkillsSearchInputModel.PageSize);
                    return vConn.Query<CandidateSkillsSearchOutputModel>(StoredProcedureConstants.SpSearchSkillsByCandidates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSkillsByCandidates", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidates);
                return new List<CandidateSkillsSearchOutputModel>();
            }
        }

        public List<JobOpeningsSearchOutputModel> GetCandidateJobOpenings(CandidatesSearchInputModel candidatesSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Email", candidatesSearchInputModel.Email);
                    vParams.Add("@SortDirection", candidatesSearchInputModel.SortDirection);
                    vParams.Add("@SortBy", candidatesSearchInputModel.SortBy);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<JobOpeningsSearchOutputModel>(StoredProcedureConstants.SpSearchCandidateJobOpenings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Candidates", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidates);
                return new List<JobOpeningsSearchOutputModel>();
            }
        }

        public List<CandidateHistorySearchOutputModel> GetCandidateHistory(CandidateHistorySearchInputModel candidateHistorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateId", candidateHistorySearchInputModel.CandidateId);
                    vParams.Add("@JobOpeningId", candidateHistorySearchInputModel.JobOpeningId);
                    vParams.Add("@CandidateHistoryId", candidateHistorySearchInputModel.CandidateHistoryId);
                    vParams.Add("@OldValue", candidateHistorySearchInputModel.OldValue);
                    vParams.Add("@NewValue", candidateHistorySearchInputModel.NewValue);
                    vParams.Add("@Description", candidateHistorySearchInputModel.Description);
                    vParams.Add("@FieldName", candidateHistorySearchInputModel.FieldName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateHistorySearchOutputModel>(StoredProcedureConstants.SpSearchCandidateHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get CandidateHistory", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateHistory);
                return new List<CandidateHistorySearchOutputModel>();
            }
        }

        public Guid? UpsertJobOpening(JobOpeningUpsertInputModel jobOpeningUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningId", jobOpeningUpsertInputModel.JobOpeningId);
                    vParams.Add("@JobOpeningTitle", jobOpeningUpsertInputModel.JobOpeningTitle);
                    vParams.Add("@JobDescription", jobOpeningUpsertInputModel.JobDescription);
                    vParams.Add("@NoOfOpenings", jobOpeningUpsertInputModel.NoOfOpenings);
                    vParams.Add("@DateFrom", jobOpeningUpsertInputModel.DateFrom);
                    vParams.Add("@DateTo", jobOpeningUpsertInputModel.DateTo);
                    vParams.Add("@MinExperience", jobOpeningUpsertInputModel.MinExperience);
                    vParams.Add("@MaxExperience", jobOpeningUpsertInputModel.MaxExperience);
                    vParams.Add("@Qualification", jobOpeningUpsertInputModel.Qualification);
                    vParams.Add("@Certification", jobOpeningUpsertInputModel.Certification);
                    vParams.Add("@MinSalary", jobOpeningUpsertInputModel.MinSalary);
                    vParams.Add("@MaxSalary", jobOpeningUpsertInputModel.MaxSalary);
                    vParams.Add("@JobTypeId", jobOpeningUpsertInputModel.JobTypeId);
                    vParams.Add("@JobOpeningStatusId", jobOpeningUpsertInputModel.JobOpeningStatusId);
                    vParams.Add("@InterviewProcessId", jobOpeningUpsertInputModel.InterviewProcessId);
                    vParams.Add("@DesignationId", jobOpeningUpsertInputModel.DesignationId);
                    vParams.Add("@HiringManagerId", jobOpeningUpsertInputModel.HiringManagerId);
                    vParams.Add("@LocationIds", jobOpeningUpsertInputModel.JobLocations);
                    vParams.Add("@SkillIds", jobOpeningUpsertInputModel.JobSkills);
                    vParams.Add("@DomainName", jobOpeningUpsertInputModel.DomainName);
                    vParams.Add("@IsArchived", jobOpeningUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", jobOpeningUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                   return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertJobOpening, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Upsert Job Opening", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertJobOpening);
                return null;
            }
        }

        public List<JobOpeningsSearchOutputModel> GetJobOpenings(JobOpeningsSearchInputModel jobOpeningsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningId", jobOpeningsSearchInputModel.JobOpeningId);
                    vParams.Add("@JobOpeningTitle", jobOpeningsSearchInputModel.JobOpeningTitle);
                    vParams.Add("@JobDescription", jobOpeningsSearchInputModel.JobDescription);
                    vParams.Add("@NoOfOpenings", jobOpeningsSearchInputModel.NoOfOpenings);
                    vParams.Add("@DateFrom", jobOpeningsSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", jobOpeningsSearchInputModel.DateTo);
                    vParams.Add("@Email", jobOpeningsSearchInputModel.Email);
                    vParams.Add("@MinExperience", jobOpeningsSearchInputModel.MinExperience);
                    vParams.Add("@MaxExperience", jobOpeningsSearchInputModel.MaxExperience);
                    vParams.Add("@Qualification", jobOpeningsSearchInputModel.Qualification);
                    vParams.Add("@Certification", jobOpeningsSearchInputModel.Certification);
                    vParams.Add("@MinSalary", jobOpeningsSearchInputModel.MinSalary);
                    vParams.Add("@MaxSalary", jobOpeningsSearchInputModel.MaxSalary);
                    vParams.Add("@JobTypeId", jobOpeningsSearchInputModel.JobTypeId);
                    vParams.Add("@JobOpeningStatusId", jobOpeningsSearchInputModel.JobOpeningStatusId);
                    vParams.Add("@InterviewProcessId", jobOpeningsSearchInputModel.InterviewProcessId);
                    vParams.Add("@DesignationId", jobOpeningsSearchInputModel.DesignationId);
                    vParams.Add("@HiringManagerId", jobOpeningsSearchInputModel.HiringManagerId);
                    vParams.Add("@CandidateId", jobOpeningsSearchInputModel.CandidateId);
                    vParams.Add("@SearchText", jobOpeningsSearchInputModel.SearchText);
                    vParams.Add("@PageSize", jobOpeningsSearchInputModel.PageSize);
                    vParams.Add("@PageNumber", jobOpeningsSearchInputModel.PageNumber);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<JobOpeningsSearchOutputModel>(StoredProcedureConstants.SpSearchJobOpenings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Job Openings", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetJobOpenings);
                return new List<JobOpeningsSearchOutputModel>();
            }
        }

        public List<BrytumViewJobDetailsOutputModel> GetBrytumViewJobDetails(JobOpeningsSearchInputModel jobOpeningsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningId", jobOpeningsSearchInputModel.JobOpeningId);
                    vParams.Add("@DateFrom", jobOpeningsSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", jobOpeningsSearchInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BrytumViewJobDetailsOutputModel>(StoredProcedureConstants.SpGetBrytumViewJobDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBrytumViewJobDetails", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetJobOpenings);
                return new List<BrytumViewJobDetailsOutputModel>();
            }
        }

        public Guid? UpsertJobOpeningSkill(JobOpeningSkillUpsertInputModel jobOpeningSkillUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningSkillId", jobOpeningSkillUpsertInputModel.JobOpeningSkillId);
                    vParams.Add("@JobOpeningId", jobOpeningSkillUpsertInputModel.JobOpeningId);
                    vParams.Add("@SkillId", jobOpeningSkillUpsertInputModel.SkillId);
                    vParams.Add("@MinExperience", jobOpeningSkillUpsertInputModel.MinExperience);
                    vParams.Add("@IsArchived", jobOpeningSkillUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", jobOpeningSkillUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertJobOpeningSkill, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Upsert Job Opening Skill", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertJobOpeningSkill);
                return null;
            }
        }

        public List<JobOpeningSkillsSearchOutputModel> GetJobOpeningSkills(JobOpeningSkillsSearchInputModel jobOpeningSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@JobOpeningSkillId", jobOpeningSkillsSearchInputModel.JobOpeningSkillId);
                    vParams.Add("@JobOpeningId", jobOpeningSkillsSearchInputModel.JobOpeningId);
                    vParams.Add("@SkillId", jobOpeningSkillsSearchInputModel.SkillId);
                    vParams.Add("@MinExperience", jobOpeningSkillsSearchInputModel.MinExperience);
                    vParams.Add("@SearchText", jobOpeningSkillsSearchInputModel.SearchText);
                    //vParams.Add("@IsArchived", jobOpeningSkillsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<JobOpeningSkillsSearchOutputModel>(StoredProcedureConstants.SpSearchJobOpeningSkills, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Job Openings", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetJobOpeningSkills);
                return new List<JobOpeningSkillsSearchOutputModel>();
            }
        }

        public Guid? UpsertCandidateSkill(CandidateSkillUpsertInputModel candidateSkillUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateSkillId", candidateSkillUpsertInputModel.CandidateSkillId);
                    vParams.Add("@CandidateId", candidateSkillUpsertInputModel.CandidateId);
                    vParams.Add("@SkillId", candidateSkillUpsertInputModel.SkillId);
                    vParams.Add("@Experience", candidateSkillUpsertInputModel.Experience);
                    vParams.Add("@IsArchived", candidateSkillUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", candidateSkillUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateSkill, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateSkill", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateSkill);
                return null;
            }
        }

        public List<CandidateSkillsSearchOutputModel> GetCandidateSkills(CandidateSkillsSearchInputModel candidateSkillsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateSkillId", candidateSkillsSearchInputModel.CandidateSkillId);
                    vParams.Add("@CandidateId", candidateSkillsSearchInputModel.CandidateId);
                    vParams.Add("@SkillId", candidateSkillsSearchInputModel.SkillId);
                    vParams.Add("@IsArchived", candidateSkillsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateSkillsSearchOutputModel>(StoredProcedureConstants.SpSearchCandidateSkills, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateSkills", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateSkills);
                return new List<CandidateSkillsSearchOutputModel>();
            }
        }

        public Guid? UpsertCandidateExperience(CandidateExperienceUpsertInputModel candidateExperienceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateExperienceDetailsId", candidateExperienceUpsertInputModel.CandidateExperienceDetailsId);
                    vParams.Add("@CandidateId", candidateExperienceUpsertInputModel.CandidateId);
                    vParams.Add("@OccupationTitle", candidateExperienceUpsertInputModel.OccupationTitle);
                    vParams.Add("@Company", candidateExperienceUpsertInputModel.Company);
                    vParams.Add("@CompanyType", candidateExperienceUpsertInputModel.CompanyType);
                    vParams.Add("@Description", candidateExperienceUpsertInputModel.Description);
                    vParams.Add("@DateFrom", candidateExperienceUpsertInputModel.DateFrom);
                    vParams.Add("@DateTo", candidateExperienceUpsertInputModel.DateTo);
                    vParams.Add("@Location", candidateExperienceUpsertInputModel.Location);
                    vParams.Add("@IsCurrentlyWorkingHere", candidateExperienceUpsertInputModel.IsCurrentlyWorkingHere);
                    vParams.Add("@Salary", candidateExperienceUpsertInputModel.Salary);
                    vParams.Add("@CurrencyId", candidateExperienceUpsertInputModel.CurrencyId);
                    vParams.Add("@IsArchived", candidateExperienceUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", candidateExperienceUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateExperience, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateExperience", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateExperience);
                return null;
            }
        }

        public List<CandidateExperienceSearchOutputModel> GetCandidateExperiences(CandidateExperienceSearchInputModel CandidateExperienceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateExperienceDetailsId", CandidateExperienceSearchInputModel.CandidateExperienceDetailsId);
                    vParams.Add("@CandidateId", CandidateExperienceSearchInputModel.CandidateId);
                    vParams.Add("@OccupationTitle", CandidateExperienceSearchInputModel.OccupationTitle);
                    vParams.Add("@Company", CandidateExperienceSearchInputModel.Company);
                    vParams.Add("@CompanyType", CandidateExperienceSearchInputModel.CompanyType);
                    vParams.Add("@Description", CandidateExperienceSearchInputModel.Description);
                    vParams.Add("@DateFrom", CandidateExperienceSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", CandidateExperienceSearchInputModel.DateTo);
                    vParams.Add("@Location", CandidateExperienceSearchInputModel.Location);
                    vParams.Add("@IsCurrentlyWorkingHere", CandidateExperienceSearchInputModel.IsCurrentlyWorkingHere);
                    vParams.Add("@Salary", CandidateExperienceSearchInputModel.Salary);
                    vParams.Add("@CurrencyId", CandidateExperienceSearchInputModel.CurrencyId);
                    vParams.Add("@IsArchived", CandidateExperienceSearchInputModel.IsArchived);
                    vParams.Add("@SortBy", CandidateExperienceSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", CandidateExperienceSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateExperienceSearchOutputModel>(StoredProcedureConstants.SpGetCandidateExperiences, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateExperiences", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateExperiences);
                return new List<CandidateExperienceSearchOutputModel>();
            }
        }

        public Guid? UpsertCandidateEducation(CandidateEducationUpsertInputModel candidateEducationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@@CandidateEducationalDetailsId", candidateEducationUpsertInputModel.CandidateEducationalDetailId);
                    vParams.Add("@CandidateId", candidateEducationUpsertInputModel.CandidateId);
                    vParams.Add("@Institute", candidateEducationUpsertInputModel.Institute);
                    vParams.Add("@Department", candidateEducationUpsertInputModel.Department);
                    vParams.Add("@NameOfDegree", candidateEducationUpsertInputModel.NameOfDegree);
                    vParams.Add("@DateFrom", candidateEducationUpsertInputModel.DateFrom);
                    vParams.Add("@DateTo", candidateEducationUpsertInputModel.DateTo);
                    vParams.Add("@IsPursuing", candidateEducationUpsertInputModel.IsPursuing);
                    vParams.Add("@IsArchived", candidateEducationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", candidateEducationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateEducation, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateEducation", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateEducation);
                return null;
            }
        }

        public List<CandidateEducationSearchOutputModel> GetCandidateEducation(CandidateEducationSearchInputModel candidateEducationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateEducationalDetailId", candidateEducationSearchInputModel.CandidateEducationalDetailId);
                    vParams.Add("@CandidateId", candidateEducationSearchInputModel.CandidateId);
                    vParams.Add("@Institute", candidateEducationSearchInputModel.Institute);
                    vParams.Add("@Department", candidateEducationSearchInputModel.Department);
                    vParams.Add("@NameOfDegree", candidateEducationSearchInputModel.NameOfDegree);
                    vParams.Add("@DateFrom", candidateEducationSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", candidateEducationSearchInputModel.DateTo);
                    vParams.Add("@IsPursuing", candidateEducationSearchInputModel.IsPursuing);
                    vParams.Add("@IsArchived", candidateEducationSearchInputModel.IsArchived);
                    vParams.Add("@SortBy", candidateEducationSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", candidateEducationSearchInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateEducationSearchOutputModel>(StoredProcedureConstants.SpGetCandidateEducation, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateEducation", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateEducation);
                return new List<CandidateEducationSearchOutputModel>();
            }
        }

        public Guid? UpsertCandidateDocument(CandidateDocumentUpsertInputModel candidateDocumentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateDocumentsId", candidateDocumentUpsertInputModel.CandidateDocumentsId);
                    vParams.Add("@CandidateId", candidateDocumentUpsertInputModel.CandidateId);
                    vParams.Add("@DocumentTypeId", candidateDocumentUpsertInputModel.DocumentTypeId);
                    vParams.Add("@Document", candidateDocumentUpsertInputModel.Document);
                    vParams.Add("@Description", candidateDocumentUpsertInputModel.Description);
                    vParams.Add("@IsResume", candidateDocumentUpsertInputModel.IsResume);
                    vParams.Add("@IsArchived", candidateDocumentUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", candidateDocumentUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateDocument, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateDocument", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateDocument);
                return null;
            }
        }

        public List<CandidateDocumentsSearchOutputModel> GetCandidateDocuments(CandidateDocumentsSearchInputModel candidateDocumentsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateDocumentId", candidateDocumentsSearchInputModel.CandidateDocumentsId);
                    vParams.Add("@CandidateId", candidateDocumentsSearchInputModel.CandidateId);
                    vParams.Add("@DocumentTypeId", candidateDocumentsSearchInputModel.DocumentTypeId);
                    vParams.Add("@Document", candidateDocumentsSearchInputModel.Document);
                    vParams.Add("@Description", candidateDocumentsSearchInputModel.Description);
                    vParams.Add("@IsResume", candidateDocumentsSearchInputModel.IsResume);
                    vParams.Add("@IsArchived", candidateDocumentsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateDocumentsSearchOutputModel>(StoredProcedureConstants.SpGetCandidateDocuments, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateDocuments", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateDocuments);
                return new List<CandidateDocumentsSearchOutputModel>();
            }
        }
        
        public Guid? UpsertInterviewProcess(InterviewProcessUpsertInputModel interviewProcessUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewProcessId", interviewProcessUpsertInputModel.InterviewProcessId);
                    vParams.Add("@InterviewProcessName", interviewProcessUpsertInputModel.InterviewProcessName);
                    vParams.Add("@InterviewTypeId", interviewProcessUpsertInputModel.InterviewTypeIds);
                    vParams.Add("@IsArchived", interviewProcessUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", interviewProcessUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInterviewProcess, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInterviewProcess", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertInterviewProcess);
                return null;
            }
        }

        public List<InterviewProcessSearchOutputModel> GetInterviewProcess(InterviewProcessSearchInputModel interviewProcessSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewProcessId", interviewProcessSearchInputModel.InterviewProcessId);
                    vParams.Add("@InterviewProcessName", interviewProcessSearchInputModel.InterviewProcessName);
                    vParams.Add("@IsArchived", interviewProcessSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<InterviewProcessSearchOutputModel>(StoredProcedureConstants.SpGetInterviewProcess, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInterviewProcess", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInterviewProcess);
                return new List<InterviewProcessSearchOutputModel>();
            }
        }

        public Guid? UpsertInterviewProcessConfiguration(InterviewProcessConfigurationUpsertInputModel interviewProcessConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewProcessConfigurationId", interviewProcessConfigurationUpsertInputModel.InterviewProcessConfigurationId);
                    vParams.Add("@InterviewProcessId", interviewProcessConfigurationUpsertInputModel.InterviewProcessId);
                    vParams.Add("@InterviewTypeId", interviewProcessConfigurationUpsertInputModel.InterviewTypeId);
                    vParams.Add("@JobOpeningId", interviewProcessConfigurationUpsertInputModel.JobOpeningId);
                    vParams.Add("@CandidateId", interviewProcessConfigurationUpsertInputModel.CandidateId);
                    vParams.Add("@IsPhoneCalling", interviewProcessConfigurationUpsertInputModel.IsPhoneCalling);
                    vParams.Add("@IsVideoCalling", interviewProcessConfigurationUpsertInputModel.IsVideoCalling);
                    vParams.Add("@InterviewTypeIds", interviewProcessConfigurationUpsertInputModel.interviewProcessConfigurationIdsXml);
                    vParams.Add("@StatusId", interviewProcessConfigurationUpsertInputModel.StatusId);
                    vParams.Add("@IsInitial", interviewProcessConfigurationUpsertInputModel.IsInitial);
                    vParams.Add("@IsArchived", interviewProcessConfigurationUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", interviewProcessConfigurationUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertInterviewProcessConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInterviewProcessConfiguration", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertInterviewProcessConfigurations);
                return null;
            }
        }

        public List<InterviewProcessConfigurationSearchOutputModel> GetInterviewProcessConfiguration(InterviewProcessConfigurationSearchInputModel interviewProcessConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@InterviewProcessConfigurationId", interviewProcessConfigurationSearchInputModel.InterviewProcessConfigurationId);
                    vParams.Add("@InterviewTypeId", interviewProcessConfigurationSearchInputModel.InterviewTypeId);
                    vParams.Add("@InterviewProcessTypeId", interviewProcessConfigurationSearchInputModel.InterviewProcessId);
                    vParams.Add("@JobOpeningId", interviewProcessConfigurationSearchInputModel.JobOpeningId);
                    vParams.Add("@CandidateId", interviewProcessConfigurationSearchInputModel.CandidateId);
                    //vParams.Add("@IsArchived", interviewProcessConfigurationSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<InterviewProcessConfigurationSearchOutputModel>(StoredProcedureConstants.SpGetInterviewProcessConfiguration, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInterviewProcessConfiguration", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetInterviewProcessConfiguration);
                return new List<InterviewProcessConfigurationSearchOutputModel>();
            }
        }

        public Guid? ApproveCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewscheduleUpsertInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@IsApproved", candidateInterviewscheduleUpsertInputModel.IsConfirmed);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                   return vConn.Query<Guid?>(StoredProcedureConstants.SpApproveCandidateInterviewSchedule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateInterviewSchedule", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateInterviewSchedule);
                return null;
            }
        }

        public Guid? UpsertCandidateInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewscheduleUpsertInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@InterviewTypeId", candidateInterviewscheduleUpsertInputModel.InterviewTypeId);
                    vParams.Add("@CandidateId", candidateInterviewscheduleUpsertInputModel.CandidateId);
                    vParams.Add("@StartTime", candidateInterviewscheduleUpsertInputModel.StartDateTime);
                    vParams.Add("@EndTime", candidateInterviewscheduleUpsertInputModel.EndDateTime);
                    vParams.Add("@InterviewDate", candidateInterviewscheduleUpsertInputModel.InterviewDate);
                    vParams.Add("@IsConfirmed", candidateInterviewscheduleUpsertInputModel.IsConfirmed);
                    vParams.Add("@IsCancelled", candidateInterviewscheduleUpsertInputModel.IsCancelled);
                    vParams.Add("@IsRescheduled", candidateInterviewscheduleUpsertInputModel.IsRescheduled);
                    vParams.Add("@ScheduleComments", candidateInterviewscheduleUpsertInputModel.ScheduleComments);
                    vParams.Add("@IsArchived", candidateInterviewscheduleUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", candidateInterviewscheduleUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Assignee", null);
                    vParams.Add("@JobOpeningId", candidateInterviewscheduleUpsertInputModel.JobOpeningId);
                    vParams.Add("@StatusId", candidateInterviewscheduleUpsertInputModel.StatusId);
                    vParams.Add("@AssigneeIds", candidateInterviewscheduleUpsertInputModel.AssigneeIds);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateInterviewSchedule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateInterviewSchedule", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateInterviewSchedule);
                return null;
            }
        }

        public List<CandidateInterviewScheduleSearchOutputModel> ReccurInterviewSchedule(List<ValidationMessage> validationMessages, bool? IsVideoCallCheck = null)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsVideoCallCheck", IsVideoCallCheck);
                    return vConn.Query<CandidateInterviewScheduleSearchOutputModel>(StoredProcedureConstants.SpReccurInterviewSchedule, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateInterviewSchedule", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateInterviewSchedule);
                return null;
            }
        }

        public List<CandidateInterviewScheduleSearchOutputModel> ReccurInterviewScheduleOfCandidates(List<ValidationMessage> validationMessages,bool? IsVideoCallCheck = null)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsVideoCallCheck", IsVideoCallCheck);
                    return vConn.Query<CandidateInterviewScheduleSearchOutputModel>(StoredProcedureConstants.SpReccurInterviewScheduleCandidates, vParams, commandType: CommandType.StoredProcedure).ToList();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateInterviewSchedule", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateInterviewSchedule);
                return null;
            }
        }

        public List<CandidateInterviewScheduleSearchOutputModel> GetUserCandidateInterviewSchedules(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateInterviewScheduleSearchOutputModel>(StoredProcedureConstants.SpSearchUserCandidateInterviewSchedules, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserCandidateInterviewSchedules", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateInterviewSchedule);
                return new List<CandidateInterviewScheduleSearchOutputModel>();
            }
        }

        public List<CandidateInterviewScheduleSearchOutputModel> GetCandidateInterviewSchedule(CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewScheduleSearchInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@InterviewTypeId", candidateInterviewScheduleSearchInputModel.InterviewTypeId);
                    vParams.Add("@CandidateId", candidateInterviewScheduleSearchInputModel.CandidateId);
                    vParams.Add("@StartTime", candidateInterviewScheduleSearchInputModel.StartTime);
                    vParams.Add("@EndTime", candidateInterviewScheduleSearchInputModel.EndTime);
                    vParams.Add("@InterviewDate", candidateInterviewScheduleSearchInputModel.InterviewDate);
                    vParams.Add("@IsConfirmed", candidateInterviewScheduleSearchInputModel.IsConfirmed);
                    vParams.Add("@IsCancelled", candidateInterviewScheduleSearchInputModel.IsCancelled);
                    vParams.Add("@IsRescheduled", candidateInterviewScheduleSearchInputModel.IsRescheduled);
                    vParams.Add("@ScheduleComments", candidateInterviewScheduleSearchInputModel.ScheduleComments);
                    //vParams.Add("@IsArchived", candidateInterviewScheduleSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateInterviewScheduleSearchOutputModel>(StoredProcedureConstants.SpSearchCandidateInterviewSchedules, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateInterviewSchedule", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateInterviewSchedule);
                return new List<CandidateInterviewScheduleSearchOutputModel>();
            }
        }

        public List<CandidateInterviewScheduleSearchOutputModel> GetCandidateInterviewer(CandidateInterviewScheduleSearchInputModel candidateInterviewScheduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewScheduleSearchInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@PageNumber", candidateInterviewScheduleSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", candidateInterviewScheduleSearchInputModel.PageSize);
                    vParams.Add("@InterviewTypeId", candidateInterviewScheduleSearchInputModel.InterviewTypeId);
                    vParams.Add("@CandidateId", candidateInterviewScheduleSearchInputModel.CandidateId);
                    vParams.Add("@InterviwerId", candidateInterviewScheduleSearchInputModel.StartTime);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateInterviewScheduleSearchOutputModel>(StoredProcedureConstants.SpGetInterviewers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateInterviewer", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateInterviewSchedule);
                return new List<CandidateInterviewScheduleSearchOutputModel>();
            }
        }

        public Guid? UpsertCandidateInterviewFeedBack(CandidateInterviewFeedBackUpsertInputModel candidateInterviewFeedBackUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewFeedBackId", candidateInterviewFeedBackUpsertInputModel.CandidateInterviewFeedBackId);
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewFeedBackUpsertInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@InterviewRatingId", candidateInterviewFeedBackUpsertInputModel.InterviewRatingId);
                    vParams.Add("@TimeStamp", candidateInterviewFeedBackUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateInterviewFeedBack, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateInterviewFeedBack", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateInterviewFeedBack);
                return null;
            }
        }

        public List<CandidateInterviewFeedbackSearchOutputModel> GetCandidateInterviewFeedBack(CandidateInterviewFeedbackSearchInputModel candidateInterviewFeedbackSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewFeedBackId", candidateInterviewFeedbackSearchInputModel.CandidateInterviewFeedBackId);
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewFeedbackSearchInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@InterviewRatingId", candidateInterviewFeedbackSearchInputModel.InterviewRatingId);
                    //vParams.Add("@IsArchived", candidateInterviewFeedbackSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateInterviewFeedbackSearchOutputModel>(StoredProcedureConstants.SpGetCandidateInterviewFeedBack, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateInterviewFeedBack", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateInterviewFeedBack);
                return new List<CandidateInterviewFeedbackSearchOutputModel>();
            }
        }

        public Guid? UpsertCandidateInterviewFeedBackComments(CandidateInterviewFeedBackCommentsUpsertInputModel candidateInterviewFeedBackCommentsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewFeedBackCommentsId", candidateInterviewFeedBackCommentsUpsertInputModel.CandidateInterviewFeedBackCommentsId);
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewFeedBackCommentsUpsertInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@AssigneeComments", candidateInterviewFeedBackCommentsUpsertInputModel.AssigneeComments);
                    vParams.Add("@AssigneeId", candidateInterviewFeedBackCommentsUpsertInputModel.AssigneeId);
                    vParams.Add("@TimeStamp", candidateInterviewFeedBackCommentsUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCandidateInterviewFeedBackComments, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCandidateInterviewFeedBackComments", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCandidateInterviewFeedBackComments);
                return null;
            }
        }

        public List<CandidateInterviewFeedbackCommentsSearchOutputModel> GetCandidateInterviewFeedBackComments(CandidateInterviewFeedbackCommentsSearchInputModel candidateInterviewFeedbackCommentsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewFeedBackCommentsId", candidateInterviewFeedbackCommentsSearchInputModel.CandidateInterviewFeedBackCommentsId);
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewFeedbackCommentsSearchInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@AssigneeComments", candidateInterviewFeedbackCommentsSearchInputModel.AssigneeComments);
                    vParams.Add("@AssigneeId", candidateInterviewFeedbackCommentsSearchInputModel.AssigneeId);
                    //vParams.Add("@IsArchived", candidateInterviewFeedbackCommentsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateInterviewFeedbackCommentsSearchOutputModel>(StoredProcedureConstants.SpGetCandidateInterviewFeedBackComments, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCandidateInterviewFeedBackComments", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateInterviewFeedBackComments);
                return new List<CandidateInterviewFeedbackCommentsSearchOutputModel>();
            }
        }
        public CandidateInterviewScheduleSearchOutputModel CancelInterviewSchedule(CandidateInterviewScheduleUpsertInputModel candidateInterviewscheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewscheduleUpsertInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@InterviewTypeId", candidateInterviewscheduleUpsertInputModel.InterviewTypeId);
                    vParams.Add("@CandidateId", candidateInterviewscheduleUpsertInputModel.CandidateId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CancelComment", candidateInterviewscheduleUpsertInputModel.CancelComment);
                    return vConn.Query<CandidateInterviewScheduleSearchOutputModel>(StoredProcedureConstants.SpCancelCandidateInterviewSchedule, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CancelInterviewSchedule", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCancelSchedulling);
                return null;
            }
        }
        public List<CandidateInterviewScheduleSearchOutputModel> GetScheduleAssigneeDetails(CandidateInterviewScheduleUpsertInputModel candidateInterviewScheduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CandidateInterviewScheduleId", candidateInterviewScheduleUpsertInputModel.CandidateInterviewScheduleId);
                    vParams.Add("@IsArchived", candidateInterviewScheduleUpsertInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CandidateInterviewScheduleSearchOutputModel>(StoredProcedureConstants.SpGetCandidateInterviewScheduleAssignees, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScheduleAssigneeDetails", "Recruitment Repository", sqlException));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCandidateInterviewFeedBackComments);
                return new List<CandidateInterviewScheduleSearchOutputModel>();
            }
        }
    }
}