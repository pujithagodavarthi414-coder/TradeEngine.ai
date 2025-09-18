using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.PositionTable;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Btrak.Dapper.Dal.Repositories
{
    public partial class PositionTableRepository : BaseRepository
    {
        /// <summary>
        /// Selects the Single object of Dataset table.
        /// </summary>
       

        public List<SalesDashboardOutputModel> GetPositionTableQuery(string productGroup, string productType, DateTime? fromDate, DateTime? ToDate, Guid? ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)

        {
            try
            {
                return new List<SalesDashboardOutputModel>();
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionTable", "GetPositionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetGoalsOverAllStatusByDashboardId);
                 return new List<SalesDashboardOutputModel>();
                
            }
        }

    }
}

