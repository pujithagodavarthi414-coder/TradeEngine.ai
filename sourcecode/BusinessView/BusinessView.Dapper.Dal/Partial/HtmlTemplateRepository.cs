using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class HtmlTemplateRepository : BaseRepository
    {
        public Guid? UpsertHtmlTemplate(HtmlTemplateUpsertInputModel htmlTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@HtmlTemplateId", htmlTemplateUpsertInputModel.HtmlTemplateId);
                    vParams.Add("@HtmlTemplateName", htmlTemplateUpsertInputModel.HtmlTemplateName);
                    vParams.Add("@HtmlTemplate", htmlTemplateUpsertInputModel.HtmlTemplate);
                    vParams.Add("@IsConfigurable", htmlTemplateUpsertInputModel.IsConfigurable);
                    vParams.Add("@IsRoleBased", htmlTemplateUpsertInputModel.IsRoleBased);
                    vParams.Add("@IsMailBased", htmlTemplateUpsertInputModel.IsMailBased);
                    vParams.Add("@Roles", htmlTemplateUpsertInputModel.Roles);
                    vParams.Add("@Mails", htmlTemplateUpsertInputModel.Mails);
                    vParams.Add("@IsArchived", htmlTemplateUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", htmlTemplateUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertHtmlTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHtmlTemplate", "HtmlTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertHtmlTemplate);
                return null;
            }
        }

        public List<HtmlTemplateApiReturnModel> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@HtmlTemplateId", htmlTemplateSearchInputModel.HtmlTemplateId);
                    vParams.Add("@SearchText", htmlTemplateSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", htmlTemplateSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<HtmlTemplateApiReturnModel>(StoredProcedureConstants.SpGetAllHtmlTemplate, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHtmlTemplates", "HtmlTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHtmlTemplate);
                return new List<HtmlTemplateApiReturnModel>();
            }
        }

        public List<DocumentTemplateModel> GetDocumentTemplates(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DocumentTemplateId", documentTemplateModel.DocumentTemplateId);
                    vParams.Add("@DocumentTemplateName", documentTemplateModel.TemplateName);
                    vParams.Add("@IsArchived", documentTemplateModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DocumentTemplateModel>(StoredProcedureConstants.SpGetAllDocumentTemplates, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDocumentTemplates", "HtmlTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHtmlTemplate);
                return new List<DocumentTemplateModel>();
            }
        }


        public Guid? UpsertDocumentTemplate(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DocumentTemplateId", documentTemplateModel.DocumentTemplateId);
                    vParams.Add("@DocumentTemplateName", documentTemplateModel.TemplateName);
                    vParams.Add("@DocumentTemplatePath", documentTemplateModel.TemplatePath);
                    vParams.Add("@IsArchived", documentTemplateModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertDocumentTemplate, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDocumentTemplate", "HtmlTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHtmlTemplate);
                return new Guid();
            }
        }


        public EmployeeReportDetailsModel GenerateReportForanEmployee(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", documentTemplateModel.SelectedEmployeeId);
                    vParams.Add("@DocumentTemplateName", documentTemplateModel.TemplateName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeReportDetailsModel>(StoredProcedureConstants.SpGetEmployeeDetailsForReport, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateReportForanEmployee", "HtmlTemplateRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetHtmlTemplate);
                return new EmployeeReportDetailsModel();
            }
        }
    }
}
