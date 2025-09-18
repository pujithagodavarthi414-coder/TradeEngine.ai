using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.RepositoryCommits;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class RepositoryCommitsRepository : BaseRepository
    {
        public Guid? UpsertReposityCommits(RepositoryCommitsInputModel repositoryCommitsInput, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CommiterEmail", repositoryCommitsInput.CommiterEmail);
                    vParams.Add("@CommiterName", repositoryCommitsInput.CommiterName);
                    vParams.Add("@CommitMessage", repositoryCommitsInput.CommitMessage);
                    vParams.Add("@CommitReferenceUrl", repositoryCommitsInput.CommitReferenceUrl);
                    vParams.Add("@FiledAddedXml", repositoryCommitsInput.FiledAddedXml);
                    vParams.Add("@FilesModifiedXml", repositoryCommitsInput.FilesModifiedXml);
                    vParams.Add("@FilesRemovedXml", repositoryCommitsInput.FilesRemovedXml);
                    vParams.Add("@FromSource", repositoryCommitsInput.FromSource);
                    vParams.Add("@RepositoryName", repositoryCommitsInput.RepositoryName);
                    vParams.Add("@CommitedByUserId", repositoryCommitsInput.CommitedByUserId);
                    vParams.Add("@CommitedDateTime", repositoryCommitsInput.CommitedDateTime);
                    vParams.Add("@CompanyId", repositoryCommitsInput.CompanyId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRepositoryCommits, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReposityCommits", "RepositoryCommitsRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertRepositoryCommits);
                return null;
            }
        }

        public List<RepositoryCommitsModel> SearchReposityCommits(RepositoryCommitsSearchModel repositoryCommitsSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", repositoryCommitsSearchModel.SearchText);
                    vParams.Add("@UserId", repositoryCommitsSearchModel.UserId);
                    vParams.Add("@OnDate", repositoryCommitsSearchModel.OnDate);
                    vParams.Add("@DateFrom", repositoryCommitsSearchModel.DateFrom);
                    vParams.Add("@DateTo", repositoryCommitsSearchModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RepositoryCommitsModel>(StoredProcedureConstants.SpSearchRepositoryCommits, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchReposityCommits", "RepositoryCommitsRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchRepositoryCommits);
                return new List<RepositoryCommitsModel>();
            }
        }
    }
}
