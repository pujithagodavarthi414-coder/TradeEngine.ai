using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Site;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Repositories
{
    public class SiteRepository: BaseRepository
    {
        public Guid? UpsertSite(SiteUpsertModel siteUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Id", siteUpsertModel.Id);
                    vParams.Add("@Name", siteUpsertModel.Name);
                    vParams.Add("@Email", siteUpsertModel.Email);
                    vParams.Add("@Address", siteUpsertModel.Address);
                    vParams.Add("@Addressee", siteUpsertModel.Addressee);
                    vParams.Add("@RoofRentalAddress", siteUpsertModel.RoofRentalAddress);
                    vParams.Add("@Date", siteUpsertModel.Date);
                    vParams.Add("@ParcellNo", siteUpsertModel.ParcellNo);
                    vParams.Add("@M2", siteUpsertModel.M2);
                    vParams.Add("@Chf", siteUpsertModel.Chf);
                    vParams.Add("@Term", siteUpsertModel.Term);
                    vParams.Add("@Muncipallity", siteUpsertModel.Muncipallity);
                    vParams.Add("@Canton", siteUpsertModel.Canton);
                    vParams.Add("@TimeStamp", siteUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", siteUpsertModel.IsArchived);
                    vParams.Add("@AutoCTariff", siteUpsertModel.AutoCTariff);
                    vParams.Add("@StartingYear", siteUpsertModel.StartingYear);
                    vParams.Add("@ProductionFirstYear", siteUpsertModel.ProductionFirstYear);
                    vParams.Add("@AutoCExpected", siteUpsertModel.AutoCExpected);
                    vParams.Add("@AnnualReduction", siteUpsertModel.AnnualReduction);
                    vParams.Add("@RepriceExpected", siteUpsertModel.RepriceExpected);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSite, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSite", "SiteRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAccessibleIpAddress);
                return null;
            }
        }
        public List<SiteOutpuModel> GetSite(SiteOutpuModel siteOutpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SiteId", siteOutpuModel.Id);
                    vParams.Add("@SearchText", siteOutpuModel.SearchText);
                    vParams.Add("@IsArchived", siteOutpuModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SiteOutpuModel>(StoredProcedureConstants.SpGetSite, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSite", "SiteRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAccessibleIpAddress);
                return null;
            }
        }


        public Guid? UpsertSolorLog(SolorLogModel solorLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SiteId", solorLogModel.SiteId);
                    vParams.Add("@SolarId", solorLogModel.SolarId);
                    vParams.Add("@Confirm", solorLogModel.Confirm);
                    vParams.Add("@SolarLogValue", solorLogModel.SolarLogValue);
                    vParams.Add("@Date", solorLogModel.Date);
                    vParams.Add("@TimeStamp", solorLogModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", solorLogModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSolorLog, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSolorLog", "SiteRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAccessibleIpAddress);
                return null;
            }
        }

        public List<SolorLogModel> GetSolorLog(SolorLogModel solorLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SolarId", solorLogModel.SolarId);
                    vParams.Add("@SearchText", solorLogModel.SearchText);
                    vParams.Add("@IsArchived", solorLogModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SolorLogModel>(StoredProcedureConstants.SpGetSolorLog, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSolorLog", "SiteRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAccessibleIpAddress);
                return null;
            }
        }
        public Guid? UpsertGridForSiteProjection(GridForSiteProjectionModel gridForSiteProjectionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GridForSiteProjectionId", gridForSiteProjectionModel.GridForSiteProjectionId);
                    vParams.Add("@SiteId", gridForSiteProjectionModel.SiteId);
                    vParams.Add("@GridId", gridForSiteProjectionModel.GridId);
                    vParams.Add("@StartDate", gridForSiteProjectionModel.StartDate);
                    vParams.Add("@EndDate", gridForSiteProjectionModel.EndDate);
                    vParams.Add("@TimeStamp", gridForSiteProjectionModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", gridForSiteProjectionModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGridforSitesProjection, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGridForSiteProjection", "SiteRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAccessibleIpAddress);
                return null;
            }
        }
        public List<GridForSiteProjectionModel> GetGridForSiteProjection(GridForSiteProjectionModel gridForSiteProjectionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", gridForSiteProjectionModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GridForSiteProjectionModel>(StoredProcedureConstants.SpGetGridforSitesProjection, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGridForSiteProjection", "SiteRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionAccessibleIpAddress);
                return null;
            }
        }
    }
}
