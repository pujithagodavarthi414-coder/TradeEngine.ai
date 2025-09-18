using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Templates;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class TemplatesRepository : BaseRepository
    {
        public Guid? UpsertTemplates(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", templatesUpsertInputModel.TemplateId);
                    vParams.Add("@TemplateName", templatesUpsertInputModel.TemplateName);
                    vParams.Add("@ProjectId", templatesUpsertInputModel.ProjectId);
                    vParams.Add("@OnBoardProcessDate", templatesUpsertInputModel.OnBoardProcessDate);
                    vParams.Add("@TemplateResponsiblePersonId", templatesUpsertInputModel.TemplateResponsiblePersonId);
                    vParams.Add("@TimeStamp", templatesUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTemplates", "TemplatesRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTemplatesUpsert);
                return null;
            }
        }

        public List<TemplatesApiReturnModel> SearchTemplates(TemplatesSearchCriteriaInputModel templatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", templatesSearchCriteriaInputModel.TemplateId);
                    vParams.Add("@ProjectId", templatesSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TemplatesApiReturnModel>(StoredProcedureConstants.SpSearchTemplates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTemplates", "TemplatesRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchGoals);
                return new List<TemplatesApiReturnModel>();
            }
        }

        public Guid? InsertTemplateDuplicate(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateName", templatesUpsertInputModel.TemplateName);
                    vParams.Add("@GoalId", templatesUpsertInputModel.GoalId);
                    vParams.Add("@ProjectId", templatesUpsertInputModel.ProjectId);
                    vParams.Add("@OnBoardProcessDate", templatesUpsertInputModel.OnBoardProcessDate);
                    vParams.Add("@TemplateResponsiblePersonId", templatesUpsertInputModel.TemplateResponsiblePersonId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpMakeTemplateDuplicate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertTemplateDuplicate", "TemplatesRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTemplatesUpsert);
                return null;
            }
        }

        public Guid? DeleteTemplates(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TemplateId", templatesUpsertInputModel.TemplateId);
                    vParams.Add("@IsArchived", templatesUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", templatesUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTemplates", "TemplatesRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTemplatesDelete);
                return null;
            }
        }

    }
}
