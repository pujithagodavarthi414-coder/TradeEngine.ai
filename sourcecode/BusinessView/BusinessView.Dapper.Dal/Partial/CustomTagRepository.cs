using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Assets;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;
using Btrak.Models.CustomTags;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class CustomTagRepository : BaseRepository
    {
        public Guid? UpsertCustomTags(CustomTagsInputModel customTags, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", customTags.ReferenceId);
                    vParams.Add("@TagsXml", customTags.TagsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCustomTags, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomTags", "CustomTagRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomTags);
                return null;
            }
        }

        public List<CustomTagsInputModel> GetCustomTags(CustomTagsSearchCriteriaModel customTagsSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", customTagsSearchCriteriaModel.ReferenceId);
                    vParams.Add("@Tag", customTagsSearchCriteriaModel.Tag);
                    vParams.Add("@SearchText", customTagsSearchCriteriaModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TagsList", customTagsSearchCriteriaModel.Tags);
                    return vConn.Query<CustomTagsInputModel>(StoredProcedureConstants.SpGetCustomTags, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomTags", "CustomTagRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchCustomTags);
                return new List<CustomTagsInputModel>();
            }
        }

        public Guid? UpsertTags(CustomTagsInputModel customTagsInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TagId", customTagsInput.TagId);
                    vParams.Add("@TagName", customTagsInput.Tag);
                    vParams.Add("@ParentTagId", customTagsInput.ParentTagId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsForDelete", customTagsInput.IsForDelete);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTags, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTags", "CustomTagRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCustomTags);
                return null;
            }
        }
    }
}
