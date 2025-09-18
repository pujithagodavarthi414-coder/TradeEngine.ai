using System;
using System.Data;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class FoodOrderUserRepository
    {
        public bool FoodOrderUserInsert(string orderedUserXml, Guid orderId, DateTime createdDateTime, Guid createdByUserId, DateTime updatedDateTime, Guid updatedByUserId)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@OrderedUserXml", orderedUserXml);
                vParams.Add("@OrderId", orderId);
                vParams.Add("@CreatedDateTime", createdDateTime);
                vParams.Add("@CreatedByUserId", createdByUserId);
                vParams.Add("@UpdatedDateTime", updatedDateTime);
                vParams.Add("@UpdatedByUserId", updatedByUserId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpFoodOrderUserInsert, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }
    }
}
