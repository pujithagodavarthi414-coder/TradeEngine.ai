using System;
using System.Data;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class VendorDetailRepository
    {
        public bool UpdateVendorDetails(Guid assetId, Guid productId, decimal? cost)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@AssetId", assetId);
                vParams.Add("@ProductId", productId);
                vParams.Add("@Cost", cost);
                int iResult = vConn.Execute(StoredProcedureConstants.SpUpdateVendorDetails, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }
    }
}
