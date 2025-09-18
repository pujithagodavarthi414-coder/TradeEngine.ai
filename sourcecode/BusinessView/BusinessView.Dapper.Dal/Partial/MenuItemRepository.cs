using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Features;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class MenuItemRepository : BaseRepository
    {
        public List<AppMenuItemApiReturnModel> GetAllApplicableMenuItems(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string MenuCategory = null)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@MenuCategory", MenuCategory);
                    return vConn.Query<AppMenuItemApiReturnModel>(StoredProcedureConstants.SpGetAllApplicableMenuItems, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllApplicableMenuItems", "MenuItemRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMenuItems);
                return new List<AppMenuItemApiReturnModel>();
            }
        }
    }
}