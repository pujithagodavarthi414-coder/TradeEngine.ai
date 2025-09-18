using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using BTrak.Common;
using Dapper;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.TestRail;
using Btrak.Models.UserStory;
using Btrak.Models.MasterData;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ComplianceAuditRepository : BaseRepository
    {
        public Guid? UpsertAuditCompliance(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@ParentAuditId", auditComplianceApiInputModel.ParentAuditId);
                    vParams.Add("@AuditComplianceName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@AuditDescription", auditComplianceApiInputModel.AuditDescription);
                    vParams.Add("@IsRAG", auditComplianceApiInputModel.IsRAG);
                    vParams.Add("@InboundPercent", auditComplianceApiInputModel.InBoundPercent);
                    vParams.Add("@OutboundPercent", auditComplianceApiInputModel.OutBoundPercent);
                    vParams.Add("@ResponsibleUserId ", auditComplianceApiInputModel.ResponsibleUserId);
                    vParams.Add("@RecurringAudit", auditComplianceApiInputModel.RecurringAudit);
                    vParams.Add("@CanLogTime", auditComplianceApiInputModel.CanLogTime);
                    vParams.Add("@CronExpression", auditComplianceApiInputModel.CronExpression);
                    vParams.Add("@ScheduleEndDate", auditComplianceApiInputModel.ScheduleEndDate);
                    vParams.Add("@IsPaused", auditComplianceApiInputModel.IsPaused);
                    vParams.Add("@TimeStamp", auditComplianceApiInputModel.TimeStamp, DbType.Binary);//@ResponsibleUserId 
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SchedulingDetails", auditComplianceApiInputModel.SchedulingDetailsString);
                    vParams.Add("@ProjectId", auditComplianceApiInputModel.ProjectId);
                    vParams.Add("@EnableQuestionLevelWorkFlow", auditComplianceApiInputModel.EnableQuestionLevelWorkFlow);
                    vParams.Add("@EnableWorkFlowForAudit", auditComplianceApiInputModel.EnableWorkFlowForAudit);
                    vParams.Add("@EnableWorkFlowForAuditConduct", auditComplianceApiInputModel.EnableWorkFlowForAuditConduct);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPUpsertAuditCompliance, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditCompliance", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditCategory);
                return null;
            }
        }

        public Guid? UpsertAuditFolder(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditFolderId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@AuditFolderName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@Description", auditComplianceApiInputModel.AuditDescription);
                    vParams.Add("@ParentAuditFolderId", auditComplianceApiInputModel.ParentAuditId);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@ProjectId", auditComplianceApiInputModel.ProjectId);
                    vParams.Add("@TimeStamp", auditComplianceApiInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPUpsertAuditFolder, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFolder", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditCategory);
                return null;
            }
        }

        public Guid? UnArchiveAuditOrConduct(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@ConductId", auditComplianceApiInputModel.ConductId);
                    vParams.Add("@IsAudit", auditComplianceApiInputModel.IsAudit);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPUnArchiveAuditOrConduct, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UnArchiveAuditOrConduct", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditCategory);
                return null;
            }
        }

        public Guid? CloneAudit(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@AuditComplianceName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPCloneAudit, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CloneAudit", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCloneAudit);
                return null;
            }
        }
        public Guid? CloneAuditByVersionId(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@AuditComplianceName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@AuditComplianceVersionId", auditComplianceApiInputModel.AuditVersionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPCloneAuditBasedOnVersionId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CloneAuditByVersionId", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCloneAudit);
                return null;
            }
        }

        public Guid? UpsertAuditTags(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@ConductId", auditComplianceApiInputModel.ConductId);
                    vParams.Add("@TagsXml", auditComplianceApiInputModel.AuditTagsModelXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAuditTags, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditTags", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditTags);
                return null;
            }
        }

        public Guid? UpsertAuditPriority(AuditPriorityModel auditPriorityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PriorityId", auditPriorityModel.PriorityId);
                    vParams.Add("@PriorityName", auditPriorityModel.PriorityName);
                    vParams.Add("@Description", auditPriorityModel.Description);
                    vParams.Add("@IsArchived", auditPriorityModel.IsArchive);
                    vParams.Add("@TimeStamp", auditPriorityModel.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAuditPriority, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditPriority", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditPriority);
                return null;
            }
        }

        public Guid? UpsertActionCategory(ActionCategoryModel actionCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ActionCategoryId", actionCategoryModel.ActionCategoryId);
                    vParams.Add("@ActionCategoryName", actionCategoryModel.ActionCategoryName);
                    vParams.Add("@IsArchived", actionCategoryModel.IsArchived);
                    vParams.Add("@TimeStamp", actionCategoryModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertActionCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActionCategory", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertActionCategory);
                return null;
            }
        }

        public Guid? UpsertAuditRating(AuditRatingModel auditRatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditRatingId", auditRatingModel.AuditRatingId);
                    vParams.Add("@AuditRatingName", auditRatingModel.AuditRatingName);
                    vParams.Add("@IsArchived", auditRatingModel.IsArchived);
                    vParams.Add("@TimeStamp", auditRatingModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAuditRating, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditRating", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditRating);
                return null;
            }
        }


        public Guid? UpsertAuditImpact(AuditImpactModel auditImpactModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ImpactId", auditImpactModel.ImpactId);
                    vParams.Add("@ImpactName", auditImpactModel.ImpactName);
                    vParams.Add("@Description", auditImpactModel.Description);
                    vParams.Add("@IsArchived", auditImpactModel.IsArchive);
                    vParams.Add("@TimeStamp", auditImpactModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAuditImpact, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditImpact", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditImpact);
                return null;
            }
        }

        public List<AuditPriorityModel> GetAuditPriority(AuditPriorityModel auditPriorityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", auditPriorityModel.IsArchive);
                    return vConn.Query<AuditPriorityModel>(StoredProcedureConstants.SpGetAuditPriority, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditPriority", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditPriority);

                return new List<AuditPriorityModel>();
            }
        }

        public List<ActionCategoryModel> GetActionCategories(ActionCategoryModel actionCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ActionCategoryId", actionCategoryModel.ActionCategoryId);
                    vParams.Add("@ActionCategoryName", actionCategoryModel.ActionCategoryName);
                    vParams.Add("@IsArchived", actionCategoryModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ActionCategoryModel>(StoredProcedureConstants.SpGetActionCategories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActionCategories", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetActionCategories);

                return new List<ActionCategoryModel>();
            }
        }

        public List<AuditRatingModel> GetAuditRatings(AuditRatingModel auditRatingModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditRatingId", auditRatingModel.AuditRatingId);
                    vParams.Add("@AuditRatingName", auditRatingModel.AuditRatingName);
                    vParams.Add("@IsArchived", auditRatingModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditRatingModel>(StoredProcedureConstants.SpGetAuditRatings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditRatings", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditRating);

                return new List<AuditRatingModel>();
            }
        }

        public Guid? UpsertAuditRisk(AuditRiskModel auditRiskModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RiskId", auditRiskModel.RiskId);
                    vParams.Add("@RiskName", auditRiskModel.RiskName);
                    vParams.Add("@Description", auditRiskModel.Description);
                    vParams.Add("@IsArchived", auditRiskModel.IsArchive);
                    vParams.Add("@TimeStamp", auditRiskModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertAuditRisk, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditRisk", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditImpact);
                return null;
            }
        }

        public List<AuditRiskModel> GetAuditRisk(AuditRiskModel auditRiskModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", auditRiskModel.IsArchive);
                    return vConn.Query<AuditRiskModel>(StoredProcedureConstants.SpGetAuditRisk, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditRisk", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditPriority);
                return new List<AuditRiskModel>();
            }
        }

        public List<AuditImpactModel> GetAuditImpact(AuditImpactModel auditImpactModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", auditImpactModel.IsArchive);
                    return vConn.Query<AuditImpactModel>(StoredProcedureConstants.SpGetAuditImpact, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditImpact", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditImpact);

                return new List<AuditImpactModel>();
            }
        }

        public Guid? SubmitAuditConductQuestion(SubmitAuditConductApiInputModel submitAuditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ConductAnswerSubmittedId", submitAuditConductApiInputModel.ConductAnswerSubmittedId);
                    vParams.Add("@AuditConductAnswerId", submitAuditConductApiInputModel.AuditConductAnswerId);
                    vParams.Add("@IsArchived", submitAuditConductApiInputModel.IsArchived);
                    vParams.Add("@AnswerComment", submitAuditConductApiInputModel.AnswerComment);
                    vParams.Add("@QuestionDateAnswer", submitAuditConductApiInputModel.QuestionOptionDate);
                    vParams.Add("@QuestionTextAnswer", submitAuditConductApiInputModel.QuestionOptionText);
                    vParams.Add("@QuestionNumericAnswer", submitAuditConductApiInputModel.QuestionOptionNumeric);
                    vParams.Add("@QuestionTimeAnswer", submitAuditConductApiInputModel.QuestionOptionTime);
                    vParams.Add("@TimeStamp", submitAuditConductApiInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPSubmitAuditConductQuestion, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SubmitAuditConductQuestion", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditCategory);
                return null;
            }
        }

        public List<AuditComplianceApiReturnModel> SearchAudits(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@MultipleAuditIdsXml", auditComplianceApiInputModel.MultipleAuditIdsXml);
                    vParams.Add("@AuditComplianceName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@AuditDescription", auditComplianceApiInputModel.AuditDescription);
                    vParams.Add("@SearchText", auditComplianceApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@ProjectId", auditComplianceApiInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsForFilter", auditComplianceApiInputModel.IsForFilter);
                    return vConn.Query<AuditComplianceApiReturnModel>(StoredProcedureConstants.SPGetAuditCompliance, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAudits", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditComplianceApiReturnModel>();
            }
        }

        public List<AuditComplianceApiReturnModel> SearchAuditsByAuditVersionId(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@MultipleAuditIdsXml", auditComplianceApiInputModel.MultipleAuditIdsXml);
                    vParams.Add("@AuditComplianceName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@AuditDescription", auditComplianceApiInputModel.AuditDescription);
                    vParams.Add("@SearchText", auditComplianceApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@ProjectId", auditComplianceApiInputModel.ProjectId);
                    vParams.Add("@AuditComplianceVersionId", auditComplianceApiInputModel.AuditVersionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditComplianceApiReturnModel>(StoredProcedureConstants.SPGetAuditComplianceBasedOnVersionId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditsByAuditVersionId", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditComplianceApiReturnModel>();
            }
        }

        public List<AuditComplianceApiReturnModel> GetAuditsFolderView(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@AuditComplianceName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@MultipleAuditIdsXml", auditComplianceApiInputModel.MultipleAuditIdsXml);
                    vParams.Add("@SearchText", auditComplianceApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@DateFrom", auditComplianceApiInputModel.DateFrom);
                    vParams.Add("@DateTo", auditComplianceApiInputModel.DateTo);
                    vParams.Add("@ResponsibleUserId", auditComplianceApiInputModel.UserId);
                    vParams.Add("@PeriodValue", auditComplianceApiInputModel.PeriodValue);
                    vParams.Add("@BranchId", auditComplianceApiInputModel.BranchId);
                    vParams.Add("@ProjectId", auditComplianceApiInputModel.ProjectId);
                    vParams.Add("@BusinessUnitIds", auditComplianceApiInputModel.BusinessUnitIdsList);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditComplianceApiReturnModel>(StoredProcedureConstants.SPGetAuditsFolderView, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditsFolderView", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditComplianceApiReturnModel>();
            }
        }

        public List<AuditComplianceApiReturnModel> GetArchivedAuditsFolderView(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@AuditComplianceName", auditComplianceApiInputModel.AuditName);
                    vParams.Add("@MultipleAuditIdsXml", auditComplianceApiInputModel.MultipleAuditIdsXml);
                    vParams.Add("@SearchText", auditComplianceApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditComplianceApiInputModel.IsArchived);
                    vParams.Add("@DateFrom", auditComplianceApiInputModel.DateFrom);
                    vParams.Add("@DateTo", auditComplianceApiInputModel.DateTo);
                    vParams.Add("@ResponsibleUserId", auditComplianceApiInputModel.UserId);
                    vParams.Add("@PeriodValue", auditComplianceApiInputModel.PeriodValue);
                    vParams.Add("@BranchId", auditComplianceApiInputModel.BranchId);
                    vParams.Add("@ProjectId", auditComplianceApiInputModel.ProjectId);
                    vParams.Add("@BusinessUnitIds", auditComplianceApiInputModel.BusinessUnitIdsList);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditComplianceApiReturnModel>(StoredProcedureConstants.SPGetArchivedAuditsFolderView, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetArchivedAuditsFolderView", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditComplianceApiReturnModel>();
            }
        }

        public List<AuditComplianceApiReturnModel> SearchAuditFolders(AuditComplianceApiInputModel auditComplianceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditFolderId", auditComplianceApiInputModel.AuditId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditComplianceApiReturnModel>(StoredProcedureConstants.SPSearchAuditFolders, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditFolders", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditComplianceApiReturnModel>();
            }
        }

        public Guid? UpsertAuditCategory(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditCategoryId", auditCategoryApiInputModel.AuditCategoryId);
                    vParams.Add("@AuditCategoryName", auditCategoryApiInputModel.AuditCategoryName);
                    vParams.Add("@IsArchived", auditCategoryApiInputModel.IsArchived);
                    vParams.Add("@AuditCategoryDescription", auditCategoryApiInputModel.AuditCategoryDescription);
                    vParams.Add("@AuditComplianceId", auditCategoryApiInputModel.AuditId);
                    vParams.Add("@ParentAuditCategoryId", auditCategoryApiInputModel.ParentAuditCategoryId);
                    vParams.Add("@TimeStamp", auditCategoryApiInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPUpsertAuditCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditCategory", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditCategory);
                return null;
            }
        }

        public List<ConductSelectedQuestionModel> GetConductSelectedQuestions(Guid? conductId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", conductId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ConductSelectedQuestionModel>(StoredProcedureConstants.SPGetConductSelectedQuestions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductSelectedQuestions", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<ConductSelectedQuestionModel>();
            }
        }

        public List<Guid?> GetConductSelectedCategories(Guid? conductId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", conductId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPGetConductSelectedCategories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductSelectedCategories", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchTestCases);

                return new List<Guid?>();
            }
        }

        public Guid? UpsertAuditConduct(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", auditConductApiInputModel.ConductId);
                    vParams.Add("@AuditConductName", auditConductApiInputModel.AuditConductName);
         
                    vParams.Add("@IsIncludeAllQuestions", auditConductApiInputModel.IsIncludeAllQuestions);
                    vParams.Add("@SelectedQuestionsXml", auditConductApiInputModel.SelectedQuestionsXml);
                    vParams.Add("@SelectedCategoriesXml", auditConductApiInputModel.SelectedCategoriesXml);
                    vParams.Add("@IsArchived", auditConductApiInputModel.IsArchived);
                    vParams.Add("@IsCompleted", auditConductApiInputModel.IsCompleted);
                    vParams.Add("@AuditConductDescription", auditConductApiInputModel.AuditConductDescription);
                    vParams.Add("@AuditComplianceId", auditConductApiInputModel.AuditId);
                    vParams.Add("@DeadlineDate", auditConductApiInputModel.DeadlineDate);
                    vParams.Add("@ResponsibleUserId", auditConductApiInputModel.ResponsibleUserId);
                    vParams.Add("@TimeStamp", auditConductApiInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@CronStartDate", auditConductApiInputModel.CronStartDate);
                    vParams.Add("@CronEndDate", auditConductApiInputModel.CronEndDate);
                    vParams.Add("@CronExpression", auditConductApiInputModel.CronExpression);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPUpsertAuditConduct, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditConduct", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditConduct);
                return null;
            }
        }

        public List<SelectedQuestionModel> GetFailedQuestionsbyConductId(Guid? conductId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", conductId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SelectedQuestionModel>(StoredProcedureConstants.SPGetFailedQuestionsbyConductId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFailedQuestionsbyConductId", "ComplianceAuditRepository", sqlException.Message),sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditConduct);
                return null;
            }
        }

        public Guid? UpsertAuditReport(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", auditReportApiInputModel.ConductId);
                    vParams.Add("@AuditReportName", auditReportApiInputModel.AuditReportName);
                    vParams.Add("@IsArchived", auditReportApiInputModel.IsArchived);
                    vParams.Add("@AuditReportDescription", auditReportApiInputModel.AuditReportDescription);
                    vParams.Add("@AuditReportId", auditReportApiInputModel.AuditReportId);
                    vParams.Add("@TimeStamp", auditReportApiInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.UpsertAuditReport, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditReport", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditConduct);
                return null;
            }
        }

        public List<AuditCategoryApiReturnModel> SearchAuditCategories(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditCategoryApiInputModel.AuditId);
                    vParams.Add("@AuditConductId", auditCategoryApiInputModel.ConductId);
                    vParams.Add("@AuditCategoryId", auditCategoryApiInputModel.AuditCategoryId);
                    vParams.Add("@AuditCategoryName", auditCategoryApiInputModel.AuditCategoryName);
                    vParams.Add("@ParentAuditCategoryId", auditCategoryApiInputModel.ParentAuditCategoryId);
                    vParams.Add("@SearchText", auditCategoryApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditCategoryApiInputModel.IsArchived);
                    vParams.Add("@IsCategoriesRequired", auditCategoryApiInputModel.IsCategoriesRequired);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditCategoryApiReturnModel>(StoredProcedureConstants.SPGetAuditCategories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditReport", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditCategoryApiReturnModel>();
            }
        }

        public List<AuditCategoryApiReturnModel> SearchAuditCategoriesByVersionId(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditCategoryApiInputModel.AuditId);
                    vParams.Add("@AuditConductId", auditCategoryApiInputModel.ConductId);
                    vParams.Add("@AuditCategoryId", auditCategoryApiInputModel.AuditCategoryId);
                    vParams.Add("@AuditCategoryName", auditCategoryApiInputModel.AuditCategoryName);
                    vParams.Add("@ParentAuditCategoryId", auditCategoryApiInputModel.ParentAuditCategoryId);
                    vParams.Add("@SearchText", auditCategoryApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditCategoryApiInputModel.IsArchived);
                    vParams.Add("@IsCategoriesRequired", auditCategoryApiInputModel.IsCategoriesRequired);
                    vParams.Add("@AuditComplianceVersionId", auditCategoryApiInputModel.AuditVersionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditCategoryApiReturnModel>(StoredProcedureConstants.SPGetAuditCategoriesBasedOnVersionId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditCategoriesByVersionId", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditCategoryApiReturnModel>();
            }
        }

        public List<AuditCategoryApiReturnModel> SearchConductCategories(AuditCategoryApiInputModel auditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditCategoryApiInputModel.AuditId);
                    vParams.Add("@AuditConductId", auditCategoryApiInputModel.ConductId);
                    vParams.Add("@AuditCategoryId", auditCategoryApiInputModel.AuditCategoryId);
                    vParams.Add("@AuditCategoryName", auditCategoryApiInputModel.AuditCategoryName);
                    vParams.Add("@ParentAuditCategoryId", auditCategoryApiInputModel.ParentAuditCategoryId);
                    vParams.Add("@SearchText", auditCategoryApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditCategoryApiInputModel.IsArchived);
                    vParams.Add("@IsCategoriesRequired", auditCategoryApiInputModel.IsCategoriesRequired);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditCategoryApiReturnModel>(StoredProcedureConstants.SPGetConductCategories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchConductCategories", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditCategoryApiReturnModel>();
            }
        }

        public List<DropdownModel> GetCategoriesAndSubcategories(Guid? auditId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", auditId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DropdownModel>(StoredProcedureConstants.SpGetCategoriesAndSubcategories, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCategoriesAndSubcategories", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCategoriesAndSubCategories);

                return new List<DropdownModel>();
            }
        }
        public List<DropdownModel> GetCategoriesAndSubcategoriesByVersionId(Guid? auditId, Guid? auditVersionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", auditId);
                    vParams.Add("@AuditComplianceVersionId", auditVersionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DropdownModel>(StoredProcedureConstants.SpGetCategoriesAndSubcategoriesBasedOnVersionId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCategoriesAndSubcategoriesByVersionId", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCategoriesAndSubCategories);

                return new List<DropdownModel>();
            }
        }

        public List<AuditTagsModel> GetTags(string searchText, string selectedIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@SelectedIds", selectedIds);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditTagsModel>(StoredProcedureConstants.SpGetSystemWideRolesAndBranchesAndEmployeesAsTags, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTags", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTags);

                return new List<AuditTagsModel>();
            }
        }

        public List<TimeSheetApproveLineManagersOutputModel> GetConductsUserDropDown(bool isBranchFilter ,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@isBranchFilter", isBranchFilter);
                    return vConn.Query<TimeSheetApproveLineManagersOutputModel>(StoredProcedureConstants.SpGetConductUserDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductsUserDropDown", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTags);

                return new List<TimeSheetApproveLineManagersOutputModel>();
            }
        }

        public List<AuditConductApiReturnModel> SearchAuditConducts(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", auditConductApiInputModel.ConductId);
                    vParams.Add("@AuditComplianceId", auditConductApiInputModel.AuditId);
                    vParams.Add("@AuditConductName", auditConductApiInputModel.AuditConductName);
                    vParams.Add("@SearchText", auditConductApiInputModel.SearchText);
                    vParams.Add("@IsCompleted", auditConductApiInputModel.IsCompleted);
                    vParams.Add("@IsArchived", auditConductApiInputModel.IsArchived);
                    vParams.Add("@DateFrom", auditConductApiInputModel.DateFrom);
                    vParams.Add("@DateTo", auditConductApiInputModel.DateTo);
                    vParams.Add("@UserId", auditConductApiInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PeriodValue", auditConductApiInputModel.PeriodValue);
                    vParams.Add("@StatusFilter", auditConductApiInputModel.StatusFilter);
                    vParams.Add("@BranchId", auditConductApiInputModel.BranchId);
                    vParams.Add("@ProjectId", auditConductApiInputModel.ProjectId);
                    return vConn.Query<AuditConductApiReturnModel>(StoredProcedureConstants.SearchAuditConducts, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditConducts", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchAuditConduct);
                return new List<AuditConductApiReturnModel>();
            }
        }

        public List<AuditConductApiReturnModel> GetConductsFolderView(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", auditConductApiInputModel.ConductId);
                    vParams.Add("@AuditComplianceId", auditConductApiInputModel.AuditId);
                    vParams.Add("@AuditConductName", auditConductApiInputModel.AuditConductName);
                    vParams.Add("@SearchText", auditConductApiInputModel.SearchText);
                    vParams.Add("@IsCompleted", auditConductApiInputModel.IsCompleted);
                    vParams.Add("@IsArchived", auditConductApiInputModel.IsArchived);
                    vParams.Add("@DateFrom", auditConductApiInputModel.DateFrom);
                    vParams.Add("@DateTo", auditConductApiInputModel.DateTo);
                    vParams.Add("@UserId", auditConductApiInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PeriodValue", auditConductApiInputModel.PeriodValue);
                    vParams.Add("@StatusFilter", auditConductApiInputModel.StatusFilter);
                    vParams.Add("@BranchId", auditConductApiInputModel.BranchId);
                    vParams.Add("@ProjectId", auditConductApiInputModel.ProjectId);
                    vParams.Add("@BusinessUnitIds", auditConductApiInputModel.BusinessUnitIdsList);
                    return vConn.Query<AuditConductApiReturnModel>(StoredProcedureConstants.SPGetConductsFolderView, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductsFolderView", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchAuditConduct);
                return new List<AuditConductApiReturnModel>();
            }
        }

        public List<AuditConductApiReturnModel> GetArchivedConductsFolderView(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", auditConductApiInputModel.ConductId);
                    vParams.Add("@AuditComplianceId", auditConductApiInputModel.AuditId);
                    vParams.Add("@AuditConductName", auditConductApiInputModel.AuditConductName);
                    vParams.Add("@SearchText", auditConductApiInputModel.SearchText);
                    vParams.Add("@IsCompleted", auditConductApiInputModel.IsCompleted);
                    vParams.Add("@IsArchived", auditConductApiInputModel.IsArchived);
                    vParams.Add("@DateFrom", auditConductApiInputModel.DateFrom);
                    vParams.Add("@DateTo", auditConductApiInputModel.DateTo);
                    vParams.Add("@UserId", auditConductApiInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PeriodValue", auditConductApiInputModel.PeriodValue);
                    vParams.Add("@StatusFilter", auditConductApiInputModel.StatusFilter);
                    vParams.Add("@BranchId", auditConductApiInputModel.BranchId);
                    vParams.Add("@ProjectId", auditConductApiInputModel.ProjectId);
                    vParams.Add("@BusinessUnitIds", auditConductApiInputModel.BusinessUnitIdsList);
                    return vConn.Query<AuditConductApiReturnModel>(StoredProcedureConstants.SPGetArchivedConductsFolderView, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetArchivedConductsFolderView", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchAuditConduct);
                return new List<AuditConductApiReturnModel>();
            }
        }

        public List<AuditReportApiReturnModel> GetAuditReports(AuditReportApiInputModel auditReportApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditReportId", auditReportApiInputModel.AuditReportId);
                    vParams.Add("@AuditConductId", auditReportApiInputModel.ConductId);
                    vParams.Add("@AuditReportName", auditReportApiInputModel.AuditReportName);
                    vParams.Add("@SearchText", auditReportApiInputModel.SearchText);
                    vParams.Add("@IsArchived", auditReportApiInputModel.IsArchived);
                    vParams.Add("@IsForMail", auditReportApiInputModel.IsForMail);
                    vParams.Add("@IsForPdf", auditReportApiInputModel.IsForPdf);
                    vParams.Add("@ProjectId", auditReportApiInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditReportApiReturnModel>(StoredProcedureConstants.GetAuditReports, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditReports", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchAuditConduct);
                return new List<AuditReportApiReturnModel>();
            }
        }

        public List<QuestionTypeApiReturnModel> GetQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionTypeId", questionTypeApiInputModel.QuestionTypeId);
                    vParams.Add("@QuestionTypeName", questionTypeApiInputModel.QuestionTypeName);
                    vParams.Add("@SearchText", questionTypeApiInputModel.SearchText);
                    vParams.Add("@IsArchived", questionTypeApiInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<QuestionTypeApiReturnModel>(StoredProcedureConstants.GetQuestionTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQuestionTypes", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionTypes);
                return new List<QuestionTypeApiReturnModel>();
            }
        }

        public List<QuestionTypeApiReturnModel> GetQuestionTypeById(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionTypeId", questionTypeApiInputModel.QuestionTypeId);
                    vParams.Add("@QuestionTypeName", questionTypeApiInputModel.QuestionTypeName);
                    vParams.Add("@SearchText", questionTypeApiInputModel.SearchText);
                    vParams.Add("@IsArchived", questionTypeApiInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<QuestionTypeApiReturnModel>(StoredProcedureConstants.GetQuestionTypeById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQuestionTypeById", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionTypes);
                return new List<QuestionTypeApiReturnModel>();
            }
        }

        public List<QuestionTypeApiReturnModel> GetMasterQuestionTypes(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", questionTypeApiInputModel.SearchText);
                    return vConn.Query<QuestionTypeApiReturnModel>(StoredProcedureConstants.SPGetMasterQuestionTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMasterQuestionTypes", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionTypes);
                return new List<QuestionTypeApiReturnModel>();
            }
        }

        public Guid? UpsertQuestionType(QuestionTypeApiInputModel questionTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionTypeId", questionTypeApiInputModel.QuestionTypeId);
                    vParams.Add("@QuestionTypeName", questionTypeApiInputModel.QuestionTypeName);
                    vParams.Add("@MasterQuestionTypeId", questionTypeApiInputModel.MasterQuestionTypeId);
                    vParams.Add("@QuestionTypeOptions", questionTypeApiInputModel.QuestionTypeOptionsXml);
                    vParams.Add("@IsFromMasterQuestionType", questionTypeApiInputModel.IsFromMasterQuestionType);
                    vParams.Add("@IsArchived", questionTypeApiInputModel.IsArchived);
                    vParams.Add("@TimeStamp", questionTypeApiInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertQuestionType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertQuestionType", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertQuestionType);
                return null;
            }
        }

        public AuditRelatedCountsApiReturnModel GetAuditRelatedCounts(Guid? projectId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", projectId);
                    return vConn.Query<AuditRelatedCountsApiReturnModel>(StoredProcedureConstants.SPGetAuditsRelatedCounts, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditRelatedCounts", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditRelatedCounts);
                return new AuditRelatedCountsApiReturnModel();
            }
        }

        public List<ConductQuestionActions> GetConductQuestionsForActionLinking(Guid? projectId, string questionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", projectId);
                    vParams.Add("QuestionName", questionName);
                    return vConn.Query<ConductQuestionActions>(StoredProcedureConstants.SPGetConductQuestionsForActionLinking, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConductQuestionsForActionLinking", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditRelatedCounts);
                return null;
            }
        }

        public Guid? UpsertAuditQuestion(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionTypeId", auditQuestionsApiInputModel.QuestionTypeId);
                    vParams.Add("@QuestionDescription", auditQuestionsApiInputModel.QuestionDescription);
                    vParams.Add("@QuestionId", auditQuestionsApiInputModel.QuestionId);
                    vParams.Add("@QuestionName", auditQuestionsApiInputModel.QuestionName);
                    vParams.Add("@QuestionHint", auditQuestionsApiInputModel.QuestionHint);
                    vParams.Add("@EstimatedTime", auditQuestionsApiInputModel.EstimatedTime);
                    vParams.Add("@AuditCategoryId", auditQuestionsApiInputModel.AuditCategoryId);
                    vParams.Add("@AuditAnswersModel", auditQuestionsApiInputModel.AuditAnswersModel);
                    vParams.Add("@DocumentsModel", auditQuestionsApiInputModel.DocumentsModel);
                    vParams.Add("@IsOriginalQuestionTypeScore", auditQuestionsApiInputModel.IsOriginalQuestionTypeScore);
                    vParams.Add("@IsQuestionMandatory", auditQuestionsApiInputModel.IsQuestionMandatory);
                    vParams.Add("@ImpactId", auditQuestionsApiInputModel.ImpactId);
                    vParams.Add("@PriorityId", auditQuestionsApiInputModel.PriorityId);
                    vParams.Add("@RiskId", auditQuestionsApiInputModel.RiskId);
                    vParams.Add("@IsArchived", auditQuestionsApiInputModel.IsArchived);
                    vParams.Add("@TimeStamp", auditQuestionsApiInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@RoleIds", auditQuestionsApiInputModel.SelectedRoleIds);
                    vParams.Add("@CanEdit", auditQuestionsApiInputModel.CanEdit);
                    vParams.Add("@CanView", auditQuestionsApiInputModel.CanView);
                    vParams.Add("@CanAddAction", auditQuestionsApiInputModel.CanAddAction);
                    vParams.Add("@NoPermission", auditQuestionsApiInputModel.NoPermission);
                    vParams.Add("@SelectedEmployees", auditQuestionsApiInputModel.SelectedEmployees);
                    vParams.Add("@QuestionResponsiblePersonId", auditQuestionsApiInputModel.QuestionResponsiblePersonId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPUpsertAuditQuestion, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditQuestion", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return null;
            }
        }

        public List<AuditQuestionsApiReturnModel> GetAuditQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionId", auditQuestionsApiInputModel.QuestionId);
                    vParams.Add("@QuestionName", auditQuestionsApiInputModel.QuestionName);
                    vParams.Add("@SearchText", auditQuestionsApiInputModel.SearchText);
                    vParams.Add("@AuditCategoryId", auditQuestionsApiInputModel.AuditCategoryId);
                    vParams.Add("@IsHierarchical", auditQuestionsApiInputModel.IsHierarchical);
                    vParams.Add("@IsArchived", auditQuestionsApiInputModel.IsArchived);
                    vParams.Add("@IsForViewHistory", auditQuestionsApiInputModel.IsForViewHistory);
                    vParams.Add("@CreatedOn", auditQuestionsApiInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", auditQuestionsApiInputModel.UpdatedOn);
                    vParams.Add("@SortBy", auditQuestionsApiInputModel.SortBy);
                    vParams.Add("@QuestionTypeFilterXml", auditQuestionsApiInputModel.QuestionTypeFilterXml);
                    vParams.Add("@QuestionIdsXml", auditQuestionsApiInputModel.QuestionIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditQuestionsApiReturnModel>(StoredProcedureConstants.SPGetAuditQuestions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditQuestions", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionTypes);
                return new List<AuditQuestionsApiReturnModel>();
            }
        }

        public List<AuditQuestionsApiReturnModel> GetAuditQuestionsByVersionId(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionId", auditQuestionsApiInputModel.QuestionId);
                    vParams.Add("@QuestionName", auditQuestionsApiInputModel.QuestionName);
                    vParams.Add("@SearchText", auditQuestionsApiInputModel.SearchText);
                    vParams.Add("@AuditCategoryId", auditQuestionsApiInputModel.AuditCategoryId);
                    vParams.Add("@IsHierarchical", auditQuestionsApiInputModel.IsHierarchical);
                    vParams.Add("@IsArchived", auditQuestionsApiInputModel.IsArchived);
                    vParams.Add("@IsForViewHistory", auditQuestionsApiInputModel.IsForViewHistory);
                    vParams.Add("@CreatedOn", auditQuestionsApiInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", auditQuestionsApiInputModel.UpdatedOn);
                    vParams.Add("@SortBy", auditQuestionsApiInputModel.SortBy);
                    vParams.Add("@QuestionTypeFilterXml", auditQuestionsApiInputModel.QuestionTypeFilterXml);
                    vParams.Add("@QuestionIdsXml", auditQuestionsApiInputModel.QuestionIdsXml);
                    vParams.Add("@AuditComplianceVersionId", auditQuestionsApiInputModel.AuditVersionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditQuestionsApiReturnModel>(StoredProcedureConstants.SPGetAuditQuestionsBasedOnVersionId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditQuestionsByVersionId", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionTypes);
                return new List<AuditQuestionsApiReturnModel>();
            }
        }


        public List<AuditQuestionsApiReturnModel> SearchAuditConductQuestions(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionId", auditQuestionsApiInputModel.QuestionId);
                    vParams.Add("@AuditConductQuestionId", auditQuestionsApiInputModel.AuditConductQuestionId);
                    vParams.Add("@AuditConductId", auditQuestionsApiInputModel.ConductId);
                    vParams.Add("@QuestionName", auditQuestionsApiInputModel.QuestionName);
                    vParams.Add("@SearchText", auditQuestionsApiInputModel.SearchText);
                    vParams.Add("@AuditCategoryId", auditQuestionsApiInputModel.AuditCategoryId);
                    vParams.Add("@IsHierarchical", auditQuestionsApiInputModel.IsHierarchical);
                    vParams.Add("@IsArchived", auditQuestionsApiInputModel.IsArchived);
                    vParams.Add("@IsForViewHistory", auditQuestionsApiInputModel.IsForViewHistory);
                    vParams.Add("@CreatedOn", auditQuestionsApiInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", auditQuestionsApiInputModel.UpdatedOn);
                    vParams.Add("@SortBy", auditQuestionsApiInputModel.SortBy);
                    vParams.Add("@AuditReportId", auditQuestionsApiInputModel.AuditReportId);
                    vParams.Add("@IsPdf", auditQuestionsApiInputModel.IsMailPdf);
                    vParams.Add("@QuestionTypeFilterXml", auditQuestionsApiInputModel.QuestionTypeFilterXml);
                    vParams.Add("@QuestionIdsXml", auditQuestionsApiInputModel.QuestionIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditQuestionsApiReturnModel>(StoredProcedureConstants.SPSearchAuditConductQuestions, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAuditConductQuestions", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchAuditConductQuestions);
                return new List<AuditQuestionsApiReturnModel>();
            }
        }

        public List<ConductSelectedQuestionModel> GetQuestionsByFilters(AuditQuestionsApiInputModel auditQuestionsApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionId", auditQuestionsApiInputModel.QuestionId);
                    vParams.Add("@SearchText", auditQuestionsApiInputModel.SearchText);
                    vParams.Add("@AuditId", auditQuestionsApiInputModel.AuditId);
                    vParams.Add("@AuditCategoryId", auditQuestionsApiInputModel.AuditCategoryId);
                    vParams.Add("@CreatedOn", auditQuestionsApiInputModel.CreatedOn);
                    vParams.Add("@UpdatedOn", auditQuestionsApiInputModel.UpdatedOn);
                    vParams.Add("@QuestionTypeFilterXml", auditQuestionsApiInputModel.QuestionTypeFilterXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ConductSelectedQuestionModel>(StoredProcedureConstants.SPGetQuestionsByFilters, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQuestionsByFilters", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionTypes);
                return new List<ConductSelectedQuestionModel>();
            }
        }

        public List<AuditQuestionHistoryModel> GetAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionId", auditQuestionHistoryModel.QuestionId);
                    vParams.Add("@AuditId", auditQuestionHistoryModel.AuditId);
                    vParams.Add("@ConductId", auditQuestionHistoryModel.ConductId);
                    vParams.Add("@IsFromAuditQuestion", auditQuestionHistoryModel.IsFromAuditQuestion);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditQuestionHistoryModel>(StoredProcedureConstants.SPGetAuditQuestionHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditQuestionHistory", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionHistory);
                return new List<AuditQuestionHistoryModel>();
            }
        }

        public List<AuditQuestionHistoryModel> UpsertAuditQuestionHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionId", auditQuestionHistoryModel.QuestionId);
                    vParams.Add("@AuditId", auditQuestionHistoryModel.AuditId);
                    vParams.Add("@ConductId", auditQuestionHistoryModel.ConductId);
                    vParams.Add("@OldValue", auditQuestionHistoryModel.OldValue);
                    vParams.Add("@NewValue", auditQuestionHistoryModel.NewValue);
                    vParams.Add("@Description", auditQuestionHistoryModel.Description);
                    vParams.Add("@Field", auditQuestionHistoryModel.Field);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditQuestionHistoryModel>(StoredProcedureConstants.SPUpsertAuditQuestionHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditQuestionHistory", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionHistory);
                return new List<AuditQuestionHistoryModel>();
            }
        }

        public List<AuditQuestionHistoryModel> GetAuditOverallHistory(AuditQuestionHistoryModel auditQuestionHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionId", auditQuestionHistoryModel.QuestionId);
                    vParams.Add("@AuditId", auditQuestionHistoryModel.AuditId);
                    vParams.Add("@ConductId", auditQuestionHistoryModel.ConductId);
                    vParams.Add("@UserIdsXml", auditQuestionHistoryModel.UserIdsXml);
                    vParams.Add("@BranchIdsXml", auditQuestionHistoryModel.BranchIdsXml);
                    vParams.Add("@AuditsXml", auditQuestionHistoryModel.AuditsXml);
                    vParams.Add("@DateFrom", auditQuestionHistoryModel.DateFrom);
                    vParams.Add("@DateTo", auditQuestionHistoryModel.DateTo);
                    vParams.Add("@PageNo", auditQuestionHistoryModel.PageNumber);
                    vParams.Add("@IsActionInculde", auditQuestionHistoryModel.IsActionInculde);
                    vParams.Add("@PageSize", auditQuestionHistoryModel.PageSize);
                    vParams.Add("@ProjectId", auditQuestionHistoryModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditQuestionHistoryModel>(StoredProcedureConstants.SPGetOverallAuditActivity, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditOverallHistory", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetQuestionHistory);
                return new List<AuditQuestionHistoryModel>();
            }
        }

        public Guid? SubmitAuditConduct(AuditConductApiInputModel auditConductApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditConductId", auditConductApiInputModel.ConductId);
                    vParams.Add("@AuditRatingId", auditConductApiInputModel.AuditRatingId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SPSubmitAuditConduct, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SubmitAuditConduct", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSubmitAuditConduct);
                return new Guid();
            }
        }

        public void ReorderQuestions(string questionIdsXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@QuestionIds", questionIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Execute(StoredProcedureConstants.SPReorderQuestions, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderQuestions", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionReorderQuestions);
            }
        }

        public void ReorderCategories(string categoryModelXml, CategoryModel categoryModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@CategoryIds", categoryModelXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsAuditElseConduct", categoryModel.IsAuditElseConduct);
                    vParams.Add("@ParentCategoryId", categoryModel.ParentCategoryId);
                    vConn.Execute(StoredProcedureConstants.SPReorderCategories, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderCategories", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionReorderQuestions);
            }
        }

        public Guid? CopyOrMoveQuestions(CopyMoveQuestionsModel copyMoveQuestionsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", copyMoveQuestionsModel.AuditId);
                    vParams.Add("@AppendToCategoryId", copyMoveQuestionsModel.AppendToCategoryId);
                    vParams.Add("@QuestionsXml", copyMoveQuestionsModel.QuestionsXml);
                    vParams.Add("@SelectedCategoriesXml", copyMoveQuestionsModel.SelectedCategoriesxml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsCopy", copyMoveQuestionsModel.IsCopy);
                    vParams.Add("@IsQuestionsOnly", copyMoveQuestionsModel.IsQuestionsOnly);
                    vParams.Add("@IsQuestionsWithCategories", copyMoveQuestionsModel.IsQuestionsWithCategories);
                    vParams.Add("@IsAllParents", copyMoveQuestionsModel.IsAllParents);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPCopyOrMoveQuestions, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CopyOrMoveQuestions", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCopyOrMoveCases);

                return null;
            }
        }

        public Guid? MoveQuestionsToAuditCategory(MoveAuditQuestionsToAuditCategoryApiInputModel moveAuditQuestionsToAuditCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditCategoryId", moveAuditQuestionsToAuditCategoryApiInputModel.AuditCategoryId);
                    vParams.Add("@AuditQuestionIds", moveAuditQuestionsToAuditCategoryApiInputModel.AuditQuestionsXml);
                    vParams.Add("@IsCopy", moveAuditQuestionsToAuditCategoryApiInputModel.IsCopy);
                    vParams.Add("@IsArchived", moveAuditQuestionsToAuditCategoryApiInputModel.IsArchived);
                    vParams.Add("@ProjectId", moveAuditQuestionsToAuditCategoryApiInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPMoveAuditQuestionsToAuditCategory, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MoveQuestionsToAuditCategory", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionMoveAuditQuestions);

                return null;
            }
        }

        public List<GetBugsBasedOnUserStoryApiReturnModel> GetActionsBasedOnAuditConductQuestion(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", userStorySearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@AuditConductQuestionId", userStorySearchCriteriaInputModel.AuditConductQuestionId);
                    vParams.Add("@AuditConductId", userStorySearchCriteriaInputModel.ConductId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetBugsBasedOnUserStoryApiReturnModel>(StoredProcedureConstants.SPGetActionsBasedOnAuditConductQuestion, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActionsBasedOnAuditConductQuestion", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBugsBasedOnUserStories);
                return new List<GetBugsBasedOnUserStoryApiReturnModel>();
            }
        }

        public List<SelectedQuestionModel> GetAuditQuestionsBasedonAuditId(Guid? auditComplainceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplainceId", auditComplainceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SelectedQuestionModel>(StoredProcedureConstants.SPGetAuditQuestionsBasedonAuditId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditQuestionsBasedonAuditId", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSubmitAuditConduct);
                return new List<SelectedQuestionModel>();
            }
        }

        public List<AuditSubmittedDetailsReturnModel> SearchSubmittedAudits(AuditSearchInputModel auditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", auditSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", auditSearchInputModel.DateTo);
                    return vConn.Query<AuditSubmittedDetailsReturnModel>(StoredProcedureConstants.SPSearchSubmittedAudits, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSubmittedAudits", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditSubmittedDetailsReturnModel>();
            }
        }

        public List<AuditSubmittedDetailsReturnModel> SearchNonCompalintAudits(AuditSearchInputModel auditSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", auditSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", auditSearchInputModel.DateTo);
                    vParams.Add("@BranchId", auditSearchInputModel.BranchId);
                    vParams.Add("@AuditId", auditSearchInputModel.AuditId);
                    vParams.Add("@ProjectId", auditSearchInputModel.ProjectId);
                    return vConn.Query<AuditSubmittedDetailsReturnModel>(StoredProcedureConstants.SPSearchNonComplainceAudits, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchNonCompalintAudits", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditSubmittedDetailsReturnModel>();
            }
        }


        public List<AuditSubmittedDetailsReturnModel> SearchCompalintAudits(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<AuditSubmittedDetailsReturnModel>(StoredProcedureConstants.SPSearchComplainceAudits, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompalintAudits", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditCategories);
                return new List<AuditSubmittedDetailsReturnModel>();
            }
        }

        public Guid? UpsertAuditComplianceSchedulingDetails(Guid auditId, Guid cronExpressionId, string scheduleDetails, string selectedQuestions, bool IsIncludeAllQuestions, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditComplianceId", auditId);
                    vParams.Add("@CronExpressionId", cronExpressionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SchedulingDetails", scheduleDetails);
                    vParams.Add("@SelectedQuestions", selectedQuestions);
                    vParams.Add("@IsIncludeAllQuestions", IsIncludeAllQuestions);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SPUpsertAuditComplianceSchedulingDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditComplianceSchedulingDetails", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditCategory);
                return null;
            }
        }

        public void ArchiveGenericStatusOfAuditQuestions(Guid? auditId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", auditId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vConn.Query<Guid?>(StoredProcedureConstants.SpArchiveGenericStatusOfAuditQuestions, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveGenericStatusOfAuditQuestions", "ComplianceAudit Repository", sqlException.Message),sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertAuditCategory);
            }
        }

        public List<AuditConductMailNotificationModel> AuditConductMailNotification(string procedureName, int? days = null, Guid? userId = null)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@days", days);
                    vParams.Add("@OperationsPerformedBy", userId);
                    return vConn.Query<AuditConductMailNotificationModel>(procedureName, vParams, commandTimeout: 0, commandType: CommandType.StoredProcedure).ToList(); //TODO
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AuditConductMailNotification", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                return new List<AuditConductMailNotificationModel>();
            }
        }

        public Guid? InsertAuditVersion(InsertAuditVersionInputModel insertAuditVersionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", insertAuditVersionInputModel.AuditId);
                    vParams.Add("@VersionName", insertAuditVersionInputModel.AuditVersionname);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertAuditVersion, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertAuditVersion", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInsertAuditVersion);
                return null;
            }
        }
        public List<GetAuditVersionsOutputModel> GetAuditVersions(Guid? auditId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@AuditId", auditId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetAuditVersionsOutputModel>(StoredProcedureConstants.SpGetAuditVersions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAuditVersions", "ComplianceAuditRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAuditVersions);
                return null;
            }
        }

    }
}
