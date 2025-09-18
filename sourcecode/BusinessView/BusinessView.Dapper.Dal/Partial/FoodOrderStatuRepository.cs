using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class FoodOrderStatuRepository
    {
        public FoodOrderStatuDbEntity GetFoodOrderStatus(string statusName)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Status", statusName);
                return vConn.Query<FoodOrderStatuDbEntity>(StoredProcedureConstants.SpGetFoodOrderStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}
