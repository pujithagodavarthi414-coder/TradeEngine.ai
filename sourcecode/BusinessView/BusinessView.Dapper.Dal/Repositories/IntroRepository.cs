
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
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
    public class IntroRepository : BaseRepository
	{
		/*public List<IntroOutputModel> GetIntro(IntroOutputModel intromodel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
		{


			try
			{
				using (IDbConnection vConn = OpenConnection())
				{
					DynamicParameters vParams = new DynamicParameters();
					vParams.Add("@IntroId", intromodel.IntroId);
					vParams.Add("@ModuleId", intromodel.ModuleId);
					vParams.Add("@CompanyId", intromodel.CompanyId);
					vParams.Add("@UserId", intromodel.UserId);
					vParams.Add("@EnableIntro", intromodel.EnableIntro);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);


					return vConn.Query<IntroOutputModel>(StoredProcedureConstants.SpGetIntro, vParams, commandType: CommandType.StoredProcedure).ToList();
				}
			}
			catch (SqlException sqlException)
			{
				LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Getintro", "Intro Repository", sqlException));
				SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCurrency);
				return null;
			}

		}*/

        public Guid? UpsertIntro(IntroOutputModel intromodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
					DynamicParameters vParams = new DynamicParameters();
					vParams.Add("@IntroId", intromodel.IntroId);
					vParams.Add("@ModuleId", intromodel.ModuleId);
					vParams.Add("@EnableIntro", intromodel.EnableIntro);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
					return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertIntro, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertIntro", "IntroRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionCurrency);
                return null;
            }
        }

		public List<IntroOutputModel> GetIntro(IntroOutputModel intromodel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
			using (IDbConnection vConn = OpenConnection())
			{
				DynamicParameters vParams = new DynamicParameters();
				vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
				vParams.Add("@UserId", intromodel.UserId);
				return vConn.Query<IntroOutputModel>(StoredProcedureConstants.SpGetIntro, vParams, commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
